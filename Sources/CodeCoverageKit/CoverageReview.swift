import Foundation

public struct CoverageReview {

  /// The Coverage Report generated
  public let report: CoverageReport

  public init(from path: String) throws {
    let data = try Data(contentsOf: URL(fileURLWithPath: path))
    self.report = try JSONDecoder().decode(CoverageReport.self, from: data)
  }

  /// Total coverage as calculated by all the targets provided in the coverage file.
  public var totalCoverage: Double {
    report.data
      .compactMap { $0.totals.lines.percent }
      .reduce(0.0, +) / Double(report.data.count)
  }

}
