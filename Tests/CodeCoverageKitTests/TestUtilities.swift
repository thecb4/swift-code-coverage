// Tests/CoverageTests/TestUtilities.swift

import Foundation

/// Utility functions for loading test fixtures.
enum TestUtilities {
  /// Loads the contents of a fixture file in the `fixtures` folder.
  ///
  /// - Parameter named: The file name (with extension) of the fixture.
  /// - Returns: The data contained in the fixture file.
  /// - Throws: An error if the file cannot be found or read.
  static func fixtureData(named name: String, file: StaticString = #file) throws -> Data {
    //// Find the directory this source file lives in
    guard
      let url = Bundle.module.url(
        forResource: name,
        withExtension: "json",
        subdirectory: "fixtures"
      )
    else {
      throw TestUtilityError.fixtureNotFound(name: name)
    }

    return try Data(contentsOf: url)
  }

  /// Encodes and decodes a value to verify Codable conformance.
  static func roundTripEncodeDecode<T: Codable & Equatable>(_ value: T) throws -> T {
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
    let data = try encoder.encode(value)
    return try JSONDecoder().decode(T.self, from: data)
  }
}
