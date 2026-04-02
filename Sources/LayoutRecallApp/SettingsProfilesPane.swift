import LayoutRecallKit
import Observation
import SwiftUI

struct SettingsProfilesPane: View {
    @Bindable var model: AppModel
    @State private var profilePendingDeletion: DisplayProfile?
    @State private var expandedProfileIDs: Set<UUID> = []
    @State private var editingProfileID: UUID?
    @State private var profileNameDraft = ""
    @FocusState private var focusedProfileID: UUID?

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            GlassCard(padding: 18) {
                VStack(alignment: .leading, spacing: 12) {
                    SectionHeading(
                        title: L10n.t("action.save"),
                        systemImage: "square.and.arrow.down"
                    )

                    Text(L10n.t("profiles.save.hint"))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)

                    SettingsActionButton(
                        title: L10n.t("action.save"),
                        systemImage: "square.and.arrow.down",
                        role: .primary,
                        accessibilityIdentifier: "settings.profiles.save"
                    ) {
                        model.saveCurrentLayout()
                    }
                }
            }

            if model.profiles.isEmpty {
                GroupBox {
                    Text(L10n.t("profiles.empty"))
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                } label: {
                    Label(L10n.t("section.profiles"), systemImage: "square.stack.3d.up.fill")
                }
            } else {
                ForEach(model.profiles) { profile in
                    profileCard(for: profile)
                }
            }
        }
        .onAppear(perform: primeExpandedProfilesIfNeeded)
        .alert(item: $profilePendingDeletion) { profile in
            Alert(
                title: Text(L10n.t("profiles.delete.title")),
                message: Text(L10n.t("profiles.delete.message", profile.name)),
                primaryButton: .destructive(Text(L10n.t("profiles.delete.confirm"))) {
                    model.deleteProfile(profile.id)
                },
                secondaryButton: .cancel()
            )
        }
    }

    private func profileCard(for profile: DisplayProfile) -> some View {
        let isReferenceProfile = model.referenceProfile?.id == profile.id
        let sortedDisplays = profile.displaySet.displays.sorted(by: DisplaySnapshot.positionComparator(lhs:rhs:))
        let actionState = model.profileCardActionState(for: profile)

        return GlassCard(padding: 18) {
            VStack(alignment: .leading, spacing: 16) {
                AdaptivePairLayout(horizontalAlignment: .center, horizontalSpacing: 10, verticalSpacing: 8) {
                    profileNameField(for: profile)
                } secondary: {
                    if isReferenceProfile {
                        StatusPill(
                            text: L10n.t("profiles.badge.reference"),
                            systemImage: "checkmark.circle.fill",
                            emphasis: true
                        )
                    }
                }

                Text(L10n.t("profiles.savedAt", profile.createdAt.formatted(date: .abbreviated, time: .omitted)))
                    .font(.caption)
                    .foregroundStyle(.secondary)

                AdaptiveGroup {
                    StatusPill(
                        text: L10n.t("settings.profileDisplayCountCompact", profile.displaySet.count),
                        systemImage: "rectangle.on.rectangle"
                    )

                    StatusPill(
                        text: L10n.t("confidence.threshold.short", profile.settings.confidenceThreshold),
                        systemImage: "dial.medium"
                    )
                }

                profileActionRow(for: profile, actionState: actionState)

                DisclosureGroup(
                    isExpanded: profileExpansionBinding(for: profile),
                    content: {
                        AdaptivePairLayout(horizontalAlignment: .top, horizontalSpacing: 18, verticalSpacing: 16, horizontalPrimaryWidth: 214) {
                            DisplayLayoutPreview(
                                displays: sortedDisplays,
                                primaryDisplayKey: model.primaryDisplayKey(for: profile)
                            )
                            .frame(height: 132)
                        } secondary: {
                            profileLayoutDetails(for: profile, displays: sortedDisplays)
                        }
                        .padding(.top, 8)
                    },
                    label: {
                        Label(L10n.t("profiles.details"), systemImage: "rectangle.3.group")
                    }
                )
                .font(.subheadline.weight(.semibold))
                .tint(Color.primary)
                .contentShape(Rectangle())
                .accessibilityIdentifier("settings.profile.disclosure.\(profile.id.uuidString)")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(
                    isReferenceProfile
                        ? Color.accentColor.opacity(0.22)
                        : Color.clear,
                    lineWidth: 1
                )
        )
    }

    private func primeExpandedProfilesIfNeeded() {
        guard expandedProfileIDs.isEmpty else { return }

        if model.profiles.count == 1, let onlyProfile = model.profiles.first {
            expandedProfileIDs.insert(onlyProfile.id)
        }

        if let referenceProfile = model.referenceProfile {
            expandedProfileIDs.insert(referenceProfile.id)
        }
    }

    private func profileExpansionBinding(for profile: DisplayProfile) -> Binding<Bool> {
        Binding(
            get: { expandedProfileIDs.contains(profile.id) },
            set: { isExpanded in
                if isExpanded {
                    expandedProfileIDs.insert(profile.id)
                } else {
                    expandedProfileIDs.remove(profile.id)
                }
            }
        )
    }

    private func profileLayoutDetails(
        for profile: DisplayProfile,
        displays: [DisplaySnapshot]
    ) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 8) {
                SettingsFormHint(text: L10n.t("profiles.preview.hint"))

                DisplayLegendList(
                    displays: displays,
                    primaryDisplayKey: model.primaryDisplayKey(for: profile)
                )
            }

            profileControls(for: profile)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func profileNameField(for profile: DisplayProfile) -> some View {
        HStack(spacing: 10) {
            if editingProfileID == profile.id {
                TextField(L10n.t("field.profileName"), text: $profileNameDraft)
                    .textFieldStyle(.roundedBorder)
                    .focused($focusedProfileID, equals: profile.id)
                    .onSubmit { commitProfileRename(for: profile) }

                Button(L10n.t("profiles.rename.confirm")) {
                    commitProfileRename(for: profile)
                }
                .buttonStyle(InlineActionButtonStyle(accent: true))

                Button(L10n.t("action.cancel")) {
                    cancelProfileRename()
                }
                .buttonStyle(InlineActionButtonStyle())
            } else {
                Text(profile.name)
                    .font(.title3.weight(.semibold))
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Button(L10n.t("profiles.rename.button")) {
                    beginProfileRename(for: profile)
                }
                .buttonStyle(InlineActionButtonStyle())
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func beginProfileRename(for profile: DisplayProfile) {
        editingProfileID = profile.id
        profileNameDraft = profile.name

        DispatchQueue.main.async {
            focusedProfileID = profile.id
        }
    }

    private func cancelProfileRename() {
        editingProfileID = nil
        profileNameDraft = ""
        focusedProfileID = nil
    }

    private func commitProfileRename(for profile: DisplayProfile) {
        let trimmedName = profileNameDraft.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedName.isEmpty else {
            cancelProfileRename()
            return
        }

        model.renameProfile(profile.id, to: trimmedName)
        cancelProfileRename()
    }

    private func profileActionRow(
        for profile: DisplayProfile,
        actionState: ProfileCardActionState
    ) -> some View {
        AdaptiveActionGroup {
            applyLayoutButton(for: profile, actionState: actionState)
            identifyDisplaysButton(for: profile, actionState: actionState)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func applyLayoutButton(
        for profile: DisplayProfile,
        actionState: ProfileCardActionState
    ) -> some View {
        SettingsActionButton(
            title: actionState.applyTitle,
            systemImage: "bolt.fill",
            role: .primary,
            isDisabled: !actionState.canApplyLayout,
            accessibilityIdentifier: "settings.profile.apply.\(profile.id.uuidString)",
            helpText: actionState.applyHelp
        ) {
            model.restoreProfile(profile.id)
        }
    }

    private func identifyDisplaysButton(
        for profile: DisplayProfile,
        actionState: ProfileCardActionState
    ) -> some View {
        SettingsActionButton(
            title: actionState.identifyTitle,
            systemImage: "number.square.fill",
            role: .secondary,
            isDisabled: !actionState.canIdentifyDisplays,
            accessibilityIdentifier: "settings.profile.identify.\(profile.id.uuidString)",
            helpText: actionState.identifyHelp
        ) {
            model.identifyDisplays(for: profile.id)
        }
    }

    private func profileControls(for profile: DisplayProfile) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(L10n.t("profiles.confidence.label"))
                    .font(.subheadline.weight(.semibold))

                HStack(spacing: 12) {
                    Slider(
                        value: Binding(
                            get: { Double(profile.settings.confidenceThreshold) },
                            set: { model.setConfidenceThreshold(profile.id, to: Int($0.rounded())) }
                        ),
                        in: 50...100,
                        step: 1
                    )

                    Text(L10n.t("confidence.threshold.short", profile.settings.confidenceThreshold))
                        .font(.caption.weight(.semibold))
                        .monospacedDigit()
                        .frame(width: 52, alignment: .trailing)
                }

                SettingsFormHint(text: L10n.t("profiles.confidence.hint"))
            }

            HStack {
                Spacer(minLength: 0)

                Button(role: .destructive) {
                    profilePendingDeletion = profile
                } label: {
                    Label(L10n.t("profiles.delete.button"), systemImage: "trash")
                }
                .buttonStyle(.bordered)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
