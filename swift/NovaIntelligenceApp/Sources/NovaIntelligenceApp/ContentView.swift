#if canImport(SwiftUI)
import SwiftUI

struct ContentView: View {
    @State private var isShowingSettings = false
    @State private var selectedConversationID: UUID = SampleData.conversations.first?.id ?? UUID()
    @State private var searchText = ""
    @State private var selectedModel: String = SampleData.models.first ?? "Nova Ultra"
    @State private var selectedWorkspace: String = SampleData.workspaces.first ?? "Default"
    @State private var composerText = SampleData.defaultPrompt

    var body: some View {
        ZStack(alignment: .center) {
            Color.novaWindow.ignoresSafeArea()

            HStack(spacing: 0) {
                PrimarySidebar(
                    selectedConversationID: $selectedConversationID,
                    searchText: $searchText,
                    conversations: SampleData.conversations
                )
                Divider().overlay(Color.novaDivider)
                ConversationColumn(
                    conversation: SampleData.conversations.first { $0.id == selectedConversationID } ?? SampleData.conversations[0],
                    selectedModel: $selectedModel,
                    selectedWorkspace: $selectedWorkspace,
                    composerText: $composerText,
                    showSettings: $isShowingSettings
                )
                Divider().overlay(Color.novaDivider)
                SecondaryColumn()
            }
            .frame(minHeight: 720)
            .preferredColorScheme(.dark)

            if isShowingSettings {
                SettingsOverlay(isPresented: $isShowingSettings)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: isShowingSettings)
    }
}

// MARK: - Primary Sidebar

private struct PrimarySidebar: View {
    @Binding var selectedConversationID: UUID
    @Binding var searchText: String
    let conversations: [Conversation]

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            header
            newChatButton
            searchField
            pinnedSection
            Divider().overlay(Color.novaDivider)
                .padding(.horizontal, -20)
            recentSection
            Spacer()
            footer
        }
        .padding(.horizontal, 24)
        .padding(.top, 28)
        .padding(.bottom, 24)
        .frame(width: 312, alignment: .top)
        .background(Color.novaSidebar)
    }

    private var header: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color.novaAccent)
                .frame(width: 36, height: 36)
                .overlay(
                    Image(systemName: "sparkles")
                        .font(.system(size: 16, weight: .semibold))
                        .novaForeground(Color.novaSidebarText)
                )
            VStack(alignment: .leading, spacing: 2) {
                Text("Nova Intelligence")
                    .font(.system(size: 16, weight: .semibold))
                    .novaForeground(Color.white)
                Text("beta")
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .novaForeground(Color.novaAccent)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Capsule().fill(Color.novaAccent.opacity(0.16)))
            }
            Spacer()
        }
    }

    private var newChatButton: some View {
        Button(action: {}) {
            HStack(spacing: 12) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 18, weight: .bold))
                Text("New Chat")
                    .font(.system(size: 15, weight: .semibold))
                Spacer()
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.novaButtonGradient)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
            )
            .novaForeground(Color.white)
        }
        .buttonStyle(.plain)
    }

    private var searchField: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 14, weight: .medium))
                .novaForeground(Color.novaMuted)
            TextField("Search", text: $searchText)
                .textFieldStyle(.plain)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white.opacity(0.06))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
    }

    private var pinnedSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(title: "Pinned")
            ForEach(conversations.filter { $0.isPinned }) { conversation in
                ConversationRow(
                    conversation: conversation,
                    isSelected: selectedConversationID == conversation.id
                ) {
                    selectedConversationID = conversation.id
                }
            }
        }
    }

    private var recentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(title: "Recent")
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(conversations.filter { !$0.isPinned }) { conversation in
                        ConversationRow(
                            conversation: conversation,
                            isSelected: selectedConversationID == conversation.id
                        ) {
                            selectedConversationID = conversation.id
                        }
                    }
                }
                .padding(.bottom, 12)
            }
        }
    }

    private var footer: some View {
        VStack(alignment: .leading, spacing: 12) {
            Divider().overlay(Color.novaDivider)
                .padding(.horizontal, -20)
            HStack(spacing: 12) {
                Image(systemName: "person.crop.circle")
                    .font(.system(size: 18, weight: .semibold))
                    .novaForeground(Color.novaMuted)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Obi")
                        .font(.system(size: 13, weight: .semibold))
                        .novaForeground(Color.white)
                    Text("Nova Intelligence Team")
                        .font(.system(size: 11, weight: .medium))
                        .novaForeground(Color.novaMuted)
                }
                Spacer()
                Image(systemName: "ellipsis")
                    .font(.system(size: 14, weight: .semibold))
                    .novaForeground(Color.novaMuted)
            }
        }
    }

    private func sectionHeader(title: String) -> some View {
        Text(title.uppercased())
            .font(.system(size: 11, weight: .semibold))
            .novaForeground(Color.novaSectionHeader)
            .padding(.leading, 4)
    }
}

