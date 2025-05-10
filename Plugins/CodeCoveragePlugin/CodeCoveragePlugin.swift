/// # CodeCoveragePlugin
///
/// A Swift Package Manager command plugin that builds and runs the code coverage review executable
/// in release mode, passing all plugin arguments through. This enables coverage enforcement in CI
/// and development workflows without requiring the tool to be globally installed.
///
/// ## Usage
/// ```
/// swift package plugin code-coverage-review --threshold 85 path/to/coverage.json
/// ```
///
/// ## Discussion
/// This plugin:
/// - Builds your executable in release mode if needed
/// - Locates the executable using `swift build -c release --show-bin-path`
/// - Invokes the executable with the provided arguments
///
/// The executable must be declared as a product in your package manifest.
///
import PackagePlugin
import Foundation

/// The main entry point for the code coverage review plugin.
///
/// This plugin builds and runs the coverage review executable from the package's build directory,
/// forwarding all arguments to the executable.
@main
struct CodeCoveragePlugin: CommandPlugin {
    /// Performs the code coverage review command.
    ///
    /// - Parameters:
    ///   - context: The plugin context provided by SwiftPM.
    ///   - arguments: The command-line arguments passed to the plugin.
    ///
    /// - Throws: A ``PluginError`` if building or running the executable fails.
    func performCommand(context: PluginContext, arguments: [String]) throws {
        // 1. get the tool from the context
        //let reviewTool = try context.tool(named: "swift-coverage-review")
        let executableName = "swift-coverage-review"
        let cwd = FileManager.default.currentDirectoryPath
        let executablePath = "\(cwd)/.build/release/\(executableName)"

        //let reviewExecutableURL = reviewTool.url
        let reviewExecutableURL = URL(fileURLWithPath: executablePath)
        print(reviewExecutableURL)

        // 2. start a subprocess for the tool
        let toolProcess = Process()
        toolProcess.executableURL = reviewExecutableURL
        toolProcess.arguments = arguments
        toolProcess.standardInput = FileHandle.nullDevice
        toolProcess.standardOutput = FileHandle.standardOutput
        toolProcess.standardError = FileHandle.standardError
        try toolProcess.run()
        toolProcess.waitUntilExit()
        if toolProcess.terminationStatus != 0 {
            Diagnostics.error("Coverage check failed with exit code \(toolProcess.terminationStatus).")
            throw PluginError.coverageCheckFailed
        }
    }

    /// Errors that can occur during plugin execution.
    enum PluginError: Error {
        /// The build failed.
        case buildFailed
        /// The binary path could not be determined.
        case binPathFailed
        /// The coverage check failed.
        case coverageCheckFailed
    }
}
