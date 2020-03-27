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
    func testGetRequestDataInvalidRequest() {
        var result: Result<Data, Error>!
        restApi.requestData(TestConstants.anyRequest) { result = $0 }
        XCTAssertTrue(session.capturedTask.resumeWasCalled)
        session.capturedCompletion(nil, nil, nil)
        XCTAssertNotNil(result)
        do {
            _ = try result.get()
            XCTFail("this should fail")
        } catch {
            XCTAssert(error is RequestError)
        }
    }

    func testGetRequestDataRequestError() {
        var result: Result<Data, Error>!
        restApi.requestData(TestConstants.anyRequest) { result = $0 }
        XCTAssertTrue(session.capturedTask.resumeWasCalled)
        session.capturedCompletion(nil, nil, TestConstants.anyError)
        XCTAssertNotNil(result)
        do {
            _ = try result.get()
            XCTFail("this should fail")
        } catch {
            XCTAssertEqual(TestConstants.anyError, error as NSError)
        }
    }

    func testGetRequestDataCancel() {
        var result: Result<Data, Error>!
        restApi.requestData(TestConstants.anyRequest) { result = $0 }
        XCTAssertTrue(session.capturedTask.resumeWasCalled)
        session.capturedCompletion(nil, nil, TestConstants.cancelationError)
        XCTAssertNil(result)
    }

    func testGetRequestDataOk() {
        var result: Result<Data, Error>!
        restApi.requestData(TestConstants.anyRequest) { result = $0 }
        XCTAssertTrue(session.capturedTask.resumeWasCalled)
        session.capturedCompletion(TestConstants.anyData, TestConstants.anyHttpResponse200, nil)
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
    func testGetPostsOk() {
        var result: Result<[Post], Error>!
        restApi.getPosts(userId: TestConstants.anyUserId) { result = $0 }
        XCTAssertEqual(session.capturedRequest.httpMethod, "GET")
        XCTAssertEqual(session.capturedRequest.url?.absoluteString, "https://jsonplaceholder.typicode.com/posts?userId=\(TestConstants.anyUserId)")
        XCTAssertTrue(session.capturedTask.resumeWasCalled)
        session.capturedCompletion(TestConstants.anyPostArrayData, TestConstants.anyHttpResponse200, nil)
        XCTAssertNotNil(result)
        do {
            let posts = try result.get()
            XCTAssertEqual(posts, TestConstants.anyPostsArray)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testGetPostsBadData() {
        var result: Result<[Post], Error>!
        restApi.getPosts(userId: TestConstants.anyUserId) { result = $0 }
        XCTAssertEqual(session.capturedRequest.httpMethod, "GET")
        XCTAssertEqual(session.capturedRequest.url?.absoluteString, "https://jsonplaceholder.typicode.com/posts?userId=\(TestConstants.anyUserId)")
        XCTAssertTrue(session.capturedTask.resumeWasCalled)
        session.capturedCompletion(TestConstants.anyData, TestConstants.anyHttpResponse200, nil)
        XCTAssertNotNil(result)
        do {
            _ = try result.get()
            XCTFail("this should fail")
        } catch {
            XCTAssert(error is DecodingError)
        }
    }
}
