import UIKit

final class FavoritablePost: NSObject {
    let post: Post
    @objc dynamic var isFavorite: Bool

    init(_ post: Post) {
        self.post = post
        self.isFavorite = false
    }
}

extension FavoritablePost: Comparable {
    static func < (lhs: FavoritablePost, rhs: FavoritablePost) -> Bool {
        lhs.post.id < rhs.post.id
    }

    static func == (lhs: FavoritablePost, rhs: FavoritablePost) -> Bool {
        lhs.post.id == rhs.post.id
    }
}

final class ManagedPosts: NSObject {
    private var observers: Any!

    let allPosts: [FavoritablePost]
    var favPosts: [FavoritablePost] = []

    @objc dynamic var favInserted = 0
    @objc dynamic var favRemoved = 0

    init(posts: [Post]) {
        self.allPosts = posts.map { FavoritablePost($0) }.sorted()
        super.init()
        self.observers = allPosts.map { post in
            post.observe(\.isFavorite) { [weak self] post, _ in
                self?.onToggle(post)
            }
        }
    }

    private func onToggle(_ post: FavoritablePost) {
        if post.isFavorite {
            favInserted = favPosts.insertSorted(post)
        } else {
            favRemoved = favPosts.removeSorted(post)
        }
    }
}

final class PostsViewModel {
    private var observers: Any!
    private let managedPosts: ManagedPosts

    private(set) var filterActive = false

    func toggleFilter() {
        filterActive.toggle()
        let set = Set(managedPosts.favPosts)
        var diff: [Int] = []
        managedPosts.allPosts.enumerated().forEach { index, post in
            if !set.contains(post) {
                diff.append(index)
            }
        }
        if filterActive {
            addRemove?([], diff)
        } else {
            addRemove?(diff, [])
        }
    }

    var addRemove: (([Int], [Int]) -> Void)?

    private func onFilteredAddRemove(added: [Int], removed: [Int]) {
        if filterActive {
            addRemove?(added, removed)
        }
    }

    init(managedPosts: ManagedPosts) {
        self.managedPosts = managedPosts
        self.observers = [
            managedPosts.observe(\.favRemoved) { [weak self] mp, _ in
                self?.onFilteredAddRemove(added: [], removed: [mp.favRemoved])
            },
            managedPosts.observe(\.favInserted) { [weak self] mp, _ in
                self?.onFilteredAddRemove(added: [mp.favInserted], removed: [])
            }
        ]
    }

    subscript(_ index: Int) -> FavoritablePost {
        filterActive ? managedPosts.favPosts[index] : managedPosts.allPosts[index]
    }

    var count: Int {
        filterActive ? managedPosts.favPosts.count : managedPosts.allPosts.count
    }
}

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
        viewModel.addRemove = { [weak tableView] added, removed in
            tableView?.performBatchUpdates(
                {
                    tableView?.deleteRows(at: removed.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                    tableView?.insertRows(at: added.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                }
            )
        }
    }
}

// MARK: - tableviewstuff

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
