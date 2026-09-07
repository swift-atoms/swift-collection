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
        .library(name: "Collection", targets: ["Collection"]),
        .library(name: "Collection Standard Library Integration", targets: ["Collection Standard Library Integration"]),
        .library(name: "Collection Foundation Library Integration", targets: ["Collection Foundation Library Integration"]),
        .library(name: "Collection Test Support", targets: ["Collection Test Support"]),
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
            name: "Collection",
            dependencies: [
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Comparison", package: "swift-comparison"),
                .product(name: "Index", package: "swift-index"),
                .product(name: "Ordinal", package: "swift-ordinal"),
                .product(name: "Sequence", package: "swift-sequence"),
                .product(name: "Tagged", package: "swift-tagged"),
                .product(name: "Order", package: "swift-order"),
                .product(name: "Property", package: "swift-property"),
                .product(name: "Affine", package: "swift-affine"),
            ],
            path: "Sources/Collection"
        ),
        .target(
            name: "Collection Standard Library Integration",
            dependencies: [
                .target(name: "Collection"),
            ],
            path: "Sources/Collection Standard Library Integration"
        ),
        .target(
            name: "Collection Foundation Library Integration",
            dependencies: [
                .target(name: "Collection"),
                .target(name: "Collection Standard Library Integration"),
            ],
            path: "Sources/Collection Foundation Library Integration"
        ),
        .target(
            name: "Collection Test Support",
            dependencies: [
                .target(name: "Collection"),
                .product(name: "Index", package: "swift-index"),
                .product(name: "Iterator", package: "swift-iterator"),
                .product(name: "Ordinal", package: "swift-ordinal"),
                .product(name: "Sequence", package: "swift-sequence"),
                .product(name: "Tagged", package: "swift-tagged"),
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Collection Tests",
            dependencies: [
                .target(name: "Collection"),
                .target(name: "Collection Test Support"),
                .product(name: "Affine", package: "swift-affine"),
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Index", package: "swift-index"),
                .product(name: "Ordinal", package: "swift-ordinal"),
                .product(name: "Sequence", package: "swift-sequence"),
                .product(name: "Tagged", package: "swift-tagged"),
                .target(name: "Collection Standard Library Integration"),
                .target(name: "Collection Foundation Library Integration"),
            ],
            path: "Tests/Collection Tests"
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets {
    target.swiftSettings = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]
}
