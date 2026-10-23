# Release reference

`VERSION` declares the package version. `CHANGELOG.md` supplies release notes
under the matching `## X.Y.Z` heading. `.github/release.json` identifies these
files, the minimum Swift version and the release platform declarations.

`.github/swift-package.json` declares the validation matrix, format paths and
GYB self-test. The required checks are `policy / policy` and `validate / result`.
Run the [local validation commands](../../CONTRIBUTING.md#validation) before
preparing a release.

Releases use a signed annotated `vX.Y.Z` tag whose message is
`swift-gyb X.Y.Z`. Pushing the tag starts `.github/workflows/release.yml`,
which validates the tagged commit through the shared package workflow before
the shared release workflow verifies the tag and publishes the changelog notes.
The [organization versioning standard](https://github.com/swift-library/.github/blob/master/VERSIONING.md)
defines version changes and tag policy.