private struct ConversationRow: View {
    let conversation: Conversation
    let isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(alignment: .center, spacing: 12) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(conversation.accent.opacity(0.24))
                    .overlay(
                        Image(systemName: conversation.icon)
                            .font(.system(size: 14, weight: .semibold))
                            .novaForeground(conversation.accent)
                    )
                    .frame(width: 32, height: 32)
                VStack(alignment: .leading, spacing: 4) {
                    Text(conversation.title)
                        .font(.system(size: 13.5, weight: .semibold))
                        .lineLimit(1)
                    Text(conversation.preview)
                        .font(.system(size: 11.5, weight: .medium))
                        .lineLimit(1)
                        .novaForeground(Color.novaMuted)
                }
                Spacer()
                Text(conversation.relativeDate)
                    .font(.system(size: 11, weight: .medium))
                    .novaForeground(Color.novaMuted)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? Color.white.opacity(0.08) : Color.clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.white.opacity(0.12) : Color.clear, lineWidth: 1)
            )
            .novaForeground(Color.white)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Conversation Column

private struct ConversationColumn: View {
    let conversation: Conversation
    @Binding var selectedModel: String
    @Binding var selectedWorkspace: String
    @Binding var composerText: String
    @Binding var showSettings: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ConversationToolbar(
                selectedModel: $selectedModel,
                selectedWorkspace: $selectedWorkspace,
                showSettings: $showSettings
            )
            Divider().overlay(Color.novaDivider)
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    ConversationHeader(conversation: conversation)
                    ForEach(conversation.messages) { message in
                        MessageRow(message: message)
                    }
                    SuggestionsCluster(suggestions: conversation.suggestions)
                }
                .padding(.horizontal, 36)
                .padding(.vertical, 32)
            }
            Divider().overlay(Color.novaDivider)
            ComposerView(text: $composerText)
                .padding(.horizontal, 28)
                .padding(.vertical, 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.novaContent)
    }
}

private struct ConversationToolbar: View {
    @Binding var selectedModel: String
    @Binding var selectedWorkspace: String
    @Binding var showSettings: Bool

    var body: some View {
        HStack(spacing: 16) {
            ModelPill(title: selectedModel) {
                Menu {
                    ForEach(SampleData.models, id: \.self) { model in
                        Button(model) { selectedModel = model }
                    }
                } label: {
                    ModelPillLabel(text: selectedModel)
                }
                .menuStyle(.borderlessButton)
            }

            WorkspacePill(title: selectedWorkspace) {
                Menu {
                    ForEach(SampleData.workspaces, id: \.self) { workspace in
                        Button(workspace) { selectedWorkspace = workspace }
                    }
                } label: {
                    ModelPillLabel(text: selectedWorkspace)
                }
                .menuStyle(.borderlessButton)
            }

            Spacer()

            ToolbarIconButton(systemName: "rectangle.and.pencil.and.ellipsis")
            ToolbarIconButton(systemName: "slider.horizontal.3")
            ToolbarIconButton(systemName: "bell")
            Button(action: { showSettings = true }) {
                ToolbarIconButtonContent(systemName: "gearshape")
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 28)
        .padding(.vertical, 22)
        .background(Color.novaContent)
    }
}

private struct ModelPill<Content: View>: View {
    var title: String
    @ViewBuilder var content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        content
    }
}

private struct ModelPillLabel: View {
    let text: String

    var body: some View {
        HStack(spacing: 8) {
            Text(text)
                .font(.system(size: 13, weight: .semibold))
            Image(systemName: "chevron.down")
                .font(.system(size: 12, weight: .semibold))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white.opacity(0.04))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.white.opacity(0.12), lineWidth: 1)
        )
        .novaForeground(Color.white)
    }
}

private struct WorkspacePill<Content: View>: View {
    let title: String
    @ViewBuilder var content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        content
    }
}

private struct ToolbarIconButton: View {
    let systemName: String

