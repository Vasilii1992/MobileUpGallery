
import Foundation

final class NetworkService {

    static let shared = NetworkService()
    private init() { }
    
    // MARK: - Fetch Photo
    func fetchAlbums(accessToken: String, completion: @escaping (Result<[[String: Any]], NetworkError>) -> Void) {
        let groupId = "-128666765"
        let method = "photos.getAlbums"
        let version = "5.131"
        let urlString = "https://api.vk.com/method/\(method)?owner_id=\(groupId)&access_token=\(accessToken)&v=\(version)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.networkFailure(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noDataReceived))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let response = json["response"] as? [String: Any],
                   let albums = response["items"] as? [[String: Any]] {
                    completion(.success(albums))
                } else {
                    completion(.failure(.unknownError))
                }
            } catch {
                completion(.failure(.jsonParsingError(error)))
            }
        }
        
        task.resume()
    }

    func fetchPhotos(albumId: Int, accessToken: String, completion: @escaping (Result<[Photo], NetworkError>) -> Void) {
        let groupId = "-128666765"
        let method = "photos.get"
        let version = "5.131"
        let urlString = "https://api.vk.com/method/\(method)?owner_id=\(groupId)&album_id=\(albumId)&access_token=\(accessToken)&v=\(version)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.networkFailure(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noDataReceived))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let errorResponse = json["error"] as? [String: Any],
                       let errorCode = errorResponse["error_code"] as? Int, errorCode == 6 {
                        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
                            self.fetchPhotos(albumId: albumId, accessToken: accessToken, completion: completion)
                        }
                        print("Rate limit exceeded,trying…")
                        return
                    }
                    
                    if let response = json["response"] as? [String: Any],
                       let items = response["items"] as? [[String: Any]] {
                        
                        let photos = items.compactMap { item -> Photo? in
                            if let sizes = item["sizes"] as? [[String: Any]],
                               let largestSize = sizes.max(by: { ($0["width"] as? Int ?? 0) < ($1["width"] as? Int ?? 0) }),
                               let url = largestSize["url"] as? String,
                               let date = item["date"] as? Int {
                                return Photo(photoUrl: url, photoDate: date)
                            }
                            return nil
                        }
                        
                        completion(.success(photos))
                    } else {
                        completion(.failure(.unknownError))
                    }
                } else {
                    completion(.failure(.unknownError))
                }
            } catch {
                completion(.failure(.jsonParsingError(error)))
            }
        }
        
        task.resume()
    }
}

// MARK: - Fetch Video
extension NetworkService {
    
    func fetchVideos(accessToken: String, completion: @escaping (Result<[Video], NetworkError>) -> Void) {
        let groupId = "-128666765"
        let method = "video.get"
        let version = "5.131"
        let urlString = "https://api.vk.com/method/\(method)?owner_id=\(groupId)&access_token=\(accessToken)&v=\(version)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.networkFailure(error)))
                return
            }

            guard let data = data else {
                completion(.failure(.noDataReceived))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let response = json["response"] as? [String: Any],
                   let items = response["items"] as? [[String: Any]] {
                    
                    let videos = items.compactMap { item -> Video? in
                        guard let title = item["title"] as? String,
                              let player = item["player"] as? String,
                              let imageArray = item["image"] as? [[String: Any]],
                              let firstImage = imageArray.last,
                              let thumbnailUrl = firstImage["url"] as? String else {
                            return nil
                        }
                        
                        return Video(title: title, videoUrl: player, thumbnailUrl: thumbnailUrl)
                    }
                    
                    completion(.success(videos))
                } else {
                    completion(.failure(.unknownError))
                }
            } catch {
                completion(.failure(.jsonParsingError(error)))
            }
        }

        task.resume()
    }
}
