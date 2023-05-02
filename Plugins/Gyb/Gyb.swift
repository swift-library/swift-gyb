//===--- Gyb.swift --------------------------------------------------------===//
//
// This source file is part of the swift-library open source project
//
// Created by Xudong Xu on 5/2/23.
//
// Copyright (c) 2023 Xudong Xu <showxdxu@gmail.com> and the swift-library project authors
//
// See https://swift-library.github.io/LICENSE.txt for license information
// See https://swift-library.github.io/CONTRIBUTORS.txt for the list of swift-library project authors
// See https://github.com/swift-library for the list of swift-library projects
//
//===----------------------------------------------------------------------===//

import PackagePlugin

@main
struct GybBuildPlugin: BuildToolPlugin {
  
  func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
    guard let target = target as? SwiftSourceModuleTarget else {
      return []
    }
    let toolPath = try context.tool(named: "gyb").path
    let gyb: (_ src: Path, _ dst: Path) throws -> Command = {
      .buildCommand(
        displayName: "Using gyb convert \($0.lastComponent) to \($1.lastComponent)",
        executable: toolPath,
        arguments: target.compilationConditions.flatMap { ["-D", "\($0)=1"] } + [
          "--line-directive", #"#sourceLocation(file: "%(file)s", line: %(line)d)"#,
          "-o", $1,
          $0,
        ],
        inputFiles: [$0],
        outputFiles: [$1])
    }
    let swiftPath: (Path) -> (Path) = {
      context.pluginWorkDirectory.appending($0.suffix("swift").lastComponent)
    }
    let gybFiles = target.sourceFiles(withSuffix: ".gyb")
    return try gybFiles.map { ($0.path, swiftPath($0.path)) }.map(gyb)
  }
}
