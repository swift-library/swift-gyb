# Release reference

`VERSION` declares the package version. `CHANGELOG.md` supplies release notes
under the matching `## X.Y.Z` heading. `.github/release.json` identifies these
files, the minimum Swift version and the release platform declarations.
The minimum is Swift 6.3; deployment floors are macOS 15, iOS 18, tvOS 18 and
watchOS 11, with each platform window also including generations 26 and 27.
Record breaking minimum changes under `## Unreleased` with a **Breaking** marker
before assigning the release version.

`.github/swift-package.json` declares the validation configuration, format paths and
GYB self-test. Its single compiler entry uses Xcode 26.6 on macOS 26.
The required checks are `policy / policy` and `validate / result`.
Run the [local validation commands](../../CONTRIBUTING.md#validation) before
preparing a release.

Releases use a signed annotated `vX.Y.Z` tag whose message is
`swift-gyb X.Y.Z`. Pushing the tag starts `.github/workflows/release.yml`,
which validates the tagged commit through the shared package workflow before
the shared release workflow verifies the tag and publishes the changelog notes.
The [organization versioning standard](https://github.com/swift-library/.github/blob/master/VERSIONING.md)
defines version changes and tag policy.
