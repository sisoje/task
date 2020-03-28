import Foundation
@testable import posts

enum TestConstants {
    static let anyUserId = 1
    static let anyString = UUID().uuidString
    static let anyUrl = URL(fileURLWithPath: anyString)
    static let anyRequest = URLRequest(url: anyUrl)
    static let anyError = NSError(domain: anyString, code: 0, userInfo: nil)
    static let cancelationError = NSError(domain: NSURLErrorDomain, code: NSURLErrorCancelled, userInfo: nil)
    static let anyData = Data(repeating: 1, count: 1)
    static func makeHttpResponse(_ code: Int) -> HTTPURLResponse {
        HTTPURLResponse(url: anyUrl, statusCode: code, httpVersion: nil, headerFields: nil)!
    }

    static let anyPostArrayData = """
    [{
      "id": 1,
      "title": "title1",
      "body": "body1"
    },
    {
      "id": 2,
      "title": "title2",
      "body": "body2"
    }]
    """.data(using: .utf8)!
    static let anyPostsArray = try! JSONDecoder().decode([Post].self, from: anyPostArrayData)
}
