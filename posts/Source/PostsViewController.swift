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
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostCell
        cell.setup(favoritablePost: viewModel[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