    var body: some View {
        Button(action: {}) {
            ToolbarIconButtonContent(systemName: systemName)
        }
        .buttonStyle(.plain)
    }
}

private struct ToolbarIconButtonContent: View {
    let systemName: String

    var body: some View {
        Image(systemName: systemName)
            .font(.system(size: 16, weight: .semibold))
            .novaForeground(Color.white)
            .frame(width: 42, height: 42)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.white.opacity(0.05))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
    }
}

private struct ConversationHeader: View {
    let conversation: Conversation

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .center, spacing: 18) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(conversation.title)
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                        .novaForeground(Color.white)
                    Text("Last updated \(conversation.relativeDate) • \(conversation.model)")
                        .font(.system(size: 12.5, weight: .medium))
                        .novaForeground(Color.novaMuted)
                }
                Spacer()
                HStack(spacing: 10) {
                    NovaTag(text: "Workspace")
                    NovaTag(text: conversation.model)
                }
            }

            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.04))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                )
                .frame(height: 1)
        }
    }
}

private struct MessageRow: View {
    let message: Conversation.Message

    var body: some View {
        HStack(alignment: .top, spacing: 18) {
            Circle()
                .fill(message.role == .assistant ? Color.novaAccent : Color.novaUser)
                .frame(width: 40, height: 40)
                .overlay(
                    Text(message.role == .assistant ? "NI" : "OB")
                        .font(.system(size: 14, weight: .bold))
                        .novaForeground(Color.white)
                )
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .center) {
                    Text(message.role == .assistant ? "Nova Intelligence" : "Obi")
                        .font(.system(size: 13.5, weight: .semibold))
                        .novaForeground(Color.white)
                    Text(message.timestamp)
                        .font(.system(size: 11.5, weight: .medium))
                        .novaForeground(Color.novaMuted)
                    Spacer()
                    if message.role == .assistant {
                        Image(systemName: "sparkles")
                            .font(.system(size: 12, weight: .semibold))
                            .novaForeground(Color.novaAccent)
                    }
                }
                Text(message.content)
                    .font(.system(size: 14.5, weight: .regular))
                    .lineSpacing(6)
                    .novaForeground(Color.white.opacity(0.94))
                if let highlights = message.highlights {
                    HighlightCard(highlights: highlights)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 18)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(message.role == .assistant ? Color.novaAssistantBubble : Color.novaUserBubble)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(Color.white.opacity(0.07), lineWidth: 1)
            )
        }
    }
}

private struct HighlightCard: View {
    let highlights: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Highlights")
                .font(.system(size: 12, weight: .semibold))
                .novaForeground(Color.novaMuted)
            ForEach(highlights, id: \.self) { item in
                HStack(alignment: .top, spacing: 8) {
                    Circle()
                        .fill(Color.novaAccent.opacity(0.24))
                        .frame(width: 18, height: 18)
                        .overlay(
                            Image(systemName: "checkmark")
                                .font(.system(size: 10, weight: .bold))
                                .novaForeground(Color.novaAccent)
                        )
                    Text(item)
                        .font(.system(size: 13, weight: .medium))
                        .novaForeground(Color.white.opacity(0.94))
                }
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white.opacity(0.03))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.white.opacity(0.06), lineWidth: 1)
        )
    }
}

private struct SuggestionsCluster: View {
    let suggestions: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Try asking")
                .font(.system(size: 12, weight: .semibold))
                .novaForeground(Color.novaMuted)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 140), spacing: 10), count: 2), spacing: 10) {
                ForEach(suggestions, id: \.self) { suggestion in
                    Text(suggestion)
                        .font(.system(size: 12.5, weight: .semibold))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            Capsule()
                                .fill(Color.white.opacity(0.06))
                        )
                        .overlay(
                            Capsule()
                                .stroke(Color.white.opacity(0.08), lineWidth: 1)
                        )
                        .novaForeground(Color.white)
                }
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white.opacity(0.03))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.white.opacity(0.05), lineWidth: 1)
        )
    }
}

private struct ComposerView: View {
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(spacing: 12) {
                ComposerAction(icon: "tray.and.arrow.up", label: "Upload Files")
                ComposerAction(icon: "camera", label: "Capture")
                ComposerAction(icon: "note.text", label: "Attach Note")
                Spacer()
                ToolbarIconButton(systemName: "mic")
                ToolbarIconButton(systemName: "square.grid.2x2")
            }
            .padding(.horizontal, 6)

