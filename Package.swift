// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Publish_ForwardTable",
    platforms: [.macOS(.v12)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Publish_ForwardTable",
            targets: ["Publish_ForwardTable"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/vithanco/Publish.git",
            branch: "master"),
        .package(
            url: "https://github.com/johnsundell/files.git",
            from: "4.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Publish_ForwardTable",
            dependencies: [
                "Publish",
                .product(name: "Files", package: "files")
            ]),
        .testTarget(
            name: "Publish_ForwardTableTests",
            dependencies: ["Publish_ForwardTable", "Publish"]),
    ]
)