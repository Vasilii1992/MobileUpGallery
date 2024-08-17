

import UIKit
import WebKit

final class VideoInfoViewController: UIViewController{
    
    var videoTitle: String?
    var videoUrl: String?
    
//MARK: - UIViews
    
    private var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.allowsInlineMediaPlayback = false
        webConfiguration.mediaTypesRequiringUserActionForPlayback = []
        return WKWebView(frame: .zero, configuration: webConfiguration)
    }()
    
    private lazy var actionBarButtonItem = BarButtonItems.createActionBarButtonItem(target: self, action: #selector(actionBarButtonTapped))
    
    private lazy var backBarButtonItem = BarButtonItems.createBackBarButtonItem(target: self, action: #selector(backBarButtonItemTapped))
    
//MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupDelegate()
        setConstraints()
        loadVideo()
        setupNavigationBar()
    }
    
    @objc func actionBarButtonTapped(sender: UIBarButtonItem) {
        guard let videoUrlString = videoUrl, let url = URL(string: videoUrlString) else {
            showAlert(title: "Error", message: "Invalid video URL for sharing")
            return
        }
        
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }

    
    @objc func backBarButtonItemTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        self.title = videoTitle
        view.addSubview(webView)
    }
    private func setupDelegate() {
        webView.uiDelegate = self
        webView.navigationDelegate = self
    }
    
    private func setConstraints() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = backBarButtonItem
        navigationItem.rightBarButtonItem = actionBarButtonItem
    }
    
    private func loadVideo() {
        guard let videoUrlString = videoUrl, let url = URL(string: videoUrlString) else {
            showAlert(title: "Error", message: "Invalid video URL")
            return
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
// MARK: - WKUIDelegate, WKNavigationDelegate

extension VideoInfoViewController: WKUIDelegate, WKNavigationDelegate  {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Started loading content")
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finished loading content")
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("Content loaded, ready to interact")
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showAlert(title: "Error", message: "Failed to load content with error: \(error.localizedDescription)")
 
    }
}
