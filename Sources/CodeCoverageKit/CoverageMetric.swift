/// A set of coverage metrics for a specific aspect of the code (e.g., lines, branches).
///
/// Contains counts of total, covered, not covered, and a coverage percentage.
public struct CoverageMetric: Codable, Equatable {
  /// The total number of items (e.g., lines, branches).
  public let count: Int
  /// The number of covered items.
  public let covered: Int
  /// The number of not covered items (optional).
  public let notcovered: Int?
  /// The percentage of items covered (0–100).
  public let percent: Double
}

extension CoverageMetric {
  public static func fixture(
    count: Int = 0,
    covered: Int = 0,
    notcovered: Int? = nil,
    percent: Double = 0.0
  ) -> Self {
    .init(
      count: count,
      covered: covered,
      notcovered: notcovered,
      percent: percent
    )
  }
}
