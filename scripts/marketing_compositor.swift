import AppKit
import Foundation

struct MarketingAssetBuilder {
    let rawDirectory: URL
    let outputDirectory: URL
    let colors = Palette()

    func run() throws {
        try FileManager.default.createDirectory(at: outputDirectory, withIntermediateDirectories: true)

        let menu = try loadImage(named: "menu.png")
        let settings = try loadImage(named: "settings.png")
        let profiles = try loadImage(named: "settings-profiles.png")
        let diagnostics = try loadImage(named: "settings-diagnostics.png")
        let general = try loadImage(named: "settings-general.png")

        try hero(menu: menu, settings: settings)
            .savePNG(to: outputDirectory.appendingPathComponent("readme-hero.png"))
        try featureTrust(menu: menu, diagnostics: diagnostics)
            .savePNG(to: outputDirectory.appendingPathComponent("readme-feature-trust.png"))
        try featureProfiles(profiles: profiles, general: general)
            .savePNG(to: outputDirectory.appendingPathComponent("readme-feature-profiles.png"))
        try socialCard(menu: menu, settings: settings)
            .savePNG(to: outputDirectory.appendingPathComponent("social-card.png"))

        try slideOne(menu: menu, settings: settings)
            .savePNG(to: outputDirectory.appendingPathComponent("slide-01.png"))
        try slideTwo(menu: menu, diagnostics: diagnostics)
            .savePNG(to: outputDirectory.appendingPathComponent("slide-02.png"))
        try slideThree(profiles: profiles, general: general)
            .savePNG(to: outputDirectory.appendingPathComponent("slide-03.png"))
    }

    private func loadImage(named name: String) throws -> NSImage {
        let url = rawDirectory.appendingPathComponent(name)
        guard let image = NSImage(contentsOf: url) else {
            throw NSError(domain: "MarketingAssetBuilder", code: 1, userInfo: [
                NSLocalizedDescriptionKey: "Missing snapshot image: \(url.path)"
            ])
        }
        return image
    }

    private func hero(menu: NSImage, settings: NSImage) throws -> NSImage {
        try renderCanvas(size: NSSize(width: 1600, height: 1000)) { rect in
            drawBackground(in: rect)
            drawOrb(x: 1280, y: 120, radius: 220, color: colors.mint.withAlphaComponent(0.14))
            drawOrb(x: 1420, y: 780, radius: 180, color: colors.amber.withAlphaComponent(0.16))

            drawKicker("For MacBook + dock + multi-display desks", at: NSPoint(x: 96, y: 840))
            drawHeadline("Stop re-fixing your monitor layout every time macOS forgets it.", at: NSPoint(x: 96, y: 680), width: 680, fontSize: 56)
            drawBody(
                "LayoutRecall saves a known-good desk layout, restores it after sleep, wake, or reconnect, and stays manual when the match is not confident enough.",
                at: NSPoint(x: 96, y: 565),
                width: 610
            )
            drawPills([
                "High-confidence restore",
                "Clear manual fallback",
                "Signed DMG + Homebrew"
            ], origin: NSPoint(x: 96, y: 470))

            drawScreenshotCard(menu, frame: NSRect(x: 840, y: 420, width: 360, height: 420), angle: -4)
            drawScreenshotCard(settings, frame: NSRect(x: 1010, y: 180, width: 510, height: 580), angle: 5)
        }
    }

    private func featureTrust(menu: NSImage, diagnostics: NSImage) throws -> NSImage {
        try renderCanvas(size: NSSize(width: 1600, height: 900)) { rect in
            drawBackground(in: rect)
            drawSectionLabel("Trust before restore", at: NSPoint(x: 104, y: 728))
            drawHeadline("Restore only when the match is confident.", at: NSPoint(x: 104, y: 608), width: 640)
            drawBody(
                "LayoutRecall keeps the matched profile, dependency state, and recent diagnostics visible so cautious users can see why it acted — or why it refused.",
                at: NSPoint(x: 104, y: 500),
                width: 560
            )
            drawChecklist([
                "Matched profile and confidence",
                "Dependency state next to restore actions",
                "Manual recovery when confidence is low",
                "Recent restore proof in diagnostics"
            ], origin: NSPoint(x: 104, y: 358))

            drawScreenshotCard(menu, frame: NSRect(x: 860, y: 420, width: 330, height: 380), angle: -2)
            drawScreenshotCard(diagnostics, frame: NSRect(x: 1040, y: 110, width: 470, height: 610), angle: 4)
        }
    }

