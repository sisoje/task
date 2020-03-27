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
        var result: Result<Data, Error>!
        restApi.requestData(TestConstants.anyRequest) { result = $0 }
        XCTAssertTrue(session.capturedTask.resumeWasCalled)
        session.capturedCompletion(TestConstants.anyData, TestConstants.makeHttpResponse(403), nil)
        XCTAssertNotNil(result)
        do {
            _ = try result.get()
            XCTFail("this should fail")
        } catch {
            XCTAssert(error is RequestError)
            XCTAssertEqual(error.localizedDescription, RequestError(request: session.capturedRequest, data: nil, response: nil).errorDescription)
        }
    }

    func testGetRequestDataRequest_Error() {
        var result: Result<Data, Error>!
        restApi.requestData(TestConstants.anyRequest) { result = $0 }
        XCTAssertTrue(session.capturedTask.resumeWasCalled)
        session.capturedCompletion(TestConstants.anyData, TestConstants.makeHttpResponse(200), TestConstants.anyError)
        XCTAssertNotNil(result)
        do {
            _ = try result.get()
            XCTFail("this should fail")
        } catch {
            XCTAssertEqual(TestConstants.anyError, error as NSError)
        }
    }

    func testGetRequestData_Cancel() {
        var result: Result<Data, Error>!
        restApi.requestData(TestConstants.anyRequest) { result = $0 }
        XCTAssertTrue(session.capturedTask.resumeWasCalled)
        session.capturedCompletion(TestConstants.anyData, TestConstants.makeHttpResponse(200), TestConstants.cancelationError)
        XCTAssertNil(result)
    }

    func testGetRequestData_Ok() {
        var result: Result<Data, Error>!
        restApi.requestData(TestConstants.anyRequest) { result = $0 }
        XCTAssertTrue(session.capturedTask.resumeWasCalled)
        session.capturedCompletion(TestConstants.anyData, TestConstants.makeHttpResponse(200), nil)
        XCTAssertNotNil(result)
        do {
            let data = try result.get()
            XCTAssertEqual(data, TestConstants.anyData)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}

// MARK: - getPosts() tests

extension RestApiTests {
    func testGetPosts_Ok() {
        var result: Result<[Post], Error>!
        restApi.getPosts(userId: TestConstants.anyUserId) { result = $0 }
        XCTAssertEqual(session.capturedRequest.httpMethod, "GET")
        XCTAssertEqual(session.capturedRequest.url?.absoluteString, "https://jsonplaceholder.typicode.com/posts?userId=\(TestConstants.anyUserId)")
        XCTAssertTrue(session.capturedTask.resumeWasCalled)
        session.capturedCompletion(TestConstants.anyPostArrayData, TestConstants.makeHttpResponse(200), nil)
        XCTAssertNotNil(result)
        do {
            let posts = try result.get()
            XCTAssertEqual(posts, TestConstants.anyPostsArray)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testGetPosts_BadData() {
        var result: Result<[Post], Error>!
        restApi.getPosts(userId: TestConstants.anyUserId) { result = $0 }
        XCTAssertEqual(session.capturedRequest.httpMethod, "GET")
        XCTAssertEqual(session.capturedRequest.url?.absoluteString, "https://jsonplaceholder.typicode.com/posts?userId=\(TestConstants.anyUserId)")
        XCTAssertTrue(session.capturedTask.resumeWasCalled)
        session.capturedCompletion(TestConstants.anyData, TestConstants.makeHttpResponse(200), nil)
        XCTAssertNotNil(result)
        do {
            _ = try result.get()
            XCTFail("this should fail")
        } catch {
            XCTAssert(error is DecodingError)
        }
    }
}
