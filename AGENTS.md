# swift-gyb Agent Guide

Read `README.md` and `CONTRIBUTING.md` before editing.

## Authority and route

- `Package.swift` owns the plugin product, targets and platform requirements.
- `Plugins/GybPlugin/` owns SwiftPM integration; `gyb.artifactbundle/` owns the
  bundled template engine and its upstream notices.
- Templates own generated source. Keep build outputs in ignored `.build/`.
- `Tests/` owns regression coverage. Run `Scripts/check` before handing off.
- `README.md` owns user guidance; `CHANGELOG.md` owns release history.

## Code Review Rules

### Compatibility and versioning

- Flag a change to public API or observable behavior, including a raised
  minimum platform or Swift version, without the change record and version
  bump the [organization versioning standard](https://github.com/swift-library/.github/blob/master/VERSIONING.md) requires. Safe
  path: record the change under the next version with that bump.

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
