import Foundation

public struct CoverageReview {

  /// The Coverage Report generated
  public let report: CoverageReport

  public init(from path: String, with dependencies: Bool = false) throws {
    let data = try Data(contentsOf: URL(fileURLWithPath: path))
    let report = try JSONDecoder().decode(CoverageReport.self, from: data)
    self.report = Self.filter(report, with: dependencies)
  }

  public init(using data: Data, with dependencies: Bool = false) throws {
    let report = try JSONDecoder().decode(CoverageReport.self, from: data)
    self.report = Self.filter(report, with: dependencies)
  }

  public init(for report: CoverageReport, with dependencies: Bool = false) {
    self.report = Self.filter(report, with: dependencies)
  }

  internal static func filter(_ report: CoverageReport, with dependencies: Bool) -> CoverageReport {
    guard !dependencies else { return report }

    let data = report.data.map { Self.filter($0, with: dependencies) }

    return CoverageReport(data: data, type: report.type, version: report.version)

  }

  internal static func filter(_ entry: DataEntry, with dependencies: Bool) -> DataEntry {
    guard !dependencies else { return entry }

    let fileExcludes = ["DerivedData", ".build", "Tests"]
    let functionExcludes = ["_Hidden", ".build", "Tests"]

    let files = exclude(entry.files, keyPath: \.filename, substrings: fileExcludes)
    let functions = exclude(entry.functions, keyPath: \.name, substrings: functionExcludes)

    let totals = summarize(files)

    return DataEntry(
      files: files,
      functions: functions,
      totals: totals
    )

  }

  internal static func exclude<T>(_ items: [T], keyPath: KeyPath<T, String>, substrings: [String])
    -> [T]
  {
    return items.filter { item in
      !substrings.contains { substring in
        item[keyPath: keyPath].contains(substring)
      }
    }
  }

  internal static func summarize(_ files: [FileCoverage]) -> CoverageSummary {

    return CoverageSummary(
      branches: .fixture(),
      functions: revisedFunctionSummary(files),
      instantiations: .fixture(),
      lines: revisedLineSummary(files),
      mcdc: .fixture(),
      regions: revisedRegionSummary(files)
    )

  }

  internal static func revisedRegionSummary(_ files: [FileCoverage]) -> CoverageMetric {
    let totalRegionCount = files.reduce(0, { $0 + $1.summary.regions.count })
    let totalRegionCovered = files.reduce(0, { $0 + $1.summary.regions.covered })
    let totalRegionCoveragePercent = (Double(totalRegionCovered) / Double(totalRegionCount)) * 100.0

    return CoverageMetric(
      count: totalRegionCount, covered: totalRegionCovered, notcovered: nil,
      percent: totalRegionCoveragePercent)
  }

  internal static func revisedFunctionSummary(_ files: [FileCoverage]) -> CoverageMetric {
    let totalFunctionCount = files.reduce(0, { $0 + $1.summary.functions.count })
    let totalFunctionCovered = files.reduce(0, { $0 + $1.summary.functions.covered })
    let totalFunctionCoveragePercent =
      (Double(totalFunctionCovered) / Double(totalFunctionCount)) * 100.0

    return CoverageMetric(
      count: totalFunctionCount, covered: totalFunctionCovered, notcovered: nil,
      percent: totalFunctionCoveragePercent)
  }

  internal static func revisedLineSummary(_ files: [FileCoverage]) -> CoverageMetric {
    let totalLinesCount = files.reduce(0, { $0 + $1.summary.lines.count })
    let totalLinesCovered = files.reduce(0, { $0 + $1.summary.lines.covered })
    let totalLinesCoveragePercent = (Double(totalLinesCovered) / Double(totalLinesCount)) * 100.0

    return CoverageMetric(
      count: totalLinesCount, covered: totalLinesCovered, notcovered: nil,
      percent: totalLinesCoveragePercent)
  }

  /// Total coverage as calculated by all the targets provided in the coverage file.
  public var totalCoverage: Double {
    report.data
      .compactMap { $0.totals.lines.percent }
      .reduce(0.0, +) / Double(report.data.count)
  }

}
