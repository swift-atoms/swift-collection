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
            url: "https://github.com/swift-atoms/swift-comparison.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-index.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-iterator.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-sequence.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-affine.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-cardinal.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-ordinal.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-tagged.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-order.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-property.git",
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
                .target(name: "Collection Namespace"),
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Comparison Protocol", package: "swift-comparison"),
                .product(name: "Index", package: "swift-index"),
                .product(name: "Ordinal Protocol", package: "swift-ordinal"),
                .product(name: "Sequence Borrowing", package: "swift-sequence"),
                .product(name: "Tagged", package: "swift-tagged"),
            ]
        ),

        .target(
            name: "Collection Bidirectional",
            dependencies: [
                .target(name: "Collection Namespace"),
                .target(name: "Collection Protocol"),
            ]
        ),

        .target(
            name: "Collection Access Random",
            dependencies: [
                .target(name: "Collection Bidirectional"),
                .target(name: "Collection Namespace"),
                .target(name: "Collection Protocol"),
            ]
        ),

        .target(
            name: "Collection Max",
            dependencies: [
                .target(name: "Collection Protocol"),
                .product(name: "Comparison Protocol", package: "swift-comparison"),
                .product(name: "Order Comparator", package: "swift-order"),
                .product(name: "Property", package: "swift-property"),
                .product(name: "Property Inout", package: "swift-property"),
            ]
        ),

        .target(
            name: "Collection Min",
            dependencies: [
                .target(name: "Collection Protocol"),
                .product(name: "Comparison Protocol", package: "swift-comparison"),
                .product(name: "Order Comparator", package: "swift-order"),
                .product(name: "Property", package: "swift-property"),
                .product(name: "Property Inout", package: "swift-property"),
            ]
        ),

        .target(
            name: "Collection Remove",
            dependencies: [
                .target(name: "Collection Protocol"),
                .product(name: "Sequence Borrowing", package: "swift-sequence"),
            ]
        ),

        .target(
            name: "Collection Rotated",
            dependencies: [
                .target(name: "Collection Namespace"),
                .product(name: "Affine Arithmetic", package: "swift-affine"),
                .product(name: "Affine Carrier", package: "swift-affine"),
                .product(name: "Affine Discrete", package: "swift-affine"),
                .product(name: "Affine Tagged", package: "swift-affine"),
                .product(
                    name: "Affine Standard Library Integration",
                    package: "swift-affine"
                ),
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Index", package: "swift-index"),
                .product(name: "Ordinal", package: "swift-ordinal"),
                .product(name: "Ordinal Cardinal", package: "swift-ordinal"),
                .product(name: "Ordinal Error", package: "swift-ordinal"),
                .product(name: "Ordinal Predecessor", package: "swift-ordinal"),
                .product(name: "Ordinal Protocol", package: "swift-ordinal"),
                .product(name: "Ordinal Successor", package: "swift-ordinal"),
                .product(name: "Ordinal Tagged", package: "swift-ordinal"),
                .product(name: "Tagged", package: "swift-tagged"),
            ]
        ),

        .target(
            name: "Collection Slice",
            dependencies: [
                .target(name: "Collection Protocol"),
                .product(name: "Property", package: "swift-property"),
                .product(name: "Property Inout", package: "swift-property"),
            ]
        ),

        .target(
            name: "Collection Standard Library Integration",
            dependencies: [
                .target(name: "Collection Access Random"),
                .target(name: "Collection Bidirectional"),
                .target(name: "Collection Protocol"),
            ]
        ),

        .target(
            name: "Collection",
            dependencies: [
                .target(name: "Collection Access Random"),
                .target(name: "Collection Bidirectional"),
                .target(name: "Collection Max"),
                .target(name: "Collection Min"),
                .target(name: "Collection Namespace"),
                .target(name: "Collection Standard Library Integration"),
                .target(name: "Collection Protocol"),
                .target(name: "Collection Remove"),
                .target(name: "Collection Rotated"),
                .target(name: "Collection Slice"),
            ]
        ),

        .target(
            name: "Collection Test Support",
            dependencies: [
                .target(name: "Collection"),
                .product(name: "Index", package: "swift-index"),
                .product(name: "Iterator", package: "swift-iterator"),
                .product(name: "Iterator Chunk", package: "swift-iterator"),
                .product(name: "Ordinal", package: "swift-ordinal"),
                .product(name: "Ordinal Successor", package: "swift-ordinal"),
                .product(name: "Ordinal Tagged", package: "swift-ordinal"),
                .product(name: "Sequence Borrowing", package: "swift-sequence"),
                .product(name: "Tagged", package: "swift-tagged"),
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Collection Tests",
            dependencies: [
                .target(name: "Collection"),
                .target(name: "Collection Test Support"),
                .product(name: "Affine Carrier", package: "swift-affine"),
                .product(name: "Affine Tagged", package: "swift-affine"),
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Cardinal Carrier", package: "swift-cardinal"),
                .product(name: "Index", package: "swift-index"),
                .product(name: "Ordinal", package: "swift-ordinal"),
                .product(name: "Ordinal Cardinal", package: "swift-ordinal"),
                .product(name: "Ordinal Protocol", package: "swift-ordinal"),
                .product(name: "Ordinal Tagged", package: "swift-ordinal"),
                .product(name: "Sequence ForEach", package: "swift-sequence"),
                .product(name: "Tagged", package: "swift-tagged"),
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
