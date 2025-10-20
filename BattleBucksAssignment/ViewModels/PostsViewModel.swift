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
    @Published var isLoadingMore: Bool = false
    @Published var errorMessage: String?
    @Published var hasMorePosts: Bool = true
    @Published var paginationError: String?
    
    private let networkService = NetworkService.shared
    
    private var currentPage: Int = 1
    private let postsPerPage: Int = 10
    private var isPaginationInProgress: Bool = false
    
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
        isLoading = true
        errorMessage = nil
        currentPage = 1
        hasMorePosts = true
        
        do {
            let fetchedPosts = try await networkService.fetchPosts(page: currentPage, limit: postsPerPage)
            posts = fetchedPosts
            currentPage += 1
            
            // Check if we have more posts to load
            if fetchedPosts.count < postsPerPage {
                hasMorePosts = false
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func loadMorePosts() async {
        guard !isLoadingMore && !isPaginationInProgress && hasMorePosts else { return }
        
        isPaginationInProgress = true
        isLoadingMore = true
        paginationError = nil
        
        do {
            let fetchedPosts = try await networkService.fetchPosts(page: currentPage, limit: postsPerPage)
            posts.append(contentsOf: fetchedPosts)
            currentPage += 1
            
            // Check if we have more posts to load
            if fetchedPosts.count < postsPerPage {
                hasMorePosts = false
            }
        } catch {
            paginationError = error.localizedDescription
        }
        
        isLoadingMore = false
        isPaginationInProgress = false
    }
    
    func retryPagination() async {
        await loadMorePosts()
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
        await fetchPosts()
    }
    
    func shouldLoadMore(for post: Post) -> Bool {
        // Only trigger pagination if we're not searching and we have more posts
        guard searchText.isEmpty && hasMorePosts && !isLoadingMore && !isPaginationInProgress else { return false }
        
        // Get the index of the current post in the filtered posts
        guard let currentIndex = filteredPosts.firstIndex(where: { $0.id == post.id }) else { return false }
        
        // Trigger pagination when we're 3 items away from the end
        let triggerIndex = max(0, filteredPosts.count - 3)
        return currentIndex >= triggerIndex
    }
}
