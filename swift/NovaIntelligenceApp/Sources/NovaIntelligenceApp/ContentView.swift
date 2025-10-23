#if canImport(SwiftUI)
import SwiftUI

struct ContentView: View {
    @State private var isShowingSettings = false
    @State private var selectedModel = "Nova Ultra"
    @State private var selectedWorkspace = "Default"
    @State private var composerText = "What are 5 creative things I could do with my kids' art?"
    @State private var selectedFolder: UUID? = SampleData.folders.first?.id

    var body: some View {
        ZStack {
            Color.novaBackground.ignoresSafeArea()
            HStack(spacing: 0) {
                primarySidebar
                Divider().overlay(Color.novaBorder)
                mainSurface
                Divider().overlay(Color.novaBorder)
                secondarySidebar
            }
            .frame(minHeight: 600)
            .preferredColorScheme(.dark)

            if isShowingSettings {
                SettingsOverlay(isPresented: $isShowingSettings)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: isShowingSettings)
    }

    private var primarySidebar: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 4) {
                Label("Nova Intelligence", systemImage: "sparkles")
                    .font(.system(size: 16, weight: .semibold))
                    .novaForeground(Color.white)
                    .labelStyle(SidebarLabelStyle())
                Text("beta")
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .novaForeground(Color.novaAccent.opacity(0.8))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(
                        Capsule().fill(Color.novaAccent.opacity(0.2))
                    )
            }

            SidebarSection(title: "General", items: SampleData.generalItems)
            SidebarSection(
                title: "Folders",
                items: SampleData.folders.map { item in
                    SidebarItem(
                        id: item.id,
                        icon: "folder",
                        label: item.name,
                        trailing: Text("\(item.chatCount)")
                            .novaForeground(Color.novaMuted)
                            .font(.system(size: 11, weight: .semibold))
                    )
                },
                selection: $selectedFolder
            )

            Spacer()

            VStack(alignment: .leading, spacing: 12) {
                SidebarButton(icon: "trash", label: "Trash")
                SidebarButton(icon: "archivebox", label: "Archive")
                SidebarButton(icon: "questionmark.circle", label: "Help")
            }
        }
        .padding(.horizontal, 22)
        .padding(.vertical, 28)
        .frame(width: 280, alignment: .leading)
        .background(Color.novaSidebar)
    }

    private var mainSurface: some View {
        VStack(spacing: 24) {
            header
            ChatPreviewCard(composerText: $composerText)
            Spacer(minLength: 0)
            ComposerView(text: $composerText)
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 28)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.novaBackground)
    }

    private var header: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Select a model")
                        .font(.system(size: 13, weight: .semibold))
                        .novaForeground(Color.novaMuted)
                    Menu {
                        ForEach(SampleData.models, id: \.self) { model in
                            Button(model) { selectedModel = model }
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Text(selectedModel)
                                .novaForeground(Color.white)
                            Image(systemName: "chevron.down")
                                .font(.system(size: 12, weight: .semibold))
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(RoundedRectangle(cornerRadius: 14).fill(Color.novaSurface))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color.novaBorder, lineWidth: 1)
                        )
                    }
                }

                Spacer()

                Menu {
                    ForEach(SampleData.workspaces, id: \.self) { workspace in
                        Button(workspace) { selectedWorkspace = workspace }
                    }
                } label: {
                    HStack(spacing: 6) {
                        Text(selectedWorkspace)
                            .novaForeground(Color.white)
                        Image(systemName: "chevron.down")
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(RoundedRectangle(cornerRadius: 14).fill(Color.novaSurface))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.novaBorder, lineWidth: 1)
                    )
                }

                Button(action: { isShowingSettings.toggle() }) {
                    Image(systemName: "gearshape")
                        .font(.system(size: 15, weight: .semibold))
                        .novaForeground(Color.white)
                        .padding(10)
                        .background(Circle().fill(Color.novaSurface))
                        .overlay(Circle().stroke(Color.novaBorder, lineWidth: 1))
                }
                .buttonStyle(.plain)
            }

            Divider().overlay(Color.novaBorder)
        }
    }

    private var secondarySidebar: some View {
        VStack(spacing: 20) {
            HoverIconButton(systemName: "rectangle.and.pencil.and.ellipsis")
            HoverIconButton(systemName: "slider.horizontal.3")
            HoverIconButton(systemName: "bell")
            Spacer()
            HoverIconButton(systemName: "person.crop.circle")
        }
        .padding(.vertical, 32)
        .frame(width: 88)
        .background(Color.novaSidebar)
    }
}

