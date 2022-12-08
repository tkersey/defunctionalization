// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "Defunctionalization",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "Defunctionalization", targets: ["Defunctionalization"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Defunctionalization",
            dependencies: []),
    ]
)
