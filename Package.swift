// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MARKRangeSlider",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "MARKRangeSlider",
            targets: ["MARKRangeSlider"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "MARKRangeSlider",
            dependencies: [],
            exclude: ["Info.plist"],
            resources: [.process("Resources")],
            publicHeadersPath: "include"
        ),
        .testTarget(
            name: "MARKRangeSliderTests",
            dependencies: ["MARKRangeSlider"],
            exclude: ["Info.plist"]
        )
    ]
)
