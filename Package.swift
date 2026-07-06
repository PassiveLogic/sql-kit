// swift-tools-version:6.1
import class Foundation.ProcessInfo
import PackageDescription

// Embedded-wasm port (see /Users/scottm/git/c34/khasm/EMBEDDED_PORT_PLAN.md): with
// KHASM_EMBEDDED=1 SwiftNIO is dropped — the Embedded build keeps only the async/`SQLBindValue`
// SQLKit core, gated in source with `#if hasFeature(Embedded)` (not available in manifests,
// hence the env var, matching khasm's own manifest gating). Regular builds — including regular
// WASI, where EventLoopFuture rides NIOAsyncRuntime — keep NIO exactly as at the 3.36.0 base.
let khasmEmbedded = ProcessInfo.processInfo.environment["KHASM_EMBEDDED"] == "1"

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
    dependencies: [
        .package(url: "https://github.com/apple/swift-collections.git", from: "1.1.0"),
        // Local embedded-ported swift-log clone (see /Users/scottm/git/c34/EMBEDDED_WASM_NOTES.md);
        // the khasm graph already resolves the swift-log identity to this clone via QuantumInterface.
        .package(path: "../swift-log"),
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.84.0"),
    ],
    targets: [
        .target(
            name: "SQLKit",
            dependencies: [
                .product(name: "Collections", package: "swift-collections"),
                .product(name: "Logging", package: "swift-log"),
            ] + (khasmEmbedded ? [] : [
                // Dropped on the Embedded build (KHASM_EMBEDDED=1, see note at the top).
                .product(name: "NIOCore", package: "swift-nio"),
            ]),
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
