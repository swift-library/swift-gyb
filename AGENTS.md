# swift-gyb Agent Guide

Read `README.md` and `CONTRIBUTING.md` before editing.

## Authority and route

- `Package.swift` owns the plugin product, targets and platform requirements.
- `Plugins/GybPlugin/` owns SwiftPM integration; `gyb.artifactbundle/` owns the
  bundled template engine and its upstream notices.
- Templates own generated source. Keep build outputs in ignored `.build/`.
- `Tests/` owns regression coverage. Run the validation commands in
  `CONTRIBUTING.md` before handing off.
- `.github/swift-package.json` owns the shared validation configuration;
  `.github/release.json` owns the release declaration. See
  `Documentation/Reference/Release.md` for version and tag details.
- `README.md` owns user guidance; `CHANGELOG.md` owns release history.

## Code Review Rules

### Compatibility and versioning

- Flag a change to public API or observable behavior without the change record
  required by the [organization versioning standard](https://github.com/swift-library/.github/blob/master/VERSIONING.md).
  Record raised deployment floors or minimum Swift versions under `## Unreleased`
  with a **Breaking** marker naming the new minimums; assign a version at release.
- Require Swift tools 6.3 and deployment minimums of macOS 15, iOS 18, tvOS 18
  and watchOS 11. Keep one shared CI compiler entry: Xcode 26.6 on macOS 26.

### Claims

- Flag README, DocC, or release-note statements that the code and tests do
  not support: capabilities that do not exist, existing behavior described as
  new, or platforms CI does not build. Safe path: describe what the code
  shows.

### Public documentation

- Flag a new public symbol without a documentation comment, and public prose
  that compares the package with other projects or describes internal
  process. Safe path: document the symbol, and describe only this package's
  own behavior.

### Tests

- Flag a behavior change without a test that would fail before the change.
  Safe path: add the test beside the existing suite for that behavior.
