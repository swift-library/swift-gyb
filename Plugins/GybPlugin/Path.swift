//===--- Path.swift -------------------------------------------------------===//
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

extension PackagePlugin.Path {
  
  /// Return a new ``PackagePlugin/Path`` formed by replacing the existing extension (if any)
  /// with the one provided.
  ///
  /// If, after removing the existing extension, the path already has the new extension, no
  /// further changes are made.
  ///
  /// - Parameters:
  ///   - suffix: The new extension for the path.
  /// - Returns: The resulting path.
  ///
  /// Use cases:
  ///
  ///     "/Impl.swfit.gyb".suffix("foo")       // "/Impl.swfit.foo"
  ///     "/Impl.swfit.gyb".suffix("swift")     // "/Impl.swfit"
  ///     "/Impl.swfit.gyb".suffix("swift.gyb") // "/Impl.swfit.gyb"
  ///     "/Impl.swfit.gyb".suffix("tar.gz")    // "/Impl.swfit.tar.gz"
  ///
  func suffix(_ suffix: String) -> Self {
    removingLastComponent().appending(stem + (stem.hasSuffix(suffix) ? "" : suffix))
  }
}
