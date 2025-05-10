import Foundation
import Testing

@testable import CodeCoverageTool

@Suite("Coverage Code CLI Tests")
struct CodeCoverageToolTests {

  //let expectedOutput = """

  //  Coverage Report (llvm.coverage.json.export v2.0.1)
  //  ================================================

  //  Target Coverage Summary:
  //  -----------------------
  //  Lines:      24.2%
  //  Functions:  25.8%
  //  Branches:    0.0%

  //  ✅ Coverage meets threshold
  //  """

  @Test func shouldExitWithSuccessfulCoverageCheck() throws {
    try assertExecuteCommand(
      command:
        "swift-coverage-review  Tests/CodeCoverageToolTests/fixtures/coverage.json --threshold 80",
      exitCode: EXIT_SUCCESS
    )
  }

  @Test func shouldExitWithUnsuccessfulCoverageCheck() throws {
    try assertExecuteCommand(
      command:
        "swift-coverage-review  Tests/CodeCoverageToolTests/fixtures/coverage.json --threshold 100",
      exitCode: EXIT_FAILURE
    )
  }

}
