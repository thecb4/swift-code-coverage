import ArgumentParser
import CodeCoverageKit

@main
internal struct CodeCoverageTool: ParsableCommand {
  @Argument(help: "Path to coverage JSON file") var inputPath: String
  @Option(help: "Minimum required coverage percentage") var threshold: Double

  func run() throws {

    let review = try CoverageReview(from: inputPath)

    let totalCoverage = review.totalCoverage

    print("\(review.report)")

    try validateCoverageByThreshold(totalCoverage)

  }

  internal func validateCoverageByThreshold(_ percent: Double) throws {
    guard percent >= threshold else {
      throw ValidationError.thresholdNotMet(current: percent, required: threshold)
    }
    print("✅ Coverage meets threshold")
  }
}
