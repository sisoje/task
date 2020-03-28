@testable import posts
import XCTest

class PostCellViewModelTests: XCTestCase {
    var postCellViewModel: PostCellViewModel!

    override func setUp() {
        postCellViewModel = PostCellViewModel(favoritablePost: FavoritablePost(TestConstants.anyPostsArray[0]))
    }

    func testToggle() {
        let ex = expectation(description: "toggle")
        postCellViewModel.favChanged = { isFavorite in
            XCTAssertTrue(isFavorite)
            ex.fulfill()
        }
        postCellViewModel.toggleFavorite()
        waitForExpectations(timeout: 0, handler: nil)
    }
}
