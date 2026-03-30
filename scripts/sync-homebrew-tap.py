#!/usr/bin/env python3

import argparse
import base64
import json
import os
import sys
import urllib.error
import urllib.request


DEFAULT_REPO = "aroido/layoutrecall"
DEFAULT_TAP_REPO = "aroido/homebrew-layoutrecall"
DEFAULT_TAP_PATH = "Casks/layoutrecall.rb"


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--repo", default=os.environ.get("GITHUB_REPOSITORY", DEFAULT_REPO))
    parser.add_argument("--tag", default=os.environ.get("RELEASE_TAG", ""))
    parser.add_argument("--tap-repo", default=os.environ.get("HOMEBREW_TAP_REPO", DEFAULT_TAP_REPO))
    parser.add_argument("--tap-path", default=os.environ.get("HOMEBREW_TAP_PATH", DEFAULT_TAP_PATH))
    parser.add_argument(
        "--token",
        default=os.environ.get("HOMEBREW_TAP_GITHUB_TOKEN")
        or os.environ.get("GH_TOKEN")
        or os.environ.get("GITHUB_TOKEN")
        or "",
    )
    parser.add_argument("--dry-run", action="store_true")
    args = parser.parse_args()

    if not args.tag:
        parser.error("Missing required --tag argument.")

    if not args.token and not args.dry_run:
        parser.error("Missing Homebrew tap GitHub token.")

    return args


def github_request(url: str, token: str, accept: str = "application/vnd.github+json") -> tuple[int, bytes]:
    request = urllib.request.Request(url)
    request.add_header("Accept", accept)
    request.add_header("User-Agent", "layoutrecall-homebrew-sync")
    if token:
        request.add_header("Authorization", f"Bearer {token}")

    try:
        with urllib.request.urlopen(request) as response:
            return response.status, response.read()
    except urllib.error.HTTPError as error:
        return error.code, error.read()


def github_json(url: str, token: str) -> dict:
    status, payload = github_request(url, token)
    if status < 200 or status >= 300:
        raise RuntimeError(f"GitHub API request failed ({status}) for {url}")
    return json.loads(payload.decode("utf-8"))


def github_text(url: str, token: str) -> str:
    status, payload = github_request(url, token, accept="application/octet-stream")
    if status < 200 or status >= 300:
        raise RuntimeError(f"GitHub asset request failed ({status}) for {url}")
    return payload.decode("utf-8")


def normalize_version(tag: str) -> str:
    return tag[1:] if tag.startswith("v") else tag


def select_dmg_asset(release: dict, version: str) -> dict:
    assets = release.get("assets", [])
    candidates = [
        asset
        for asset in assets
        if str(asset.get("name", "")).endswith(".dmg")
        and not str(asset.get("name", "")).endswith(".dmg.blockmap")
    ]

    if not candidates:
        raise RuntimeError("No DMG asset found on the GitHub release.")

    versioned_name = f"LayoutRecall-{version}.dmg"
    for asset in candidates:
        if asset.get("name") == versioned_name:
            return asset

    return candidates[0]


def resolve_sha256(repo: str, release: dict, dmg_asset: dict, token: str) -> str:
    checksum_asset = next(
        (asset for asset in release.get("assets", []) if asset.get("name") == "SHA256SUMS.txt"),
        None,
    )
    if checksum_asset is None:
        raise RuntimeError("SHA256SUMS.txt was not found on the GitHub release.")

    checksum_text = github_text(
        f"https://api.github.com/repos/{repo}/releases/assets/{checksum_asset['id']}",
        token,
    )

    suffix = f" {dmg_asset['name']}"
    for line in checksum_text.splitlines():
        stripped = line.strip()
        if stripped.endswith(suffix):
            return stripped.split()[0]

    raise RuntimeError(f"Unable to find a SHA256 entry for {dmg_asset['name']}.")


def build_cask(version: str, sha256: str, tag: str, asset_name: str) -> str:
    return f"""cask "layoutrecall" do
  version "{version}"
  sha256 "{sha256}"

  url "https://github.com/aroido/layoutrecall/releases/download/{tag}/{asset_name}"
  name "LayoutRecall"
  desc "Restore saved display layouts when identical monitors get scrambled"
  homepage "https://github.com/aroido/layoutrecall"

  depends_on arch: :arm64

  app "LayoutRecall.app"

  auto_updates true

  zap trash: [
    "~/Library/Application Support/LayoutRecall",
    "~/Library/Preferences/com.aroido.layoutrecall.plist",
  ]
end
"""


def fetch_tap_file(tap_repo: str, tap_path: str, token: str) -> tuple[str | None, str | None]:
    status, payload = github_request(
        f"https://api.github.com/repos/{tap_repo}/contents/{tap_path}",
        token,
    )

    if status == 404:
        return None, None

    if status < 200 or status >= 300:
        raise RuntimeError(f"Unable to load {tap_repo}/{tap_path} from GitHub contents API.")

    file_data = json.loads(payload.decode("utf-8"))
    content = base64.b64decode(file_data["content"].replace("\n", "")).decode("utf-8")
    return file_data["sha"], content


def update_tap_file(tap_repo: str, tap_path: str, token: str, previous_sha: str | None, next_content: str, tag: str) -> None:
    body = {
        "message": f"chore: sync layoutrecall cask for {tag}",
        "content": base64.b64encode(next_content.encode("utf-8")).decode("utf-8"),
    }
    if previous_sha:
        body["sha"] = previous_sha

    request = urllib.request.Request(
        f"https://api.github.com/repos/{tap_repo}/contents/{tap_path}",
        data=json.dumps(body).encode("utf-8"),
        method="PUT",
    )
    request.add_header("Accept", "application/vnd.github+json")
    request.add_header("Authorization", f"Bearer {token}")
    request.add_header("Content-Type", "application/json")
    request.add_header("User-Agent", "layoutrecall-homebrew-sync")

    try:
        with urllib.request.urlopen(request) as response:
            if response.status < 200 or response.status >= 300:
                raise RuntimeError(f"Failed to update {tap_repo}/{tap_path} ({response.status})")
    except urllib.error.HTTPError as error:
        raise RuntimeError(
            f"Failed to update {tap_repo}/{tap_path} ({error.code}): {error.read().decode('utf-8', errors='ignore')}"
        ) from error


def main() -> int:
    args = parse_args()
    version = normalize_version(args.tag)
    release = github_json(
        f"https://api.github.com/repos/{args.repo}/releases/tags/{args.tag}",
        args.token,
    )
    dmg_asset = select_dmg_asset(release, version)
    sha256 = resolve_sha256(args.repo, release, dmg_asset, args.token)
    next_content = build_cask(version, sha256, args.tag, dmg_asset["name"])

    if args.dry_run:
        sys.stdout.write(next_content)
        return 0

    previous_sha, current_content = fetch_tap_file(args.tap_repo, args.tap_path, args.token)
    if current_content == next_content:
        print(f"Homebrew tap already matches {args.tag}.")
        return 0

    update_tap_file(args.tap_repo, args.tap_path, args.token, previous_sha, next_content, args.tag)
    print(f"Updated {args.tap_repo}/{args.tap_path} for {args.tag}.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
