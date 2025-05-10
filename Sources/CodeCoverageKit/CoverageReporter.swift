public protocol CoverageReporter {
  var review: CoverageReview { get }
  associatedtype Format

  func summarize() throws -> Format

  func detail() throws -> Format
}
