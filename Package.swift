// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "swift-gyb",
  platforms: [.macOS(.v10_13), .iOS(.v11), .tvOS(.v11), .watchOS(.v4)],
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(name: "GybExample", targets: ["GybExample"]),
    .plugin(name: "Gyb", targets: ["Gyb"]),
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
      name: "GybExample",
      plugins: [.plugin(name: "Gyb")]),
    
    .plugin(
      name: "Gyb",
      capability: .buildTool(),
      dependencies: ["gyb"]),
    
    .binaryTarget(
      name: "gyb",
      path: "gyb.artifactbundle"),
    
    .testTarget(
      name: "GybTests",
      dependencies: ["GybExample", "Gyb"])
  ]
)
