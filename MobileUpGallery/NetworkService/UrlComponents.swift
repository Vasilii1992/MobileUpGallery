//
//  UrlComponents.swift
//  MobileUpGallery
//
//  Created by Василий Тихонов on 14.08.2024.
//

import Foundation

struct UrlComponents {
    
    static func createUrl() -> URL {
        var urlComponent = URLComponents()
        urlComponent.scheme = "https"
        urlComponent.host = "oauth.vk.com"
        urlComponent.path = "/authorize"
        
        urlComponent.queryItems = [
            URLQueryItem(name: "client_id", value: "52141017"),
            URLQueryItem(name: "redirect_url", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "scope", value: "photos,groups")
        ]
        return urlComponent.url!
    }
}
