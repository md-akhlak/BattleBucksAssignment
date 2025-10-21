//
//  FavoritesView.swift
//  BattleBucksAssignment
//
//  Created by Md Akhlak on 18/10/25.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var viewModel: PostsViewModel
    @State private var selectedPost: Post?
    @State private var searchText: String = ""
    @State private var selectedLayout: LayoutType = .grid
    @State private var showSearchBar: Bool = false
    @State private var hasAppeared: Bool = false
    
    enum LayoutType: CaseIterable {
        case grid, list
        
        var icon: String {
            switch self {
            case .grid: return "grid"
            case .list: return "list.bullet"
            }
        }
    }
    
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                headerView
                
                if showSearchBar {
                    searchBar
                }
                
                // Content
                if viewModel.isLoading || (!hasAppeared && viewModel.favoritePosts.isEmpty) {
                    loadingView
                } else if viewModel.isRefreshing {
                    // Show shimmer during refresh
                    VStack {
                        FavoritesShimmerView(selectedLayout: selectedLayout)
                        Text("Refreshing favorites...")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.top, 16)
                    }
                } else if viewModel.favoritePosts.isEmpty {
                    emptyStateView
                } else if filteredFavorites.isEmpty {
                    noResultsView
                } else {
                    contentView
                }
            }
            .background(
                LinearGradient(
                    colors: [Color(.systemGray6), Color(.systemGray5)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .navigationDestination(item: $selectedPost) { post in
                PostDetailView(post: post)
                    .environmentObject(viewModel)
            }
            .onAppear {
                hasAppeared = true
            }
        }
    }
    
    var filteredFavorites: [Post] {
        if searchText.isEmpty {
            return viewModel.favoritePosts
        } else {
            return viewModel.favoritePosts.filter { post in
                post.title.localizedCaseInsensitiveContains(searchText) ||
                post.body.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 16) {
        HStack {
                VStack(alignment: .leading, spacing: 4) {
            Text("Favorites")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                    
                    Text("\(viewModel.favoritePosts.count) saved posts")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
            Spacer()
                
                HStack(spacing: 12) {
                    // Search Button
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            showSearchBar.toggle()
                            if !showSearchBar {
                                searchText = ""
                            }
                        }
                    }) {
                        Image(systemName: showSearchBar ? "xmark" : "magnifyingglass")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.primary)
                            .frame(width: 36, height: 36)
                            .background(
                                Circle()
                                    .fill(Color(.systemGray5))
                                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                            )
                    }
                    
                    // Layout Toggle
                    Menu {
                        ForEach(LayoutType.allCases, id: \.self) { layout in
                            Button(action: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                    selectedLayout = layout
                                }
                            }) {
                                HStack {
                                    Image(systemName: layout.icon)
                                    Text(layout == .grid ? "Grid View" : "List View")
                                    if selectedLayout == layout {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        }
                    } label: {
                        Image(systemName: selectedLayout.icon)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.primary)
                            .frame(width: 36, height: 36)
                            .background(
                                Circle()
                                    .fill(Color(.systemGray5))
                                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                            )
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
        }
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .font(.system(size: 16))
            
            TextField("Search favorites...", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
                .font(.system(size: 16))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
        .padding(.horizontal, 20)
        .transition(.asymmetric(
            insertion: .opacity.combined(with: .move(edge: .top)),
            removal: .opacity.combined(with: .move(edge: .top))
        ))
    }
    
    private var loadingView: some View {
        FavoritesShimmerView(selectedLayout: selectedLayout)
            .refreshable {
                print("🔄 Pull-to-refresh triggered in FavoritesView loadingView")
                await viewModel.refreshPosts()
            }
    }
    
    private var emptyStateView: some View {
        ScrollView {
            VStack(spacing: 24) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.red.opacity(0.1), .pink.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: "heart")
                        .font(.system(size: 50, weight: .light))
                        .foregroundColor(.red.opacity(0.6))
                }
                
                VStack(spacing: 12) {
                    Text("No Favorites Yet")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text("Start exploring posts and tap the heart icon to save your favorites")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.top, 100)
        }
        .refreshable {
            print("🔄 Pull-to-refresh triggered in FavoritesView")
            await viewModel.refreshPosts()
        }
    }
    
    private var noResultsView: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 50))
                    .foregroundColor(.gray.opacity(0.6))
                
                Text("No Results Found")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("Try adjusting your search terms")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.top, 100)
        }
        .refreshable {
            print("🔄 Pull-to-refresh triggered in FavoritesView")
            await viewModel.refreshPosts()
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        ScrollView {
            if selectedLayout == .grid {
                favoritesGrid
            } else {
                favoritesList
            }
        }
        .refreshable {
            print("🔄 Pull-to-refresh triggered in FavoritesView")
            await viewModel.refreshPosts()
        }
    }
    
    private var favoritesGrid: some View {
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ], spacing: 16) {
            ForEach(filteredFavorites) { post in
                FavoriteCardView(post: post) {
                    selectedPost = post
                }
                .environmentObject(viewModel)
                .transition(.asymmetric(
                    insertion: .opacity.combined(with: .scale(scale: 0.8)),
                    removal: .opacity.combined(with: .scale(scale: 0.8))
                ))
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 24)
        .padding(.bottom, 100)
    }
    
    private var favoritesList: some View {
        LazyVStack(spacing: 16) {
            ForEach(filteredFavorites) { post in
                FavoriteListItemView(post: post) {
                        selectedPost = post
                    }
                    .environmentObject(viewModel)
                .transition(.asymmetric(
                    insertion: .opacity.combined(with: .move(edge: .trailing)),
                    removal: .opacity.combined(with: .move(edge: .leading))
                ))
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 24)
        .padding(.bottom, 100)
    }
}

