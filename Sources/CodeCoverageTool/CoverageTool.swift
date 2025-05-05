import ArgumentParser
import CodeCoverageKit
import Foundation

@main
internal struct CoverageTool: AsyncParsableCommand {
  @Argument var inputPath: String
  @Option var threshold: Double

  func run() async throws {
    let data = try Data(contentsOf: URL(fileURLWithPath: inputPath))
    let report = try JSONDecoder().decode(CoverageReport.self, from: data)

    printDetailedReport(report)

    let totalCoverage =
      report.data
      .compactMap { $0.totals.lines.percent }
      .reduce(0.0, +) / Double(report.data.count)

    print("Total Coverage: \(String(format: "%.1f", totalCoverage))%")
    try validateCoverage(totalCoverage)
  }

  internal func validateCoverage(_ percent: Double) throws {
    guard percent >= threshold else {
      throw ValidationError.thresholdNotMet(current: percent, required: threshold)
    }
    print("✅ Coverage meets threshold")
  }

  internal func printDetailedReport(_ report: CoverageReport) {
    print("Coverage Report (\(report.type) v\(report.version))")
    print("================================================")

    for entry in report.data {
      print("\nTarget Coverage Summary:")
      print("-----------------------")
      print(String(format: "Lines:    %6.1f%%", entry.totals.lines.percent))
      print(String(format: "Functions:%6.1f%%", entry.totals.functions.percent))
      print(String(format: "Branches: %6.1f%%", entry.totals.branches.percent))
    }
  }

}
