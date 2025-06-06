// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CasaAjedrez",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "CasaAjedrez",
            targets: ["CasaAjedrez"]),
    ],
    dependencies: [
        // Include swift-testing for structured test macros
        .package(url: "https://github.com/apple/swift-testing.git", from: "0.5.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "CasaAjedrez"),
        .testTarget(
            name: "CasaAjedrezTests",
            dependencies: [
                "CasaAjedrez",
                .product(name: "Testing", package: "swift-testing")
            ]
        ),
    ]
)
