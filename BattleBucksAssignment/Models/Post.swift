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
    
    // Hashable conformance for use in Set
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Post, rhs: Post) -> Bool {
        lhs.id == rhs.id
    }
}

