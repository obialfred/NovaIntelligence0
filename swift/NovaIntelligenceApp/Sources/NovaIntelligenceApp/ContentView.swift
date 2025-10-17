#if canImport(SwiftUI)
import SwiftUI

struct ContentView: View {
    @Binding var targetURL: URL

    @State private var selection: NovaWorkspace? = NovaWorkspace.defaultWorkspaces.first
    @State private var addressBarText: String = ""
    @State private var isShowingSettings = false

    var body: some View {
        #if os(macOS) || os(iOS)
        NavigationSplitView {
            NovaSidebar(selection: $selection)
        } detail: {
            detailView
                .toolbar {
                    NovaToolbar(
                        title: selection?.title ?? "Nova Intelligence",
                        addressText: Binding(
                            get: { currentAddressText },
                            set: { newValue in addressBarText = newValue }
                        ),
                        onSubmitAddress: handleAddressSubmit,
                        onReload: refresh,
                        onShowSettings: { isShowingSettings.toggle() }
                    )
                }
        }
        .navigationSplitViewStyle(.balanced)
        .sheet(isPresented: $isShowingSettings) {
            SettingsSheet()
        }
        .onAppear(perform: syncInitialSelection)
        .onChange(of: selection) { newValue in
            guard let url = newValue?.url else { return }
            targetURL = url
            addressBarText = ""
        }
        .onChange(of: targetURL) { newValue in
            guard let matchingWorkspace = NovaWorkspace.defaultWorkspaces.first(where: { $0.url == newValue }) else {
                selection = nil
                return
            }
            if selection != matchingWorkspace {
                selection = matchingWorkspace
            }
        }
        #else
        detailView
            .sheet(isPresented: $isShowingSettings) {
                SettingsSheet()
            }
        #endif
    }

    private var detailView: some View {
        NovaWebView(url: $targetURL)
            .background(Color.appBackground)
            .task { syncInitialSelection() }
    }

    private var currentAddressText: String {
        addressBarText.isEmpty ? targetURL.absoluteString : addressBarText
    }

    private func syncInitialSelection() {
        if selection == nil {
            selection = NovaWorkspace.defaultWorkspaces.first
        }
    }

    private func handleAddressSubmit() {
        guard let url = URL(fromUserInput: addressBarText) else { return }
        targetURL = url
        addressBarText = ""
    }

    private func refresh() {
        targetURL = targetURL.appendingTimeStamp()
    }
}

private struct NovaToolbar: ToolbarContent {
    var title: String
    var addressText: Binding<String>
    var onSubmitAddress: () -> Void
    var onReload: () -> Void
    var onShowSettings: () -> Void

    var body: some ToolbarContent {
        #if os(macOS)
        ToolbarItemGroup(placement: .navigation) {
            Label(title, systemImage: "sparkles")
                .labelStyle(.titleAndIcon)
        }

        ToolbarItemGroup(placement: .principal) {
            addressField(
                addressText: addressText,
                onSubmit: onSubmitAddress,
                onReload: onReload
            )
            .frame(maxWidth: 420)
        }

        ToolbarItemGroup(placement: .primaryAction) {
            Button(action: onReload) {
                Image(systemName: "arrow.clockwise")
            }
            Button(action: onShowSettings) {
                Image(systemName: "slider.horizontal.3")
            }
        }
        #else
        ToolbarItemGroup(placement: .navigationBarLeading) {
            Label(title, systemImage: "sparkles")
                .labelStyle(.titleAndIcon)
                .font(.headline)
                .foregroundColor(.accentColor)
        }

        ToolbarItemGroup(placement: .primaryAction) {
            Button(action: onShowSettings) {
                Image(systemName: "slider.horizontal.3")
            }
        }

        ToolbarItemGroup(placement: .bottomBar) {
            addressField(
                addressText: addressText,
                onSubmit: onSubmitAddress,
                onReload: onReload
            )
        }
        #endif
    }

    @ViewBuilder
    private func addressField(
        addressText: Binding<String>,
        onSubmit: @escaping () -> Void,
        onReload: @escaping () -> Void
    ) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "globe")
                .foregroundStyle(.secondary)
            TextField("https://", text: addressText)
                .textFieldStyle(.roundedBorder)
#if os(iOS)
                .keyboardType(.URL)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
#endif
                .submitLabel(.go)
                .onSubmit(onSubmit)
            Button(action: onReload) {
                Image(systemName: "arrow.clockwise")
            }
            .buttonStyle(.borderless)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct NovaSidebar: View {
    @Binding var selection: NovaWorkspace?

    var body: some View {
        List(NovaWorkspace.defaultWorkspaces, selection: $selection) { workspace in
            if let badge = workspace.badgeText {
                Label(workspace.title, systemImage: workspace.symbolName)
                    .badge(badge)
            } else {
                Label(workspace.title, systemImage: workspace.symbolName)
            }
        }
        .listStyle(.sidebar)
        .navigationTitle("Nova Intelligence")
    }
}

struct NovaWorkspace: Identifiable, Hashable {
    let id: UUID = UUID()
    var title: String
    var symbolName: String
    var badgeText: String?
    var url: URL

    static let defaultWorkspaces: [NovaWorkspace] = [
        NovaWorkspace(
            title: "Web App",
            symbolName: "rectangle.on.rectangle.angled",
            badgeText: nil,
            url: URL.defaultNovaURL
        ),
        NovaWorkspace(
            title: "Admin",
            symbolName: "lock.shield",
            badgeText: "beta",
            url: URL(string: "https://nova.intelligence.local/admin") ?? URL.defaultNovaURL
        ),
        NovaWorkspace(
            title: "Docs",
            symbolName: "book",
            badgeText: "new",
            url: URL(string: "https://nova.intelligence.local/docs") ?? URL.defaultNovaURL
        )
    ]
}

private struct SettingsSheet: View {
    @AppStorage("novaAutoLaunch") private var autoLaunch = true
    @AppStorage("novaUseNativeTitleBar") private var useNativeTitleBar = true
    @AppStorage("novaRememberWorkspace") private var rememberWorkspace = true

    var body: some View {
        Form {
            Section(header: Text("Launch")) {
                Toggle("Launch Nova Intelligence at login", isOn: $autoLaunch)
            }
            Section(header: Text("Appearance")) {
                Toggle("Use native window chrome", isOn: $useNativeTitleBar)
            }
            Section(header: Text("Workspace")) {
                Toggle("Reopen last workspace", isOn: $rememberWorkspace)
            }
        }
        .toggleStyle(.switch)
        .formStyle(.grouped)
        .presentationDetents([.medium, .large])
        .padding()
    }
}

private extension Color {
    static var appBackground: Color {
        #if os(macOS)
        return Color(nsColor: .windowBackgroundColor)
        #else
        return Color(.secondarySystemBackground)
        #endif
    }
}

#Preview
struct ContentView_Previews: PreviewProvider {
    @State static var sampleURL = URL.defaultNovaURL

    static var previews: some View {
        ContentView(targetURL: $sampleURL)
    }
}
#endif
