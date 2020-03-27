import UIKit

final class PostsViewController: UITableViewController {
    var posts: [Post]!

    override func viewDidLoad() {}
}

// MARK: - tableviewstuff

extension PostsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)
        return cell
    }
}
