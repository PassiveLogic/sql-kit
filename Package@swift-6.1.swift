// swift-tools-version:6.1
import PackageDescription

// Trait-aware manifest (SE-0450). Modern toolchains select this over Package.swift.
//  - `SwiftNIO` (default): the existing SwiftNIO/EventLoopFuture backend — unchanged behavior.
//  - `EmbeddedWASI`: a NIO-free, Swift-Concurrency backend for Embedded Swift / WASI. Enable it
//    *instead of* the defaults (e.g. `swift build --traits EmbeddedWASI`), which turns `SwiftNIO`
//    off and drops the swift-nio dependency.
let package = Package(
    name: "sql-kit",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .watchOS(.v6),
        .tvOS(.v13),
    ],
    products: [
        .library(name: "SQLKit", targets: ["SQLKit"]),
        .library(name: "SQLKitBenchmark", targets: ["SQLKitBenchmark"]),
    ],
    traits: [
        .trait(name: "SwiftNIO", description: "Default backend built on SwiftNIO (EventLoopFuture)."),
        .trait(
            name: "EmbeddedWASI",
            description: "NIO-free, Swift-Concurrency backend for Embedded Swift / WASI; drops swift-nio."
        ),
        .default(enabledTraits: ["SwiftNIO"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-collections.git", from: "1.1.0"),
        .package(path: "../swift-log"),
        .package(path: "../swift-nio"),
    ],
    targets: [
        .target(
            name: "SQLKit",
            dependencies: [
                .product(name: "Collections", package: "swift-collections"),
                .product(name: "Logging", package: "swift-log"),
                // NIOCore (ByteBuffer / EventLoopFuture) is only used by the SwiftNIO backend.
                .product(name: "NIOCore", package: "swift-nio", condition: .when(traits: ["SwiftNIO"])),
            ],
            swiftSettings: swiftSettings
        ),
        .target(
            name: "SQLKitBenchmark",
            dependencies: [
                .target(name: "SQLKit"),
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "SQLKitTests",
            dependencies: [
                .target(name: "SQLKit"),
                .target(name: "SQLKitBenchmark"),
            ],
            swiftSettings: swiftSettings
        ),
    ]
)

var swiftSettings: [SwiftSetting] { [
    .enableUpcomingFeature("ExistentialAny"),
    .enableUpcomingFeature("ConciseMagicFile"),
    .enableUpcomingFeature("ForwardTrailingClosures"),
    .enableUpcomingFeature("DisableOutwardActorInference"),
    .enableExperimentalFeature("StrictConcurrency=complete"),
] }
