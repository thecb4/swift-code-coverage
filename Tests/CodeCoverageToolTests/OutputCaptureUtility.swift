import Foundation

//func captureOutput(_ block: () throws -> Void) rethrows -> (stdout: String, stderr: String) {
//  // Save original file descriptors
//  let origStdout = dup(STDOUT_FILENO)
//  let origStderr = dup(STDERR_FILENO)
//  defer {
//    dup2(origStdout, STDOUT_FILENO)
//    dup2(origStderr, STDERR_FILENO)
//    close(origStdout)
//    close(origStderr)
//  }

//  // Create pipes
//  let stdoutPipe = Pipe()
//  let stderrPipe = Pipe()
//  dup2(stdoutPipe.fileHandleForWriting.fileDescriptor, STDOUT_FILENO)
//  dup2(stderrPipe.fileHandleForWriting.fileDescriptor, STDERR_FILENO)

//  // Run the block
//  try block()
//  fflush(stdout)
//  fflush(stderr)

//  // Close the write ends to signal EOF
//  stdoutPipe.fileHandleForWriting.closeFile()
//  stderrPipe.fileHandleForWriting.closeFile()

//  // Synchronously read all output
//  let stdoutData = stdoutPipe.fileHandleForReading.readDataToEndOfFile()
//  let stderrData = stderrPipe.fileHandleForReading.readDataToEndOfFile()

//  let stdoutString = String(data: stdoutData, encoding: .utf8) ?? ""
//  let stderrString = String(data: stderrData, encoding: .utf8) ?? ""
//  return (stdoutString, stderrString)
//}

func captureOutput(_ block: () throws -> Void) async rethrows -> (stdout: String, stderr: String) {
  let collector = OutputCollector()

  // Redirect stdout/stderr to pipes
  let origStdout = dup(STDOUT_FILENO)
  let origStderr = dup(STDERR_FILENO)
  let stdoutPipe = Pipe()
  let stderrPipe = Pipe()
  dup2(stdoutPipe.fileHandleForWriting.fileDescriptor, STDOUT_FILENO)
  dup2(stderrPipe.fileHandleForWriting.fileDescriptor, STDERR_FILENO)

  // Async capture
  try await withThrowingTaskGroup(of: Void.self) { group in
    // In OutputCaptureUtility.swift
    group.addTask {
      let handle = stdoutPipe.fileHandleForReading
      while true {
        let data = handle.availableData
        guard !data.isEmpty else { break }
        await collector.appendStdout(data)
      }
    }

    group.addTask {
      let handle = stderrPipe.fileHandleForReading
      while true {
        let data = handle.availableData
        guard !data.isEmpty else { break }
        await collector.appendStderr(data)
      }
    }

    // Execute the block
    try block()

    // flush
    fflush(stdout)
    fflush(stderr)

    // Close write ends
    stdoutPipe.fileHandleForWriting.closeFile()
    stderrPipe.fileHandleForWriting.closeFile()
  }

  // Restore original descriptors
  dup2(origStdout, STDOUT_FILENO)
  dup2(origStderr, STDERR_FILENO)
  close(origStdout)
  close(origStderr)

  return await collector.collectOutput()
}
