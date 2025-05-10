public struct TextCoverageReporter: CoverageReporter {
  public let review: CoverageReview

  public init(for review: CoverageReview) {
    self.review = review
  }

  public init(for report: CoverageReport) {
    self.review = CoverageReview(for: report)
  }

  public func summarize() throws -> String {

    let report = review.report

    var details = "\n"

    details += "Coverage Report (\(report.type) v\(report.version))\n"
    details += "================================================\n"

    for entry in report.data {
      details += "\nTarget Coverage Summary:\n"
      details += "-----------------------\n"
      details += String(format: "Lines:    %6.1f%%\n", entry.totals.lines.percent)
      details += String(format: "Functions:%6.1f%%\n", entry.totals.functions.percent)
      details += String(format: "Branches: %6.1f%%\n", entry.totals.branches.percent)
    }

    details += "================================================\n"

    details += String(format: "Total Coverage: %6.1f%%\n", review.totalCoverage)

    return details
  }

  public func detail() throws -> Format {
    var details = ""

    for entry in review.report.data {
      details += fileEntryCoverageDetails(for: entry)
    }

    return details
  }

  internal func fileEntryCoverageDetails(for entry: DataEntry) -> String {

    var details =
      """
      ╒════════════════════════════════════════════╤═════════╤═════════════════╤════════════╤═══════════╤═══════════════════╤════════════╤═══════╤═══════════════╤════════════╕
      │ File                                       │ Regions │ Region Coverage │ Coverage % │ Functions │ Function Coverage │ Coverage % │ Lines │ Line Coverage │ Coverage % │
      ╞════════════════════════════════════════════╪═════════╪═════════════════╪────────────╪───────────╪───────────────────╪────────────╪═══════╪───────────────╪────────────╡\n
      """

    for file in entry.files {
      let summary = file.summary
      let fileName =
        (stripComponents(from: file.filename, before: ["Sources", "Plugins"]) ?? file.filename)
        .padding(toLength: 42, withPad: " ", startingAt: 0)

      let values =
        """
        | \(fileName) │ \(String(format: "%7d", summary.regions.count)) │ \(String(format: "%15d", summary.regions.covered)) │ \(String(format: "%10.0f", summary.regions.percent)) │ \(String(format: "%9d", summary.functions.count)) │ \(String(format: "%17d", summary.functions.covered)) │ \(String(format: "%10.0f", summary.functions.percent)) │ \(String(format: "%5d", summary.lines.count)) │ \(String(format: "%13d", summary.lines.covered)) │ \(String(format: "%10.0f", summary.lines.percent)) │\n
        """

      details += values
    }

    details +=
      """
      ├────────────────────────────────────────────┼─────────┼─────────────────┼────────────┼───────────┼───────────────────┼────────────┼───────┼───────────────┼────────────┤\n
      """

    let totals = entry.totals

    let totalString = "Total".padding(toLength: 42, withPad: " ", startingAt: 0)

    details += String(
      format:
        "│ %@ │ %7d │ %15d │ %10.0f │ %9d │ %17d │ %10.0f │ %5d │ %13d │ %10.0f │",
      totalString,
      totals.regions.count, totals.regions.covered, totals.regions.percent,
      totals.functions.count, totals.regions.covered, totals.regions.percent,
      totals.lines.count, totals.lines.covered, totals.lines.percent
    )

    details += "\n"

    details +=
      """
      "╘════════════════════════════════════════════╧═════════╧═════════════════╧════════════╧═══════════╧═══════════════════╧════════════╧═══════╧═══════════════╧════════════╛\n"
      """

    return details
  }

  internal func stripComponents(from path: String, before directories: [String]) -> String? {
    let components = path.split(separator: "/").map(String.init)
    for dir in directories {
      if let index = components.firstIndex(of: dir), index < components.count - 1 {
        return components[(index + 1)...].joined(separator: "/")
      }
    }
    return nil
  }

}