            VStack(spacing: 0) {
                TextEditor(text: $text)
                    .font(.system(size: 14.5))
                    .scrollContentBackground(.hidden)
                    .frame(minHeight: 120, maxHeight: 160)
                    .padding(.horizontal, 24)
                    .padding(.top, 22)
                    .padding(.bottom, 14)
                    .background(Color.clear)
                Divider().overlay(Color.white.opacity(0.06))
                HStack(spacing: 12) {
                    HStack(spacing: 8) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 13, weight: .semibold))
                        Text("Nova Suggest is enabled")
                            .font(.system(size: 12, weight: .medium))
                    }
                    .novaForeground(Color.novaMuted)
                    Spacer()
                    Button(action: {}) {
                        Text("Generate")
                            .font(.system(size: 14, weight: .semibold))
                            .padding(.horizontal, 24)
                            .padding(.vertical, 10)
                            .background(
                                Capsule()
                                    .fill(Color.novaAccent)
                            )
                            .novaForeground(Color.black)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 14)
            }
            .background(
                RoundedRectangle(cornerRadius: 28)
                    .fill(Color.white.opacity(0.04))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 28)
                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
            )
        }
    }
}

private struct ComposerAction: View {
    let icon: String
    let label: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 12, weight: .semibold))
            Text(label)
                .font(.system(size: 12, weight: .medium))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.04))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
        .novaForeground(Color.novaMuted)
    }
}

private struct NovaTag: View {
    let text: String

    var body: some View {
        Text(text.uppercased())
            .font(.system(size: 10, weight: .bold))
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(Color.white.opacity(0.08))
            )
            .overlay(
                Capsule()
                    .stroke(Color.white.opacity(0.12), lineWidth: 1)
            )
            .novaForeground(Color.novaMuted)
    }
}

// MARK: - Secondary Column

private struct SecondaryColumn: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                SessionPanel()
                QuickActionsPanel()
                KeyboardShortcutsPanel()
            }
            .padding(.horizontal, 26)
            .padding(.vertical, 32)
        }
        .frame(width: 320, maxHeight: .infinity)
        .background(Color.novaSidebar)
    }
}

private struct SessionPanel: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            panelHeader(title: "Session")
            VStack(alignment: .leading, spacing: 10) {
                SessionRow(title: "Project", value: "Nova Classroom Vision")
                SessionRow(title: "Owner", value: "Obi")
                SessionRow(title: "Created", value: "Mar 6, 2025")
            }
        }
        .padding(22)
        .background(NovaPanelBackground())
    }
}

private struct QuickActionsPanel: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            panelHeader(title: "Quick Actions")
            VStack(alignment: .leading, spacing: 12) {
                ForEach(SampleData.quickActions, id: \.self) { action in
                    HStack(spacing: 10) {
                        Image(systemName: action.icon)
                            .font(.system(size: 12, weight: .semibold))
                            .novaForeground(Color.novaAccent)
                        Text(action.title)
                            .font(.system(size: 12.5, weight: .medium))
                            .novaForeground(Color.white)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 10, weight: .semibold))
                            .novaForeground(Color.novaMuted)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white.opacity(0.05))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.08), lineWidth: 1)
                    )
                }
            }
        }
        .padding(22)
        .background(NovaPanelBackground())
    }
}

private struct KeyboardShortcutsPanel: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            panelHeader(title: "Keyboard Shortcuts")
            VStack(alignment: .leading, spacing: 10) {
                ShortcutRow(keys: "⌘" + "K", description: "Command Palette")
                ShortcutRow(keys: "⌘" + "⇧" + "F", description: "Search Messages")
                ShortcutRow(keys: "⌘" + "Enter", description: "Send Message")
            }
        }
        .padding(22)
        .background(NovaPanelBackground())
    }
}

private struct SessionRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .novaForeground(Color.novaMuted)
            Spacer()
            Text(value)
                .font(.system(size: 12.5, weight: .semibold))
                .novaForeground(Color.white)
        }
        Divider().overlay(Color.white.opacity(0.06))
    }
}

private struct ShortcutRow: View {
    let keys: String
    let description: String

    var body: some View {
        HStack(spacing: 12) {
            ShortcutBadge(text: keys)
            Text(description)
                .font(.system(size: 12.5, weight: .medium))
                .novaForeground(Color.white)
            Spacer()
        }
    }
}

