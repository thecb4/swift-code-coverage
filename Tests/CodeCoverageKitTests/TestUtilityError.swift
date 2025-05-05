import Foundation

enum TestUtilityError: LocalizedError {
  case fixtureNotFound(name: String)

  var errorDescription: String? {
    switch self {
    case .fixtureNotFound(let name):
      return "Fixture \(name).json not found in fixtures directory"
    }
  }
}
