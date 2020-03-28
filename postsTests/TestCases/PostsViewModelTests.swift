@testable import posts
import XCTest

class PostsViewModelTests: XCTestCase {
    var postsViewModel: PostsViewModel!

    override func setUp() {
        postsViewModel = PostsViewModel(posts: TestConstants.anyPostsArray)
    }

    func testToggleOneWithoutFilter() {
        postsViewModel.addRemoveBlock = { _, _ in
            XCTFail()
        }
        postsViewModel[0].isFavorite.toggle()
    }

    func testToggleOneWithFilter() {
        let ex = expectation(description: "toggle one")
        postsViewModel[0].isFavorite.toggle()
        postsViewModel.toggleFilter()
        postsViewModel.addRemoveBlock = { added, removed in
            XCTAssertEqual(added, [])
            XCTAssertEqual(removed, [0])
            ex.fulfill()
        }
        postsViewModel[0].isFavorite.toggle()
        waitForExpectations(timeout: 0, handler: nil)
    }

    func testToggleFilter() {
        let exFav = expectation(description: "filter toggle fav")
        let exAll = expectation(description: "filter toggle all")

        XCTAssertEqual(postsViewModel.count, 2)
        postsViewModel.addRemoveBlock = { added, removed in
            XCTAssertEqual(added, [])
            XCTAssertEqual(removed, [0, 1])
            exFav.fulfill()
        }
        postsViewModel.toggleFilter()
        XCTAssertEqual(postsViewModel.count, 0)
        postsViewModel.addRemoveBlock = { added, removed in
            XCTAssertEqual(added, [0, 1])
            XCTAssertEqual(removed, [])
            exAll.fulfill()
        }
        postsViewModel.toggleFilter()
        XCTAssertEqual(postsViewModel.count, 2)

        waitForExpectations(timeout: 0, handler: nil)
    }
}
