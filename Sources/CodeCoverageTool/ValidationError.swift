import Foundation

internal enum ValidationError: Error, LocalizedError {
  case thresholdNotMet(current: Double, required: Double)
  case invalidInput(String)

  var errorDescription: String? {
    switch self {
    case .thresholdNotMet(let current, let required):
      return "Coverage below threshold: \(current)% < \(required)%"
    case .invalidInput(let message):
      return message
    }
  }
}
