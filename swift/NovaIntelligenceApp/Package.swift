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
    dependencies: [
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.59.0")
    ],
    targets: [
        .executableTarget(
            name: "NovaIntelligenceApp",
            dependencies: [
                .product(name: "NIO", package: "swift-nio", condition: .when(platforms: [.linux])),
                .product(name: "NIOHTTP1", package: "swift-nio", condition: .when(platforms: [.linux])),
                .product(name: "NIOPosix", package: "swift-nio", condition: .when(platforms: [.linux]))
            ],
            path: "Sources"
        )
    ]
)
