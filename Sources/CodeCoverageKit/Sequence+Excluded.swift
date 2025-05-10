extension Sequence where Element == String {
  /// Returns true if none of the substrings are contained in the string.
  func isExcluded(by substrings: [String]) -> Bool {
    return !substrings.contains { self.contains($0) }
  }
}
