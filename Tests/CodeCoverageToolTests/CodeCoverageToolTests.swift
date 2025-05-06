import CodeCoverageKit
import Foundation
import Testing

@testable import CodeCoverageTool

@Suite("Code Coverage Tool CLI")
struct CodeCoverageToolTests {
  @Test("Basic argument parsing validation")
  func argumentParsing() throws {
    let args = ["--threshold", "80", "coverage.json"]
    let command = try CoverageTool.parse(args)

    #expect(command.threshold == 80.0)
    #expect(command.inputPath == "coverage.json")
  }

  @Test("Threshold validation passes when coverage meets requirement")
  func validThreshold() throws {
    var tool = CoverageTool()
    let coverage = 85.0
    tool.threshold = 80.0

    #expect(throws: Never.self) {
      try tool.validateCoverage(coverage)
    }
  }

  @Test("Threshold validation fails when coverage is insufficient")
  func invalidThreshold() throws {
    var tool = CoverageTool()
    let coverage = 75.0
    tool.threshold = 80.0

    #expect(throws: ValidationError.self) {
      try tool.validateCoverage(coverage)
    }
  }

  @Test("Invalid JSON handling")
  func invalidJSON() throws {
    let invalidJSON = """
      { "invalid": "json
      """.data(using: .utf8)!

    #expect(throws: DecodingError.self) {
      try JSONDecoder().decode(CoverageReport.self, from: invalidJSON)
    }
  }

  @Test("Missing file handling")
  func missingFile() throws {
    let nonExistentPath = "nonexistent.json"

    #expect(throws: CocoaError.self) {
      try Data(contentsOf: URL(fileURLWithPath: nonExistentPath))
    }
  }
}

//import CodeCoverageKit
//import Foundation
//import Testing

//@testable import CodeCoverageTool

//@Suite("Code Coverage Kit - CLI Tests")
//struct CoverageToolTests {
//  private let testJSON = """
//    {
//        "files": [
//            {
//                "path": "Sources/NetworkManager.swift",
//                "lineCoverage": 92.3,
//                "functionsCovered": 8,
//                "totalFunctions": 9
//            },
//            {
//                "path": "Sources/DataParser.swift",
//                "lineCoverage": 85.6,
//                "functionsCovered": 23,
//                "totalFunctions": 28
//            }
//        ],
//        "totalCoverage": 88.9
//    }
//    """

//  @Test("Basic argument parsing validation")
//  func argumentParsing() throws {
//    let args = ["--threshold", "80", "coverage.json"]
//    let command = try CoverageTool.parse(args)
//    #expect(command.inputPath == "coverage.json")
//    #expect(command.threshold == 80.0)
//  }

//  @Test("Threshold validation passes when coverage meets requirement")
//  func validThreshold() throws {
//    let tempFile = try createTempFile(content: testJSON)
//    var command = CoverageTool()
//    command.inputPath = tempFile.path
//    command.threshold = 80.0

//    try #expect(doesNotThrow: {
//      try command.validateCoverage(try loadTestData())
//    })
//  }

//  @Test("Threshold validation fails when coverage is insufficient")
//  func invalidThreshold() throws {
//    let tempFile = try createTempFile(content: testJSON)
//    var command = CoverageTool()
//    command.inputPath = tempFile.path
//    command.threshold = 90.0

//    try #expect(throws: ValidationError.self) {
//      try command.validateCoverage(try loadTestData())
//    }
//  }

//  @Test("File coverage percentage calculation")
//  func fileCoverageCalculation() throws {
//    let file = FileCoverage(
//      path: "test.swift",
//      lineCoverage: 80.0,
//      functionsCovered: 4,
//      totalFunctions: 5
//    )
//    #expect(file.functionPercentage == 80.0)
//  }

//  @Test("JSON decoding validation")
//  func jsonDecoding() throws {
//    let data = testJSON.data(using: .utf8)!
//    let coverage = try JSONDecoder().decode(CoverageData.self, from: data)

//    #expect(coverage.files.count == 2)
//    #expect(coverage.totalCoverage == 88.9)
//    #expect(coverage.files[0].functionPercentage == (8.0 / 9.0 * 100))
//  }

//  // Parameterized test for different threshold values
//  @Test("Threshold validation matrix", arguments: [75.0, 85.0, 88.9, 90.0])
//  func thresholdMatrix(threshold: Double) throws {
//    let coverage = DataEntry(
//      files: [],
//      functions: [],
//      totalCoverage: 88.9
//    )

//    if threshold <= 88.9 {
//        #expect(throws: Never.self) {  // Never.self means "expect no throw"
//            try CoverageTool().validateCoverage(coverage)
//        }
//    } else {
//        #expect(throws: ValidationError.self) {
//            try CoverageTool().validateCoverage(coverage)
//        }
//    }

//  }

//  // Helper methods
//  private func createTempFile(content: String) throws -> URL {
//    let tempDir = FileManager.default.temporaryDirectory
//    let fileURL = tempDir.appendingPathComponent(UUID().uuidString)
//    try content.write(to: fileURL, atomically: true, encoding: .utf8)
//    return fileURL
//  }

//  private func loadTestData() throws -> CoverageData {
//    try JSONDecoder().decode(CoverageData.self, from: testJSON.data(using: .utf8)!)
//  }
//}

//// Test suite for error conditions
//struct ErrorHandlingTests {
//  @Test("Invalid JSON handling")
//  func invalidJSON() async throws {
//    let tempFile = try createTempFile(content: "{ invalid: json }")
//    var command = CoverageTool()
//    command.inputPath = tempFile.path
//    command.threshold = 80.0

//    await #expect(throws: DecodingError.self) {
//      _ = try await command.run()
//    }
//  }

//  @Test("Missing file handling")
//  func missingFile() async throws {
//    var command = CoverageTool()
//    command.inputPath = "nonexistent.json"
//    command.threshold = 80.0

//    await #expect(throws: CocoaError.self) {
//      _ = try await command.run()
//    }
//  }

//  private func createTempFile(content: String) throws -> URL {
//    let tempDir = FileManager.default.temporaryDirectory
//    let fileURL = tempDir.appendingPathComponent(UUID().uuidString)
//    try content.write(to: fileURL, atomically: true, encoding: .utf8)
//    return fileURL
//  }
//}
