import Foundation

enum PostErrors: Error {
    case idEmpty
    case idNotValid
}

struct RequestError: LocalizedError {
    var errorDescription: String? {
        "error with URL request"
    }
}

extension PostErrors: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .idEmpty:
                return "ID can not be empty"
            case .idNotValid:
                return "ID has to be a number"
        }
    }
}
