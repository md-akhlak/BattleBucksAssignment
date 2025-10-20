//
//  NetworkService.swift
//  BattleBucksAssignment
//
//  Created by Md Akhlak on 18/10/25.
//

import Foundation
import Combine

class NetworkService: ObservableObject {
    static let shared = NetworkService()
    
    private init() {}
    
    private let baseURL = "https://jsonplaceholder.typicode.com"
    
    func fetchPosts(page: Int = 1, limit: Int = 10) async throws -> [Post] {
        guard let url = URL(string: "\(baseURL)/posts?_page=\(page)&_limit=\(limit)") else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let posts = try JSONDecoder().decode([Post].self, from: data)
            return posts
        } catch {
            throw NetworkError.decodingError
        }
    }
    
//    func fetchAllPosts() async throws -> [Post] {
//        guard let url = URL(string: "\(baseURL)/posts") else {
//            throw NetworkError.invalidURL
//        }
//        
//        let (data, response) = try await URLSession.shared.data(from: url)
//        
//        guard let httpResponse = response as? HTTPURLResponse,
//              httpResponse.statusCode == 200 else {
//            throw NetworkError.invalidResponse
//        }
//        
//        do {
//            let posts = try JSONDecoder().decode([Post].self, from: data)
//            return posts
//        } catch {
//            throw NetworkError.decodingError
//        }
//    }
}

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .decodingError:
            return "Failed to decode data"
        }
    }
}
