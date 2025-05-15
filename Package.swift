// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "testing-task-group",
    platforms: [
        .macOS(.v15),
    ],
    products: [
        .library(
            name: "TestingTaskGroup",
            targets: [
                "TestingTaskGroup",
            ]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-async-algorithms.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "TestingTaskGroup",
            dependencies: [
                "AsyncMaterializedSequence",
            ]
        ),
        .target(
            name: "AsyncMaterializedSequence"
        ),
        .testTarget(
            name: "TestingTaskGroupTests",
            dependencies: [
                "TestingTaskGroup",
                .product(name: "AsyncAlgorithms", package: "swift-async-algorithms"),
            ]
        ),
        .testTarget(
            name: "AsyncMaterializedSequenceTests",
            dependencies: [
                "AsyncMaterializedSequence",
                .product(name: "AsyncAlgorithms", package: "swift-async-algorithms"),
            ]
        ),
    ]
)
