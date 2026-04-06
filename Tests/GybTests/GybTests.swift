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
}
