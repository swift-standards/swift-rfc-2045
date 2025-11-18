// swift-tools-version: 6.0

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
        .package(path: "../swift-incits-4-1986"),
    ],
    targets: [
        .target(
            name: "RFC 2045",
            dependencies: [
                .product(name: "INCITS 4 1986", package: "swift-incits-4-1986"),
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
