#if canImport(SwiftUI)
import SwiftUI
import Foundation
#if os(macOS)
import AppKit
#endif

struct ContentView: View {
    @State private var isShowingSettings = false
    @State private var selectedConversationID: UUID = SampleData.conversations.first?.id ?? UUID()
    @State private var activeStyle: NovaTheme.Style = .light
    @State private var selectedModel: ModelProfile = SampleData.models.first ?? SampleData.models[0]
    @State private var selectedWorkspace: String = SampleData.workspaces.first ?? "Default"
    @State private var composerText = SampleData.defaultPrompt
    @State private var searchText = ""

    private var palette: NovaTheme.Palette {
        NovaTheme.palette(for: activeStyle)
    }

    private var selectedConversation: Conversation {
        SampleData.conversations.first { $0.id == selectedConversationID } ?? SampleData.conversations[0]
    }

    var body: some View {
        ZStack(alignment: .center) {
            palette.canvas.ignoresSafeArea()

            HStack(spacing: 0) {
                NavigationRail(
                    style: $activeStyle,
                    palette: palette,
                    isSettingsPresented: $isShowingSettings
                )

                Divider().overlay(palette.divider)

                ConversationSidebar(
                    palette: palette,
                    searchText: $searchText,
                    selectedConversationID: $selectedConversationID,
                    conversations: SampleData.conversations
                )
                .frame(width: 300)

                Divider().overlay(palette.divider)

                ConversationWorkspace(
                    palette: palette,
                    conversation: selectedConversation,
                    models: SampleData.models,
                    selectedModel: $selectedModel,
                    selectedWorkspace: $selectedWorkspace,
                    composerText: $composerText,
                    themeStyle: $activeStyle,
                    isShowingSettings: $isShowingSettings
                )
            }
            .frame(minWidth: 1180, minHeight: 740)

            if isShowingSettings {
                SettingsOverlay(palette: palette, isPresented: $isShowingSettings, style: $activeStyle)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.22), value: isShowingSettings)
        .background(palette.canvas)
    }
}

// MARK: - Navigation Rail

private struct NavigationRail: View {
    @Binding var style: NovaTheme.Style
    let palette: NovaTheme.Palette
    @Binding var isSettingsPresented: Bool

    var body: some View {
        VStack(spacing: 26) {
            VStack(spacing: 10) {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(palette.railAccent)
                    .frame(width: 46, height: 46)
                    .overlay(
                        Text("NI")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(palette.railOnAccent)
                    )
                Text("Nova Intelligence")
                    .font(.system(size: 11, weight: .semibold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(palette.sectionLabel)
                    .frame(width: 68)
            }

            VStack(spacing: 10) {
                RailButton(symbol: "plus", label: "New Chat", palette: palette, isActive: true)
                RailButton(symbol: "tray.full", label: "Workspace", palette: palette, isActive: false)
                RailButton(symbol: "magnifyingglass", label: "Search", palette: palette, isActive: false)
            }

            Spacer()

            VStack(spacing: 16) {
                Menu {
                    Button("System") { style = .system }
                    Button("Light") { style = .light }
                    Button("Dark") { style = .dark }
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: "paintpalette")
                            .font(.system(size: 15, weight: .semibold))
                        Text(style.label)
                            .font(.system(size: 11, weight: .medium))
                    }
                    .foregroundColor(palette.sectionLabel)
                }
                .menuStyle(.borderlessButton)

                Button(action: { isSettingsPresented = true }) {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(palette.primaryText)
                        .frame(width: 44, height: 44)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(palette.surface)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .stroke(palette.outline)
                                )
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical, 28)
        .padding(.horizontal, 18)
        .frame(width: 96)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [palette.railGradientStart, palette.railGradientEnd]),
                startPoint: .top,
                endPoint: .bottom
            )
            .overlay(
                Rectangle()
                    .stroke(palette.railBorder, lineWidth: 1)
            )
        )
    }
}

private struct RailButton: View {
    let symbol: String
    let label: String
    let palette: NovaTheme.Palette
    let isActive: Bool

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: symbol)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(isActive ? palette.onAccent : palette.sectionLabel)
                .frame(width: 48, height: 48)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(
                            isActive
                                ? LinearGradient(
                                    gradient: Gradient(colors: [palette.accent.opacity(0.42), palette.accent.opacity(0.18)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                                : palette.railItemBackground
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(isActive ? palette.accent.opacity(0.7) : palette.railBorder.opacity(0.6))
                        )
                )
            Text(label)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(isActive ? palette.onAccent : palette.sectionLabel)
        }
        .overlay(
            Capsule()
                .fill(palette.accent)
                .frame(width: 4)
                .offset(x: -34)
                .opacity(isActive ? 1 : 0)
        )
    }
}