private struct ShortcutBadge: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.system(size: 12, weight: .bold))
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.08))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
            .novaForeground(Color.white)
    }
}

private func panelHeader(title: String) -> some View {
    Text(title.uppercased())
        .font(.system(size: 11, weight: .semibold))
        .novaForeground(Color.novaSectionHeader)
}

private struct NovaPanelBackground: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 24)
            .fill(Color.white.opacity(0.04))
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
            )
    }
}

// MARK: - Settings Overlay

private struct SettingsOverlay: View {
    @Binding var isPresented: Bool
    @State private var category: SettingsCategory = .general
    @State private var theme: ThemeOption = .system
    @State private var language: LanguageOption = .englishUS
    @State private var telemetry = false
    @State private var autoArchive = true
    @State private var voiceMode = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.55)
                .ignoresSafeArea()
                .onTapGesture { isPresented = false }

            VStack(spacing: 0) {
                header
                Divider().overlay(Color.novaDivider)
                HStack(spacing: 0) {
                    SettingsSidebar(category: $category)
                    Divider().overlay(Color.novaDivider)
                    SettingsDetail(
                        category: category,
                        theme: $theme,
                        language: $language,
                        telemetry: $telemetry,
                        autoArchive: $autoArchive,
                        voiceMode: $voiceMode
                    )
                }
                Divider().overlay(Color.novaDivider)
                footer
            }
            .frame(width: 860, height: 520)
            .background(
                RoundedRectangle(cornerRadius: 32)
                    .fill(Color.novaSurface)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 32)
                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
            )
        }
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Settings")
                    .font(.system(size: 18, weight: .semibold))
                    .novaForeground(Color.white)
                Text("Nova Intelligence (beta)")
                    .font(.system(size: 12, weight: .medium))
                    .novaForeground(Color.novaMuted)
            }
            Spacer()
            Button(action: { isPresented = false }) {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .bold))
                    .novaForeground(Color.white)
                    .padding(10)
                    .background(
                        Circle().fill(Color.white.opacity(0.05))
                    )
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 28)
        .padding(.vertical, 24)
    }

    private var footer: some View {
        HStack {
            NovaTag(text: "Version 0.6.34")
            Spacer()
            Button(action: { isPresented = false }) {
                Text("Close")
                    .font(.system(size: 14, weight: .semibold))
                    .padding(.horizontal, 26)
                    .padding(.vertical, 12)
                    .background(
                        Capsule()
                            .fill(Color.novaAccent)
                    )
                    .novaForeground(Color.black)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 28)
        .padding(.vertical, 18)
    }
}

private struct SettingsSidebar: View {
    @Binding var category: SettingsCategory

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(SettingsCategory.allCases) { item in
                Button(action: { category = item }) {
                    HStack(spacing: 12) {
                        Image(systemName: item.icon)
                            .font(.system(size: 14, weight: .semibold))
                            .novaForeground(category == item ? Color.novaAccent : Color.novaMuted)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(item.title)
                                .font(.system(size: 13.5, weight: .semibold))
                            Text(item.subtitle)
                                .font(.system(size: 11, weight: .medium))
                                .novaForeground(Color.novaMuted)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 18)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(category == item ? Color.white.opacity(0.08) : Color.clear)
                    )
                }
                .buttonStyle(.plain)
            }
            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 24)
        .frame(width: 260, alignment: .top)
        .background(Color.novaSurfaceShade)
    }
}

