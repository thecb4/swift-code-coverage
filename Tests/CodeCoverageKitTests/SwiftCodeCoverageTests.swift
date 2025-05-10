// Tests/CoverageTests/CoverageModelSuite.swift

import Foundation
import Testing

@testable import CodeCoverageKit

@Suite("Code Coverage Kit - Model Tests")
struct CoverageModelSuite {

  // MARK: - LLVMCoverageReport

  @Test("CoverageReport decodes full report structure")
  func testLLVMCoverageReportDecoding() throws {
    let data = try TestUtilities.fixtureData(named: "coverage")
    let report = try JSONDecoder().decode(CoverageReport.self, from: data)
    #expect(report.type == "llvm.coverage.json.export")
    #expect(report.version == "2.0.1")
    #expect(report.data.count == 1)
  }

  @Test("LLVMCoverageReport round-trip encoding/decoding")
  func testLLVMCoverageReportRoundTrip() throws {
    let original = CoverageReport(
      data: [
        .init(
          files: [],
          functions: [],
          totals: .fixture()  // Now works!
        )
      ],
      type: "test",
      version: "1.0"
    )

    let decoded = try TestUtilities.roundTripEncodeDecode(original)
    #expect(original == decoded)
  }

  // MARK: - FileCoverage

  @Test("FileCoverage decodes file coverage with segments")
  func testFileCoverageDecoding() throws {
    let json = """
      {
          "branches": [],
          "expansions": [],
          "filename": "test.swift",
          "mcdc_records": [],
          "segments": [[510,52,1,true,true,false]],
          "summary": {
              "branches": {"count":0,"covered":0,"notcovered":0,"percent":0},
              "functions": {"count":0,"covered":0,"notcovered":0,"percent":0},
              "instantiations": {"count":0,"covered":0,"notcovered":0,"percent":0},
              "lines": {"count":17,"covered":14,"notcovered":3,"percent":82.35},
              "mcdc": {"count":0,"covered":0,"notcovered":0,"percent":0},
              "regions": {"count":0,"covered":0,"notcovered":0,"percent":0}
          }
      }
      """
    let coverage = try JSONDecoder().decode(FileCoverage.self, from: json.data(using: .utf8)!)
    #expect(coverage.filename == "test.swift")
    #expect(coverage.segments.count == 1)
    #expect(coverage.summary.lines.percent == 82.35)
  }

  // MARK: - Segment

  @Test("Segment decodes from array")
  func testSegmentDecoding() throws {
    let json = "[510,52,1,true,true,false]"
    let segment = try JSONDecoder().decode(Segment.self, from: json.data(using: .utf8)!)
    #expect(segment.line == 510)
    #expect(segment.column == 52)
    #expect(segment.count == 1)
    #expect(segment.hasCount == true)
    #expect(segment.isRegionEntry == true)
    #expect(segment.isGapRegion == false)
  }

  // MARK: - CoverageSummary

  @Test("CoverageSummary decodes complete summary")
  func testCoverageSummaryDecoding() throws {
    let json = """
      {
          "branches": {"count":10,"covered":8,"notcovered":2,"percent":80},
          "functions": {"count":5,"covered":5,"notcovered":0,"percent":100},
          "instantiations": {"count":0,"covered":0,"notcovered":0,"percent":0},
          "lines": {"count":3,"covered":3,"notcovered":0,"percent":100},
          "mcdc": {"count":0,"covered":0,"notcovered":0,"percent":0},
          "regions": {"count":1,"covered":1,"notcovered":0,"percent":100}
      }
      """
    let summary = try JSONDecoder().decode(CoverageSummary.self, from: json.data(using: .utf8)!)
    #expect(summary.branches.percent == 80)
    #expect(summary.functions.covered == 5)
    #expect(summary.lines.percent == 100)
  }

  @Test("CoverageSummary handles missing notcovered field")
  func testCoverageSummaryMissingNotCovered() throws {
    let json = """
      {
          "branches": {"count":0,"covered":0,"percent":0},
          "functions": {"count":0,"covered":0,"percent":0},
          "instantiations": {"count":0,"covered":0,"percent":0},
          "lines": {"count":0,"covered":0,"percent":0},
          "mcdc": {"count":0,"covered":0,"percent":0},
          "regions": {"count":0,"covered":0,"percent":0}
      }
      """
    let summary = try JSONDecoder().decode(CoverageSummary.self, from: json.data(using: .utf8)!)
    #expect(summary.branches.notcovered == nil)
  }

  // MARK: - CoverageMetric

  @Test("CoverageMetric percent calculation")
  func testCoverageMetricPercentCalculation() throws {
    let json = """
      {"count": 10, "covered": 8, "notcovered": 2, "percent": 80.0}
      """
    let metric = try JSONDecoder().decode(CoverageMetric.self, from: json.data(using: .utf8)!)
    #expect(metric.count == 10)
    #expect(metric.covered == 8)
    #expect(metric.notcovered == 2)
    #expect(metric.percent == 80.0)
  }

  // MARK: - Error Handling

  @Test("Throws on invalid segment structure")
  func testInvalidSegmentThrows() throws {
    let invalidJSON = "[1,2,3]".data(using: .utf8)!
    #expect(throws: DecodingError.self) {
      _ = try JSONDecoder().decode(Segment.self, from: invalidJSON)
    }
  }

  @Test("Throws on missing required field")
  func testMissingRequiredFieldThrows() throws {
    let json = """
      {"filename": "test.swift"}
      """
    #expect(throws: DecodingError.self) {
      _ = try JSONDecoder().decode(FileCoverage.self, from: json.data(using: .utf8)!)
    }
  }

  @Test("Report Description")
  func testReportDescription() throws {
    let data = try TestUtilities.fixtureData(named: "coverage")
    let report = try JSONDecoder().decode(CoverageReport.self, from: data)

    let review = CoverageReview(for: report)
    let reporter = TextCoverageReporter(for: review)

    let summary = try reporter.summarize()
    let details = try reporter.detail()

    print(summary)
    print(details)
  }
}
