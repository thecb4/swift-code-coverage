/// A region represents a code region for coverage analysis.
///
/// Each region includes its start/end locations and various region-specific IDs and flags.
public struct Region: Codable, Equatable {
  /// The starting line number of the region.
  public let startLine: Int
  /// The starting column number of the region.
  public let startColumn: Int
  /// The ending line number of the region.
  public let endLine: Int
  /// The ending column number of the region.
  public let endColumn: Int
  /// The execution count for this region.
  public let executionCount: Int
  /// The file ID associated with this region.
  public let fileID: Int
  /// The expanded file ID for this region.
  public let expandedFileID: Int
  /// The kind of region (as an integer code).
  public let kind: Int

  public init(from decoder: Decoder) throws {
    var container = try decoder.unkeyedContainer()
    startLine = try container.decode(Int.self)
    startColumn = try container.decode(Int.self)
    endLine = try container.decode(Int.self)
    endColumn = try container.decode(Int.self)
    executionCount = try container.decode(Int.self)
    fileID = try container.decode(Int.self)
    expandedFileID = try container.decode(Int.self)
    kind = try container.decode(Int.self)
  }
}
