#if canImport(SwiftUI)
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
#else
import Foundation
import Dispatch
#if canImport(Glibc)
import Glibc
#else
import Darwin
#endif

@main
struct NovaIntelligenceAppCLI {
    static func main() throws {
        let arguments = CommandLine.arguments.dropFirst()
        let portArgument = arguments.first { $0.hasPrefix("--port=") }
        let portValue = portArgument?.split(separator: "=").last.flatMap(String.init)
        let port = portValue.flatMap(Int.init) ?? 8000

        guard let indexURL = Bundle.module.url(forResource: "index", withExtension: "html") else {
            throw PreviewServerError.missingResources
        }

        let workingDirectory = indexURL.deletingLastPathComponent()
        let server = try PreviewServer(rootDirectory: workingDirectory, port: port)
        try server.start()
        server.wait()
    }
}

private enum PreviewServerError: Error, LocalizedError {
    case missingResources
    case interpreterUnavailable

    var errorDescription: String? {
        switch self {
        case .missingResources:
            return "Unable to locate the embedded Open WebUI preview resources."
        case .interpreterUnavailable:
            return "Python 3 is required to host the preview on Linux. Install python3 and try again."
        }
    }
}

private final class PreviewServer {
    private let process: Process
    private let port: Int
    private let signals: [Int32] = [SIGINT, SIGTERM]
    private var signalSources: [DispatchSourceSignal] = []
    private let rootDirectory: URL

    init(rootDirectory: URL, port: Int) throws {
        guard PreviewServer.pythonAvailable() else {
            throw PreviewServerError.interpreterUnavailable
        }

        self.rootDirectory = rootDirectory
        self.port = port

        process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        process.arguments = ["python3", "-m", "http.server", String(port), "--bind", "0.0.0.0"]
        process.currentDirectoryURL = rootDirectory
        process.standardOutput = FileHandle.standardOutput
        process.standardError = FileHandle.standardError
    }

    func start() throws {
        try process.run()
        print("Serving Nova Intelligence preview on http://127.0.0.1:\(port)")
        print("Accessible on your LAN at http://0.0.0.0:\(port)")
        print("Root directory: \(rootDirectory.path)")

        for signalValue in signals {
            signal(signalValue, SIG_IGN)
            let source = DispatchSource.makeSignalSource(signal: signalValue, queue: .global())
            source.setEventHandler { [weak self] in
                guard let self else { return }
                if self.process.isRunning {
                    self.process.terminate()
                }
                exit(signalValue == SIGINT ? 130 : EXIT_SUCCESS)
            }
            source.resume()
            signalSources.append(source)
        }
    }

    func wait() {
        process.waitUntilExit()
    }

    private static func pythonAvailable() -> Bool {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        process.arguments = ["python3", "--version"]
        do {
            try process.run()
            process.waitUntilExit()
            return process.terminationStatus == 0
        } catch {
            return false
        }
    }
}
#endif
