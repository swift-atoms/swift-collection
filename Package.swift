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
            name: "Collection Access Random",
            targets: ["Collection Access Random"]
        ),
        .library(
            name: "Collection Bidirectional",
            targets: ["Collection Bidirectional"]
        ),
        .library(
            name: "Collection Max",
            targets: ["Collection Max"]
        ),
        .library(
            name: "Collection Min",
            targets: ["Collection Min"]
        ),
        .library(
            name: "Collection Namespace",
            targets: ["Collection Namespace"]
        ),
        .library(
            name: "Collection Standard Library Integration",
            targets: ["Collection Standard Library Integration"]
        ),
        .library(
            name: "Collection Protocol",
            targets: ["Collection Protocol"]
        ),
        .library(
            name: "Collection Remove",
            targets: ["Collection Remove"]
        ),
        .library(
            name: "Collection Rotated",
            targets: ["Collection Rotated"]
        ),
        .library(
            name: "Collection Slice",
            targets: ["Collection Slice"]
        ),

        .library(
            name: "Collection",
            targets: ["Collection"]
        ),

        .library(
            name: "Collection Test Support",
            targets: ["Collection Test Support"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-molecules/swift-comparison.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-index.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-iterator.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-order.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-property.git",
            branch: "main"
        ),
    ],
    targets: [

        .target(
            name: "Collection Namespace"
        ),

        .target(
            name: "Collection Protocol",
            dependencies: [
                "Collection Namespace",
                .product(name: "Comparison", package: "swift-comparison"),
                .product(name: "Index", package: "swift-index"),
                .product(name: "Iterable", package: "swift-iterator"),
            ]
        ),

        .target(
            name: "Collection Bidirectional",
            dependencies: [
                "Collection Namespace",
                "Collection Protocol",
            ]
        ),

        .target(
            name: "Collection Access Random",
            dependencies: [
                "Collection Bidirectional",
                "Collection Namespace",
                "Collection Protocol",
            ]
        ),

        .target(
            name: "Collection Max",
            dependencies: [
                "Collection Protocol",
                .product(name: "Order", package: "swift-order"),
                .product(name: "Property", package: "swift-property"),
            ]
        ),

        .target(
            name: "Collection Min",
            dependencies: [
                "Collection Protocol",
                .product(name: "Order", package: "swift-order"),
                .product(name: "Property", package: "swift-property"),
            ]
        ),

        .target(
            name: "Collection Remove",
            dependencies: [
                "Collection Protocol"
            ]
        ),

        .target(
            name: "Collection Rotated",
            dependencies: [
                "Collection Namespace",
                .product(name: "Index", package: "swift-index"),
            ]
        ),

        .target(
            name: "Collection Slice",
            dependencies: [
                "Collection Protocol",
                .product(name: "Property", package: "swift-property"),
            ]
        ),

        .target(
            name: "Collection Standard Library Integration",
            dependencies: [
                "Collection Access Random",
                "Collection Bidirectional",
                "Collection Protocol",
            ]
        ),

        .target(
            name: "Collection",
            dependencies: [
                "Collection Access Random",
                "Collection Bidirectional",
                "Collection Max",
                "Collection Min",
                "Collection Namespace",
                "Collection Standard Library Integration",
                "Collection Protocol",
                "Collection Remove",
                "Collection Rotated",
                "Collection Slice",
            ]
        ),

        .target(
            name: "Collection Test Support",
            dependencies: [
                "Collection",
                .product(name: "Index Test Support", package: "swift-index"),
                .product(name: "Iterable", package: "swift-iterator"),
                .product(name: "Iterator Chunk", package: "swift-iterator"),
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Collection Tests",
            dependencies: [
                "Collection",
                "Collection Test Support",
                .product(name: "Iterable", package: "swift-iterator"),
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
