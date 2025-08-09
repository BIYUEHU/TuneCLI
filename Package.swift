// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TuneCLI",
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
        .package(url: "https://github.com/onevcat/Rainbow", from: "4.0.0"),
        .package(url: "https://github.com/jkandzi/Progress.swift", from: "0.4.0"),
        .package(url: "https://github.com/AudioKit/AudioKit", from: "5.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SAudio",
            publicHeadersPath: "include"
        ),
        .executableTarget(
            name: "TuneCLI",
            dependencies: [

                .product(name: "ArgumentParser", package: "swift-argument-parser"), "SAudio",
            ]),
    ]
)