// MARK: - Conversation Sidebar

private struct ConversationSidebar: View {
    let palette: NovaTheme.Palette
    @Binding var searchText: String
    @Binding var selectedConversationID: UUID
    let conversations: [Conversation]

    private var pinned: [Conversation] {
        conversations.filter { $0.isPinned }
    }

    private var recent: [Conversation] {
        conversations.filter { !$0.isPinned }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 18) {
                Text("Chats")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(palette.primaryText)

                Label {
                    TextField("Search", text: $searchText)
                        .textFieldStyle(.plain)
                        .font(.system(size: 13))
                        .foregroundColor(palette.primaryText)
                } icon: {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(palette.subtleText)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(palette.surface)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(palette.outline)
                        )
                )

                if !pinned.isEmpty {
                    SidebarSection(title: "Pinned", palette: palette) {
                        ForEach(pinned) { conversation in
                            ConversationRow(
                                palette: palette,
                                conversation: conversation,
                                isSelected: selectedConversationID == conversation.id
                            ) {
                                selectedConversationID = conversation.id
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 32)

            SidebarSection(title: "Recent", palette: palette) {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 10) {
                        ForEach(recent) { conversation in
                            ConversationRow(
                                palette: palette,
                                conversation: conversation,
                                isSelected: selectedConversationID == conversation.id
                            ) {
                                selectedConversationID = conversation.id
                            }
                        }
                    }
                    .padding(.bottom, 24)
                }
            }
            .padding(.horizontal, 24)

            Spacer()

            HStack(spacing: 12) {
                Circle()
                    .fill(palette.surface)
                    .frame(width: 36, height: 36)
                    .overlay(
                        Text("OB")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(palette.primaryText)
                    )
                VStack(alignment: .leading, spacing: 2) {
                    Text("Obi")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(palette.primaryText)
                    Text("Nova Intelligence Team")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(palette.subtleText)
                }
                Spacer()
                Image(systemName: "ellipsis")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(palette.subtleText)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 22)
        }
        .background(palette.sidebar)
    }
}

private struct SidebarSection<Content: View>: View {
    let title: String
    let palette: NovaTheme.Palette
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title.uppercased())
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(palette.sectionLabel)
                .padding(.leading, 4)
                .textCase(.uppercase)
            content()
        }
        .padding(.vertical, 18)
    }
}

private struct ConversationRow: View {
    let palette: NovaTheme.Palette
    let conversation: Conversation
    let isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Circle()
                    .fill(conversation.accent.opacity(0.18))
                    .frame(width: 32, height: 32)
                    .overlay(
                        Image(systemName: conversation.icon)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(conversation.accent)
                    )
                VStack(alignment: .leading, spacing: 4) {
                    Text(conversation.title)
                        .font(.system(size: 13.5, weight: .semibold))
                        .lineLimit(1)
                        .foregroundColor(palette.primaryText)
                    Text(conversation.preview)
                        .font(.system(size: 12))
                        .lineLimit(1)
                        .foregroundColor(palette.subtleText)
                }
                Spacer()
                Text(conversation.relativeDate)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(palette.subtleText)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(isSelected ? palette.surface : Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .stroke(isSelected ? palette.accent : palette.outline, lineWidth: isSelected ? 1.2 : 1)
                    )
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Workspace

private struct ConversationWorkspace: View {
    let palette: NovaTheme.Palette
    let conversation: Conversation
    let models: [ModelProfile]
    @Binding var selectedModel: ModelProfile
    @Binding var selectedWorkspace: String
    @Binding var composerText: String
    @Binding var themeStyle: NovaTheme.Style
    @Binding var isShowingSettings: Bool

    var body: some View {
        VStack(spacing: 0) {
            Toolbar
                .init(
                    palette: palette,
                    models: models,
                    selectedModel: $selectedModel,
                    selectedWorkspace: $selectedWorkspace,
                    themeStyle: $themeStyle,
                    isShowingSettings: $isShowingSettings
                )

            Divider().overlay(palette.divider)

            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    NovaStatusBanner(palette: palette)
                    WorkspaceHero(
                        palette: palette,
                        conversation: conversation,
                        models: models,
                        selectedModel: $selectedModel
                    )
                    MessageThread(palette: palette, conversation: conversation)
                }
                .padding(.horizontal, 48)
                .padding(.top, 36)
                .padding(.bottom, 120)
            }
            .background(palette.canvas)

