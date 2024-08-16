//
//  VideoInfoViewController.swift
//  MobileUpGallery
//
//  Created by Василий Тихонов on 16.08.2024.
//


import UIKit
import WebKit

class VideoInfoViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    var videoTitle: String?
    var videoUrl: String?
    
    private var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.allowsInlineMediaPlayback = false
        webConfiguration.mediaTypesRequiringUserActionForPlayback = []
        return WKWebView(frame: .zero, configuration: webConfiguration)
    }()
    
    private lazy var actionBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                            target: self,
                                            action: #selector(actionBarButtonTapped))
        barButtonItem.tintColor = .black
        return barButtonItem
    }()
    
    private lazy var exitBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
                                            style: .plain,
                                            target: self,
                                            action: #selector(exitBarButtonItemTapped))
        barButtonItem.tintColor = .black
        return barButtonItem
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = videoTitle
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

    
    @objc func exitBarButtonItemTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupViews() {
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
        navigationItem.leftBarButtonItem = exitBarButtonItem
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

