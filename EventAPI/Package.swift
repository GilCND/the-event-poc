// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EventAPI",
    platforms: [
        .iOS(.v17),
        .watchOS(.v8),
        .visionOS(.v1),
        .tvOS(.v15),
        .macOS(.v11)
       ],
    products: [
        .library(name: "EventAPI", targets: ["EventAPI"])
    ], targets: [
        .target(
            name: "EventAPI"),
        .testTarget(name: "EventAPITests", dependencies: [.target(name: "EventAPI")], resources: [.copy("event.json")]),
    ]
)
