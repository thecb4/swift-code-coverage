/// A segment represents a contiguous range of code with a specific coverage status.
///
/// Each segment is described by its location, execution count, and coverage flags.
public struct Segment: Codable, Equatable {
  /// The line number where the segment starts.
  public let line: Int
  /// The column number where the segment starts.
  public let column: Int
  /// The execution count for this segment.
  public let count: Int
  /// Whether this segment has a count.
  public let hasCount: Bool
  /// Whether this segment is a region entry.
  public let isRegionEntry: Bool
  /// Whether this segment is a gap region.
  public let isGapRegion: Bool

  public init(from decoder: Decoder) throws {
    var container = try decoder.unkeyedContainer()
    line = try container.decode(Int.self)
    column = try container.decode(Int.self)
    count = try container.decode(Int.self)
    hasCount = try container.decode(Bool.self)
    isRegionEntry = try container.decode(Bool.self)
    isGapRegion = try container.decode(Bool.self)
  }
}
