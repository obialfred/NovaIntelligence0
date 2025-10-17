import SwiftUI

struct ContentView: View {
    @Binding var targetURL: URL
    @State private var addressBarText: String = ""
    @State private var isShowingSettings = false

    var body: some View {
        NavigationStack {
            NovaWebView(url: $targetURL)
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Image(systemName: "sparkles")
                            .foregroundStyle(Color(hex: "3B2FF3"))
                        Text("Nova Intelligence")
                            .font(.headline)
                    }
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button {
                            isShowingSettings.toggle()
                        } label: {
                            Image(systemName: "slider.horizontal.3")
                        }
                    }
                    ToolbarItemGroup(placement: .bottomBar) {
                        TextField("https://", text: Binding(
                            get: { addressBarText.isEmpty ? targetURL.absoluteString : addressBarText },
                            set: { newValue in
                                addressBarText = newValue
                            }
                        ))
                        .textFieldStyle(.roundedBorder)
                        .autocapitalization(.none)
                        .keyboardType(.URL)
                        .submitLabel(.go)
                        .onSubmit {
                            guard let url = URL(fromUserInput: addressBarText) else { return }
                            targetURL = url
                            addressBarText = ""
                        }
                        Button(action: refresh) {
                            Image(systemName: "arrow.clockwise")
                        }
                    }
                }
                .sheet(isPresented: $isShowingSettings) {
                    SettingsSheet()
                }
        }
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
        .presentationDetents([.medium, .large])
    }
}

#Preview
struct ContentView_Previews: PreviewProvider {
    @State static var sampleURL = URL.defaultNovaURL

    static var previews: some View {
        ContentView(targetURL: $sampleURL)
    }
}
