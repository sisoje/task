import Foundation

enum UserIdValidationError: Error {
    case empty
    case invalid
}

extension UserIdValidationError: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .empty:
                return "Please enter ID"
            case .invalid:
                return "Invalid ID, it needs to be an number"
        }
    }
}