            Divider().overlay(palette.divider)

            Composer(palette: palette, text: $composerText)
                .padding(.horizontal, 44)
                .padding(.vertical, 24)
                .background(palette.canvas)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(palette.canvas)
    }
}

private struct Toolbar: View {
    let palette: NovaTheme.Palette
    let models: [ModelProfile]
    @Binding var selectedModel: ModelProfile
    @Binding var selectedWorkspace: String
    @Binding var themeStyle: NovaTheme.Style
    @Binding var isShowingSettings: Bool

    var body: some View {
        HStack(spacing: 18) {
            PillButton(palette: palette) {
                Menu {
                    ForEach(models) { model in
                        Button(model.name) { selectedModel = model }
                    }
                } label: {
                    PillLabel(text: selectedModel.name, palette: palette)
                }
                .menuStyle(.borderlessButton)
            }

            PillButton(palette: palette) {
                Menu {
                    ForEach(SampleData.workspaces, id: \.self) { workspace in
                        Button(workspace) { selectedWorkspace = workspace }
                    }
                } label: {
                    PillLabel(text: selectedWorkspace, palette: palette)
                }
                .menuStyle(.borderlessButton)
            }

            Spacer()

            HStack(spacing: 12) {
                IconButton(symbol: "rectangle.and.pencil.and.ellipsis", palette: palette)
                IconButton(symbol: "slider.horizontal.3", palette: palette)
                IconButton(symbol: "bell", palette: palette)
                Button(action: { isShowingSettings = true }) {
                    IconButtonLabel(symbol: "gearshape", palette: palette)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 44)
        .padding(.vertical, 22)
        .background(palette.canvas)
    }
}

private struct PillButton<Content: View>: View {
    let palette: NovaTheme.Palette
    @ViewBuilder var content: () -> Content

    var body: some View {
        content()
    }
}

private struct PillLabel: View {
    let text: String
    let palette: NovaTheme.Palette

    var body: some View {
        HStack(spacing: 8) {
            Text(text)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(palette.primaryText)
            Image(systemName: "chevron.down")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(palette.subtleText)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(palette.controlSurface)
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(palette.outline)
                )
        )
        .shadow(color: palette.shadow.opacity(0.08), radius: 18, y: 8)
    }
}

private struct IconButton: View {
    let symbol: String
    let palette: NovaTheme.Palette

    var body: some View {
        Button(action: {}) {
            IconButtonLabel(symbol: symbol, palette: palette)
        }
        .buttonStyle(.plain)
    }
}

private struct IconButtonLabel: View {
    let symbol: String
    let palette: NovaTheme.Palette

    var body: some View {
        Image(systemName: symbol)
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(palette.primaryText)
            .frame(width: 42, height: 42)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(palette.controlSurface)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(palette.outline)
                    )
            )
            .shadow(color: palette.shadow.opacity(0.06), radius: 16, y: 8)
    }
}

private struct NovaStatusBanner: View {
    let palette: NovaTheme.Palette

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(palette.successAccent)
                .padding(10)
                .background(Circle().fill(palette.controlSurface))
                .overlay(Circle().stroke(palette.outline))

            VStack(alignment: .leading, spacing: 2) {
                Text(SampleData.bannerTitle)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(palette.bannerText)
                Text(SampleData.bannerMessage)
                    .font(.system(size: 12.5, weight: .medium))
                    .foregroundColor(palette.bannerText)
            }

            Spacer()
        }
        .padding(.horizontal, 22)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(palette.bannerBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(palette.outline)
                )
        )
        .shadow(color: palette.shadow.opacity(0.1), radius: 20, y: 12)
    }
}

private struct WorkspaceHero: View {
    let palette: NovaTheme.Palette
    let conversation: Conversation
    let models: [ModelProfile]
    @Binding var selectedModel: ModelProfile

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack(alignment: .center, spacing: 14) {
                ForEach(models) { model in
                    Button(action: { selectedModel = model }) {
                        ModelAvatar(profile: model, palette: palette, isSelected: selectedModel.id == model.id)
                    }
                    .buttonStyle(.plain)
                }
                Spacer()
                Button(action: {}) {
                    HStack(spacing: 8) {
                        Text("Customize")
                            .font(.system(size: 12.5, weight: .semibold))
                        Image(systemName: "slider.horizontal.3")
                            .font(.system(size: 12.5, weight: .semibold))
                    }
                    .padding(.horizontal, 18)
                    .padding(.vertical, 10)
                    .background(
                        Capsule()
                            .fill(palette.surface)
                            .overlay(Capsule().stroke(palette.outline))
                    )
                }
                .buttonStyle(.plain)
                .foregroundColor(palette.primaryText)
            }