private struct SettingsDetail: View {
    let category: SettingsCategory
    @Binding var theme: ThemeOption
    @Binding var language: LanguageOption
    @Binding var telemetry: Bool
    @Binding var autoArchive: Bool
    @Binding var voiceMode: Bool

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                switch category {
                case .general:
                    generalSection
                case .interface:
                    interfaceSection
                case .tools:
                    toolsSection
                case .personalisation:
                    personalisationSection
                case .audio:
                    audioSection
                case .dataControls:
                    dataControlsSection
                case .account:
                    accountSection
                case .about:
                    aboutSection
                case .search:
                    searchSection
                }
            }
            .padding(32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.novaSurface)
    }

    private var generalSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(title: "Theme")
            SegmentedControl(options: ThemeOption.allCases.map { $0.title }, selection: Binding(
                get: { theme.index },
                set: { theme = ThemeOption(index: $0) }
            ))
            SectionHeader(title: "Language")
            Picker("Language", selection: $language) {
                ForEach(LanguageOption.allCases) { option in
                    Text(option.title).tag(option)
                }
            }
            .pickerStyle(.segmented)
            .frame(maxWidth: 420)
        }
    }

    private var interfaceSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(title: "Interface")
            NovaToggleRow(title: "Auto-archive inactive chats", isOn: $autoArchive)
            NovaToggleRow(title: "Show message timestamps", isOn: .constant(true))
        }
    }

    private var toolsSection: some View {
        VStack(alignment: .leading, spacing: 18) {
            SectionHeader(title: "Connected Tools")
            SettingsListRow(title: "Google Drive", detail: "Connected")
            SettingsListRow(title: "Slack", detail: "Requires attention")
            SettingsListRow(title: "Figma", detail: "Not connected")
        }
    }

    private var personalisationSection: some View {
        VStack(alignment: .leading, spacing: 18) {
            SectionHeader(title: "Personalisation")
            SettingsTextBlock(text: SampleData.systemPrompt)
        }
    }

    private var audioSection: some View {
        VStack(alignment: .leading, spacing: 18) {
            SectionHeader(title: "Voice Mode")
            NovaToggleRow(title: "Enable Nova Voice", isOn: $voiceMode)
            SettingsListRow(title: "Preferred voice", detail: "Nova Tone")
        }
    }

    private var dataControlsSection: some View {
        VStack(alignment: .leading, spacing: 18) {
            SectionHeader(title: "Data Controls")
            NovaToggleRow(title: "Allow product telemetry", isOn: $telemetry)
            SettingsListRow(title: "Clear chat history", detail: "3.1 GB")
        }
    }

    private var accountSection: some View {
        VStack(alignment: .leading, spacing: 18) {
            SectionHeader(title: "Account")
            SettingsListRow(title: "Plan", detail: "Nova Intelligence (beta)")
            SettingsListRow(title: "Members", detail: "8 seats")
        }
    }

    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 18) {
            SectionHeader(title: "About")
            SettingsTextBlock(text: SampleData.licenseText)
        }
    }

    private var searchSection: some View {
        VStack(alignment: .leading, spacing: 18) {
            SectionHeader(title: "Search")
            SettingsTextBlock(text: "Manage search indexing and shortcuts for Nova Intelligence conversations.")
        }
    }
}

private struct SectionHeader: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.system(size: 13, weight: .bold))
            .novaForeground(Color.white)
    }
}

private struct SegmentedControl: View {
    let options: [String]
    @Binding var selection: Int

    var body: some View {
        HStack(spacing: 8) {
            ForEach(Array(options.enumerated()), id: \.offset) { index, title in
                Button(action: { selection = index }) {
                    Text(title)
                        .font(.system(size: 12.5, weight: .semibold))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(selection == index ? Color.novaAccent : Color.white.opacity(0.06))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white.opacity(0.08), lineWidth: 1)
                        )
                        .novaForeground(selection == index ? Color.black : Color.white)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

private struct NovaToggleRow: View {
    let title: String
    @Binding var isOn: Bool

    var body: some View {
        Toggle(isOn: $isOn) {
            Text(title)
                .font(.system(size: 13, weight: .medium))
                .novaForeground(Color.white)
        }
        .toggleStyle(SwitchToggleStyle(tint: Color.novaAccent))
        .padding(.horizontal, 4)
    }
}

private struct SettingsListRow: View {
    let title: String
    let detail: String

    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 13, weight: .medium))
                .novaForeground(Color.white)
            Spacer()
            Text(detail)
                .font(.system(size: 12, weight: .semibold))
                .novaForeground(Color.novaMuted)
            Image(systemName: "chevron.right")
                .font(.system(size: 11, weight: .bold))
                .novaForeground(Color.novaMuted)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.05))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
    }
}

private struct SettingsTextBlock: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.system(size: 12.5, weight: .medium))
            .lineSpacing(6)
            .novaForeground(Color.white.opacity(0.9))
            .padding(18)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.05))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
            )
    }
}

private enum SettingsCategory: String, CaseIterable, Identifiable {
    case search
    case general
    case interface
    case tools
    case personalisation
    case audio
    case dataControls
    case account
    case about

    var id: String { rawValue }

    var title: String {
        switch self {
        case .search: return "Search"
        case .general: return "General"
        case .interface: return "Interface"
        case .tools: return "External Tools"
        case .personalisation: return "Personalisation"
        case .audio: return "Audio"
        case .dataControls: return "Data Controls"
        case .account: return "Account"
        case .about: return "About"
        }
    }

