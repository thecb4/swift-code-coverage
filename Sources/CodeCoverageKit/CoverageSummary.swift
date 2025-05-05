/// A summary of code coverage metrics for a file, function, or the entire report.
///
/// Includes branch, function, instantiation, line, MC/DC, and region metrics.
public struct CoverageSummary: Codable, Equatable {
  /// Branch coverage metrics.
  public let branches: CoverageMetric
  /// Function coverage metrics.
  public let functions: CoverageMetric
  /// Instantiation coverage metrics (e.g., for templates/generics).
  public let instantiations: CoverageMetric
  /// Line coverage metrics.
  public let lines: CoverageMetric
  /// MC/DC coverage metrics.
  public let mcdc: CoverageMetric
  /// Region coverage metrics.
  public let regions: CoverageMetric
}

extension CoverageSummary {
  public static func fixture(
    branches: CoverageMetric = .fixture(),
    functions: CoverageMetric = .fixture(),
    instantiations: CoverageMetric = .fixture(),
    lines: CoverageMetric = .fixture(),
    mcdc: CoverageMetric = .fixture(),
    regions: CoverageMetric = .fixture()
  ) -> Self {
    .init(
      branches: branches,
      functions: functions,
      instantiations: instantiations,
      lines: lines,
      mcdc: mcdc,
      regions: regions
    )
  }
}
