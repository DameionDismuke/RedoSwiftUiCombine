//
//  NetworkError.swift
//  ReviewPractice9162024SwiftUI
//
//  Created by Consultant on 9/18/24.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case badURL
    case requestFailed
    case decodingFailed
    case unknown
    
    var errorDescription: String {
        switch self {
        case .badURL:
            return "Invalid URL."
        case .requestFailed:
            return "The network request failed."
        case .decodingFailed:
            return "Failed to decode the response."
        case .unknown:
            return "An unknown error occurred."
        }
    }
}
