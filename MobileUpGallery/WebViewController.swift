//
//  WebViewController.swift
//  MobileUpGallery
//
//  Created by Василий Тихонов on 13.08.2024.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    private let webView = WKWebView()
    private let urlString: String
    
    init(with urlString: String) {
        self.urlString = urlString
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webViewLoad(urlString: urlString)
        setupViews()
        setConstraints()

        
        
    }
    
    private func webViewLoad(urlString: String) {
        
        guard let url = URL(string: urlString) else {
            self.dismiss(animated: true)
            return
        }
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
        
    }
    
    private func setupViews() {
        view.addSubview(webView)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapDone))
        
    }
    
    @objc func didTapDone() {
        dismiss(animated: true)
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
