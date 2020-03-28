import Foundation

final class CommentsViewModel {
    let restApi: RestApi
    let favoitedPost: FavoritablePost
    private(set) var comments: [Comment] = []

    private var task: URLSessionDataTask? {
        didSet {
            oldValue?.cancel()
        }
    }

    init(restApi: RestApi, favoitedPost: FavoritablePost) {
        self.restApi = restApi
        self.favoitedPost = favoitedPost
    }

    func getComments(_ completion: @escaping (Error?) -> Void) {
        task = restApi.getComments(postId: favoitedPost.post.id) { [weak self] result in
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

    deinit {
        task?.cancel()
    }
}
