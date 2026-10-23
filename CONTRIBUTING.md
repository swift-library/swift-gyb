# Contributing

External contributions are welcome. Use a Conventional Commit PR title and run
the validation commands below before submitting changes. Describe the behavior
being changed and include a regression test for a bug fix. Follow the
[shared contribution guide](https://github.com/swift-library/.github/blob/master/CONTRIBUTING.md)
and [release standard](https://github.com/swift-library/.github/blob/master/VERSIONING.md).
Maintainers follow the shared [signing instructions](https://github.com/swift-library/.github/blob/master/MAINTENANCE.md#signing).

By submitting a contribution, you confirm your right to license it under
[Apache-2.0 WITH Swift-exception](LICENSE.txt). Preserve third-party notices.

## Validation

Use Swift 6.3 or later. Shared CI uses the latest stable Xcode only, currently
Xcode 26.6 on macOS 26, for its compiler lane. The deployment minimums are
macOS 15, iOS 18, tvOS 18 and watchOS 11.

Run these commands from the repository root:

```sh
swift build
swift test
swift build -c release
swift format lint --strict --configuration .swift-format --recursive Package.swift Plugins Sources Tests
python3 gyb.artifactbundle/gyb.py --test
```

The shared CI reads its compiler and platform matrices, format paths and
repository commands from [`.github/swift-package.json`](.github/swift-package.json). The required
checks are `policy / policy` and `validate / result`. See the
[release reference](Documentation/Reference/Release.md) for version and tag details.
