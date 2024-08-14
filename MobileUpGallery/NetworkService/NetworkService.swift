//
//  NetworkService.swift
//  MobileUpGallery
//
//  Created by Василий Тихонов on 14.08.2024.
//

import Foundation

class NetworkService {

    static let shared = NetworkService()
    
    private init() { }
    
    func fetchAlbums(accessToken: String, completion: @escaping ([[String: Any]]?) -> Void) {
        let groupId = "-128666765"
        let method = "photos.getAlbums"
        let version = "5.131"
        let urlString = "https://api.vk.com/method/\(method)?owner_id=\(groupId)&access_token=\(accessToken)&v=\(version)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL string: \(urlString)")
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                print("Error fetching albums")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received from VK API")
                completion(nil)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let response = json["response"] as? [String: Any],
                   let albums = response["items"] as? [[String: Any]] {
                    completion(albums)
                } else {
                    print("Failed to parse JSON response")
                    completion(nil)
                }
            } catch {
                print("JSON parsing error")
                completion(nil)
            }
        }
        
        task.resume()
    }
    
    func fetchPhotos(albumId: Int, accessToken: String, completion: @escaping ([(String, Int)]?) -> Void) {
        let groupId = "-128666765"
        let method = "photos.get"
        let version = "5.131"
        let urlString = "https://api.vk.com/method/\(method)?owner_id=\(groupId)&album_id=\(albumId)&access_token=\(accessToken)&v=\(version)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL string: \(urlString)")
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                print("Error fetching photos")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received from VK API")
                completion(nil)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let response = json["response"] as? [String: Any],
                   let items = response["items"] as? [[String: Any]] {
                    
                    let photos = items.compactMap { item -> (String, Int)? in
                        if let sizes = item["sizes"] as? [[String: Any]],
                           let largestSize = sizes.max(by: { ($0["width"] as? Int ?? 0) < ($1["width"] as? Int ?? 0) }),
                           let url = largestSize["url"] as? String,
                           let date = item["date"] as? Int {
                            return (url, date)
                        }
                        return nil
                    }
                    
                    completion(photos)
                } else {
                    print("Failed to parse JSON response")
                    completion(nil)
                }
            } catch {
                print("JSON parsing error")
                completion(nil)
            }
        }
        
        task.resume()
    }
}
