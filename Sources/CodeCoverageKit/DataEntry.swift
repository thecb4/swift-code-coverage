/// A container for file and function coverage data in an LLVM coverage report.
///
/// Each `DataEntry` typically represents a single coverage run or target.
public struct DataEntry: Codable, Equatable {
  /// The files included in this coverage entry.
  public let files: [FileCoverage]
  /// The functions included in this coverage entry.
  public let functions: [FunctionCoverage]
  /// The total coverage summary for this entry.
  public let totals: CoverageSummary

  public init(
    files: [FileCoverage] = [], functions: [FunctionCoverage] = [],
    totals: CoverageSummary = CoverageSummary.fixture()
  ) {
    self.files = files
    self.functions = functions
    self.totals = totals
  }
}
