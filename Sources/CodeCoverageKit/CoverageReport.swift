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

extension CoverageReport: CustomStringConvertible {

  /// The description of the Coverage Report
  public var description: String {

    var details = "\n"

    details += "Coverage Report (\(self.type) v\(self.version))\n"
    details += "================================================\n"

    for entry in self.data {
      details += "\nTarget Coverage Summary:\n"
      details += "-----------------------\n"
      details += String(format: "Lines:    %6.1f%%\n", entry.totals.lines.percent)
      details += String(format: "Functions:%6.1f%%\n", entry.totals.functions.percent)
      details += String(format: "Branches: %6.1f%%\n", entry.totals.branches.percent)
    }

    return details

  }
}
