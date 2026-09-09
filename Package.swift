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

        .library(name: "Collection Foundation Integration", targets: ["Collection Foundation Integration"]),
        .library(name: "Collection Test Support", targets: ["Collection Test Support"]),
    ],
    traits: [
        .trait(name: "Prefix", description: "Prefix selection integration"),
        .default(enabledTraits: ["Prefix"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-atoms/swift-predicate.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-prefix.git", branch: "main"),

        .package(url: "https://github.com/swift-atoms/swift-ownership.git", branch: "main"),

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
        .testTarget(name: "Prefix Collection Tests", dependencies: [
            .target(name: "Collection"),
            .product(name: "Prefix", package: "swift-prefix", condition: .when(traits: ["Prefix"])),
        ]),
        .target(
            name: "Collection",
            dependencies: [
                .product(name: "Prefix", package: "swift-prefix", condition: .when(traits: ["Prefix"])),
                .product(name: "Predicate", package: "swift-predicate", condition: .when(traits: ["Prefix"])),
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Comparison", package: "swift-comparison"),
                .product(name: "Index", package: "swift-index"),
                .product(name: "Ordinal", package: "swift-ordinal"),
                .product(name: "Sequence", package: "swift-sequence"),
                .product(name: "Tagged", package: "swift-tagged"),
                .product(name: "Order", package: "swift-order"),
                .product(name: "Property", package: "swift-property"),
            ],
            path: "Sources/Collection"
        ),
        
        .target(
            name: "Collection Foundation Integration",
            dependencies: [
                .target(name: "Collection"),
            ],
            path: "Sources/Collection Foundation Integration"
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
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Index", package: "swift-index"),
                .product(name: "Ordinal", package: "swift-ordinal"),
                .product(name: "Sequence", package: "swift-sequence"),
                .product(name: "Tagged", package: "swift-tagged"),
                .target(name: "Collection Foundation Integration"),
            ],
            path: "Tests/Collection Tests"
        ),
        .testTarget(
            name: "Consolidated Collection Property Tests",
            dependencies: [
                .product(name: "Tagged", package: "swift-tagged"),

                .target(name: "Collection"),
                .product(name: "Comparison", package: "swift-comparison"),
                .product(name: "Order", package: "swift-order"),
                .product(name: "Ownership", package: "swift-ownership"),
                .product(name: "Property", package: "swift-property"),
                .product(name: "Iterator", package: "swift-iterator"),
            ],
            path: "Tests/Consolidated swift-collection-property"
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
