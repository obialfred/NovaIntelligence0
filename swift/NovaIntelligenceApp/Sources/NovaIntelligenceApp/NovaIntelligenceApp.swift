#if canImport(SwiftUI)
import SwiftUI

@main
struct NovaIntelligenceApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 1180, minHeight: 720)
        }
        #if os(macOS)
        .windowStyle(.hiddenTitleBar)
        #endif
    }
}
#else
import Foundation

@main
enum NovaIntelligenceLinuxApp {
    static func main() {
        do {
            try LinuxPreviewServer.run()
        } catch {
            fputs("Failed to launch Nova Intelligence (beta) preview: \(error)\n", stderr)
            exit(EXIT_FAILURE)
        }
    }
}
#endif
