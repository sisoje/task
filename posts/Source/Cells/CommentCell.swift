import UIKit

class CommentCell: UITableViewCell {
    @IBOutlet var commentBodyLabel: UILabel!
    @IBOutlet var commentEmailLabel: UILabel!
    @IBOutlet var commentNameLabel: UILabel!
}

extension CommentCell {
    func setup(comment: Comment) {
        commentBodyLabel.text = comment.body
        commentNameLabel.text = comment.name
        commentEmailLabel.text = comment.email
    }
}
