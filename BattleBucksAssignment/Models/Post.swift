//
//  Post.swift
//  BattleBucksAssignment
//
//  Created by Md Akhlak on 18/10/25.
//

import Foundation

struct Post: Codable, Identifiable, Hashable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
    
    enum CodingKeys: String, CodingKey {
        case userId
        case id
        case title
        case body
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userId = try container.decode(Int.self, forKey: .userId)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        body = try container.decode(String.self, forKey: .body)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(userId, forKey: .userId)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(body, forKey: .body)
    }
    
    // MARK: - Hashable Implementation
    // Hashable conformance for use in Set<Post> (favorites)
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Post, rhs: Post) -> Bool {
        lhs.id == rhs.id
    }
}

