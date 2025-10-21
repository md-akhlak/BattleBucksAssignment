//
//  PostsViewModel.swift
//  BattleBucksAssignment
//
//  Created by Md Akhlak on 18/10/25.
//

import Foundation
import Combine
import SwiftUI

@MainActor
class PostsViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var favorites: Set<Post> = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var isRefreshing: Bool = false
    @Published var errorMessage: String?
    
    private let networkService = NetworkService.shared
    
    var filteredPosts: [Post] {
        if searchText.isEmpty {
            return posts
        } else {
            return posts.filter { post in
                post.title.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var favoritePosts: [Post] {
        return posts.filter { favorites.contains($0) }
    }
    
    func fetchPosts() async {
        print("🔄 fetchPosts() called - isLoading: \(isLoading)")
        isLoading = true
        errorMessage = nil
        
        do {
            print("🌐 Fetching posts from API...")
            let fetchedPosts = try await networkService.fetchAllPosts()
            posts = fetchedPosts
            print("✅ Successfully fetched \(fetchedPosts.count) posts")
        } catch {
            print("❌ Error fetching posts: \(error.localizedDescription)")
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
        print("🏁 fetchPosts() completed - isLoading: \(isLoading)")
    }
    
    func toggleFavorite(for post: Post) {
        withAnimation(.easeInOut(duration: 0.3)) {
            if favorites.contains(post) {
                favorites.remove(post)
            } else {
                favorites.insert(post)
            }
        }
    }
    
    func isFavorite(_ post: Post) -> Bool {
        return favorites.contains(post)
    }
    
    func refreshPosts() async {
        print("🔄 refreshPosts() called - isRefreshing: \(isRefreshing)")
        
        // Prevent multiple simultaneous refresh calls
        guard !isRefreshing else {
            print("⚠️ Refresh already in progress, ignoring duplicate call")
            return
        }
        
        isRefreshing = true
        errorMessage = nil
        
        do {
            print("🌐 Refreshing posts from API...")
            let fetchedPosts = try await networkService.fetchAllPosts()
            posts = fetchedPosts
            print("✅ Successfully refreshed \(fetchedPosts.count) posts")
        } catch {
            print("❌ Error refreshing posts: \(error.localizedDescription)")
            // Only show error if it's not a cancellation
            if !(error is CancellationError) && 
               !error.localizedDescription.contains("cancelled") {
                errorMessage = error.localizedDescription
            }
        }
        
        isRefreshing = false
        print("🏁 refreshPosts() completed - isRefreshing: \(isRefreshing)")
    }
}
