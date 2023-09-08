// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "Network",
    products: [
        .library(
            name: "Network",
            targets: [
                "Network"
            ]
        ),
        .library(
            name: "NetworkInterface",
            targets: [
                "NetworkInterface"
            ]
        ),
    ],
    dependencies: [],
    targets: [
        // Implementation
        .target(
            name: "Network",
            dependencies: [
                "NetworkInterface"
            ]
        ),
        .testTarget(
            name: "NetworkTests",
            dependencies: [
                "Network",
                "NetworkInterface"
            ]
        ),
        // Interface
        .target(
            name: "NetworkInterface",
            dependencies: []
        ),
        .testTarget(
            name: "NetworkInterfaceTests",
            dependencies: [
                "NetworkInterface"
            ]
        ),
    ]
)