private struct SidebarLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 10) {
            configuration.icon
                .font(.system(size: 16, weight: .semibold))
                .novaForeground(Color.novaAccent)
            configuration.title
        }
    }
}

private struct SidebarSection: View {
    let title: String
    var items: [SidebarItem]
    var selection: Binding<UUID?>?

    init(title: String, items: [SidebarItem], selection: Binding<UUID?>? = nil) {
        self.title = title
        self.items = items
        self.selection = selection
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title.uppercased())
                .font(.system(size: 11, weight: .bold))
                .novaForeground(Color.novaMuted.opacity(0.8))
                .padding(.leading, 4)

            ForEach(items) { item in
                SidebarRow(item: item, isSelected: selection?.wrappedValue == item.id) {
                    selection?.wrappedValue = item.id
                }
            }
        }
    }
}

private struct SidebarRow: View {
    let item: SidebarItem
    var isSelected: Bool
    var action: () -> Void

    init(item: SidebarItem, isSelected: Bool, action: @escaping () -> Void = {}) {
        self.item = item
        self.isSelected = isSelected
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: item.icon)
                    .font(.system(size: 15, weight: .semibold))
                    .novaForeground(isSelected ? Color.white : Color.novaMuted)
                Text(item.label)
                    .font(.system(size: 14, weight: .medium))
                    .novaForeground(isSelected ? Color.white : Color.novaMuted)
                Spacer()
                if let trailing = item.trailing {
                    trailing
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.novaSurface : Color.clear)
            )
        }
        .buttonStyle(.plain)
    }
}

private struct SidebarButton: View {
    let icon: String
    let label: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
                .novaForeground(Color.novaMuted)
            Text(label)
                .font(.system(size: 13, weight: .medium))
                .novaForeground(Color.novaMuted)
        }
    }
}

private struct ChatPreviewCard: View {
    @Binding var composerText: String

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(spacing: 14) {
                Circle()
                    .fill(Color.novaAccent)
                    .frame(width: 44, height: 44)
                    .overlay(Text("NI").font(.system(size: 16, weight: .bold)))
                VStack(alignment: .leading, spacing: 4) {
                    Text("Hello, Obi")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .novaForeground(Color.white)
                    Text("What are 5 creative things I could do with my kids' art? I don't want to throw them away, but it's also so much clutter!")
                        .font(.system(size: 14))
                        .novaForeground(Color.white.opacity(0.85))
                        .lineSpacing(4)
                }
                Spacer()
                VStack(spacing: 12) {
                    HoverIconButton(systemName: "tray.and.arrow.down")
                    HoverIconButton(systemName: "square.and.arrow.up")
                }
            }

            VStack(alignment: .leading, spacing: 10) {
                Text("Suggested")
                    .font(.system(size: 12, weight: .semibold))
                    .novaForeground(Color.novaMuted)
                HStack(spacing: 12) {
                    ForEach(SampleData.suggestions, id: \.self) { suggestion in
                        Text(suggestion)
                            .font(.system(size: 12, weight: .medium))
                            .novaForeground(Color.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.novaSurface)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.novaBorder, lineWidth: 1)
                            )
                    }
                }
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 28)
                .fill(Color.novaSurface)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 28)
                .stroke(Color.novaBorder.opacity(0.8), lineWidth: 1)
        )
    }
}

private struct ComposerView: View {
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                AttachButton(label: "Upload Files", icon: "tray.and.arrow.up")
                AttachButton(label: "Capture", icon: "camera")
                AttachButton(label: "Attach Notes", icon: "note.text")
                Spacer()
                HoverIconButton(systemName: "mic")
                HoverIconButton(systemName: "ellipsis")
            }

            RoundedRectangle(cornerRadius: 26)
                .fill(Color.novaSurface)
                .overlay(
                    RoundedRectangle(cornerRadius: 26)
                        .stroke(Color.novaBorder, lineWidth: 1)
                )
                .overlay(
                    HStack(spacing: 16) {
                        TextEditor(text: $text)
                            .font(.system(size: 14))
                            .scrollContentBackground(.hidden)
                            .novaForeground(Color.white)
                            .frame(minHeight: 80, maxHeight: 120)
                            .padding(.vertical, 18)
                        Spacer()
                        Button(action: {}) {
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.system(size: 30))
                                .novaForeground(Color.novaAccent)
                        }
                        .buttonStyle(.plain)
                        .padding(.trailing, 18)
                    }
                        .padding(.leading, 24)
                )
        }
    }
}