    var subtitle: String {
        switch self {
        case .search: return "Commands, palette & results"
        case .general: return "Theme, language, defaults"
        case .interface: return "Layout preferences"
        case .tools: return "Linked integrations"
        case .personalisation: return "Prompts & behaviours"
        case .audio: return "Voice configuration"
        case .dataControls: return "Retention & privacy"
        case .account: return "Plan & members"
        case .about: return "Version & credits"
        }
    }

    var icon: String {
        switch self {
        case .search: return "text.magnifyingglass"
        case .general: return "gearshape"
        case .interface: return "rectangle.split.3x1"
        case .tools: return "puzzlepiece.extension"
        case .personalisation: return "wand.and.stars"
        case .audio: return "waveform"
        case .dataControls: return "lock.shield"
        case .account: return "person.2"
        case .about: return "info.circle"
        }
    }
}

private enum ThemeOption: String, CaseIterable, Identifiable {
    case system
    case dark
    case light

    var id: String { rawValue }

    var title: String {
        switch self {
        case .system: return "System"
        case .dark: return "Dark"
        case .light: return "Light"
        }
    }

    var index: Int {
        ThemeOption.allCases.firstIndex(of: self) ?? 0
    }

    init(index: Int) {
        self = ThemeOption.allCases[index]
    }
}

private enum LanguageOption: String, CaseIterable, Identifiable {
    case englishUS
    case englishUK
    case french

    var id: String { rawValue }

    var title: String {
        switch self {
        case .englishUS: return "English (US)"
        case .englishUK: return "English (UK)"
        case .french: return "French"
        }
    }
}

// MARK: - Sample Data

private struct Conversation: Identifiable {
    struct Message: Identifiable {
        enum Role { case user, assistant }

        let id = UUID()
        let role: Role
        let content: String
        let timestamp: String
        var highlights: [String]? = nil
    }

    struct QuickAction: Hashable {
        let icon: String
        let title: String
    }

    let id: UUID
    let title: String
    let preview: String
    let relativeDate: String
    let model: String
    let icon: String
    let accent: Color
    let isPinned: Bool
    let messages: [Message]
    let suggestions: [String]

    init(
        id: UUID = UUID(),
        title: String,
        preview: String,
        relativeDate: String,
        model: String,
        icon: String,
        accent: Color,
        isPinned: Bool = false,
        messages: [Message],
        suggestions: [String]
    ) {
        self.id = id
        self.title = title
        self.preview = preview
        self.relativeDate = relativeDate
        self.model = model
        self.icon = icon
        self.accent = accent
        self.isPinned = isPinned
        self.messages = messages
        self.suggestions = suggestions
    }
}

private enum SampleData {
    static let defaultPrompt = "What are five creative things I could do with my kids' art?"

    private static let featuredMessages: [Conversation.Message] = [
        Conversation.Message(
            role: .assistant,
            content: "Here are five creative ways to transform your kids' art into keepsakes and displays:\n\n1. **Gallery Wall Rotation** — Frame a grid of their favorite pieces using magnetic frames so you can swap new art each week.\n2. **Storybook Compilation** — Photograph each masterpiece and create a yearly photo book with captions they dictate.\n3. **Gift Wrap Station** — Turn drawings into custom wrapping paper or thank-you cards for family.\n4. **Fabric Transfer Quilt** — Scan the artwork, print on fabric sheets, and stitch a cozy quilt that keeps memories close.\n5. **Shadow Box Exhibits** — Combine 3D crafts with photos in labeled shadow boxes that rotate seasonally.",
            timestamp: "Now",
            highlights: [
                "Magnetic gallery wall for easy rotation",
                "Storybook photo album with artist captions",
                "Fabric transfer quilt using scanned artwork"
            ]
        ),
        Conversation.Message(
            role: .user,
            content: "These are amazing! Can you draft an email to parents explaining the rotating gallery idea?",
            timestamp: "1 min ago"
        ),
        Conversation.Message(
            role: .assistant,
            content: "Absolutely! Here's a warm, professional draft you can adapt for your classroom.\n\n---\n\nSubject: Showcasing Our Young Artists\n\nHi families,\n\nWe're launching a rotating art gallery to celebrate the imagination blooming in our classroom. Each week, we'll feature a new set of student creations along our hallway display. Students will curate their pieces, add short artist statements, and learn how to present their work with pride.\n\nIf you'd like to help mount frames or photograph artwork, let me know—I'd love to coordinate a volunteer schedule. We'll also capture every display digitally so you can revisit the collection anytime.\n\nThank you for championing our artists!\n\nWarmly,\nObi",
            timestamp: "moments ago"
        )
    ]

