import CodeCoverageKit

extension DataEntry {
  func filtered(filteredFrom original: DataEntry, includeDependencies: Bool = false) -> Self {
    guard !includeDependencies else { return self }

    let files = original.files.filter { !$0.filename.contains("DerivedData") }
    let functions = original.functions.filter { !$0.name.contains("_Hidden") }

    return DataEntry(
      files: files,
      functions: functions,
      totals: totals
    )
  }
}
