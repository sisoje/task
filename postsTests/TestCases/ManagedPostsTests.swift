@testable import posts
import XCTest

class ManagedPostsTests: XCTestCase {
    var managedPosts: ManagedPosts!

    override func setUp() {
        managedPosts = ManagedPosts(posts: TestConstants.anyPostsArray)
    }

    func testToggle() {
        XCTAssertEqual(managedPosts.favPosts, [])
        managedPosts.allPosts.forEach { $0.isFavorite.toggle() }
        XCTAssertEqual(managedPosts.favPosts, managedPosts.allPosts)
        managedPosts.allPosts.forEach { $0.isFavorite.toggle() }
        XCTAssertEqual(managedPosts.favPosts, [])
    }

    func testDiff() {
        XCTAssertEqual(managedPosts.calcDiff(), [0, 1])
        managedPosts.allPosts.forEach { $0.isFavorite.toggle() }
        XCTAssertEqual(managedPosts.calcDiff(), [])
        managedPosts.allPosts.forEach { $0.isFavorite.toggle() }
        XCTAssertEqual(managedPosts.calcDiff(), [0, 1])
    }
}
