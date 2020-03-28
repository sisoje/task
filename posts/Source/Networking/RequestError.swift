import Foundation

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