    private func featureProfiles(profiles: NSImage, general: NSImage) throws -> NSImage {
        try renderCanvas(size: NSSize(width: 1600, height: 900)) { rect in
            drawBackground(in: rect)
            drawSectionLabel("Desk-to-desk recovery", at: NSPoint(x: 104, y: 728))
            drawHeadline("Save the desk you want back, then recover it fast.", at: NSPoint(x: 104, y: 608), width: 640)
            drawBody(
                "Profiles, startup behavior, and restore controls stay in the same settings flow so repeat setups stay practical instead of fragile.",
                at: NSPoint(x: 104, y: 500),
                width: 560
            )
            drawChecklist([
                "Multiple saved layouts",
                "Manual apply and Fix Now fallback",
                "Launch-at-login and update controls",
                "Language and setup guidance in-app"
            ], origin: NSPoint(x: 104, y: 358))

            drawScreenshotCard(profiles, frame: NSRect(x: 820, y: 300, width: 520, height: 500), angle: -3)
            drawScreenshotCard(general, frame: NSRect(x: 1070, y: 90, width: 420, height: 450), angle: 5)
        }
    }

    private func socialCard(menu: NSImage, settings: NSImage) throws -> NSImage {
        try renderCanvas(size: NSSize(width: 1200, height: 630)) { rect in
            drawBackground(in: rect)
            drawOrb(x: 1060, y: 120, radius: 150, color: colors.mint.withAlphaComponent(0.18))
            drawKicker("LayoutRecall for macOS", at: NSPoint(x: 76, y: 520))
            drawHeadline(
                "macOS forgot your monitor layout. LayoutRecall brings it back.",
                at: NSPoint(x: 72, y: 300),
                width: 520,
                fontSize: 34
            )
            drawBody(
                "Safe menu bar recovery, saved profiles, and diagnostics for multi-display desks.",
                at: NSPoint(x: 72, y: 184),
                width: 470,
                fontSize: 21
            )

            drawScreenshotCard(menu, frame: NSRect(x: 700, y: 250, width: 220, height: 260), angle: -5)
            drawScreenshotCard(settings, frame: NSRect(x: 850, y: 60, width: 300, height: 380), angle: 6)
        }
    }

    private func slideOne(menu: NSImage, settings: NSImage) throws -> NSImage {
        try renderCanvas(size: NSSize(width: 1600, height: 900)) { rect in
            drawBackground(in: rect)
            drawStep("01", title: "Save the desk layout you want back.", body: "Capture the arrangement you trust once so a wake cycle or dock reconnect does not send you back to rearranging screens by hand.", at: NSPoint(x: 96, y: 690), width: 580)
            drawScreenshotCard(settings, frame: NSRect(x: 860, y: 180, width: 560, height: 620), angle: 4)
            drawScreenshotCard(menu, frame: NSRect(x: 720, y: 360, width: 290, height: 350), angle: -6)
        }
    }

    private func slideTwo(menu: NSImage, diagnostics: NSImage) throws -> NSImage {
        try renderCanvas(size: NSSize(width: 1600, height: 900)) { rect in
            drawBackground(in: rect)
            drawStep("02", title: "Restore only when the match is confident.", body: "The menu shows matched profile, dependency state, and diagnostics so users know why LayoutRecall acted — or why it stayed manual.", at: NSPoint(x: 96, y: 690), width: 620)
            drawScreenshotCard(menu, frame: NSRect(x: 840, y: 360, width: 320, height: 380), angle: -4)
            drawScreenshotCard(diagnostics, frame: NSRect(x: 1040, y: 120, width: 470, height: 610), angle: 4)
        }
    }

    private func slideThree(profiles: NSImage, general: NSImage) throws -> NSImage {
        try renderCanvas(size: NSSize(width: 1600, height: 900)) { rect in
            drawBackground(in: rect)
            drawStep("03", title: "Keep profiles and setup controls close by.", body: "Save multiple layouts, apply one directly, and keep app behavior visible from the same settings flow when you want explicit control.", at: NSPoint(x: 96, y: 690), width: 600)
            drawScreenshotCard(profiles, frame: NSRect(x: 780, y: 250, width: 520, height: 520), angle: -4)
            drawScreenshotCard(general, frame: NSRect(x: 1080, y: 110, width: 380, height: 420), angle: 5)
        }
    }

    private func renderCanvas(size: NSSize, draw: (NSRect) -> Void) throws -> NSImage {
        let image = NSImage(size: size)
        image.lockFocus()
        defer { image.unlockFocus() }

        let rect = NSRect(origin: .zero, size: size)
        draw(rect)
        return image
    }

