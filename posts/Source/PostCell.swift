import UIKit

final class PostCell: UITableViewCell {
    @IBOutlet var postTitleLabel: UILabel!
    @IBOutlet var favButton: UIButton!
    @IBOutlet var postBodyLabel: UILabel!

    @IBAction func favButtonAction() {
        favButton.isSelected.toggle()
    }
}
