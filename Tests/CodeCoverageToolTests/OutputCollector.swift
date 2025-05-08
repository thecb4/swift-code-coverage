import Foundation

actor OutputCollector {
  private var stdoutData = Data()
  private var stderrData = Data()

  func appendStdout(_ data: Data) {
    stdoutData.append(data)
  }

  func appendStderr(_ data: Data) {
    stderrData.append(data)
  }

  func collectOutput() -> (stdout: String, stderr: String) {
    (
      String(data: stdoutData, encoding: .utf8) ?? "",
      String(data: stderrData, encoding: .utf8) ?? ""
    )
  }
}
