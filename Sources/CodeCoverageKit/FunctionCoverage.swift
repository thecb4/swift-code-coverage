/// Coverage information for a single function.
///
/// Includes branch, region, and MC/DC data for the function.
public struct FunctionCoverage: Codable, Equatable {
  /// The list of branch coverage records for this function.
  public let branches: [Branch]
  /// The execution count for this function.
  public let count: Int
  /// The filenames associated with this function (may be more than one due to inlining).
  public let filenames: [String]
  /// The list of MC/DC records for this function.
  public let mcdcRecords: [MCDCRecord]
  /// The mangled name of the function.
  public let name: String
  /// The code regions associated with this function.
  public let regions: [Region]

  enum CodingKeys: String, CodingKey {
    case branches, count, filenames
    case mcdcRecords = "mcdc_records"
    case name, regions
  }
}