private struct AttachButton: View {
    let label: String
    let icon: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 12, weight: .semibold))
            Text(label)
                .font(.system(size: 12, weight: .medium))
        }
        .novaForeground(Color.novaMuted)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.novaSurface.opacity(0.6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.novaBorder, lineWidth: 1)
        )
    }
}

private struct HoverIconButton: View {
    let systemName: String
    @State private var isHovering = false

    var body: some View {
        Image(systemName: systemName)
            .font(.system(size: 15, weight: .semibold))
            .novaForeground(Color.white)
            .frame(width: 44, height: 44)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(isHovering ? Color.novaSurface.opacity(0.9) : Color.novaSurface.opacity(0.6))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.novaBorder, lineWidth: 1)
            )
            .onHover { hovering in
                #if os(macOS)
                isHovering = hovering
                #endif
            }
    }
}

private struct SidebarItem: Identifiable {
    let id: UUID
    let icon: String
    let label: String
    var trailing: Text?

    init(id: UUID = UUID(), icon: String, label: String, trailing: Text? = nil) {
        self.id = id
        self.icon = icon
        self.label = label
        self.trailing = trailing
    }
}

private struct Folder: Identifiable {
    let id: UUID = UUID()
    let name: String
    let chatCount: Int
}

private enum SampleData {
    static let generalItems: [SidebarItem] = [
        SidebarItem(icon: "plus", label: "New Chat"),
        SidebarItem(icon: "magnifyingglass", label: "Search"),
        SidebarItem(icon: "square.and.pencil", label: "Notes"),
        SidebarItem(icon: "rectangle.stack", label: "Workspace")
    ]

    static let folders: [Folder] = [
        Folder(name: "Folder 1", chatCount: 4),
        Folder(name: "Research", chatCount: 12),
        Folder(name: "Product", chatCount: 7)
    ]

    static let suggestions = [
        "Give me ideas",
        "Summarize recent chats",
        "Brainstorm for the next art unit"
    ]

    static let models = ["Nova Ultra", "Nova Mini", "Nova Voice" ]

    static let workspaces = ["Default", "Team", "Personal"]
}

private struct SettingsOverlay: View {
    @Binding var isPresented: Bool
    @State private var selection: SettingsCategory = .general
    @State private var theme: ThemeOption = .system
    @State private var language: LanguageOption = .englishUS
    @State private var notificationsEnabled = false
    @State private var systemPrompt = "Enter system prompt here"

