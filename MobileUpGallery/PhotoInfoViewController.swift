//
//  PhotoInfoViewController.swift
//  MobileUpGallery
//
//  Created by Василий Тихонов on 15.08.2024.
//

import UIKit
import SDWebImage
import Photos


class PhotoInfoViewController: UIViewController {
    
    let urlString: String
    let photoDate: Int
    
    init(urlString: String, photoDate: Int) {
        self.urlString = urlString
        self.photoDate = photoDate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    let photoImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavigationBar()
        configure(with: urlString)
        setupTitle()
    }
    
    private func setupTitle() {
        let date = Date(timeIntervalSince1970: TimeInterval(photoDate))
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "d MMMM yyyy"
        title = dateFormatter.string(from: date)
    }
    
    @objc func actionBarButtonTapped(sender: UIBarButtonItem) {
        guard let image = photoImageView.image else {
            return
        }
        
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityViewController.popoverPresentationController?.barButtonItem = sender
        
        activityViewController.completionWithItemsHandler = { activity, success, items, error in
            if success, let activityType = activity, activityType == .saveToCameraRoll {
                let alert = UIAlertController(title: "Success",
                                              message: "Photo saved to gallery!",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        present(activityViewController, animated: true, completion: nil)
    }

    @objc func exitBarButtonItemTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(photoImageView)
        
        NSLayoutConstraint.activate([
            photoImageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            photoImageView.heightAnchor.constraint(equalToConstant: 375),
            photoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            photoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = exitBarButtonItem
        navigationItem.rightBarButtonItem = actionBarButtonItem
    }
    
    private func configure(with urlString: String) {
        if let url = URL(string: urlString) {
            photoImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"), options: .highPriority, completed: nil)
        }
    }
}
