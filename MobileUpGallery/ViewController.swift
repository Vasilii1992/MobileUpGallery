//
//  ViewController.swift
//  MobileUpGallery
//
//  Created by Василий Тихонов on 13.08.2024.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var authorizationButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        button.setTitle("Вход через VK", for: .normal)
        button.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(authorizationButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 343).isActive = true
        button.heightAnchor.constraint(equalToConstant: 52).isActive = true
        
        return button
    }()
    
    let galleryLabel: UILabel = {
        let label = UILabel()
        label.text = "Mobile Up\nGallery"
        label.font = UIFont.systemFont(ofSize: 44, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
        
        
    }
    
    @objc func authorizationButtonTapped() {
        
        let webViewController = WebViewController(with: "https://www.vk.com")
        let navigation = UINavigationController(rootViewController: webViewController)
        self.present(navigation, animated: true)
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(galleryLabel)
        view.addSubview(authorizationButton)
        
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
        
            galleryLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
            galleryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            galleryLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            
            authorizationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            authorizationButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40)
        
        
        ])
    }

}

