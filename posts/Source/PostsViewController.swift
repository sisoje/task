import UIKit

final class PostsViewController: UITableViewController {
    var posts: [Post]!

    @IBOutlet var favItem: UIBarButtonItem!
    @IBOutlet var allItem: UIBarButtonItem!

    @IBAction func filterAllAction() {
        favItem.isEnabled.toggle()
        allItem.isEnabled.toggle()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        allItem.isEnabled = false
    }
}

// MARK: - tableviewstuff

extension PostsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostCell
        cell.favButton.isSelected = true
        cell.postTitleLabel.text = post.title
        cell.postBodyLabel.text = post.body
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
