// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-collection",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(
            name: "Collection",
            targets: ["Collection"]
        ),
        .library(
            name: "Collection Standard Library Integration",
            targets: ["Collection Standard Library Integration"]
        ),
        .library(
            name: "Collection Apple Foundation Integration",
            targets: ["Collection Apple Foundation Integration"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-atoms/swift-comparison.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-iterator.git",
            branch: "main"
        ),
    ],
    targets: [
        .target(
            name: "Collection",
            dependencies: [
                .product(name: "Comparison", package: "swift-comparison"),
                .product(name: "Iterator", package: "swift-iterator"),
            ]
        ),
        .target(
            name: "Collection Standard Library Integration",
            dependencies: ["Collection"]
        ),
        .target(
            name: "Collection Apple Foundation Integration",
            dependencies: [
                "Collection",
                "Collection Standard Library Integration",
            ]
        ),
        .testTarget(
            name: "Collection Tests",
            dependencies: [
                "Collection",
                .product(name: "Iterator", package: "swift-iterator"),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
