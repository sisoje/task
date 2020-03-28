import Foundation

final class FavoritablePost: NSObject {
    let post: Post
    @objc dynamic var isFavorite: Bool

    init(_ post: Post) {
        self.post = post
        self.isFavorite = false
    }
}

extension FavoritablePost: Comparable {
    static func < (lhs: FavoritablePost, rhs: FavoritablePost) -> Bool {
        lhs.post.id < rhs.post.id
    }

    static func == (lhs: FavoritablePost, rhs: FavoritablePost) -> Bool {
        lhs.post.id == rhs.post.id
    }
}
