import UIKit

final class CommentsViewModel {
    let restApi: RestApi
    let favoitedPost: FavoritablePost
    private(set) var comments: [Comment] = []

    init(restApi: RestApi, favoitedPost: FavoritablePost) {
        self.restApi = restApi
        self.favoitedPost = favoitedPost
    }

    func getComments(_ completion: @escaping (Error?) -> Void) {
        restApi.getComments(postId: favoitedPost.post.id) { [weak self] result in
            self?.handleCommentsResult(result, completion)
        }
    }

    private func handleCommentsResult(_ result: Result<[Comment], Error>, _ completion: @escaping (Error?) -> Void) {
        do {
            comments = try result.get()
            completion(nil)
        } catch {
            completion(error)
        }
    }
}

class CommentsViewController: UITableViewController {
    var viewModel: CommentsViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: "CommentCell")
        tableView.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "PostCell")

        viewModel.getComments { [weak self] error in
            self?.handleError(error)
        }
    }

    private func handleError(_ error: Error?) {
        guard let error = error else {
            tableView.reloadSections(IndexSet([1]), with: .automatic)
            return
        }
        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: .cancel,
                handler: nil
            )
        )
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Table view stuff

extension CommentsViewController {
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "Post" : "Comments"
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? 1 : viewModel.comments.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
            cell.setup(favoritablePost: viewModel.favoitedPost)
            return cell
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
        let comment = viewModel.comments[indexPath.row]
        cell.setup(comment: comment)
        return cell
    }
}
