#if canImport(SwiftUI)
import SwiftUI

@main
struct NovaIntelligenceApp: App {
    @AppStorage("novaRememberWorkspace") private var rememberWorkspace = true
    @AppStorage("novaLastURL") private var persistedURLString = ""

    @State private var targetURL: URL = URL.defaultNovaURL

    var body: some Scene {
        WindowGroup {
            ContentView(targetURL: $targetURL)
                .task {
                    guard rememberWorkspace else { return }
                    guard let restoredURL = URL(string: persistedURLString), !persistedURLString.isEmpty else { return }
                    targetURL = restoredURL
                }
                .onChange(of: targetURL) { newValue in
                    guard rememberWorkspace else { return }
                    persistedURLString = newValue.absoluteString
                }
        }
        #if os(macOS)
        .windowStyle(.automatic)
        #endif
    }
}
#else
@main
enum NovaIntelligenceAppCLI {
    static func main() {
        print("Nova Intelligence SwiftUI host requires macOS or iOS.")
        print("You're running on an unsupported platform, so a CLI placeholder was launched instead.")
        print("To test the UI, open swift/NovaIntelligenceApp in Xcode on macOS or run 'swift run --repl' on an Apple platform.")
    }
}
#endif
