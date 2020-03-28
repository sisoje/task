import Foundation

final class PostCellViewModel {
    private var observer: Any?
    private let favoritablePost: FavoritablePost

    var favChanged: ((Bool) -> Void)?

    init(favoritablePost: FavoritablePost) {
        self.favoritablePost = favoritablePost
        self.observer = favoritablePost.observe(\.isFavorite) { [weak self] favoritablePost, _ in
            self?.favChanged?(favoritablePost.isFavorite)
        }
    }
}

extension PostCellViewModel {
    func toggleFavorite() {
        favoritablePost.isFavorite.toggle()
    }
}
