//
//  APIError.swift
//  GhibliApp
//
//  Created by Кирилл on 21.03.2026.
//

import Foundation

enum APIError: LocalizedError {
    case invalideURL
    case invalidResponse
    case decoding(Error)
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalideURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response"
        case .decoding(let error):
            return "Failed to decode: \(error.localizedDescription)"
        case .networkError(let error):
            return "A network error occurred: \(error.localizedDescription)"
        }
    }
}
