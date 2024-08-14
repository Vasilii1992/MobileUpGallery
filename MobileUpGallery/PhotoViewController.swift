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

    
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 48) / 2, height: (UIScreen.main.bounds.width - 48) / 2)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseId)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
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
}

