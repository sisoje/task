import Foundation

final class PostsViewModel {
    private var observers: Any?
    private let managedPosts: ManagedPosts

    private(set) var filterActive = false

    var addRemoveBlock: (([Int], [Int]) -> Void)?

    init(managedPosts: ManagedPosts) {
        self.managedPosts = managedPosts
        managedPosts.favoriteChanged = { [weak self] index, isFavorite in
            self?.onToggleFavorite(index: index, isFavorite: isFavorite)
        }
    }
}

extension PostsViewModel {
    convenience init(posts: [Post]) {
        self.init(managedPosts: ManagedPosts(posts: posts))
    }

    func toggleFilter() {
        filterActive.toggle()
        let diff = managedPosts.calcDiff()
        if filterActive {
            addRemoveBlock?([], diff)
        } else {
            addRemoveBlock?(diff, [])
        }
    }

    private func onToggleFavorite(index: Int, isFavorite: Bool) {
        if filterActive {
            let added = isFavorite ? [index] : []
            let removed = isFavorite ? [] : [index]
            addRemoveBlock?(added, removed)
        }
    }

    subscript(_ index: Int) -> FavoritablePost {
        filterActive ? managedPosts.favPosts[index] : managedPosts.allPosts[index]
    }

    var count: Int {
        filterActive ? managedPosts.favPosts.count : managedPosts.allPosts.count
    }
}
