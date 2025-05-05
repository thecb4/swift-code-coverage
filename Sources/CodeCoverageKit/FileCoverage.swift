/// Coverage information for a single source file.
///
/// Contains detailed segment, branch, and summary data for the file.
public struct FileCoverage: Codable, Equatable {
  /// The list of branch coverage records for this file.
  public let branches: [Branch]
  /// The list of expansions (template instantiations) for this file.
  public let expansions: [Expansion]
  /// The absolute path to the source file.
  public let filename: String
  /// The list of MC/DC records for this file.
  public let mcdcRecords: [MCDCRecord]
  /// The code coverage segments for this file.
  public let segments: [Segment]
  /// The coverage summary for this file.
  public let summary: CoverageSummary

  enum CodingKeys: String, CodingKey {
    case branches, expansions, filename
    case mcdcRecords = "mcdc_records"
    case segments, summary
  }
}
