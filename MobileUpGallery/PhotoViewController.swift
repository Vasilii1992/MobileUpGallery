//
//  PhotoViewController.swift
//  MobileUpGallery
//
//  Created by Василий Тихонов on 13.08.2024.
//

import UIKit
import SDWebImage

class PhotoViewController: UIViewController {
    
    var accessToken: String?
    var photos: [Photo] = []
    
    private let networkService = NetworkService.shared

    let collectionView = PhotoCollectionView.createPhotoCollectionView()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
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
    
    private func fetchAlbumsAndPhotos() {
        guard let accessToken = accessToken else {
            print("No access token available")
            return
        }
        
        networkService.fetchAlbums(accessToken: accessToken) { [weak self] albums in
            guard let self = self, let albums = albums else {
                print("Failed to fetch albums")
                return
            }
            
           
            let dispatchGroup = DispatchGroup()
            
            for album in albums {
                if let albumId = album["id"] as? Int {
                   
                    dispatchGroup.enter()
                    
                    self.fetchPhotosFromAlbum(albumId: albumId) { success in
                       
                        dispatchGroup.leave()
                    }
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                self.photos.sort(by: { $0.photoDate > $1.photoDate })
                self.collectionView.reloadData()
                print("All photos loaded and UI updated")
                print("\(self.photos.count) photos ")
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            }
        }
    }

    private func fetchPhotosFromAlbum(albumId: Int, completion: @escaping (Bool) -> Void) {
        guard let accessToken = accessToken else {
            print("No access token available")
            completion(false)
            return
        }
        
        networkService.fetchPhotos(albumId: albumId, accessToken: accessToken) { [weak self] photos in
            guard let self = self, let photos = photos else {
                print("Failed to fetch photos")
                completion(false)
                return
            }
            
            self.photos.append(contentsOf: photos)
            completion(true)
        }
    }
}

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
