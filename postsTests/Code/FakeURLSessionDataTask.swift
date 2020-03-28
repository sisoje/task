import Foundation

class FakeURLSessionDataTask: URLSessionDataTask {
    override init() {}

    private(set) var resumeWasCalled = false

    override func resume() {
        resumeWasCalled = true
    }
}
