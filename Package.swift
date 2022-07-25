// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftyRedux",
    platforms: [
        .macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)
    ],
    products: [
        .library(
            name: "SwiftyRedux",
            targets: ["SwiftyRedux"]),
    ],
    targets: [
        .target(
            name: "SwiftyRedux",
            dependencies: []),
        .testTarget(
            name: "SwiftyReduxTests",
            dependencies: ["SwiftyRedux"]),
    ]
)
