

import UIKit
import SDWebImage
import Photos

final class PhotoInfoViewController: UIViewController {
    
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
    
//MARK: - UIViews
    
    private lazy var actionBarButtonItem = BarButtonItems.createActionBarButtonItem(target: self, action: #selector(actionBarButtonTapped))
    
    private lazy var backBarButtonItem = BarButtonItems.createBackBarButtonItem(target: self, action: #selector(backBarButtonItemTapped))

    let photoImageView = ImageView(frame: .zero)
    
//MARK: - ViewDidLoad
    
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
            showAlert(title: "Error", message: "No photo available to save.")
            return
        }
        
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityViewController.popoverPresentationController?.barButtonItem = sender
        
        activityViewController.completionWithItemsHandler = { activity, success, items, error in
            if let error = error {
                self.showAlert(title: "Save Error", message: error.localizedDescription)
            } else if success, let activityType = activity, activityType == .saveToCameraRoll {

                self.showAlert(title: "Success", message: "Photo saved to gallery!")
            }
        }
        
        present(activityViewController, animated: true, completion: nil)
    }

    @objc func backBarButtonItemTapped() {
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
        navigationItem.leftBarButtonItem = backBarButtonItem
        navigationItem.rightBarButtonItem = actionBarButtonItem
    }
    
    private func configure(with urlString: String) {
        if let url = URL(string: urlString) {
            photoImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"), options: .highPriority, completed: nil)
        }
    }
}
