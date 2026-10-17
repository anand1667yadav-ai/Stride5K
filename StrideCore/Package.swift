// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "StrideCore",
    platforms: [
        .iOS(.v17),
        .watchOS(.v10),
        .macOS(.v14),
    ],
    products: [
        .library(name: "StrideCore", targets: ["StrideCore"]),
    ],
    targets: [
        .target(name: "StrideCore"),
        .testTarget(
            name: "StrideCoreTests",
            dependencies: ["StrideCore"]
        ),
    ]
)
