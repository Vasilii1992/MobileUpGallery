
import UIKit

final class GalleryViewController: UIViewController {
    
    var accessToken: String?
    // MARK: - UIViews
    private lazy var segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["Фото", "Видео"])
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.selectedSegmentIndex = 0
        segmentControl.addTarget(self, action: #selector(segmentAction), for: .valueChanged)
        return segmentControl
    }()
    
    private lazy var exitBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Выход",
                                            style: .plain,
                                            target: self,
                                            action: #selector(exitBarButtonItemTapped))
        barButtonItem.tintColor = .black
        return barButtonItem
    }()

    private lazy var photoViewController: PhotoViewController = {
        let viewController = PhotoViewController()
        viewController.accessToken = accessToken
        addChild(viewController)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        return viewController
    }()
    
    private lazy var videoViewController: VideoViewController = {
        let viewController = VideoViewController()
        viewController.accessToken = accessToken
        addChild(viewController)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        return viewController
    }()
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
        segmentAction(sender: segmentControl)
        
    }

    private func setupViews() {
        title = "Mobile Up Gallery"
        view.backgroundColor = .white
        view.addSubview(segmentControl)
        
        view.addSubview(photoViewController.view)
        view.addSubview(videoViewController.view)
        
        photoViewController.didMove(toParent: self)
        videoViewController.didMove(toParent: self)
        
        navigationItem.rightBarButtonItem = exitBarButtonItem
    }
    
    private func showViewController(_ viewController: UIViewController) {
        viewController.view.isHidden = false
    }
    
    private func hideViewController(_ viewController: UIViewController) {
        viewController.view.isHidden = true
    }
    
    @objc func exitBarButtonItemTapped() {
        UserDefaults.standard.removeObject(forKey: "vkAccessToken")
        dismiss(animated: true)
    }
    
    @objc func segmentAction(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            showViewController(photoViewController)
            hideViewController(videoViewController)
        case 1:
            showViewController(videoViewController)
            hideViewController(photoViewController)
        default:
            break
        }
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            segmentControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            segmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            photoViewController.view.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 16),
            photoViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photoViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            photoViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            videoViewController.view.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 16),
            videoViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            videoViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            videoViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}
