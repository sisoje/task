@testable import posts
import XCTest

class CommentsViewModelTests: XCTestCase {
    var session: FakeUrlSession!
    var restApi: RestApi!
    var viewModel: CommentsViewModel!
    var favoritablePost: FavoritablePost!

    override func setUp() {
        session = FakeUrlSession()
        restApi = RestApi(session: session)
        favoritablePost = FavoritablePost(TestConstants.anyPostsArray[0])
        viewModel = CommentsViewModel(restApi: restApi, favoitedPost: favoritablePost)
    }

    func testViewModel() {
        let ex = expectation(description: #function)
        viewModel.getComments { error in
            XCTAssertNil(error)
            ex.fulfill()
        }
        session.capturedCompletion(TestConstants.anyCommentsArrayData, TestConstants.makeHttpResponse(200), nil)
        waitForExpectations(timeout: 0, handler: nil)
        XCTAssertEqual(viewModel.comments, TestConstants.anyCommentsArray)
    }
}
