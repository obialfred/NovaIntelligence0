import Foundation

enum OpenWebUIBundleError: LocalizedError {
    case preparationScriptMissing
    case preparationFailed(status: Int32)
    case missingIndex
    case scriptMissing

    var errorDescription: String? {
        switch self {
        case .preparationScriptMissing:
            return "Unable to locate the Nova Intelligence (beta) preparation helper."
        case let .preparationFailed(status):
            return "Preparing the Nova Intelligence (beta) assets failed (exit status: \(status))."
        case .missingIndex:
            return "The Nova Intelligence (beta) bundle does not contain an index.html entry."
        case .scriptMissing:
            return "Unable to locate the bundled preview server helper script."
        }
    }
}

enum OpenWebUIBundle {
    private static let bundleVersion = "0.6.34"
    private static let completionMarker = ".prepared"
    private static let preparationScriptName = "prepare_bundle"

    static func cachedIndexURL() -> URL? {
        guard let directory = (try? preparedDirectoryIfPresent()) ?? nil else {
            return nil
        }

        let indexURL = directory.appendingPathComponent("index.html")
        guard FileManager.default.fileExists(atPath: indexURL.path) else {
            return nil
        }

        try? ensureOfflineScaffolding(in: directory)

        return indexURL
    }

    static func indexURL() throws -> URL {
        let directory = try ensureAssetDirectory()
        let indexURL = directory.appendingPathComponent("index.html")
        guard FileManager.default.fileExists(atPath: indexURL.path) else {
            throw OpenWebUIBundleError.missingIndex
        }
        return indexURL
    }

    static func ensureAssetDirectory() throws -> URL {
        let fileManager = FileManager.default
        let (extractionDirectory, marker) = try bundlePaths()

        if directoryIsPrepared(extractionDirectory, marker: marker) {
            try ensureOfflineScaffolding(in: extractionDirectory)
            return extractionDirectory
        }

        if fileManager.fileExists(atPath: extractionDirectory.path) {
            try fileManager.removeItem(at: extractionDirectory)
        }
        try fileManager.createDirectory(at: extractionDirectory, withIntermediateDirectories: true)

        try prepareBundle(into: extractionDirectory)
        try ensureOfflineScaffolding(in: extractionDirectory)
        try bundleVersion.write(to: marker, atomically: true, encoding: .utf8)

        return extractionDirectory
    }

    static func previewServerScriptURL() throws -> URL {
        guard let scriptURL = Bundle.module.url(forResource: "preview_server", withExtension: "py") else {
            throw OpenWebUIBundleError.scriptMissing
        }
        return scriptURL
    }

    private static func prepareBundle(into destination: URL) throws {
        guard let scriptURL = Bundle.module.url(forResource: preparationScriptName, withExtension: "py") else {
            throw OpenWebUIBundleError.preparationScriptMissing
        }

        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        process.arguments = [
            "python3",
            scriptURL.path,
            "--output", destination.path,
            "--version", bundleVersion,
            "--brand", "Nova Intelligence (beta)"
        ]
        var environment = ProcessInfo.processInfo.environment
        environment["PIP_DISABLE_PIP_VERSION_CHECK"] = "1"
        environment["PYTHONWARNINGS"] = "ignore"
        process.environment = environment
        try process.run()
        process.waitUntilExit()

        guard process.terminationStatus == 0 else {
            throw OpenWebUIBundleError.preparationFailed(status: process.terminationStatus)
        }
    }

    private static func ensureOfflineScaffolding(in directory: URL) throws {
        try ensureStubAPIResponses(in: directory)
    }

    private static func ensureStubAPIResponses(in directory: URL) throws {
        let fileManager = FileManager.default
        let apiDirectory = directory.appendingPathComponent("api", isDirectory: true)
        if !fileManager.fileExists(atPath: apiDirectory.path) {
            try fileManager.createDirectory(at: apiDirectory, withIntermediateDirectories: true)
        }

        try writeIfMissing(
            to: apiDirectory.appendingPathComponent("config"),
            contents: OpenWebUIOfflineStubs.config
        )
        try writeIfMissing(
            to: apiDirectory.appendingPathComponent("changelog"),
            contents: OpenWebUIOfflineStubs.changelog
        )
        let versionDirectory = apiDirectory.appendingPathComponent("version", isDirectory: true)
        if !fileManager.fileExists(atPath: versionDirectory.path) {
            try fileManager.createDirectory(at: versionDirectory, withIntermediateDirectories: true)
        }
        try writeIfMissing(
            to: versionDirectory.appendingPathComponent("index.html"),
            contents: OpenWebUIOfflineStubs.version
        )
        try writeIfMissing(
            to: versionDirectory.appendingPathComponent("updates"),
            contents: OpenWebUIOfflineStubs.versionUpdates
        )
        try writeIfMissing(
            to: apiDirectory.appendingPathComponent("webhook"),
            contents: OpenWebUIOfflineStubs.webhook
        )
    }

