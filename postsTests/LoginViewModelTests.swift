@testable import posts
import XCTest

class LoginViewModelTests: XCTestCase {
    var session: FakeUrlSession!
    var restApi: RestApi!
    var loginViewModel: LoginViewModel!

    override func setUp() {
        session = FakeUrlSession()
        restApi = RestApi(session: session)
        loginViewModel = LoginViewModel(restApi: restApi)
    }

    func testUserId_Empty() {
        [nil, ""].forEach { userId in
            var result: Result<[Post], Error>!
            loginViewModel.loginWithId(userId) { result = $0 }
            XCTAssertNotNil(result)
            do {
                _ = try result.get()
            } catch {
                XCTAssert(error is UserIdValidationError)
                XCTAssertEqual(error.localizedDescription, UserIdValidationError.empty.errorDescription)
            }
        }
    }

    func testUserId_Invalid() {
        var result: Result<[Post], Error>!
        loginViewModel.loginWithId("NAN") { result = $0 }
        XCTAssertNotNil(result)
        do {
            _ = try result.get()
        } catch {
            XCTAssert(error is UserIdValidationError)
            XCTAssertEqual(error.localizedDescription, UserIdValidationError.invalid.errorDescription)
        }
    }

    func testUserId_Ok() {
        var result: Result<[Post], Error>!
        loginViewModel.loginWithId(String(TestConstants.anyUserId)) { result = $0 }
        session.capturedCompletion(TestConstants.anyPostArrayData, TestConstants.makeHttpResponse(200), nil)
        XCTAssertNotNil(result)
        do {
            let posts = try result.get()
            XCTAssertEqual(posts, TestConstants.anyPostsArray)
        } catch {
            XCTFail("should not fail")
        }
    }

    func testUserId_Error() {
        var result: Result<[Post], Error>!
        loginViewModel.loginWithId(String(TestConstants.anyUserId)) { result = $0 }
        session.capturedCompletion(TestConstants.anyPostArrayData, TestConstants.makeHttpResponse(403), nil)
        XCTAssertNotNil(result)
        do {
            _ = try result.get()
            XCTFail("should not fail")
        } catch {}
    }
}
