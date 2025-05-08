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
        // 1. Build the executable in release mode.
        let buildProcess = Process()
        buildProcess.executableURL = URL(fileURLWithPath: "/usr/bin/swift")
        buildProcess.arguments = ["build", "-c", "release"]
        try buildProcess.run()
        buildProcess.waitUntilExit()
        guard buildProcess.terminationStatus == 0 else {
            Diagnostics.error("Failed to build the executable in release mode.")
            throw PluginError.buildFailed
        }

        // 2. Get the release binary directory using `swift build --show-bin-path`.
        let binPathProcess = Process()
        binPathProcess.executableURL = URL(fileURLWithPath: "/usr/bin/swift")
        binPathProcess.arguments = ["build", "-c", "release", "--show-bin-path"]
        let pipe = Pipe()
        binPathProcess.standardOutput = pipe
        try binPathProcess.run()
        binPathProcess.waitUntilExit()
        guard binPathProcess.terminationStatus == 0 else {
            Diagnostics.error("Failed to determine the binary path.")
            throw PluginError.binPathFailed
        }
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        guard let binPath = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines),
              !binPath.isEmpty else {
            Diagnostics.error("Could not read binary path from swift build output.")
            throw PluginError.binPathFailed
        }

        // 3. Compose the path to your executable.
        let executableName = "swift-code-coverage-review" // Update if your executable has a different name
        let executableURL = URL(fileURLWithPath: binPath).appendingPathComponent(executableName)

        // 4. Run the executable with the plugin's arguments.
        let toolProcess = Process()
        toolProcess.executableURL = executableURL
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
