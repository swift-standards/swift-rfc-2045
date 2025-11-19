// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "swift-rfc-2045",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .tvOS(.v18),
        .watchOS(.v11)
    ],
    products: [
        .library(
            name: "RFC 2045",
            targets: ["RFC 2045"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/swift-standards/swift-incits-4-1986", from: "0.1.0"),
        .package(url: "https://github.com/swift-standards/swift-rfc-5322", from: "0.1.0"),
        .package(url: "https://github.com/swift-standards/swift-standards", from: "0.1.0"),
    ],
    targets: [
        .target(
            name: "RFC 2045",
            dependencies: [
                .product(name: "INCITS 4 1986", package: "swift-incits-4-1986"),
                .product(name: "RFC 5322", package: "swift-rfc-5322"),
                .product(name: "Standards", package: "swift-standards"),
            ]
        ),
        .testTarget(
            name: "RFC 2045 Tests",
            dependencies: ["RFC 2045"]
        )
    ]
)

for target in package.targets {
    var settings = target.swiftSettings ?? []
    settings.append(
        .enableUpcomingFeature("MemberImportVisibility")
    )
    target.swiftSettings = settings
}