            VStack(alignment: .leading, spacing: 10) {
                Text(SampleData.heroCaption.uppercased())
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(palette.sectionLabel)
                    .tracking(0.6)
                Text(SampleData.heroGreeting)
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(palette.primaryText)
                Text(selectedModel.description)
                    .font(.system(size: 14.5, weight: .medium))
                    .foregroundColor(palette.subtleText)
                    .lineLimit(3)
            }

            ModelStatusBadge(palette: palette, model: selectedModel)

            SuggestionsGrid(palette: palette, suggestions: conversation.suggestions)
        }
        .padding(32)
        .background(
            RoundedRectangle(cornerRadius: 32)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [palette.heroGradientStart, palette.heroGradientEnd]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 32)
                        .stroke(palette.heroStroke)
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 32)
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [palette.accent.opacity(0.14), .clear]),
                        center: .topTrailing,
                        startRadius: 0,
                        endRadius: 220
                    )
                )
                .allowsHitTesting(false)
        )
        .shadow(color: palette.shadow.opacity(0.16), radius: 30, y: 18)
    }
}

private struct ModelAvatar: View {
    let profile: ModelProfile
    let palette: NovaTheme.Palette
    let isSelected: Bool

    private var initials: String {
        profile.name.split(separator: " ").compactMap { $0.first }.prefix(2).map(String.init).joined()
    }

    var body: some View {
        Circle()
            .fill(profile.accent.opacity(0.18))
            .frame(width: 44, height: 44)
            .overlay(
                Circle()
                    .stroke(isSelected ? profile.accent : palette.outline, lineWidth: isSelected ? 2 : 1)
            )
            .overlay(
                Text(initials)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(profile.accent)
            )
            .overlay(
                Circle()
                    .strokeBorder(Color.white.opacity(isSelected ? 0.8 : 0.0), lineWidth: isSelected ? 3 : 0)
            )
            .shadow(color: palette.shadow.opacity(isSelected ? 0.16 : 0.05), radius: isSelected ? 16 : 8, y: isSelected ? 8 : 4)
    }
}

private struct ModelStatusBadge: View {
    let palette: NovaTheme.Palette
    let model: ModelProfile

    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(model.accent)
                .frame(width: 12, height: 12)
            VStack(alignment: .leading, spacing: 2) {
                Text(model.name)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(palette.primaryText)
                Text(model.status)
                    .font(.system(size: 11.5, weight: .medium))
                    .foregroundColor(palette.subtleText)
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(palette.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(palette.outline)
                )
        )
    }
}

private struct MessageThread: View {
    let palette: NovaTheme.Palette
    let conversation: Conversation

    var body: some View {
        VStack(alignment: .leading, spacing: 28) {
            ConversationHeader(palette: palette, conversation: conversation)
            ForEach(conversation.messages) { message in
                MessageRow(palette: palette, message: message)
            }
        }
    }
}

private struct ConversationHeader: View {
    let palette: NovaTheme.Palette
    let conversation: Conversation

    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            VStack(alignment: .leading, spacing: 6) {
                Text(conversation.title)
                    .font(.system(size: 28, weight: .semibold, design: .rounded))
                    .foregroundColor(palette.primaryText)
                Text("Last updated \(conversation.relativeDate) • \(conversation.model)")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(palette.subtleText)
            }
            Spacer()
            HStack(spacing: 8) {
                TagView(text: "Workspace", palette: palette)
                TagView(text: conversation.model, palette: palette)
            }
        }
    }
}

