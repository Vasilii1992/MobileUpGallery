//
//  WebViewController.swift
//  MobileUpGallery
//
//  Created by Василий Тихонов on 13.08.2024.
//

import UIKit
import WebKit

protocol WebViewControllerDelegate: AnyObject {
    func didReceiveAccessToken(_ token: String)
    func didCancelAuthorization()
}

class WebViewController: UIViewController {
    
    weak var delegate: WebViewControllerDelegate?

    
    private let webView = WKWebView()
    private let url: URL
    
    init(with url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
        webView.navigationDelegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(cancelTapped))


    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webViewLoad(url: url)
        setupViews()
        setConstraints()
   
    }
    
    @objc private func cancelTapped() {
         delegate?.didCancelAuthorization()
     }
    
    private func webViewLoad(url: URL) {

        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
        
    }
    
    private func setupViews() {
        view.addSubview(webView)
            
    }

    private func setConstraints() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - WKNavigationDelegate
extension WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let url = webView.url, url.absoluteString.starts(with: "https://oauth.vk.com/blank.html") {
            if let fragment = url.fragment {
                let params = fragment.components(separatedBy: "&")
                var dict = [String: String]()
                for param in params {
                    let keyValue = param.components(separatedBy: "=")
                    if keyValue.count == 2 {
                        dict[keyValue[0]] = keyValue[1]
                    }
                }
                
                if let accessToken = dict["access_token"] {
                    delegate?.didReceiveAccessToken(accessToken)
                }
            }
        }
    }
}
