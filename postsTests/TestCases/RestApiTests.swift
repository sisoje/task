@testable import posts
import XCTest

class RestApiTests: XCTestCase {
    var session: FakeUrlSession!
    var restApi: RestApi!

    override func setUp() {
        session = FakeUrlSession()
        restApi = RestApi(session: session)
    }
}

// MARK: - requestData() tests

extension RestApiTests {
    func testGetRequestData_Forbidden() {
        let ex = expectation(description: #function)
        restApi.requestData(TestConstants.anyRequest) { result in
            do {
                _ = try result.get()
                XCTFail("this should fail")
            } catch {
                XCTAssert(error is RequestError)
                XCTAssertEqual(error.localizedDescription, RequestError(request: self.session.capturedRequest, data: nil, response: nil).errorDescription)
            }
            ex.fulfill()
        }
        XCTAssertTrue(session.capturedTask.resumeWasCalled)
        session.capturedCompletion(TestConstants.anyData, TestConstants.makeHttpResponse(403), nil)
        waitForExpectations(timeout: 0, handler: nil)
    }

    func testGetRequestDataRequest_Error() {
        let ex = expectation(description: #function)
        restApi.requestData(TestConstants.anyRequest) { result in
            do {
                _ = try result.get()
                XCTFail("this should fail")
            } catch {
                XCTAssertEqual(TestConstants.anyError, error as NSError)
            }
            ex.fulfill()
        }
        XCTAssertTrue(session.capturedTask.resumeWasCalled)
        session.capturedCompletion(TestConstants.anyData, TestConstants.makeHttpResponse(200), TestConstants.anyError)
        waitForExpectations(timeout: 0, handler: nil)
    }

    func testGetRequestData_Cancel() {
        var result: Result<Data, Error>!
        restApi.requestData(TestConstants.anyRequest) { result = $0 }
        XCTAssertTrue(session.capturedTask.resumeWasCalled)
        session.capturedCompletion(TestConstants.anyData, TestConstants.makeHttpResponse(200), TestConstants.cancelationError)
        XCTAssertNil(result)
    }

    func testGetRequestData_Ok() {
        let ex = expectation(description: #function)
        restApi.requestData(TestConstants.anyRequest) { result in
            do {
                let data = try result.get()
                XCTAssertEqual(data, TestConstants.anyData)
            } catch {
                XCTFail(error.localizedDescription)
            }
            ex.fulfill()
        }
        XCTAssertTrue(session.capturedTask.resumeWasCalled)
        session.capturedCompletion(TestConstants.anyData, TestConstants.makeHttpResponse(200), nil)
        waitForExpectations(timeout: 0, handler: nil)
    }
}

// MARK: - getPosts() tests

extension RestApiTests {
    func testGetPosts_Ok() {
        let ex = expectation(description: #function)
        restApi.getPosts(userId: TestConstants.anyId) { result in
            do {
                let posts = try result.get()
                XCTAssertEqual(posts, TestConstants.anyPostsArray)
            } catch {
                XCTFail(error.localizedDescription)
            }
            ex.fulfill()
        }
        XCTAssertEqual(session.capturedRequest.httpMethod, "GET")
        XCTAssertEqual(session.capturedRequest.url?.absoluteString, "https://jsonplaceholder.typicode.com/posts?userId=\(TestConstants.anyId)")
        XCTAssertTrue(session.capturedTask.resumeWasCalled)
        session.capturedCompletion(TestConstants.anyPostArrayData, TestConstants.makeHttpResponse(200), nil)
        waitForExpectations(timeout: 0, handler: nil)
    }

    func testGetPosts_BadData() {
        let ex = expectation(description: #function)
        restApi.getPosts(userId: TestConstants.anyId) { result in
            do {
                _ = try result.get()
                XCTFail("this should fail")
            } catch {
                XCTAssert(error is DecodingError)
            }
            ex.fulfill()
        }
        XCTAssertEqual(session.capturedRequest.httpMethod, "GET")
        XCTAssertEqual(session.capturedRequest.url?.absoluteString, "https://jsonplaceholder.typicode.com/posts?userId=\(TestConstants.anyId)")
        XCTAssertTrue(session.capturedTask.resumeWasCalled)
        session.capturedCompletion(TestConstants.anyData, TestConstants.makeHttpResponse(200), nil)
        waitForExpectations(timeout: 0, handler: nil)
    }
}

// MARK: - getComments() tests

extension RestApiTests {
    func testGetComments_Ok() {
        let ex = expectation(description: #function)
        restApi.getComments(postId: TestConstants.anyId) { result in
            do {
                let comments = try result.get()
                XCTAssertEqual(comments, TestConstants.anyCommentsArray)
            } catch {
                XCTFail(error.localizedDescription)
            }
            ex.fulfill()
        }
        XCTAssertEqual(session.capturedRequest.httpMethod, "GET")
        XCTAssertEqual(session.capturedRequest.url?.absoluteString, "https://jsonplaceholder.typicode.com/comments?postId=\(TestConstants.anyId)")
        XCTAssertTrue(session.capturedTask.resumeWasCalled)
        session.capturedCompletion(TestConstants.anyCommentsArrayData, TestConstants.makeHttpResponse(200), nil)
        waitForExpectations(timeout: 0, handler: nil)
    }

    func testGetComments_BadData() {
        let ex = expectation(description: #function)
        restApi.getComments(postId: TestConstants.anyId) { result in
            do {
                _ = try result.get()
                XCTFail("this should fail")
            } catch {
                XCTAssert(error is DecodingError)
            }
            ex.fulfill()
        }
        XCTAssertEqual(session.capturedRequest.httpMethod, "GET")
        XCTAssertEqual(session.capturedRequest.url?.absoluteString, "https://jsonplaceholder.typicode.com/comments?postId=\(TestConstants.anyId)")
        XCTAssertTrue(session.capturedTask.resumeWasCalled)
        session.capturedCompletion(TestConstants.anyData, TestConstants.makeHttpResponse(200), nil)
        waitForExpectations(timeout: 0, handler: nil)
    }
}