private struct MessageRow: View {
    let palette: NovaTheme.Palette
    let message: Conversation.Message

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .center, spacing: 14) {
                Circle()
                    .fill(message.role == .assistant ? palette.accent.opacity(0.08) : palette.userBubble)
                    .frame(width: 42, height: 42)
                    .overlay(
                        Group {
                            if message.role == .assistant {
                                Image(systemName: "sparkles")
                                    .font(.system(size: 16, weight: .semibold))
                            } else {
                                Text("OB")
                                    .font(.system(size: 14, weight: .semibold))
                            }
                        }
                        .foregroundColor(message.role == .assistant ? palette.accent : palette.primaryText)
                    )
                VStack(alignment: .leading, spacing: 2) {
                    Text(message.role == .assistant ? "Nova Intelligence (beta)" : "Obi")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(palette.primaryText)
                    Text(message.timestamp)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(palette.subtleText)
                }
                Spacer()
            }

            VStack(alignment: .leading, spacing: 14) {
                Text(message.content)
                    .font(.system(size: 13.5))
                    .foregroundColor(palette.primaryText)
                    .lineSpacing(4)
                if let highlights = message.highlights {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Highlights")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(palette.primaryText)
                        ForEach(highlights, id: \.self) { highlight in
                            HStack(alignment: .top, spacing: 8) {
                                Text("•")
                                    .foregroundColor(palette.subtleText)
                                Text(highlight)
                                    .foregroundColor(palette.primaryText)
                                    .font(.system(size: 12.5))
                            }
                        }
                    }
                    .padding(18)
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(palette.surface)
                            .overlay(
                                RoundedRectangle(cornerRadius: 18)
                                    .stroke(palette.outline)
                            )
                    )
                }
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(palette.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: 26, style: .continuous)
                        .stroke(palette.outline)
                )
        )
    }
}

private struct SuggestionsGrid: View {
    let palette: NovaTheme.Palette
    let suggestions: [Conversation.Suggestion]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 6) {
                Image(systemName: "bolt.fill")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(palette.subtleText)
                Text("Suggested")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(palette.subtleText)
            }
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 14) {
                ForEach(suggestions) { suggestion in
                    Button(action: {}) {
                        HStack(alignment: .center, spacing: 12) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(suggestion.title)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(palette.primaryText)
                                    .lineLimit(2)
                                Text(suggestion.subtitle)
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundColor(palette.subtleText)
                            }
                            Spacer(minLength: 8)
                            Image(systemName: "arrow.up.right")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(palette.subtleText)
                                .padding(8)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(palette.surface)
                                )
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 18)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [palette.heroGradientStart.opacity(0.85), palette.heroGradientEnd]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 18)
                                        .stroke(palette.heroStroke)
                                )
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

private struct Composer: View {
    let palette: NovaTheme.Palette
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 10) {
                ComposerIconButton(symbol: "paperclip", palette: palette)
                ComposerIconButton(symbol: "photo", palette: palette)
                ComposerIconButton(symbol: "note.text", palette: palette)
                Spacer()
                ComposerIconButton(symbol: "sparkles", palette: palette)
                ComposerIconButton(symbol: "mic", palette: palette)
            }

            ZStack(alignment: .topLeading) {
                if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    Text("Send a message to Nova Intelligence…")
                        .font(.system(size: 14))
                        .foregroundColor(palette.subtleText.opacity(0.8))
                        .padding(.horizontal, 18)
                        .padding(.vertical, 18)
                }

                TextEditor(text: $text)
                    .font(.system(size: 14))
                    .foregroundColor(palette.primaryText)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .frame(minHeight: 110, maxHeight: 180)
                    .background(Color.clear)
                    .scrollContentBackground(.hidden)
            }

            Divider().overlay(palette.divider)

            HStack(spacing: 12) {
                HStack(spacing: 6) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 12, weight: .semibold))
                    Text("Nova Suggest is on")
                        .font(.system(size: 12, weight: .medium))
                }
                .foregroundColor(palette.subtleText)
                Spacer()
                Button(action: {}) {
                    HStack(spacing: 6) {
                        Text("Send")
                            .font(.system(size: 12.5, weight: .semibold))
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 13, weight: .bold))
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(
                        Capsule()
                            .fill(palette.accent)
                    )
                    .foregroundColor(palette.onAccent)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(palette.composerSurface)
                .overlay(
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .stroke(palette.outline)
                )
        )
    }
}

private struct ComposerIconButton: View {
    let symbol: String
    let palette: NovaTheme.Palette

    var body: some View {
        Button(action: {}) {
            Image(systemName: symbol)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(palette.subtleText)
                .frame(width: 34, height: 34)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(palette.controlSurface)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .stroke(palette.outline)
                        )
                )
        }
        .buttonStyle(.plain)
    }
}

private struct TagView: View {
    let text: String
    let palette: NovaTheme.Palette

