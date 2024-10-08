
import UIKit

final class VideoViewController: UIViewController {
    
    var accessToken: String?
    var videos: [Video] = []
    
    private let networkService = NetworkService.shared
    
    private let collectionView = CollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
        setDelegate()
        fetchVideos()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: VideoCell.reuseId)
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
    
    private func fetchVideos() {
        guard let accessToken = accessToken else {
            showAlert(title: "Error", message: "No access token available")
            return
        }
        
        networkService.fetchVideos(accessToken: accessToken) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let videos):
                self.videos = videos
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
            case .failure(let error):
                self.showAlert(title: "Failed to Fetch Videos", message: error.localizedDescription)
            }
        }
    }

}
// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension VideoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCell.reuseId, for: indexPath) as? VideoCell else {
            return UICollectionViewCell()
        }
        let video = videos[indexPath.item]
        cell.configure(with: video.title, videoUrl: video.videoUrl, thumbnailUrl: video.thumbnailUrl)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let video = videos[indexPath.item]
        let videoInfoVC = VideoInfoViewController()
        videoInfoVC.videoTitle = video.title
        videoInfoVC.videoUrl = video.videoUrl
        navigationController?.pushViewController(videoInfoVC, animated: true)
    }

}
// MARK: - UICollectionViewDelegateFlowLayout
extension VideoViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
 
        return CGSize(width: collectionView.bounds.width, height: 203)
    }
}
