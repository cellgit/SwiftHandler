// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftHandler",
    defaultLocalization: "en", // 指定默认语言，例如英文
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SwiftHandler",
            targets: ["SwiftHandler"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SwiftHandler",
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "SwiftHandlerTests",
            dependencies: ["SwiftHandler"]),
    ]
)