    private static func writeIfMissing(to url: URL, contents: String) throws {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: url.path) {
            return
        }
        try contents.write(to: url, atomically: true, encoding: .utf8)
    }

    private static func resolveExtractionRoot() throws -> URL {
        let fileManager = FileManager.default
        #if os(Linux)
        let base = fileManager.homeDirectoryForCurrentUser
            .appendingPathComponent(".nova-intelligence", isDirectory: true)
            .appendingPathComponent("web-bundle", isDirectory: true)
        #else
        let support = try fileManager.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        let base = support
            .appendingPathComponent("NovaIntelligence", isDirectory: true)
            .appendingPathComponent("WebBundle", isDirectory: true)
        #endif
        try fileManager.createDirectory(at: base, withIntermediateDirectories: true)
        return base
    }

    private static func bundlePaths() throws -> (directory: URL, marker: URL) {
        let extractionRoot = try resolveExtractionRoot()
        let directoryName = "NovaIntelligence-\(bundleVersion)"
        let extractionDirectory = extractionRoot.appendingPathComponent(directoryName, isDirectory: true)
        let marker = extractionDirectory.appendingPathComponent(completionMarker)
        return (extractionDirectory, marker)
    }

    private static func preparedDirectoryIfPresent() throws -> URL? {
        let (directory, marker) = try bundlePaths()

        guard directoryIsPrepared(directory, marker: marker) else {
            return nil
        }

        return directory
    }

    private static func directoryIsPrepared(_ directory: URL, marker: URL) -> Bool {
        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: directory.path),
              fileManager.fileExists(atPath: marker.path) else { return false }

        guard let recordedVersion = try? String(contentsOf: marker, encoding: .utf8),
              recordedVersion == bundleVersion else {
            return false
        }

        return true
    }
}

enum OpenWebUIOfflineStubs {
    static let config = """
    {
      "status": true,
      "name": "Nova Intelligence (beta)",
      "version": "offline-preview",
      "default_locale": "en",
      "onboarding": false,
      "oauth": {
        "providers": {}
      },
      "features": {
        "auth": false,
        "auth_trusted_header": false,
        "enable_signup_password_confirmation": false,
        "enable_ldap": false,
        "enable_api_key": false,
        "enable_signup": false,
        "enable_login_form": true,
        "enable_websocket": false,
        "enable_version_update_check": false,
        "enable_direct_connections": false,
        "enable_channels": false,
        "enable_notes": false,
        "enable_web_search": false,
        "enable_code_execution": false,
        "enable_code_interpreter": false,
        "enable_image_generation": false,
        "enable_autocomplete_generation": false,
        "enable_community_sharing": false,
        "enable_message_rating": false,
        "enable_user_webhooks": false,
        "enable_admin_export": false,
        "enable_admin_chat_access": false,
        "enable_google_drive_integration": false,
        "enable_onedrive_integration": false,
        "enable_onedrive_personal": false,
        "enable_onedrive_business": false
      },
      "default_models": [],
      "default_prompt_suggestions": [],
      "user_count": 1,
      "code": {
        "engine": ""
      },
      "audio": {
        "tts": {
          "engine": "",
          "voice": "",
          "split_on": ""
        },
        "stt": {
          "engine": ""
        }
      },
      "file": {
        "max_size": 10485760,
        "max_count": 10,
        "image_compression": {
          "width": 1024,
          "height": 1024
        }
      },
      "permissions": {},
      "google_drive": {
        "client_id": "stub-google-client",
        "api_key": "stub-google-key"
      },
      "onedrive": {
        "client_id_personal": "",
        "client_id_business": "",
        "sharepoint_url": "",
        "sharepoint_tenant_id": ""
      },
      "ui": {
        "pending_user_overlay_title": "",
        "pending_user_overlay_content": "",
        "response_watermark": ""
      },
      "license_metadata": {},
      "metadata": {
        "login_footer": "",
        "auth_logo_position": ""
      }
    }
    """

    static let changelog = """
    {}
    """

    static let version = """
    {
      "version": "offline-preview"
    }
    """

    static let versionUpdates = """
    {
      "current": "offline-preview",
      "latest": "offline-preview"
    }
    """

    static let webhook = """
    {
      "url": ""
    }
    """
}
