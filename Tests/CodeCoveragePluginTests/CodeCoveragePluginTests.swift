import Testing
import Foundation


@Suite("Coverage Code CLI Tests")
struct CodeCoveragePluginTests {
    @Test("Plugin runs the coverage review tool and passes arguments")
    func testPluginRunsCoverageReview() throws {
        // Prepare test arguments and a path to a sample coverage.json
        let coveragePath = "Tests/CodeCoverageToolTests/fixtures/coverage.json"
        let threshold = "80"
        let arguments = ["--threshold", threshold, coveragePath]

        // Set up the process to invoke the plugin via SwiftPM
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/swift")
        process.arguments = [
            "package", "plugin", "code-coverage-review"
        ] + arguments

        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe

        try process.run()
        process.waitUntilExit()

        let outputData = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: outputData, encoding: .utf8) ?? ""

        #expect(output.contains("Coverage")) // Or whatever output you expect
        #expect(process.terminationStatus == 0)
    }

}
