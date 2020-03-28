import Foundation

typealias DataTaskCompletionType = (Data?, URLResponse?, Error?) -> Void

class FakeUrlSession: URLSession {
    override init() {}

    private(set) var capturedTask: FakeURLSessionDataTask!
    private(set) var capturedRequest: URLRequest!
    private(set) var capturedCompletion: DataTaskCompletionType!

    override func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskCompletionType) -> URLSessionDataTask {
        capturedTask = FakeURLSessionDataTask()
        capturedRequest = request
        capturedCompletion = completionHandler
        return capturedTask
    }
}
