// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "swift-rfc-2045",
    platforms: [
        .macOS(.v14),
        .iOS(.v17),
        .tvOS(.v17),
        .watchOS(.v10)
    ],
    products: [
        .library(
            name: "RFC 2045",
            targets: ["RFC 2045"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "RFC 2045",
            dependencies: []
        ),
        .testTarget(
            name: "RFC 2045 Tests",
            dependencies: ["RFC 2045"]
        )
    ]
)

for target in package.targets {
    target.swiftSettings?.append(
        contentsOf: [
            .enableUpcomingFeature("MemberImportVisibility")
        ]
    )
}