    private func drawBackground(in rect: NSRect) {
        let gradient = NSGradient(colors: [
            colors.backgroundTop,
            colors.backgroundBottom,
        ])!
        gradient.draw(in: rect, angle: -90)

        let stripeColor = colors.cardStroke.withAlphaComponent(0.06)
        for index in stride(from: 0, to: Int(rect.width + rect.height), by: 48) {
            let path = NSBezierPath()
            path.move(to: NSPoint(x: CGFloat(index) - 240, y: 0))
            path.line(to: NSPoint(x: CGFloat(index), y: rect.height))
            stripeColor.setStroke()
            path.lineWidth = 1
            path.stroke()
        }
    }

    private func drawOrb(x: CGFloat, y: CGFloat, radius: CGFloat, color: NSColor) {
        let rect = NSRect(x: x - radius, y: y - radius, width: radius * 2, height: radius * 2)
        color.setFill()
        NSBezierPath(ovalIn: rect).fill()
    }

    private func drawKicker(_ text: String, at point: NSPoint) {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 18, weight: .semibold),
            .foregroundColor: colors.mutedText,
        ]
        NSString(string: text).draw(at: point, withAttributes: attributes)
    }

    private func drawSectionLabel(_ text: String, at point: NSPoint) {
        let pillRect = NSRect(x: point.x, y: point.y, width: 220, height: 34)
        colors.accentPanel.setFill()
        NSBezierPath(roundedRect: pillRect, xRadius: 17, yRadius: 17).fill()
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        let attributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 14, weight: .bold),
            .foregroundColor: colors.accentText,
            .paragraphStyle: style,
        ]
        NSString(string: text.uppercased()).draw(in: pillRect.insetBy(dx: 8, dy: 8), withAttributes: attributes)
    }

    private func drawHeadline(_ text: String, at point: NSPoint, width: CGFloat, fontSize: CGFloat = 52) {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 3
        let attributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: fontSize, weight: .bold),
            .foregroundColor: colors.primaryText,
            .paragraphStyle: paragraph,
        ]
        NSString(string: text).draw(in: NSRect(x: point.x, y: point.y, width: width, height: 220), withAttributes: attributes)
    }

    private func drawBody(_ text: String, at point: NSPoint, width: CGFloat, fontSize: CGFloat = 24) {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 6
        let attributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: fontSize, weight: .regular),
            .foregroundColor: colors.secondaryText,
            .paragraphStyle: paragraph,
        ]
        NSString(string: text).draw(in: NSRect(x: point.x, y: point.y, width: width, height: 180), withAttributes: attributes)
    }

    private func drawPills(_ items: [String], origin: NSPoint) {
        var x = origin.x
        for item in items {
            let text = NSString(string: item)
            let size = text.size(withAttributes: [.font: NSFont.systemFont(ofSize: 15, weight: .medium)])
            let pillRect = NSRect(x: x, y: origin.y, width: size.width + 34, height: 36)
            colors.cardFill.setFill()
            NSBezierPath(roundedRect: pillRect, xRadius: 18, yRadius: 18).fill()
            colors.cardStroke.setStroke()
            let outline = NSBezierPath(roundedRect: pillRect, xRadius: 18, yRadius: 18)
            outline.lineWidth = 1
            outline.stroke()
            text.draw(
                at: NSPoint(x: x + 17, y: origin.y + 10),
                withAttributes: [
                    .font: NSFont.systemFont(ofSize: 15, weight: .medium),
                    .foregroundColor: colors.primaryText,
                ]
            )
            x += pillRect.width + 12
        }
    }

    private func drawChecklist(_ items: [String], origin: NSPoint) {
        for (index, item) in items.enumerated() {
            let y = origin.y - CGFloat(index) * 54
            let bulletRect = NSRect(x: origin.x, y: y + 8, width: 22, height: 22)
            colors.mint.setFill()
            NSBezierPath(ovalIn: bulletRect).fill()
            NSString(string: item).draw(
                at: NSPoint(x: origin.x + 38, y: y),
                withAttributes: [
                    .font: NSFont.systemFont(ofSize: 22, weight: .medium),
                    .foregroundColor: colors.primaryText,
                ]
            )
        }
    }

    private func drawStep(_ step: String, title: String, body: String, at point: NSPoint, width: CGFloat) {
        let stepRect = NSRect(x: point.x, y: point.y + 106, width: 76, height: 76)
        colors.accentPanel.setFill()
        NSBezierPath(roundedRect: stepRect, xRadius: 24, yRadius: 24).fill()
        NSString(string: step).draw(
            in: stepRect.insetBy(dx: 0, dy: 16),
            withAttributes: [
                .font: NSFont.monospacedDigitSystemFont(ofSize: 28, weight: .bold),
                .foregroundColor: colors.accentText,
                .paragraphStyle: centeredParagraph(),
            ]
        )
        let titleFontSize: CGFloat = 48
        let titleLineSpacing: CGFloat = 3
        let titleHeight = measureTextHeight(title, width: width, fontSize: titleFontSize, lineSpacing: titleLineSpacing)
        drawHeadline(title, at: NSPoint(x: point.x, y: point.y), width: width, fontSize: titleFontSize)
        drawBody(body, at: NSPoint(x: point.x, y: point.y - titleHeight - 28), width: width)
    }

    private func drawScreenshotCard(_ image: NSImage, frame: NSRect, angle: CGFloat) {
        NSGraphicsContext.current?.saveGraphicsState()
        if let context = NSGraphicsContext.current?.cgContext {
            context.translateBy(x: frame.midX, y: frame.midY)
            context.rotate(by: angle * .pi / 180)
            context.translateBy(x: -frame.midX, y: -frame.midY)
        }

        let shadow = NSShadow()
        shadow.shadowColor = NSColor.black.withAlphaComponent(0.22)
        shadow.shadowBlurRadius = 28
        shadow.shadowOffset = NSSize(width: 0, height: -14)
        shadow.set()

        colors.cardFill.setFill()
        let cardPath = NSBezierPath(roundedRect: frame, xRadius: 28, yRadius: 28)
        cardPath.fill()

        colors.cardStroke.setStroke()
        cardPath.lineWidth = 1
        cardPath.stroke()

        let imageRect = frame.insetBy(dx: 18, dy: 18)
        let clipPath = NSBezierPath(roundedRect: imageRect, xRadius: 18, yRadius: 18)
        clipPath.addClip()
        image.draw(in: imageRect)
        NSGraphicsContext.current?.restoreGraphicsState()
    }

    private func centeredParagraph() -> NSParagraphStyle {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        return paragraph
    }

    private func measureTextHeight(_ text: String, width: CGFloat, fontSize: CGFloat, lineSpacing: CGFloat) -> CGFloat {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = lineSpacing
        let attributed = NSAttributedString(
            string: text,
            attributes: [
                .font: NSFont.systemFont(ofSize: fontSize, weight: .bold),
                .paragraphStyle: paragraph,
            ]
        )
        let rect = attributed.boundingRect(
            with: NSSize(width: width, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading]
        )
        return ceil(rect.height)
    }
}

