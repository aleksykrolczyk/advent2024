// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "advent2024",
  platforms: [.macOS("13.0")],
  dependencies: [
    .package(url: "https://github.com/twostraws/SwiftGD", from: "2.5.0"),
    .package(
      url: "https://github.com/apple/swift-collections.git",
      .upToNextMinor(from: "1.1.0")
    ),
  ],

  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .executableTarget(
      name: "advent2024",
      dependencies: [
        "SwiftGD",
        .product(name: "Collections", package: "swift-collections"),
      ],
      path: "Sources",
      resources: [.copy("data")]
    )
  ]
)
