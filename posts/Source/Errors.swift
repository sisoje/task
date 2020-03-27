import Foundation

enum UserIdValidationError: Error {
    case empty
    case invalid
}

struct RequestError: Error {
    let request: URLRequest
    let data: Data?
    let response: URLResponse?
}

extension RequestError: LocalizedError {
    var errorDescription: String? {
        "Error with URL request: \(request)"
    }
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
