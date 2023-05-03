// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "swift-gyb",
  platforms: [.macOS(.v10_13), .iOS(.v11), .tvOS(.v11), .watchOS(.v4)],
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(name: "GybExample", targets: ["GybExample"]),
    .plugin(name: "GybPlugin", targets: ["GybPlugin"]),
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
      name: "GybExample",
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
      dependencies: ["GybExample", "GybPlugin"])
  ]
)
