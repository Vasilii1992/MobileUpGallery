//
//  PhotoCollectionView.swift
//  MobileUpGallery
//
//  Created by Василий Тихонов on 14.08.2024.
//

import UIKit

class PhotoCollectionView {
    
    static func createPhotoCollectionView() -> UICollectionView {
        let collectionView: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.minimumLineSpacing = 10
            layout.minimumInteritemSpacing = 10
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.backgroundColor = .white
            collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseId)
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            collectionView.showsVerticalScrollIndicator = false
            return collectionView
        }()
        
        return collectionView
    }
}


/*
 
 
 */
