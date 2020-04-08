// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MyLibraryNetwork",
    platforms: [.iOS(.v9)],
    products: [
        .library(
            name: "MyLibraryNetwork",
            targets: ["MyLibraryNetwork"]),
    ],
    targets: [
        .target(
            name: "MyLibraryNetwork",
            dependencies: [])
    ]
)
