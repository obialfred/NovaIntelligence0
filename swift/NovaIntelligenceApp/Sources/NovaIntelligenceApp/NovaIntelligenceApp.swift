import SwiftUI

@main
struct NovaIntelligenceApp: App {
    @State private var targetURL = URL.defaultNovaURL

    var body: some Scene {
        WindowGroup {
            ContentView(targetURL: $targetURL)
        }
        #if os(macOS)
        .windowStyle(.automatic)
        #endif
    }
}