    var body: some View {
        Text(text)
            .font(.system(size: 11, weight: .semibold))
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                Capsule().fill(palette.controlSurface)
            )
            .foregroundColor(palette.primaryText)
    }
}

// MARK: - Settings

private struct SettingsOverlay: View {
    let palette: NovaTheme.Palette
    @Binding var isPresented: Bool
    @Binding var style: NovaTheme.Style
    @State private var telemetryEnabled = true
    @State private var voiceMode = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.45)
                .ignoresSafeArea()
                .onTapGesture { isPresented = false }

            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Settings")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(palette.primaryText)
                        Text("Nova Intelligence (beta)")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(palette.subtleText)
                    }
                    Spacer()
                    Button(action: { isPresented = false }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(palette.primaryText)
                            .padding(12)
                            .background(Circle().fill(palette.controlSurface))
                            .overlay(Circle().stroke(palette.outline))
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 28)
                .padding(.vertical, 22)

                Divider().overlay(palette.divider)

                ScrollView {
                    VStack(alignment: .leading, spacing: 28) {
                        SettingsSection(title: "Appearance", palette: palette) {
                            Picker("Theme", selection: $style) {
                                ForEach(NovaTheme.Style.allCases) { option in
                                    Text(option.label).tag(option)
                                }
                            }
                            .pickerStyle(.segmented)
                            .frame(maxWidth: 320)
                        }

                        SettingsSection(title: "Data controls", palette: palette) {
                            Toggle("Allow product telemetry", isOn: $telemetryEnabled)
                                .toggleStyle(.switch)
                                .tint(palette.accent)
                            Toggle("Enable Nova Voice", isOn: $voiceMode)
                                .toggleStyle(.switch)
                                .tint(palette.accent)
                        }

                        SettingsSection(title: "About", palette: palette) {
                            Text("Nova Intelligence (beta) mirrors the Open WebUI desktop experience with a fully native SwiftUI implementation.")
                                .font(.system(size: 12.5))
                                .foregroundColor(palette.primaryText)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    .padding(32)
                }

                Divider().overlay(palette.divider)

                HStack {
                    Text("Version 0.6.34")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(palette.subtleText)
                    Spacer()
                    Button("Close") {
                        isPresented = false
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 22)
                    .padding(.vertical, 10)
                    .background(Capsule().fill(palette.accent))
                    .foregroundColor(palette.onAccent)
                }
                .padding(.horizontal, 28)
                .padding(.vertical, 18)
            }
            .frame(width: 760, height: 520)
            .background(
                RoundedRectangle(cornerRadius: 32)
                    .fill(palette.panel)
                    .overlay(
                        RoundedRectangle(cornerRadius: 32)
                            .stroke(palette.outline)
                    )
            )
            .shadow(color: palette.shadow.opacity(0.2), radius: 34, y: 18)
        }
    }
}

private struct SettingsSection<Content: View>: View {
    let title: String
    let palette: NovaTheme.Palette
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title.uppercased())
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(palette.sectionLabel)
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Models & Data

private struct Conversation: Identifiable {
    struct Message: Identifiable {
        enum Role { case user, assistant }

        let id = UUID()
        let role: Role
        let content: String
        let timestamp: String
        let highlights: [String]?
    }

    struct Suggestion: Identifiable {
        let id = UUID()
        let title: String
        let subtitle: String
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
    let suggestions: [Suggestion]
}

private struct ModelProfile: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let description: String
    let status: String
    let isDefault: Bool
    let accent: Color
}

private enum SampleData {
    static let defaultPrompt = "What are five creative things I could do with my kids' art?"
    static let bannerTitle = "SUCCESS"
    static let bannerMessage = "Nova Intelligence — On a mission to build the best open-source AI user interface."
    static let heroCaption = "Select a model"
    static let heroGreeting = "Hello, Obi"
    static let heroSubtitle = "How can I help you today?"
    static let heroButtonLabel = "Customize"

