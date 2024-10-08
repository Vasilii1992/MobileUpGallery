
import UIKit
import WebKit

final class MainViewController: UIViewController {
    
// MARK: - UIViews
    let authorizationButton = AuthorizationButton.createAuthorizationButton(title: "Вход через VK")
    let galleryLabel = Label(labelText: "Mobile Up\nGallery", fontSize: 44, weight: .bold)
    
// MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
        
          NetworkMonitor.shared.statusChangeHandler = { [weak self] isConnected in
              if isConnected {
                  print("Internet is connected")
              } else {
                  print("Internet is not connected")
                  DispatchQueue.main.async {
                      self?.showAlert(title: "No Internet Connection", message: "Please check your internet connection and try again.")
                  }
              }
          }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = UserDefaults.standard.string(forKey: "vkAccessToken") {
            goToGalleryViewController(token: token)
        }
    }

    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(galleryLabel)
        view.addSubview(authorizationButton)
        
        authorizationButton.addTarget(self, action: #selector(authorizationButtonTapped), for: .touchUpInside)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            
            galleryLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
            galleryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            galleryLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            authorizationButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -42),
            authorizationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16),
            authorizationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            authorizationButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    private func goToGalleryViewController(token: String) {
        let galleryViewController = GalleryViewController()
        galleryViewController.accessToken = token
        let navigationController = UINavigationController(rootViewController: galleryViewController)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: false, completion: nil)
    }
    
    @objc func authorizationButtonTapped() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            if !NetworkMonitor.shared.isConnected {
                self.showAlert(title: "No Internet Connection", message: "Please check your internet connection and try again.")
                return
            }

            let webViewController = WebViewController(with: UrlComponents.createUrl())
            webViewController.delegate = self
            let navigation = UINavigationController(rootViewController: webViewController)
            self.present(navigation, animated: true)
        }
    }
}

//MARK: - WebViewControllerDelegate

extension MainViewController: WebViewControllerDelegate {
    func didReceiveAccessToken(_ token: String) {
        print("Access Token: \(token)")
        
        UserDefaults.standard.set(token, forKey: "vkAccessToken")
        
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            goToGalleryViewController(token: token)
        }
    }
    func didCancelAuthorization() {
        dismiss(animated: true) {
            self.showAlert(title: "Authorization Cancelled", message: "You have cancelled the authorization process.")
        }
    }
}