    static let conversations: [Conversation] = [
        Conversation(
            title: "Classroom art showcase plan",
            preview: "Outline ideas to display student artwork",
            relativeDate: "5 minutes ago",
            model: "Nova Ultra",
            icon: "wand.and.stars",
            accent: Color(red: 0.83, green: 0.61, blue: 0.21),
            isPinned: true,
            messages: featuredMessages,
            suggestions: [
                "Draft a parent newsletter",
                "Create a budget for the gallery",
                "Design student feedback prompts",
                "Plan the unveiling event"
            ]
        ),
        Conversation(
            title: "STEM night prompts",
            preview: "Generate interactive booth ideas",
            relativeDate: "Yesterday",
            model: "Nova Ultra",
            icon: "cube.transparent",
            accent: Color(red: 0.49, green: 0.62, blue: 0.99),
            messages: featuredMessages,
            suggestions: ["Map the schedule", "Draft volunteer roles"]
        ),
        Conversation(
            title: "Reading level summaries",
            preview: "Summaries for parent updates",
            relativeDate: "2 days ago",
            model: "Nova Mini",
            icon: "book.closed",
            accent: Color(red: 0.57, green: 0.79, blue: 0.62),
            messages: featuredMessages,
            suggestions: ["Create takeaway PDF"]
        ),
        Conversation(
            title: "Field trip logistics",
            preview: "Draft permission slip copy",
            relativeDate: "1 week ago",
            model: "Nova Voice",
            icon: "bus",
            accent: Color(red: 0.89, green: 0.53, blue: 0.55),
            messages: featuredMessages,
            suggestions: ["Outline bus schedule"]
        )
    ]

    static let models = ["Nova Ultra", "Nova Mini", "Nova Voice"]
    static let workspaces = ["Default", "Team", "Personal"]

    static let quickActions: [Conversation.QuickAction] = [
        .init(icon: "doc.on.doc", title: "Summarize last 7 days"),
        .init(icon: "calendar", title: "Plan a class event"),
        .init(icon: "bolt", title: "Generate teaching ideas")
    ]

    static let systemPrompt = "Nova Intelligence (beta) mirrors the Open WebUI interface with SwiftUI components for a seamless desktop experience."

    static let licenseText = "Nova Intelligence (beta) incorporates interface concepts inspired by the Open WebUI project. This native SwiftUI build recreates the layout, shortcuts, and visual system without bundling upstream binaries."
}

// MARK: - Colors & Helpers

private extension Color {
    static let novaWindow = Color(red: 0.08, green: 0.08, blue: 0.1)
    static let novaSidebar = Color(red: 0.12, green: 0.13, blue: 0.16)
    static let novaSidebarText = Color(red: 0.16, green: 0.16, blue: 0.2)
    static let novaContent = Color(red: 0.11, green: 0.11, blue: 0.14)
    static let novaSurface = Color(red: 0.15, green: 0.16, blue: 0.19)
    static let novaSurfaceShade = Color(red: 0.13, green: 0.13, blue: 0.16)
    static let novaDivider = Color.white.opacity(0.06)
    static let novaAccent = Color(red: 0.95, green: 0.72, blue: 0.32)
    static let novaMuted = Color.white.opacity(0.68)
    static let novaSectionHeader = Color.white.opacity(0.45)
    static let novaButtonGradient = LinearGradient(
        gradient: Gradient(colors: [Color(red: 0.99, green: 0.71, blue: 0.32), Color(red: 0.9, green: 0.49, blue: 0.28)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    static let novaAssistantBubble = Color(red: 0.17, green: 0.18, blue: 0.22)
    static let novaUserBubble = Color(red: 0.16, green: 0.18, blue: 0.22)
    static let novaUser = Color(red: 0.44, green: 0.61, blue: 0.99)
}

private extension View {
    @ViewBuilder
    func novaForeground(_ color: Color) -> some View {
        if #available(macOS 14.0, iOS 17.0, tvOS 17.0, *) {
            self.foregroundStyle(color)
        } else {
            self.foregroundColor(color)
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewLayout(.fixed(width: 1440, height: 900))
    }
}
#endif
#endif
