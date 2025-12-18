// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ObserveData",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v26),
        .macOS(.v26),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ObserveData",
            targets: ["ObserveData"]
        ),
    ],
    dependencies: [
//        .package(path: "../GridNavigation")
        .package(url: "https://github.com/jjnicolas/GridNavigation", branch: "main"),
//        .package(url: "https://github.com/jjnicolas/GridNavigation", revision: "5d7116650646f42400425c3c309d5d9725cc128e"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ObserveData",
            dependencies: ["GridNavigation"]
        ),
        .testTarget(
            name: "ObserveDataTests",
            dependencies: ["ObserveData"],
        ),
    ]
)