    private static let baseMessages: [Conversation.Message] = [
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
            timestamp: "1 min ago",
            highlights: nil
        ),
        Conversation.Message(
            role: .assistant,
            content: "Absolutely! Here's a warm, professional draft you can adapt for your classroom.\n\n---\n\nSubject: Showcasing Our Young Artists\n\nHi families,\n\nWe're launching a rotating art gallery to celebrate the imagination blooming in our classroom. Each week, we'll feature a new set of student creations along our hallway display. Students will curate their pieces, add short artist statements, and learn how to present their work with pride.\n\nIf you'd like to help mount frames or photograph artwork, let me know—I'd love to coordinate a volunteer schedule. We'll also capture every display digitally so you can revisit the collection anytime.\n\nThank you for championing our artists!\n\nWarmly,\nObi",
            timestamp: "moments ago",
            highlights: nil
        )
    ]

    static let conversations: [Conversation] = [
        Conversation(
            id: UUID(),
            title: "Classroom art showcase plan",
            preview: "Outline ideas to display student artwork",
            relativeDate: "5m",
            model: "Nova Ultra",
            icon: "wand.and.stars",
            accent: Color(red: 0.98, green: 0.74, blue: 0.22),
            isPinned: true,
            messages: baseMessages,
            suggestions: [
                Conversation.Suggestion(
                    title: "Give me ideas for what to do with my kids' art",
                    subtitle: "Prompt"
                ),
                Conversation.Suggestion(
                    title: "Tell me a fun fact about the Roman Empire",
                    subtitle: "Prompt"
                ),
                Conversation.Suggestion(
                    title: "Overcome procrastination: give me tips",
                    subtitle: "Prompt"
                ),
                Conversation.Suggestion(
                    title: "Help me study vocabulary for a college exam",
                    subtitle: "Prompt"
                )
            ]
        ),
        Conversation(
            id: UUID(),
            title: "STEM night prompts",
            preview: "Generate interactive booth ideas",
            relativeDate: "1d",
            model: "Nova Ultra",
            icon: "cube.transparent",
            accent: Color(red: 0.38, green: 0.59, blue: 0.98),
            isPinned: false,
            messages: baseMessages,
            suggestions: [
                Conversation.Suggestion(title: "Draft volunteer roles", subtitle: "Prompt"),
                Conversation.Suggestion(title: "Create budget", subtitle: "Prompt")
            ]
        ),
        Conversation(
            id: UUID(),
            title: "Reading level summaries",
            preview: "Summaries for parent updates",
            relativeDate: "2d",
            model: "Nova Mini",
            icon: "book.closed",
            accent: Color(red: 0.52, green: 0.74, blue: 0.53),
            isPinned: false,
            messages: baseMessages,
            suggestions: [
                Conversation.Suggestion(title: "Draft family note", subtitle: "Prompt")
            ]
        ),
        Conversation(
            id: UUID(),
            title: "Field trip logistics",
            preview: "Draft permission slip copy",
            relativeDate: "1w",
            model: "Nova Voice",
            icon: "bus",
            accent: Color(red: 0.89, green: 0.49, blue: 0.55),
            isPinned: false,
            messages: baseMessages,
            suggestions: [
                Conversation.Suggestion(title: "Outline bus schedule", subtitle: "Prompt")
            ]
        )
    ]

    static let models: [ModelProfile] = [
        ModelProfile(
            name: "Nova Ultra",
            description: "Balanced reasoning and speed for most tasks.",
            status: "Set as default",
            isDefault: true,
            accent: Color(red: 0.33, green: 0.37, blue: 0.91)
        ),
        ModelProfile(
            name: "Nova Mini",
            description: "Lightweight and efficient for quick prompts.",
            status: "Tap to switch",
            isDefault: false,
            accent: Color(red: 0.13, green: 0.65, blue: 0.89)
        ),
        ModelProfile(
            name: "Nova Voice",
            description: "Conversational voice mode for spoken replies.",
            status: "Experimental",
            isDefault: false,
            accent: Color(red: 0.91, green: 0.47, blue: 0.51)
        )
    ]
    static let workspaces = ["Default", "Team", "Personal"]
}

// MARK: - Theme

private enum NovaTheme {
    struct Palette {
        let canvas: Color
        let sidebar: Color
        let railGradientStart: Color
        let railGradientEnd: Color
        let railBorder: Color
        let railAccent: Color
        let railOnAccent: Color
        let railItemBackground: Color
        let surface: Color
        let panel: Color
        let mutedSurface: Color
        let controlSurface: Color
        let composerSurface: Color
        let accent: Color
        let onAccent: Color
        let primaryText: Color
        let subtleText: Color
        let sectionLabel: Color
        let divider: Color
        let userBubble: Color
        let bannerBackground: Color
        let bannerText: Color
        let outline: Color
        let heroGradientStart: Color
        let heroGradientEnd: Color
        let heroStroke: Color
        let shadow: Color
        let successAccent: Color
    }

    enum Style: String, CaseIterable, Identifiable {
        case system
        case light
        case dark

