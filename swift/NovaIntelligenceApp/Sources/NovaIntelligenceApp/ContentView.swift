import SwiftUI

struct ContentView: View {
    @Binding var targetURL: URL
    @State private var addressBarText: String = ""
    @State private var isShowingSettings = false

    var body: some View {
        VStack(spacing: 0) {
            header
            Divider()
            addressBar
            Divider()
            NovaWebView(url: $targetURL)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .sheet(isPresented: $isShowingSettings) {
            SettingsSheet()
                #if os(iOS)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
                #endif
        }
        #if os(macOS)
        .frame(minWidth: 720, minHeight: 480)
        #endif
    }

    private var header: some View {
        HStack(spacing: 12) {
            Image(systemName: "sparkles")
                .foregroundStyle(Color(hex: "3B2FF3"))
            Text("Nova Intelligence")
                .font(.headline)
                .foregroundStyle(Color.primary)
            Spacer()
            Button {
                isShowingSettings.toggle()
            } label: {
                Image(systemName: "slider.horizontal.3")
                    .imageScale(.medium)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }

    private var addressBar: some View {
        HStack(spacing: 12) {
            TextField(
                "https://",
                text: Binding(
                    get: {
                        addressBarText.isEmpty ? targetURL.absoluteString : addressBarText
                    },
                    set: { newValue in
                        addressBarText = newValue
                    }
                )
            )
            #if os(iOS)
            .autocapitalization(.none)
            .keyboardType(.URL)
            .submitLabel(.go)
            #endif
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .onSubmit(loadFromAddressBar)

            Button(action: refresh) {
                Image(systemName: "arrow.clockwise")
            }
            .buttonStyle(PlainButtonStyle())
            #if os(macOS)
            .help("Reload the current page")
            #endif
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }

    private func loadFromAddressBar() {
        guard let url = URL(fromUserInput: addressBarText) else { return }
        targetURL = url
        addressBarText = ""
    }

    private func refresh() {
        targetURL = targetURL.appendingTimeStamp()
    }
}

private struct SettingsSheet: View {
    @AppStorage("novaAutoLaunch") private var autoLaunch = true
    @AppStorage("novaUseNativeTitleBar") private var useNativeTitleBar = true

    var body: some View {
        Form {
            Section(header: Text("Nova Intelligence")) {
                Toggle("Launch Nova Intelligence on startup", isOn: $autoLaunch)
                Toggle("Use native title bar", isOn: $useNativeTitleBar)
            }
        }
        .padding()
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    @State static var sampleURL = URL.defaultNovaURL

    static var previews: some View {
        ContentView(targetURL: $sampleURL)
    }
}
#endif
