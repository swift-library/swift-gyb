// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "swift-gyb",
  platforms: [.macOS(.v15), .iOS(.v18), .tvOS(.v18), .watchOS(.v11)],
  products: [
    // This package only exposes the build tool plugin publicly.
    .plugin(name: "GybPlugin", targets: ["GybPlugin"])
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
      name: "GybBuildFixtures",
      swiftSettings: [
        .define("GYB_TEST_FLAG")
      ],
      plugins: [.plugin(name: "GybPlugin")]),

    .plugin(
      name: "GybPlugin",
      capability: .buildTool(),
      dependencies: ["gyb"]),

    .binaryTarget(
      name: "gyb",
      path: "gyb.artifactbundle"),

    .testTarget(
      name: "GybTests",
      dependencies: ["GybBuildFixtures"]),
  ]
)