        var id: String { rawValue }

        var label: String {
            switch self {
            case .system: return "System"
            case .light: return "Light"
            case .dark: return "Dark"
            }
        }
    }

    static func palette(for style: Style) -> Palette {
        switch effectiveStyle(for: style) {
        case .dark:
            return Palette(
                canvas: Color(red: 0.06, green: 0.07, blue: 0.08),
                sidebar: Color(red: 0.09, green: 0.1, blue: 0.12),
                railGradientStart: Color(red: 0.07, green: 0.08, blue: 0.12),
                railGradientEnd: Color(red: 0.04, green: 0.05, blue: 0.07),
                railBorder: Color.white.opacity(0.08),
                railAccent: Color(red: 0.97, green: 0.74, blue: 0.21),
                railOnAccent: Color.black,
                railItemBackground: Color.white.opacity(0.06),
                surface: Color(red: 0.12, green: 0.13, blue: 0.15),
                panel: Color(red: 0.12, green: 0.12, blue: 0.14),
                mutedSurface: Color(red: 0.15, green: 0.16, blue: 0.18),
                controlSurface: Color(red: 0.16, green: 0.17, blue: 0.2),
                composerSurface: Color(red: 0.09, green: 0.1, blue: 0.12),
                accent: Color(red: 0.33, green: 0.63, blue: 0.97),
                onAccent: Color.white,
                primaryText: Color(red: 0.92, green: 0.94, blue: 0.98),
                subtleText: Color(red: 0.63, green: 0.68, blue: 0.76),
                sectionLabel: Color(red: 0.48, green: 0.52, blue: 0.6),
                divider: Color.white.opacity(0.07),
                userBubble: Color.white.opacity(0.07),
                bannerBackground: Color(red: 0.13, green: 0.19, blue: 0.17),
                bannerText: Color(red: 0.73, green: 0.91, blue: 0.83),
                outline: Color.white.opacity(0.06),
                heroGradientStart: Color(red: 0.11, green: 0.13, blue: 0.18),
                heroGradientEnd: Color(red: 0.07, green: 0.08, blue: 0.12),
                heroStroke: Color.white.opacity(0.05),
                shadow: Color.black.opacity(0.4),
                successAccent: Color(red: 0.34, green: 0.75, blue: 0.55)
            )
        case .light:
            return Palette(
                canvas: Color(hex: "#f4f6fb"),
                sidebar: Color.white,
                railGradientStart: Color(hex: "#111629"),
                railGradientEnd: Color(hex: "#192038"),
                railBorder: Color(hex: "#1f2937").opacity(0.08),
                railAccent: Color(hex: "#101526"),
                railOnAccent: Color.white,
                railItemBackground: Color.white.opacity(0.14),
                surface: Color.white,
                panel: Color.white,
                mutedSurface: Color(hex: "#f6f7fb"),
                controlSurface: Color(hex: "#eef1ff"),
                composerSurface: Color.white,
                accent: Color(hex: "#3b82f6"),
                onAccent: Color.white,
                primaryText: Color(hex: "#111827"),
                subtleText: Color(hex: "#4b5563"),
                sectionLabel: Color(hex: "#6b7280"),
                divider: Color(hex: "#e2e8f0"),
                userBubble: Color.white,
                bannerBackground: Color(hex: "#ecfdf3"),
                bannerText: Color(hex: "#15803d"),
                outline: Color(hex: "#dbe2f4"),
                heroGradientStart: Color(hex: "#f6f7ff"),
                heroGradientEnd: Color(hex: "#eef2ff"),
                heroStroke: Color(hex: "#dfe4f7"),
                shadow: Color.black.opacity(0.08),
                successAccent: Color(hex: "#22c55e")
            )
        }
    }

    private static func effectiveStyle(for style: Style) -> Style {
        if style == .system {
            #if os(macOS)
            return NSApplication.shared.effectiveAppearance.name == .darkAqua ? .dark : .light
            #else
            return .light
            #endif
        }
        return style
    }
}

private extension Color {
    init(hex: String) {
        var formatted = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        if formatted.count == 3 {
            formatted = formatted.map { String($0) + String($0) }.joined()
        }

        var value: UInt64 = 0
        Scanner(string: formatted).scanHexInt64(&value)

        let red = Double((value & 0xFF0000) >> 16) / 255.0
        let green = Double((value & 0x00FF00) >> 8) / 255.0
        let blue = Double(value & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue)
    }
}

#endif
