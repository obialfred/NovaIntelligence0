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
struct NovaIntelligenceAppCLI {
    static func main() {
        print("Nova Intelligence (beta) is available as a SwiftUI application on Apple platforms.")
        print("Build and run the package with a SwiftUI-capable toolchain to view the native interface.")
    }
}
#endif
