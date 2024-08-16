//
//  NetworkError.swift
//  MobileUpGallery
//
//  Created by Василий Тихонов on 16.08.2024.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case networkFailure(Error)
    case noDataReceived
    case jsonParsingError(Error)
    case rateLimitExceeded
    case unknownError
    
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "The URL provided was invalid."
        case .networkFailure(let error):
            return "Network error occurred: \(error.localizedDescription)"
        case .noDataReceived:
            return "No data received from the server."
        case .jsonParsingError:
            return "Failed to parse the JSON response."
        case .rateLimitExceeded:
            return "Rate limit exceeded, please try again later."
        case .unknownError:
            return "An unknown error occurred."
        }
    }
}

