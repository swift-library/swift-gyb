//===--- GybTests.swift ---------------------------------------------------===//
//
// This source file is part of the swift-library open source project
//
// Created by Xudong Xu on 4/23/23.
//
// Copyright (c) 2023 Xudong Xu <showxdxu@gmail.com> and the swift-library project authors
//
// See https://swift-library.github.io/LICENSE.txt for license information
// See https://swift-library.github.io/CONTRIBUTORS.txt for the list of swift-library project authors
// See https://github.com/swift-library for the list of swift-library projects
//
//===----------------------------------------------------------------------===//

import Foundation
import Testing
@testable import GybBuildFixtures

struct GybCodable: Codable {}

enum GybRaw: String {
  case value
}

struct GybTests {
  @Test
  func generatedImplTypesAreUsable() {
    _ = DefaultImpl<Int>(.standard)
    _ = RawRepresentableImpl<GybRaw>(.standard)
    _ = CodableImpl<GybCodable>(.standard)
  }

  @Test
  func plainGYBTemplateIsGeneratedAsSwift() {
    _ = PlainTemplateMarker()
    #expect(String(describing: PlainTemplateMarker.self) == "PlainTemplateMarker")
  }

  @Test
  func nonSwiftGYBTemplatesKeepOriginalExtensions() throws {
    let nonSwiftCases = [
      ("NonSwift__Guide.txt", "GYB_NON_SWIFT_TEXT_FIXTURE"),
      ("NonSwift__Snippets__index.html", "GYB_NON_SWIFT_HTML_FIXTURE"),
    ]

    for (expectedOutputFileName, expectedMarker) in nonSwiftCases {
      let matchingOutputs = try findBuildArtifacts(named: expectedOutputFileName)
      #expect(!matchingOutputs.isEmpty)
      #expect(try findBuildArtifacts(named: expectedOutputFileName + ".swift").isEmpty)

      let outputContents = try String(contentsOf: matchingOutputs[0], encoding: .utf8)
      #expect(outputContents.contains(expectedMarker))
      #expect(!outputContents.contains("#sourceLocation("))
    }
  }

  @Test
  func sameBasenameTemplatesFromDifferentDirectoriesAreBothGenerated() {
    _ = StubAImplMarker()
    _ = StubBImplMarker()
    #expect(String(describing: StubAImplMarker.self) == "StubAImplMarker")
    #expect(String(describing: StubBImplMarker.self) == "StubBImplMarker")
    #expect(StubAImplMarker.fileID != StubBImplMarker.fileID)
  }

  @Test
  func compilationConditionsArePassedToGYBTemplates() {
    _ = CompilationConditionMarker()
    #expect(String(describing: CompilationConditionMarker.self) == "CompilationConditionMarker")
  }

  private func findBuildArtifacts(named fileName: String) throws -> [URL] {
    let packageRoot = URL(fileURLWithPath: #filePath)
      .deletingLastPathComponent()
      .deletingLastPathComponent()
      .deletingLastPathComponent()
    let buildDirectory = packageRoot.appendingPathComponent(".build", isDirectory: true)

    guard let enumerator = FileManager.default.enumerator(
      at: buildDirectory,
      includingPropertiesForKeys: [.isRegularFileKey],
      options: [.skipsHiddenFiles]
    ) else {
      return []
    }

    var matches: [URL] = []
    for case let candidate as URL in enumerator where candidate.lastPathComponent == fileName {
      matches.append(candidate)
    }
    return matches
  }
}
