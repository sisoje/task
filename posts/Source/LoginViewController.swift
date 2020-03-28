import UIKit

final class LoginViewController: UIViewController {
    var loginViewModel: LoginViewModel!

    @IBOutlet var textFieldUserId: UITextField!

    @IBAction func actionLogin(_ sender: UIButton) {
        sender.isEnabled = false
        loginViewModel.loginWithId(textFieldUserId.text) { [weak self] result in
            sender.isEnabled = true
            self?.handleResult(result)
        }
    }
}

// MARK: - result handling

extension LoginViewController {
    private func handleError(_ error: Error) {
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

    private func handlePosts(_ posts: [Post]) {
        let navigationController = UIStoryboard(name: "Posts", bundle: nil).instantiateInitialViewController() as! UINavigationController
        let postsViewController = navigationController.viewControllers[0] as! PostsViewController
        postsViewController.viewModel = PostsViewModel(posts: posts)
        SceneDelegate.shared.window?.rootViewController = navigationController
    }

    private func handleResult(_ result: Result<[Post], Error>) {
        do {
            handlePosts(try result.get())
        } catch {
            handleError(error)
        }
    }
}
