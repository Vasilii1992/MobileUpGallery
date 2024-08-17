

import UIKit
import SDWebImage

final class VideoCell: UICollectionViewCell {
    
    static let reuseId = "VideoCell"
    
    private let videoImageView = ImageView(frame: .zero)
    
    private let overlayView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        view.translatesAutoresizingMaskIntoConstraints = false
        //максимальный и минимальный размер view
        view.widthAnchor.constraint(greaterThanOrEqualToConstant: 60).isActive = true
        view.widthAnchor.constraint(lessThanOrEqualToConstant: 230).isActive = true

        return view
    }()
    
    private let overlayTextLabel = Label(fontSize: 13, weight: .semibold, alignment: .right)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(videoImageView)
        contentView.addSubview(overlayView)
        overlayView.addSubview(overlayTextLabel)
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            videoImageView.topAnchor.constraint(equalTo: topAnchor),
            videoImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            videoImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            videoImageView.heightAnchor.constraint(equalToConstant: 210),
            
            overlayView.bottomAnchor.constraint(equalTo: videoImageView.bottomAnchor, constant: -20),
            overlayView.heightAnchor.constraint(equalToConstant: 40),
            overlayView.trailingAnchor.constraint(equalTo: videoImageView.trailingAnchor,constant: -10),

            overlayView.widthAnchor.constraint(equalTo: overlayTextLabel.widthAnchor, constant: 20),
            
            overlayTextLabel.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor, constant: 10),
            overlayTextLabel.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor, constant: -10),
            overlayTextLabel.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor),
        ])
    }

    func configure(with title: String, videoUrl: String, thumbnailUrl: String) {
  
        overlayTextLabel.text = title
        if let url = URL(string: thumbnailUrl) {
            videoImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"), options: .highPriority, completed: nil)
        }
    }
}
