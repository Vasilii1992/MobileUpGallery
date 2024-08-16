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
    
    private var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = videoTitle
        setupWebView()
        loadVideo()
    }
    
    private func setupWebView() {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.allowsInlineMediaPlayback = false
        webConfiguration.mediaTypesRequiringUserActionForPlayback = []
        
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        view.addSubview(webView)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadVideo() {
        guard let videoUrlString = videoUrl, let url = URL(string: videoUrlString) else {
            print("Invalid video URL")
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
}

