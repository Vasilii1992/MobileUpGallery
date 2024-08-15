
import UIKit
import SDWebImage

class VideoCell: UICollectionViewCell {
    
    static let reuseId = "VideoCell"
    
  
    private let videoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
  
    private let overlayTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .white
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
        contentView.backgroundColor = .systemGray5
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            videoImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            videoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            videoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            videoImageView.heightAnchor.constraint(equalToConstant: 210),
            
            
            overlayView.leadingAnchor.constraint(equalTo: videoImageView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: videoImageView.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: videoImageView.bottomAnchor),
            overlayView.heightAnchor.constraint(equalToConstant: 60),
            
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
