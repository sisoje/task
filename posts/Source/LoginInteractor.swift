import Foundation

struct LoginInteractor {
    let restApi: RestApi

    func loginWithId(_ textId: String?, _ completion: @escaping (Result<[Post], Error>) -> Void) {
        guard let textId = textId, !textId.isEmpty else {
            completion(.failure(UserIdValidationError.empty))
            return
        }

        guard let id = Int(textId) else {
            completion(.failure(UserIdValidationError.invalid))
            return
        }

        restApi.getPosts(userId: id, completion)
    }
}
