// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftCodeCoverage",
    platforms: [.macOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(name: "CodeCoverageKit", targets: ["CodeCoverageKit"]),
        .executable(name: "swift-coverage-review", targets: ["CodeCoverageTool"]),
        .plugin(name: "CodeCoveragePlugin", targets: ["CodeCoveragePlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-format", from: "601.0.0"),
        .package(url: "https://github.com/swiftlang/swift-docc-plugin", from: "1.4.3"),
        .package(url: "https://github.com/apple/swift-argument-parser",from: "1.5.0"),
        .package(url: "https://github.com/apple/swift-system", from: "1.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "CodeCoverageKit",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ],
        ),
        .executableTarget(
            name: "CodeCoverageTool",
            dependencies: [
                "CodeCoverageKit"
            ],
        ),
        .plugin(
            name: "CodeCoveragePlugin",
            capability: .command(
                intent: .custom(
                verb: "code-coverage-review",
                description: "Analyzes code coverage reports"
              )
            )
        ),
        .testTarget(
            name: "CodeCoverageKitTests",
            dependencies: ["CodeCoverageKit"],
            resources: [
                .copy("fixtures") // or .copy("fixtures/coverage.json")
            ]
        ),
        .testTarget(
            name: "CodeCoverageToolTests",
            dependencies: [
                "CodeCoverageTool",
                "CodeCoverageKit",
                .product(name: "SystemPackage", package: "swift-system")
            ],
            resources: [
                .copy("fixtures") // or .copy("fixtures/coverage.json")
            ]
        ),
    ]
)
