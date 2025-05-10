/// The root structure representing an LLVM code coverage JSON export.
///
/// This struct contains all coverage data, the type of report, and the version.
public struct CoverageReport: Codable, Equatable {
  /// The array of data entries, each representing a coverage analysis unit (usually one per target).
  public let data: [DataEntry]
  /// The type of the coverage report (e.g., "llvm.coverage.json.export").
  public let type: String
  /// The version string of the coverage report format.
  public let version: String
}
