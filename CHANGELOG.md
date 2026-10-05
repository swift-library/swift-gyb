# Changelog

## Unreleased

- Raise the minimum platforms to macOS 12, iOS 15, tvOS 15 and watchOS 9, the
  oldest targets Xcode 27 builds for. Packages with lower deployment targets
  stay on 0.0.2.
- Releases are validated and published through the shared swift-library
  release workflow. Tags use the `vX.Y.Z` form from the next release on.
- Add a NOTICE for the bundled `gyb.py`.

## 0.0.2

- Rename the plugin product from `Gyb` to `GybPlugin`, and remove the
  `GybExample` library product.
- Keep non-Swift outputs, such as `.txt.gyb` and `.html.gyb`, under their own
  extension and bundle them as target resources.
- Expand templates in nested directories, flattening their relative path with
  `__` so templates with the same file name produce separate outputs.
- Pass the target's `.define` compilation conditions to templates.
- Update the bundled `gyb.py` to Swift revision `2f9445d5`.
- Build and test on macOS and Linux in CI.

## 0.0.1

- Initial release of the `Gyb` build tool plugin.
