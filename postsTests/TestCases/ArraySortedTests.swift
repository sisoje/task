@testable import posts
import XCTest

class ArraySortedTests: XCTestCase {
    func testLowerBound() {
        let arr = [0, 2]
        XCTAssertEqual(arr.lowerBound(of: -1), 0)
        XCTAssertEqual(arr.lowerBound(of: 0), 0)
        XCTAssertEqual(arr.lowerBound(of: 1), 1)
        XCTAssertEqual(arr.lowerBound(of: 2), 1)
        XCTAssertEqual(arr.lowerBound(of: 3), 2)
    }

    func testInsert() {
        var arr = [0, 2]
        arr.insertSorted(1)
        XCTAssertEqual(arr, [0, 1, 2])
    }

    func testRemove() {
        var arr = [0, 1, 2]
        arr.removeSorted(1)
        XCTAssertEqual(arr, [0, 2])
    }
}
