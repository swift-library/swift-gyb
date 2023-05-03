# Swift Gyb

The gyb.py plugin for SwiftPM project.

## Usage

[GYB] is a lightweight templating system that allows you to use Python code for variable substitution and flow control:

- The sequence `%{ code } ` evaluates a block of Python code
- The sequence `% code: ... % end` manages control flow
- The sequence `${ code }` substitutes the result of an expression

A good example of GYB can be found in [Codable.swift.gyb]. At the top of the file, the base Codable types are assigned to an instance variable:

```python
%{
codable_types = ['Bool', 'String', 'Double', 'Float',
                 'Int', 'Int8', 'Int16', 'Int32', 'Int64',
                 'UInt', 'UInt8', 'UInt16', 'UInt32', 'UInt64']
}%
```

Later on, in the implementation of [`SingleValueEncodingContainer`], these types are iterated over to generate the methods declarations for the protocol’s requirements:

```python
% for type in codable_types:
  mutating func encode(_ value: ${type}) throws
% end
```

Evaluating the GYB template results in the following declarations:

```swift
mutating func encode(_ value: Bool) throws
mutating func encode(_ value: String) throws
mutating func encode(_ value: Double) throws
mutating func encode(_ value: Float) throws
mutating func encode(_ value: Int) throws
mutating func encode(_ value: Int8) throws
mutating func encode(_ value: Int16) throws
mutating func encode(_ value: Int32) throws
mutating func encode(_ value: Int64) throws
mutating func encode(_ value: UInt) throws
mutating func encode(_ value: UInt8) throws
mutating func encode(_ value: UInt16) throws
mutating func encode(_ value: UInt32) throws
mutating func encode(_ value: UInt64) throws
```

This pattern is used throughout the file to generate similarly formulaic declarations for methods like `encode(_:forKey:)`, `decode(_:forKey:)`, and `decodeIfPresent(_:forKey:)`. In total, GYB reduces the amount of boilerplate code by a few thousand LOC:

```bash
$ wc -l Codable.swift.gyb
2183 Codable.swift.gyb
$ wc -l Codable.swift
5790 Codable.swift
```

> Ref: [Swift GYB - NSHipster](https://nshipster.com/swift-gyb/)

## Adding `swift-gyb` as a Dependency

To use the `swift-gyb` plugin in a SwiftPM project, 
add it to the dependencies for your package and your `.swift.gyb` files contained target:

```swift
let package = Package(
  // name, platforms, products, etc.
  dependencies: [
    // other dependencies
    .package(url: "https://github.com/swift-library/swift-gyb", from: "0.0.1"),
  ],
  targets: [
    .executableTarget(
      name: "<command-line-tool>",
      dependencies: [
        // other dependencies
      ],
      plugins: [
        .plugin(name: "GybPlugin", package: "swift-gyb"),
      ]
    ),
    // other targets
  ]
)
```

### Supported Versions

The most recent versions of swift-gyb support Swift 5.8 and newer. The minimum Swift version supported by swift-gyb releases are detailed below:

swift-gyb | Minimum Swift Version
----------|----------------------
`0.0.1`   | 5.8

<!-- Link references for readme -->

[GYB]: https://github.com/apple/swift/blob/main/utils/gyb.py
[Codable.swift.gyb]: https://github.com/apple/swift/blob/main/stdlib/public/core/Codable.swift.gyb
[`SingleValueEncodingContainer`]: https://github.com/apple/swift/blob/db81593be463c73f2a3f72b45c1b7ee38e115692/stdlib/public/core/Codable.swift#L2822
