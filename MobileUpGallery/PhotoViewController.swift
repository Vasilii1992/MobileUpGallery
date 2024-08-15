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
    // получаю тюпл для того чтобы отсортировать по дате.
    var photos: [(String, Int)] = []
    
    private let networkService = NetworkService.shared

    let collectionView = PhotoCollectionView.createPhotoCollectionView()
    
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
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
               for album in albums {
                   if let albumId = album["id"] as? Int {
                       self.fetchPhotosFromAlbum(albumId: albumId)
                   }
               }
           }
       }

       private func fetchPhotosFromAlbum(albumId: Int) {
           guard let accessToken = accessToken else {
               print("No access token available")
               return
           }
           
           networkService.fetchPhotos(albumId: albumId, accessToken: accessToken) { [weak self] photos in
               guard let self = self, let photos = photos else {
                   print("Failed to fetch photos")
                   return
               }
               
               self.photos.append(contentsOf: photos)
               
               self.photos.sort(by: { $0.1 > $1.1 })
               
               DispatchQueue.main.async {
                   self.collectionView.reloadData()
               }
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
        let photoUrlString = photos[indexPath.item].0

        cell.configure(with: photoUrlString)
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photoUrlString = photos[indexPath.item].0
        let photoDate = photos[indexPath.item].1
        
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
