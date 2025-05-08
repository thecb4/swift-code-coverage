import Foundation
import Testing

@testable import CodeCoverageTool

@Suite("Coverage Code CLI Tests")
struct CodeCoverageToolTests {

  let expectedOutput = """

    Coverage Report (llvm.coverage.json.export v2.0.1)
    ================================================

    Target Coverage Summary:
    -----------------------
    Lines:      24.2%
    Functions:  25.8%
    Branches:    0.0%

    ✅ Coverage meets threshold
    """

  @Test func successfulCoverageCheck() throws {
    try assertExecuteCommand(
      command:
        "swift-coverage-review  Tests/CodeCoverageToolTests/fixtures/coverage.json --threshold 20",
      expectedOutput: expectedOutput,
      exitCode: EXIT_SUCCESS
    )
  }

  //@Test func testThresholdValidation() async {
  //  let (stdout, stderr) = await captureOutput {
  //    guard
  //      let command = try? CodeCoverageTool.parse([
  //        "coverage.json",
  //        "--threshold", "90.0",
  //      ])
  //    else {
  //      #expect(Bool(false), "Could not parse the command")
  //      return
  //    }

  //    do {
  //      try command.run()
  //    } catch {
  //      #expect(Bool(false), "Could not run the command")
  //      return
  //    }

  //  }

  //  print("standard out" + stdout)
  //  print("standard err" + stderr)

  //  #expect(stdout.contains("Coverage"))
  //  #expect(stderr.isEmpty)
  //}

  //@Test func testFailsBelowThreshold() async {
  //  // 1. Capture both output streams
  //  let (stdout, stderr) = await captureOutput {
  //    do {
  //      // 2. Run CLI with threshold higher than actual coverage
  //      guard
  //        let command = try? CodeCoverageTool.parse([
  //          "coverage.json",  // Assume this file has 85% coverage
  //          "--threshold", "90.0",
  //        ])
  //      else {
  //        #expect(Bool(false), "Could not parse the command")
  //        return
  //      }

  //      try command.run()

  //      // 3. Fail if no error thrown
  //      Issue.record("Expected threshold error not thrown")
  //    } catch let error as ValidationError {
  //      // 4. Verify error type and message
  //      #expect(error == .thresholdNotMet(current: 85.0, required: 90.0))
  //    } catch {
  //      Issue.record("Unexpected error type: \(type(of: error))")
  //    }

  //  }

  //  print("standard out" + stdout)
  //  print("standard err" + stderr)

  //  // 5. Assert error message appears in stderr
  //  #expect(stderr.contains("Threshold not met: 85.0% < 90.0%"))
  //}
}
