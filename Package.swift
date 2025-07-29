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
        .binaryTarget(name: "HarperFFI", path: "./HarperFFI.xcframework"),
        .target(
            name: "HarperSwift",
            dependencies: ["CHarper", "HarperFFI"],
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