struct Palette {
    let backgroundTop = NSColor(calibratedRed: 0.06, green: 0.10, blue: 0.18, alpha: 1.0)
    let backgroundBottom = NSColor(calibratedRed: 0.14, green: 0.18, blue: 0.29, alpha: 1.0)
    let cardFill = NSColor(calibratedRed: 0.10, green: 0.14, blue: 0.22, alpha: 0.88)
    let cardStroke = NSColor(calibratedRed: 0.70, green: 0.79, blue: 0.96, alpha: 0.18)
    let accentPanel = NSColor(calibratedRed: 0.80, green: 0.96, blue: 0.91, alpha: 0.16)
    let accentText = NSColor(calibratedRed: 0.77, green: 0.98, blue: 0.90, alpha: 1.0)
    let primaryText = NSColor(calibratedRed: 0.95, green: 0.97, blue: 0.99, alpha: 1.0)
    let secondaryText = NSColor(calibratedRed: 0.78, green: 0.83, blue: 0.90, alpha: 1.0)
    let mutedText = NSColor(calibratedRed: 0.59, green: 0.72, blue: 0.84, alpha: 1.0)
    let mint = NSColor(calibratedRed: 0.46, green: 0.93, blue: 0.81, alpha: 1.0)
    let amber = NSColor(calibratedRed: 1.00, green: 0.78, blue: 0.39, alpha: 1.0)
}

extension NSImage {
    func savePNG(to url: URL) throws {
        guard let tiffData = tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiffData),
              let png = bitmap.representation(using: .png, properties: [:]) else {
            throw NSError(domain: "MarketingAssetBuilder", code: 2, userInfo: [
                NSLocalizedDescriptionKey: "Failed to encode PNG for \(url.lastPathComponent)"
            ])
        }
        try png.write(to: url, options: .atomic)
    }
}

let arguments = CommandLine.arguments
guard arguments.count == 3 else {
    fputs("usage: swift marketing_compositor.swift <raw-snapshot-dir> <output-dir>\n", stderr)
    exit(64)
}

let builder = MarketingAssetBuilder(
    rawDirectory: URL(fileURLWithPath: arguments[1], isDirectory: true),
    outputDirectory: URL(fileURLWithPath: arguments[2], isDirectory: true)
)

do {
    try builder.run()
} catch {
    fputs("marketing_compositor failed: \(error)\n", stderr)
    exit(1)
}
