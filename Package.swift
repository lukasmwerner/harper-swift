// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "HarperSwift",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "HarperSwift",
            targets: ["HarperSwift"]
        ),
        .executable(
            name: "harper",
            targets: ["HarperCLI"]
        ),
    ],
    targets: [
        .systemLibrary(
            name: "CHarper",
            path: "Sources/CHarper",
            pkgConfig: nil,
            providers: []
        ),
        .target(
            name: "HarperSwift",
            dependencies: ["CHarper"],
            linkerSettings: [
                .unsafeFlags(["-L", "target/release"]),
                .linkedLibrary("harper_ffi")
            ]
        ),
        .executableTarget(
            name: "HarperCLI",
            dependencies: ["HarperSwift"]
        ),
        .testTarget(
            name: "HarperSwiftTests",
            dependencies: ["HarperSwift"]
        )
    ]
)