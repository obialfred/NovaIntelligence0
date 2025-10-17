// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "NovaIntelligenceApp",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17),
        .macOS(.v13),
        .tvOS(.v17)
    ],
    products: [
        .executable(name: "NovaIntelligenceApp", targets: ["NovaIntelligenceApp"])
    ],
    targets: [
        .executableTarget(
            name: "NovaIntelligenceApp",
            path: "Sources",
            resources: [
                .process("NovaIntelligenceApp/Resources")
            ]
        )
    ]
)
