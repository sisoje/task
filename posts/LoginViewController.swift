import UIKit

typealias LoginResult = Result<[Post], Error>

class LoginViewController: UIViewController {
    @IBOutlet var textFieldUserId: UITextField!

    let loginViewModel = LoginViewModel(restApi: .shared)

    override func viewDidLoad() {
        super.viewDidLoad()
    }

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
        print(posts)
    }

    private func handleResult(_ result: LoginResult) {
        do {
            handlePosts(try result.get())
        } catch {
            handleError(error)
        }
    }
}
