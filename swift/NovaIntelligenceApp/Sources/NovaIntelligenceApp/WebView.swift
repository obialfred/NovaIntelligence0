#if canImport(SwiftUI)
import SwiftUI
import WebKit

#if os(macOS)
import AppKit
#else
import UIKit
#endif

struct NovaWebView: View {
    @Binding var url: URL

    var body: some View {
        Representable(url: $url)
            .ignoresSafeArea()
    }
}

#if os(macOS)
private struct Representable: NSViewRepresentable {
    @Binding var url: URL
    private let webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration.novaConfiguration())

    func makeNSView(context: Context) -> WKWebView {
        configure(webView)
        return webView
    }

    func updateNSView(_ nsView: WKWebView, context: Context) {
        load(url, in: nsView)
    }

    static func dismantleNSView(_ nsView: WKWebView, coordinator: ()) {
        nsView.stopLoading()
    }
}
#else
private struct Representable: UIViewRepresentable {
    @Binding var url: URL
    private let webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration.novaConfiguration())

    func makeUIView(context: Context) -> WKWebView {
        configure(webView)
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        load(url, in: uiView)
    }

    static func dismantleUIView(_ uiView: WKWebView, coordinator: ()) {
        uiView.stopLoading()
    }
}
#endif

private extension Representable {
    func configure(_ webView: WKWebView) {
        webView.allowsBackForwardNavigationGestures = true
        webView.customUserAgent = "NovaIntelligence/1.0"
    }

    func load(_ url: URL, in webView: WKWebView) {
        if webView.url == url { return }

        if url.isFileURL {
            let readAccess = url.deletingLastPathComponent()
            webView.loadFileURL(url, allowingReadAccessTo: readAccess)
        } else {
            webView.load(URLRequest(url: url))
        }
    }
}

private extension WKWebViewConfiguration {
    static func novaConfiguration() -> WKWebViewConfiguration {
        let configuration = WKWebViewConfiguration()
        configuration.websiteDataStore = .default()
        configuration.limitsNavigationsToAppBoundDomains = false
        return configuration
    }
}

extension URL {
    static var defaultNovaURL: URL {
        if let offlineDemo = OpenWebUIBundle.cachedIndexURL() {
            return offlineDemo
        }
        if let primary = URL(string: "https://nova.intelligence.local") {
            return primary
        }
        return URL(string: "http://localhost:8080") ?? URL(fileURLWithPath: "/")
    }

    init?(fromUserInput rawValue: String) {
        let trimmed = rawValue.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }

        if trimmed.contains(" ") { return nil }
        if let url = URL(string: trimmed), url.scheme != nil {
            self = url
            return
        }
        let prefixed = "https://" + trimmed
        guard let url = URL(string: prefixed) else { return nil }
        self = url
    }

    func appendingTimeStamp() -> URL {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
            return self
        }
        var queryItems = components.queryItems ?? []
        let stamp = String(Int(Date().timeIntervalSince1970))
        queryItems.append(URLQueryItem(name: "ts", value: stamp))
        components.queryItems = queryItems
        return components.url ?? self
    }
}

extension Color {
    init(hex: String) {
        let cleaned = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: cleaned).scanHexInt64(&int)
        let r, g, b: UInt64
        switch cleaned.count {
        case 6:
            (r, g, b) = (int >> 16 & 0xff, int >> 8 & 0xff, int & 0xff)
        default:
            (r, g, b) = (0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255.0,
            green: Double(g) / 255.0,
            blue: Double(b) / 255.0,
            opacity: 1.0
        )
    }
}
#endif
