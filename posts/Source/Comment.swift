import Foundation

struct Comment: Codable, Equatable {
    let id: Int
    let name: String
    let email: String
    let body: String
}
