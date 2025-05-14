// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "testing-task-group",
    products: [
        .library(
            name: "TestingTaskGroup",
            targets: [
                "TestingTaskGroup",
            ]
        ),
    ],
    targets: [
        .target(
            name: "TestingTaskGroup"
        ),
        .testTarget(
            name: "TestingTaskGroupTests",
            dependencies: [
                "TestingTaskGroup",
            ]
        ),
    ]
)
