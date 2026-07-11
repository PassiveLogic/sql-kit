// swift-tools-version:6.1
import PackageDescription

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
        .default(enabledTraits: ["NIO"]),
        .trait(
            name: "NIO",
            description: "Default backend: SwiftNIO (the legacy EventLoopFuture query surface)."
        ),
        .trait(
            name: "NativeConcurrency",
            description: "NIO-free build on Swift concurrency: the EventLoopFuture overloads are removed; the async query surface is the only one. Build with `--traits NativeConcurrency` (replaces the default NIO trait)."
        ),
        .trait(
            name: "Freestanding",
            description: "Embedded/freestanding flavor (implies NativeConcurrency). No additional source effect in this package beyond NativeConcurrency; declared so a root's `--traits Freestanding` configuration names a known trait when this package is wired by path.",
            enabledTraits: ["NativeConcurrency"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-collections.git", from: "1.1.0"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.5.4"),
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.84.0"),
    ],
    targets: [
        .target(
            name: "SQLKit",
            dependencies: [
                .product(name: "Collections", package: "swift-collections"),
                .product(name: "Logging", package: "swift-log"),
                // The EventLoopFuture surface rides the default `NIO` trait; with
                // `NativeConcurrency` enabled instead, SQLKit is NIO-free (async-only),
                // gated in source with `#if NativeConcurrency`.
                .product(name: "NIOCore", package: "swift-nio", condition: .when(traits: ["NIO"])),
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
                .product(name: "NIOCore", package: "swift-nio"),
                .product(name: "NIOEmbedded", package: "swift-nio"),
                .target(name: "SQLKit"),
                .target(name: "SQLKitBenchmark"),
            ],
            swiftSettings: swiftSettings
        ),
    ]
)

var swiftSettings: [SwiftSetting] { [
    .enableUpcomingFeature("ExistentialAny"),
    .enableUpcomingFeature("InternalImportsByDefault"),
    .enableUpcomingFeature("MemberImportVisibility"),
    .enableUpcomingFeature("InferIsolatedConformances"),
    // .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
    .enableUpcomingFeature("ImmutableWeakCaptures"),
] }
