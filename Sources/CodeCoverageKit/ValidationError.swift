import Foundation

public enum ValidationError: Error, LocalizedError, Equatable {
  case thresholdNotMet(current: Double, required: Double)
  case invalidInput(String)

  public var errorDescription: String? {
    switch self {
    case .thresholdNotMet(let current, let required):
      return "Coverage below threshold: \(current)% < \(required)%"
    case .invalidInput(let message):
      return message
    }
  }
}
