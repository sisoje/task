@testable import posts
import XCTest

class LoginInteractorTests: XCTestCase {
    var session: FakeUrlSession!
    var restApi: RestApi!
    var loginViewModel: LoginInteractor!

    override func setUp() {
        session = FakeUrlSession()
        restApi = RestApi(session: session)
        loginViewModel = LoginInteractor(restApi: restApi)
    }

    func testUserId_Empty() {
        [nil, ""].forEach { userId in
            let ex = expectation(description: #function + String(describing: userId))
            loginViewModel.loginWithId(userId) { result in
                do {
                    _ = try result.get()
                } catch {
                    XCTAssert(error is UserIdValidationError)
                    XCTAssertEqual(error.localizedDescription, UserIdValidationError.empty.errorDescription)
                }
                ex.fulfill()
            }
        }
        waitForExpectations(timeout: 0, handler: nil)
    }

    func testUserId_Invalid() {
        let ex = expectation(description: #function)
        loginViewModel.loginWithId("NAN") { result in
            do {
                _ = try result.get()
            } catch {
                XCTAssert(error is UserIdValidationError)
                XCTAssertEqual(error.localizedDescription, UserIdValidationError.invalid.errorDescription)
            }
            ex.fulfill()
        }
        waitForExpectations(timeout: 0, handler: nil)
    }

    func testUserId_Ok() {
        let ex = expectation(description: #function)
        loginViewModel.loginWithId(String(TestConstants.anyId)) { result in
            do {
                let posts = try result.get()
                XCTAssertEqual(posts, TestConstants.anyPostsArray)
            } catch {
                XCTFail("should not fail")
            }
            ex.fulfill()
        }
        session.capturedCompletion(TestConstants.anyPostArrayData, TestConstants.makeHttpResponse(200), nil)
        waitForExpectations(timeout: 0, handler: nil)
    }

    func testUserId_Error() {
        var result: Result<[Post], Error>!
        loginViewModel.loginWithId(String(TestConstants.anyId)) { result = $0 }
        session.capturedCompletion(TestConstants.anyPostArrayData, TestConstants.makeHttpResponse(403), nil)
        XCTAssertNotNil(result)
        do {
            _ = try result.get()
            XCTFail("should not fail")
        } catch {}
    }
}
