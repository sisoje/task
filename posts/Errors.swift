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
                return "ID can not be empty"
            case .invalid:
                return "ID has to be a number"
        }
    }
}