// MARK: - Custom Card Views

struct FavoriteCardView: View {
    let post: Post
    let onTap: () -> Void
    @EnvironmentObject var viewModel: PostsViewModel
    @State private var isPressed: Bool = false
    
    var body: some View {
        VStack(spacing: 12) {
            // Top section with user info and favorite button
            HStack {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 32, height: 32)
                        .overlay(
                            Text("U\(post.userId)")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.white)
                        )
                }
                
                Spacer()
                
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        viewModel.toggleFavorite(for: post)
                    }
                }) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.red)
                        .frame(width: 40, height: 40)
                        .background(
                            Circle()
                                .fill(Color(.systemBackground))
                                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                        )
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            // Content
            VStack(alignment: .leading, spacing: 8) {
                Text(post.title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("#\(post.id)")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(
                    color: isPressed ? .black.opacity(0.1) : .black.opacity(0.05),
                    radius: isPressed ? 4 : 8,
                    x: 0,
                    y: isPressed ? 1 : 2
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.1), lineWidth: 1)
        )
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .onTapGesture {
            onTap()
        }
        .onLongPressGesture(minimumDuration: 0) { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        } perform: {}
    }
}

struct FavoriteListItemView: View {
    let post: Post
    let onTap: () -> Void
    @EnvironmentObject var viewModel: PostsViewModel
    @State private var isPressed: Bool = false
    
    var body: some View {
        HStack(spacing: 16) {
            // User avatar with enhanced design
            ZStack {
                
                VStack(alignment: .center, spacing: 4){
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 48, height: 48)
                        .overlay(
                            Text("U\(post.userId)")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                        )
                    
                    Text("#\(post.id)")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 8)
                }
            }
            
            // Enhanced content section
            VStack(alignment: .leading, spacing: 8) {
                Text(post.title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Enhanced favorite button
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    viewModel.toggleFavorite(for: post)
                }
            }) {
                Image(systemName: "heart.fill")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.red)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(Color(.systemBackground))
                            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                    )
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(
                    color: isPressed ? .black.opacity(0.1) : .black.opacity(0.05),
                    radius: isPressed ? 4 : 8,
                    x: 0,
                    y: isPressed ? 1 : 2
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    LinearGradient(
                        colors: [Color.gray.opacity(0.1), Color.blue.opacity(0.05)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .onTapGesture {
            onTap()
        }
    }
}
    

#Preview {
    FavoritesView()
        .environmentObject(PostsViewModel())
}

