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

  struct GybSourceOutputPair {
    let sourcePath: Path
    let outputPath: Path
    let lineDirectiveFile: String?
  }

  func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
    guard let target = target as? SwiftSourceModuleTarget else {
      return []
    }
    let toolPath = try context.tool(named: "gyb").path
    let sourceDirectory = target.directory.string
    let sourceDirectoryPrefix = sourceDirectory.hasSuffix("/") ? sourceDirectory : sourceDirectory + "/"

    let gyb: (_ pair: GybSourceOutputPair) -> Command = { pair in
      var arguments = target.compilationConditions.flatMap { ["-D", "\($0)=1"] }
      let lineDirective: String
      if let lineDirectiveFile = pair.lineDirectiveFile {
        lineDirective = #"#sourceLocation(file: "\#(lineDirectiveFile)", line: %(line)d)"#
      } else {
        lineDirective = ""
      }
      arguments += ["--line-directive", lineDirective]
      arguments += [
        "-o", pair.outputPath.string,
        pair.sourcePath.string,
      ]
      return .buildCommand(
        displayName: "Using gyb convert \(pair.sourcePath.lastComponent) to \(pair.outputPath.lastComponent)",
        executable: toolPath,
        arguments: arguments,
        inputFiles: [pair.sourcePath],
        outputFiles: [pair.outputPath])
    }

    let gybFiles = target.sourceFiles(withSuffix: ".gyb")
    let sourceAndOutputPaths = gybFiles.compactMap { sourceFile -> GybSourceOutputPair? in
      let sourcePath = sourceFile.path
      let relativePath = makeRelativePath(sourcePath.string, sourceDirectoryPrefix: sourceDirectoryPrefix)
      guard let outputFileName = outputFileName(forRelativeGYBPath: relativePath) else {
        return nil
      }
      let outputPath = context.pluginWorkDirectory.appending(outputFileName)
      return GybSourceOutputPair(
        sourcePath: sourcePath,
        outputPath: outputPath,
        lineDirectiveFile: shouldEmitSwiftLineDirective(forOutputFileName: outputFileName)
          ? lineDirectiveFileName(forRelativeGYBPath: relativePath)
          : nil)
    }
    return sourceAndOutputPaths.map(gyb)
  }

  private func makeRelativePath(_ absolutePath: String, sourceDirectoryPrefix: String) -> String {
    if absolutePath.hasPrefix(sourceDirectoryPrefix) {
      return String(absolutePath.dropFirst(sourceDirectoryPrefix.count))
    }
    return absolutePath
  }

  private func outputFileName(forRelativeGYBPath relativeGYBPath: String) -> String? {
    guard relativeGYBPath.hasSuffix(".gyb") else {
      return nil
    }
    let normalizedPath = normalizedPathSeparators(relativeGYBPath)
    let pathWithoutGYB = String(normalizedPath.dropLast(".gyb".count))
    return flatOutputName(pathWithoutGYB)
  }

  private func shouldEmitSwiftLineDirective(forOutputFileName outputFileName: String) -> Bool {
    outputFileName.hasSuffix(".swift")
  }

  private func lineDirectiveFileName(forRelativeGYBPath relativeGYBPath: String) -> String {
    flatOutputName(normalizedPathSeparators(relativeGYBPath))
  }

  private func normalizedPathSeparators(_ path: String) -> String {
    String(path.map { $0 == "\\" ? "/" : $0 })
  }

  private func flatOutputName(_ relativePath: String) -> String {
    relativePath
      .split(separator: "/", omittingEmptySubsequences: false)
      .joined(separator: "__")
  }
}
