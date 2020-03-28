import UIKit

final class PostCell: UITableViewCell {
    @IBOutlet var postTitleLabel: UILabel!
    @IBOutlet var favButton: UIButton!
    @IBOutlet var postBodyLabel: UILabel!

    private var viewModel: PostCellViewModel!

    @IBAction func favButtonAction() {
        viewModel.toggleFavorite()
    }

    override func prepareForReuse() {
        viewModel = nil
    }
}

extension PostCell {
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
