import Foundation

struct Post: Codable, Equatable {
    let id: Int
    let title: String
    let body: String
}
