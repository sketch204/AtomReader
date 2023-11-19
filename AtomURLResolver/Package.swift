// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AtomURLResolver",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "AtomURLResolver",
            targets: ["AtomURLResolver"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/sketch204/AtomXML", .upToNextMinor(from: "1.0.0")),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "AtomURLResolver",
            dependencies: ["AtomXML"]
        ),
        .testTarget(
            name: "AtomURLResolverTests",
            dependencies: ["AtomURLResolver"]
        ),
    ]
)
