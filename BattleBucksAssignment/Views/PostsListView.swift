//
//  PostsListView.swift
//  BattleBucksAssignment
//
//  Created by Md Akhlak on 18/10/25.
//

import SwiftUI

struct PostsListView: View {
    @EnvironmentObject var viewModel: PostsViewModel
    @State private var selectedPost: Post?
    @State private var hasAppeared: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header with title
                headerView
                
                // Search Bar
                searchBar
                
                // Content
                if viewModel.isLoading || (!hasAppeared && viewModel.posts.isEmpty) {
                    loadingView
                } else if viewModel.isRefreshing {
                    // Show shimmer during refresh
                    VStack {
                        loadingView
                        Text("Refreshing posts...")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.top, 16)
                    }
                } else if let errorMessage = viewModel.errorMessage {
                    errorView(errorMessage)
                } else {
                    postsList
                }
            }
            .background(Color(.systemGray6))
            .task {
                await viewModel.fetchPosts()
            }
            .navigationDestination(item: $selectedPost) { post in
                PostDetailView(post: post)
                    .environmentObject(viewModel)
            }
            .onAppear {
                hasAppeared = true
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Posts")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .font(.system(size: 16))
            
            TextField("Search posts...", text: $viewModel.searchText)
                .textFieldStyle(PlainTextFieldStyle())
                .font(.system(size: 16))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.systemGray5))
        .cornerRadius(8)
        .padding(.horizontal, 16)
        .padding(.top, 16)
    }
    
    private var loadingView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(0..<6, id: \.self) { _ in
                    ShimmerPostCard()
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 20)
            .padding(.bottom, 100) // Space for tab bar
        }
        .refreshable {
            print("🔄 Pull-to-refresh triggered in PostsListView loadingView")
            await viewModel.refreshPosts()
        }
        .background(Color(.systemGray6))
    }
    
    private func errorView(_ message: String) -> some View {
        ScrollView {
            VStack(spacing: 16) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.system(size: 50))
                    .foregroundColor(.orange)
                
                Text("Error")
                    .font(.headline)
                
                Text(message)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Button("Retry") {
                    Task {
                        await viewModel.fetchPosts()
                    }
                }
                .buttonStyle(.borderedProminent)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.top, 100)
        }
        .refreshable {
            print("🔄 Pull-to-refresh triggered in PostsListView errorView")
            await viewModel.refreshPosts()
        }
    }
    
    private var postsList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredPosts) { post in
                    PostCardView(post: post) {
                        selectedPost = post
                    }
                    .environmentObject(viewModel)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 20)
            .padding(.bottom, 100) // Space for tab bar
        }
        .refreshable {
            print("🔄 Pull-to-refresh triggered in PostsListView postsList")
            await viewModel.refreshPosts()
        }
        .background(Color(.systemGray6))
    }
}

struct PostCardView: View {
    let post: Post
    let onTap: () -> Void
    @EnvironmentObject var viewModel: PostsViewModel
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Left side - Post icon and ID
                VStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 40, height: 40)
                            .overlay(
                                Text("U\(post.userId)")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white)
                            )
                    }
                    
                    Text("#\(post.id)")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.secondary)
                }
                
                // Center - Content
                VStack(alignment: .leading, spacing: 8) {
                    Text(post.title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // Right side - Favorite button
                VStack {
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            viewModel.toggleFavorite(for: post)
                        }
                    }) {
                        Image(systemName: viewModel.isFavorite(post) ? "heart.fill" : "heart")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(viewModel.isFavorite(post) ? .red : .primary)
                            .frame(width: 40, height: 40)
                            .background(
                                Circle()
                                    .fill(Color(.systemBackground))
                                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                            )
                            .scaleEffect(viewModel.isFavorite(post) ? 1.1 : 1.0)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Spacer()
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            
        }
        .buttonStyle(PlainButtonStyle())
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.1), lineWidth: 1)
        )
    }
}

#Preview {
    PostsListView()
        .environmentObject(PostsViewModel())
}
