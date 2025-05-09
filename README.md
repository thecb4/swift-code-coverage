# Swift Code Coverage

Swift Code Coverage is a Swift library, executable, and package plugin that reviews the code coverage file that is created during testing.

## Installation

You can use mint to install the executable or use it as a package command plugin

### Mint

Use [Mint](https://github.com/yonaskolb/Mint)

```bash
mint install thecb4/swift-code-coverage
```

### Swift Package Plugin

Install as a dependency in your swift package

```swift
.package(url: "https://github.com/apple/swift-system", from: "1.0.0")
```


## Usage

```bash
swift-code-coverage coverage.json --threshold 20
```

The output will look like

```bash
Coverage Report (llvm.coverage.json.export v2.0.1)
================================================

Target Coverage Summary:
-----------------------
Lines:      24.2%
Functions:  25.8%
Branches:    0.0%

✅ Coverage meets threshold
```


## License

[MIT](/LICENSE.md)
