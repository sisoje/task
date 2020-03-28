import UIKit

final class PostCellViewModel {
    private var observer: Any!
    let favoritablePost: FavoritablePost

    var favChanged: ((Bool) -> Void)?

    init(favoritablePost: FavoritablePost) {
        self.favoritablePost = favoritablePost
        self.observer = favoritablePost.observe(\.isFavorite) { [weak self] fp, _ in
            self?.favChanged?(fp.isFavorite)
        }
    }
}

final class PostCell: UITableViewCell {
    @IBOutlet var postTitleLabel: UILabel!
    @IBOutlet var favButton: UIButton!
    @IBOutlet var postBodyLabel: UILabel!

    @IBAction func favButtonAction() {
        viewModel.favoritablePost.isFavorite.toggle()
    }

    override func prepareForReuse() {
        viewModel = nil
    }

    private var viewModel: PostCellViewModel!

    func setup(favoritablePost: FavoritablePost) {
        postTitleLabel.text = favoritablePost.post.title
        postBodyLabel.text = favoritablePost.post.body
        favButton.isSelected = favoritablePost.isFavorite
        viewModel = PostCellViewModel(favoritablePost: favoritablePost)
        viewModel.favChanged = { [weak self] sel in
            self?.favButton.isSelected = sel
        }
    }
}
