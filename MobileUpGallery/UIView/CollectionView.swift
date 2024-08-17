

import UIKit

final class CollectionView: UICollectionView {
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        configure()
        
    }
    
   private func configure() {
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        showsVerticalScrollIndicator = false

    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