    var body: some View {
        ZStack {
            Color.black.opacity(0.55)
                .ignoresSafeArea()
                .onTapGesture { isPresented = false }

            VStack(spacing: 0) {
                HStack {
                    Text("Settings")
                        .font(.system(size: 18, weight: .semibold))
                        .novaForeground(Color.white)
                    Spacer()
                    Button(action: { isPresented = false }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .bold))
                            .novaForeground(Color.white)
                            .padding(8)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 28)
                .padding(.vertical, 20)

                Divider().overlay(Color.novaBorder)

                HStack(spacing: 0) {
                    settingsSidebar
                    Divider().overlay(Color.novaBorder)
                    settingsDetail
                }
                .frame(height: 420)

                Divider().overlay(Color.novaBorder)

                HStack {
                    Spacer()
                    Button(action: { isPresented = false }) {
                        Text("Save")
                            .font(.system(size: 14, weight: .semibold))
                            .novaForeground(Color.white)
                            .padding(.horizontal, 26)
                            .padding(.vertical, 10)
                            .background(RoundedRectangle(cornerRadius: 20).fill(Color.novaAccent))
                    }
                }
                .padding(20)
            }
            .frame(width: 760)
            .background(RoundedRectangle(cornerRadius: 28).fill(Color.novaSurface))
            .overlay(
                RoundedRectangle(cornerRadius: 28)
                    .stroke(Color.novaBorder, lineWidth: 1)
            )
        }
    }

    private var settingsSidebar: some View {
        VStack(alignment: .leading, spacing: 4) {
            ForEach(SettingsCategory.allCases) { category in
                Button(action: { selection = category }) {
                    HStack {
                        Text(category.title)
                            .font(.system(size: 13, weight: .medium))
                            .novaForeground(selection == category ? Color.white : Color.novaMuted)
                        Spacer()
                        if category == .search {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 12, weight: .semibold))
                                .novaForeground(Color.novaMuted)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(selection == category ? Color.novaSurfaceElevated : Color.clear)
                    )
                }
                .buttonStyle(.plain)
            }
            Spacer()
        }
        .padding(20)
        .frame(width: 200)
    }

    private var settingsDetail: some View {
        VStack(alignment: .leading, spacing: 20) {
            switch selection {
            case .general:
                SettingsSection(title: "Nova Intelligence Settings") {
                    Picker("Theme", selection: $theme) {
                        ForEach(ThemeOption.allCases) { option in
                            Text(option.title).tag(option)
                        }
                    }
                    .pickerStyle(.segmented)

                    Picker("Language", selection: $language) {
                        ForEach(LanguageOption.allCases) { option in
                            Text(option.title).tag(option)
                        }
                    }
                    .pickerStyle(.menu)

                    Toggle("Notifications", isOn: $notificationsEnabled)
                        .toggleStyle(SwitchToggleStyle(tint: Color.novaAccent))

                    VStack(alignment: .leading, spacing: 6) {
                        Text("System Prompt")
                            .font(.system(size: 12, weight: .semibold))
                            .novaForeground(Color.novaMuted)
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color.novaSurfaceElevated)
                            .overlay(
                                RoundedRectangle(cornerRadius: 18)
                                    .stroke(Color.novaBorder, lineWidth: 1)
                            )
                            .overlay(
                                TextEditor(text: $systemPrompt)
                                    .font(.system(size: 13))
                                    .novaForeground(Color.white)
                                    .padding(16)
                                    .scrollContentBackground(.hidden)
                            )
                            .frame(height: 120)
                    }
                }

            case .dataControls:
                SettingsSection(title: "Data Controls") {
                    SettingsLinkRow(title: "Import Chats")
                    SettingsLinkRow(title: "Export Chats")
                    SettingsLinkRow(title: "Archive All Chats")
                    SettingsLinkRow(title: "Delete All Chats", accent: .pink)
                }

            case .account:
                SettingsSection(title: "Your Account") {
                    HStack(spacing: 16) {
                        Circle()
                            .fill(Color.novaAccent)
                            .frame(width: 48, height: 48)
                            .overlay(Text("O").font(.system(size: 20, weight: .bold)))
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Obi")
                                .font(.system(size: 15, weight: .semibold))
                            Text("Share your background and interests")
                                .font(.system(size: 13))
                                .novaForeground(Color.novaMuted)
                        }
                    }

                    SettingsLinkRow(title: "Notification Webhook")
                    SettingsLinkRow(title: "Change Password")
                    SettingsLinkRow(title: "API Keys")
                }

            case .about:
                SettingsSection(title: "Nova Intelligence Version") {
                    Text("0.6.34")
                        .font(.system(size: 13, weight: .semibold))
                        .novaForeground(Color.white)
                    Text(SampleData.licenseText)
                        .font(.system(size: 11))
                        .novaForeground(Color.novaMuted)
                        .lineSpacing(4)
                }

            default:
                SettingsSection(title: selection.title) {
                    Text("Coming soon")
                        .font(.system(size: 13))
                        .novaForeground(Color.novaMuted)
                }
            }

            Spacer()
        }
        .padding(26)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .background(Color.novaSurface)
    }
}

private struct SettingsSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .novaForeground(Color.white)
            VStack(alignment: .leading, spacing: 16) {
                content
            }
        }
    }
}

private struct SettingsLinkRow: View {
    let title: String
    var accent: Color = .white

    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 13, weight: .medium))
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .bold))
        }
        .novaForeground(accent)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.novaSurfaceElevated)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.novaBorder, lineWidth: 1)
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

private extension Color {
    static let novaBackground = Color(red: 16/255, green: 16/255, blue: 19/255)
    static let novaSidebar = Color(red: 22/255, green: 23/255, blue: 28/255)
    static let novaSurface = Color(red: 30/255, green: 31/255, blue: 36/255)
    static let novaSurfaceElevated = Color(red: 36/255, green: 37/255, blue: 43/255)
    static let novaAccent = Color(red: 241/255, green: 180/255, blue: 76/255)
    static let novaMuted = Color.white.opacity(0.6)
    static let novaBorder = Color.white.opacity(0.08)
}

private extension SampleData {
    static let licenseText = "Nova Intelligence (beta) incorporates components inspired by the Open WebUI project. The Nova Intelligence desktop shell recreates the interface natively in SwiftUI while retaining the original interaction patterns, shortcuts, and layout conventions."
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
