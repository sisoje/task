import Foundation

final class ManagedPosts {
    private var observers: Any?

    let allPosts: [FavoritablePost]
    private(set) var favPosts: [FavoritablePost]

    var favoriteChanged: ((Int, Bool) -> Void)?

    init(favoritablePosts: [FavoritablePost]) {
        self.allPosts = favoritablePosts.sorted()
        self.favPosts = allPosts.filter { $0.isFavorite }
        addToggleFavoriteObservers()
    }
}

extension ManagedPosts {
    convenience init(posts: [Post]) {
        self.init(favoritablePosts: posts.map { FavoritablePost($0) })
    }

    private func addToggleFavoriteObservers() {
        observers = allPosts.map { post in
            post.observe(\.isFavorite) { [weak self] post, _ in
                self?.onToggle(post)
            }
        }
    }

    private func onToggle(_ post: FavoritablePost) {
        let index = post.isFavorite ? favPosts.insertSorted(post) : favPosts.removeSorted(post)
        favoriteChanged?(index, post.isFavorite)
    }

    func calcDiff() -> [Int] {
        let set = Set(favPosts)
        var diff: [Int] = []
        allPosts.enumerated().forEach { index, post in
            if !set.contains(post) {
                diff.append(index)
            }
        }
        return diff
    }
}
