//
//  PhotoCell.swift
//  MobileUpGallery
//
//  Created by Василий Тихонов on 13.08.2024.
//

import UIKit
import SDWebImage

class PhotoCell: UICollectionViewCell {
    
    static let reuseId = "PhotoCell"
    
    let photoImageView: UIImageView = {
       let image = UIImageView()
       image.translatesAutoresizingMaskIntoConstraints = false
       image.contentMode = .scaleAspectFill
       image.clipsToBounds = true
       return image
   }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPhotoImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.sd_cancelCurrentImageLoad()
        photoImageView.image = UIImage(named: "placeholder") 
    }
    
    
    private func setupPhotoImageView() {
        contentView.addSubview(photoImageView)
        photoImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        photoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        photoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        photoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true

    }
    
    func configure(with urlString: String) {
        if let url = URL(string: urlString) {
            photoImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"), options: .highPriority, completed: nil)
        }
    }

    
}
