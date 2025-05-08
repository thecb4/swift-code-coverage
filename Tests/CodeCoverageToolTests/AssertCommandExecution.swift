import Foundation
import SystemPackage
import Testing

@discardableResult
func assertExecuteCommand(
  command: String,
  expectedOutput: String? = nil,
  exitCode: Int32 = EXIT_SUCCESS,
  file: StaticString = #filePath,
  line: UInt = #line,
  environment: [String: String] = [:]
) throws -> String {
  try assertExecuteCommand(
    command: command.split(separator: " ").map(String.init),
    expectedOutput: expectedOutput,
    exitCode: exitCode,
    file: file,
    line: line,
    environment: environment
  )
}

@discardableResult
func assertExecuteCommand(
  command: [String],
  expectedOutput: String? = nil,
  exitCode: Int32 = EXIT_SUCCESS,
  file: StaticString = #filePath,
  line: UInt = #line,
  environment: [String: String] = [:]
) throws -> String {
  #if os(Windows)
    throw XCTSkip("Unsupported on this platform")
  #endif

  let executableName = command[0]
  let arguments = Array(command.dropFirst())

  // Find executable in build directory
  let buildDir = Bundle.module.bundleURL
    .deletingLastPathComponent()
    .appendingPathComponent("\(executableName)")

  guard FileManager.default.fileExists(atPath: buildDir.path) else {
    Issue.record("No executable at '\(buildDir.path)'")
    return ""
  }

  let process = Process()
  process.executableURL = buildDir
  process.arguments = arguments

  let outputPipe = Pipe()
  let errorPipe = Pipe()
  process.standardOutput = outputPipe
  process.standardError = errorPipe

  process.environment = ProcessInfo.processInfo.environment
    .merging(environment) { $1 }

  try process.run()
  process.waitUntilExit()

  let outputData = try outputPipe.fileHandleForReading.readToEnd() ?? Data()
  let errorData = try errorPipe.fileHandleForReading.readToEnd() ?? Data()

  let combinedOutput = String(decoding: errorData + outputData, as: UTF8.self)

  if let expectedOutput {
    let expected =
      expectedOutput
      .trimmingCharacters(in: .whitespacesAndNewlines)
    let actual =
      combinedOutput
      .trimmingCharacters(in: .whitespacesAndNewlines)

    #expect(actual == expected)
  }

  #expect(process.terminationStatus == exitCode)

  return combinedOutput
}
