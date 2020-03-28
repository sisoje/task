import UIKit

final class LoginViewController: UIViewController {
    var loginInteractor: LoginInteractor!

    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet var textFieldUserId: UITextField!

    @IBAction func actionLogin(_ sender: UIButton) {
        sender.isEnabled = false
        activityIndicatorView.startAnimating()
        loginInteractor.loginWithId(textFieldUserId.text) { [weak self] result in
            sender.isEnabled = true
            self?.activityIndicatorView.stopAnimating()
            self?.handleResult(result)
        }
    }
}

// MARK: - result handling

extension LoginViewController {
    private func handleResult(_ result: Result<[Post], Error>) {
        do {
            let posts = try result.get()
            let navigationController = UIStoryboard(name: "Posts", bundle: nil).instantiateInitialViewController() as! UINavigationController
            let postsViewController = navigationController.viewControllers[0] as! PostsViewController
            postsViewController.viewModel = PostsViewModel(posts: posts)
            SceneDelegate.shared.window?.rootViewController = navigationController
        } catch {
            presentError(error)
        }
    }
}
