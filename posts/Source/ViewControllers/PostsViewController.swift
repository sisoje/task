import UIKit

final class PostsViewController: UITableViewController {
    var viewModel: PostsViewModel!

    @IBOutlet var favItem: UIBarButtonItem!
    @IBOutlet var allItem: UIBarButtonItem!

    @IBAction func filterAllAction() {
        [favItem, allItem].forEach { $0?.isEnabled.toggle() }
        viewModel.toggleFilter()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "PostCell")
        allItem.isEnabled = viewModel.filterActive
        favItem.isEnabled = !viewModel.filterActive
        viewModel.addRemoveBlock = { [weak tableView] added, removed in
            tableView?.performBatchUpdates(
                {
                    tableView?.deleteRows(at: removed.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                    tableView?.insertRows(at: added.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                }
            )
        }
    }
}

// MARK: - tableview stuff

extension PostsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        let post = viewModel[indexPath.row]
        cell.setup(favoritablePost: post)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let post = viewModel[indexPath.row]
        let commentsViewController = UIStoryboard(name: "Comments", bundle: nil).instantiateInitialViewController() as! CommentsViewController
        commentsViewController.favoitedPost = post
        navigationController?.pushViewController(commentsViewController, animated: true)
    }
}
