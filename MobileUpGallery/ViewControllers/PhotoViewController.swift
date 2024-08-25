
import UIKit

final class PhotoViewController: UIViewController {
    
    var accessToken: String?
    var photos: [Photo] = []
    
    private let networkService = NetworkService.shared
    
// MARK: - UIViews
    
    private let collectionView = CollectionView()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
     //   indicator.hidesWhenStopped = true  чтобы не прятать его , а он сам прятался когда останавливался.
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
// MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints() 
        setDelegate()
        fetchAlbumsAndPhotos()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)

         activityIndicator.startAnimating()
        
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseId)
    }
    
    private func setDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - Receive albums and photos from the server
    
    private func fetchAlbumsAndPhotos() {
        guard let accessToken = accessToken else {
            showAlert(title: "Error", message: "No access token available")
            return
        }
        
        networkService.fetchAlbums(accessToken: accessToken) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let albums):
                    let fetchQueue = DispatchQueue(label: "photoFetchQueue", attributes: .concurrent)
                    let group = DispatchGroup()
                    
                    for album in albums {
                        if let albumId = album["id"] as? Int {
                            group.enter()
                            fetchQueue.async(group: group) {
                                self.fetchPhotosFromAlbum(albumId: albumId) { success in
                                    if success {
                                            self.photos.sort(by: { $0.photoDate > $1.photoDate })
                                            self.collectionView.reloadData()
                                            
                                            if self.photos.count > 0 && !self.activityIndicator.isHidden {
                                                self.activityIndicator.stopAnimating()
                                                self.activityIndicator.isHidden = true
                                            }
                                    }
                                    group.leave()
                                }
                            }
                        }
                    }
                    
                    group.notify(queue: .main) {
                        print("All photos loaded and UI updated")
                        print("\(self.photos.count) photos")
                        
                    }
                    
                case .failure(let error):
                    self.showAlert(title: "Failed to Fetch Albums", message: error.localizedDescription)
                }
            }
        }
    }

    private func fetchPhotosFromAlbum(albumId: Int, completion: @escaping (Bool) -> Void) {
        guard let accessToken = accessToken else {
            showAlert(title: "Error", message: "No access token available")
            completion(false)
            return
        }
        networkService.fetchPhotos(albumId: albumId, accessToken: accessToken) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else {
                    completion(false)
                    return
                }
                switch result {
                case .success(let photos):
                    self.photos.append(contentsOf: photos)
                    completion(true)
                    
                case .failure(let error):
                    self.showAlert(title: "Failed to Fetch Photos", message: error.localizedDescription)
                    completion(false)
                }
            }
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension PhotoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseId, for: indexPath) as? PhotoCell else {
            return UICollectionViewCell()
        }
        let photoUrlString = photos[indexPath.item].photoUrl
    
            cell.configure(with: photoUrlString)

       
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photoUrlString = photos[indexPath.item].photoUrl
        let photoDate = photos[indexPath.item].photoDate
        
        let vc = PhotoInfoViewController(urlString: photoUrlString, photoDate: photoDate)
        navigationController?.pushViewController(vc, animated: true)
    }

}

// MARK: - UICollectionViewDelegateFlowLayout

extension PhotoViewController: UICollectionViewDelegateFlowLayout {
    
    private var numberOfColumns: Int { return 2 }
    
    private var cellSpacing: CGFloat { return 5 }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing = cellSpacing * CGFloat(numberOfColumns - 1) 
        let itemWidth = (collectionView.bounds.width - totalSpacing) / CGFloat(numberOfColumns)
        
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: cellSpacing, left: 0, bottom: cellSpacing, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
}
