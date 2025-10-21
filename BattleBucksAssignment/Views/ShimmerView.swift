//
//  ShimmerView.swift
//  BattleBucksAssignment
//
//  Created by Md Akhlak on 18/10/25.
//

import SwiftUI

// MARK: - Shimmer Modifier
struct ShimmerModifier: ViewModifier {
    @State private var isAnimating = false
    
    init(isAnimating: Bool = true) {
        self.isAnimating = isAnimating
    }
    
    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    colors: [
                        Color.clear,
                        Color.white.opacity(0.6),
                        Color.clear
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .rotationEffect(.degrees(30))
                .offset(x: isAnimating ? 200 : -200)
                .animation(
                    .linear(duration: 1.5)
                    .repeatForever(autoreverses: false),
                    value: isAnimating
                )
            )
            .onAppear {
                if isAnimating {
                    withAnimation(
                        .linear(duration: 1.5)
                        .repeatForever(autoreverses: false)
                    ) {
                        self.isAnimating = false
                    }
                }
            }
    }
}


// MARK: - Main Shimmer View
struct ShimmerView: View {
    var isAnimating: Bool = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Scrollable content
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    // Posts List Section
                    VStack(spacing: 12) {
                        ForEach(0..<6, id: \.self) { _ in
                            PostCardShimmerView(isAnimating: isAnimating)
                        }
                    }
                    .padding(.top, 16)
                    .padding(.horizontal, 20)
                }
            }
        }
    }
}

// MARK: - Post Card Shimmer
struct PostCardShimmerView: View {
    var isAnimating: Bool = true
    
    var body: some View {
        HStack(spacing: 16) {
            // Left side - Post icon and ID shimmer (matching PostCardView)
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(Color.secondary.opacity(0.1))
                        .frame(width: 40, height: 40)
                        .shimmer(isAnimating: isAnimating)
                }
                
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.secondary.opacity(0.1))
                    .frame(width: 20, height: 10)
                    .shimmer(isAnimating: isAnimating)
            }
            
            // Center - Content shimmer (matching PostCardView)
            VStack(alignment: .leading, spacing: 8) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.secondary.opacity(0.1))
                    .frame(height: 16)
                    .shimmer(isAnimating: isAnimating)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.secondary.opacity(0.1))
                    .frame(height: 14)
                    .shimmer(isAnimating: isAnimating)
                    .frame(width: UIScreen.main.bounds.width * 0.6)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Right side - Favorite button shimmer (matching PostCardView)
            VStack {
                Circle()
                    .fill(Color.secondary.opacity(0.1))
                    .frame(width: 40, height: 40)
                    .shimmer(isAnimating: isAnimating)
                
                Spacer()
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.1), lineWidth: 1)
        )
    }
}

// MARK: - Favorites Shimmer Views
struct FavoritesShimmerView: View {
    var isAnimating: Bool = true
    var selectedLayout: FavoritesView.LayoutType = .list
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Scrollable content
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    if selectedLayout == .grid {
                        // Grid layout shimmer
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 16),
                            GridItem(.flexible(), spacing: 16)
                        ], spacing: 16) {
                            ForEach(0..<10, id: \.self) { _ in
                                FavoriteCardShimmerView(isAnimating: isAnimating)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 24)
                        .padding(.bottom, 100)
                    } else {
                        // List layout shimmer
                        LazyVStack(spacing: 16) {
                            ForEach(0..<10, id: \.self) { _ in
                                FavoriteListItemShimmerView(isAnimating: isAnimating)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 24)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
    }
}

struct FavoriteCardShimmerView: View {
    var isAnimating: Bool = true
    
    var body: some View {
        VStack(spacing: 12) {
            // Top section with user info and favorite button
            HStack {
                Circle()
                    .fill(Color.secondary.opacity(0.1))
                    .frame(width: 32, height: 32)
                    .shimmer(isAnimating: isAnimating)
                
                Spacer()
                
                Circle()
                    .fill(Color.secondary.opacity(0.1))
                    .frame(width: 40, height: 40)
                    .shimmer(isAnimating: isAnimating)
            }
            
            // Content
            VStack(alignment: .leading, spacing: 8) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.secondary.opacity(0.1))
                    .frame(height: 14)
                    .shimmer(isAnimating: isAnimating)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.secondary.opacity(0.1))
                    .frame(height: 12)
                    .shimmer(isAnimating: isAnimating)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.secondary.opacity(0.1))
                    .frame(height: 10)
                    .shimmer(isAnimating: isAnimating)
                    .frame(width: 60)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.1), lineWidth: 1)
        )
    }
}

struct FavoriteListItemShimmerView: View {
    var isAnimating: Bool = true
    
    var body: some View {
        HStack(spacing: 16) {
            // User avatar shimmer
            VStack(alignment: .center, spacing: 4) {
                Circle()
                    .fill(Color.secondary.opacity(0.1))
                    .frame(width: 48, height: 48)
                    .shimmer(isAnimating: isAnimating)
                
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.secondary.opacity(0.1))
                    .frame(width: 30, height: 10)
                    .shimmer(isAnimating: isAnimating)
            }
            
            // Content shimmer
            VStack(alignment: .leading, spacing: 8) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.secondary.opacity(0.1))
                    .frame(height: 18)
                    .shimmer(isAnimating: isAnimating)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.secondary.opacity(0.1))
                    .frame(height: 16)
                    .shimmer(isAnimating: isAnimating)
                    .frame(width: UIScreen.main.bounds.width * 0.5)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Heart button shimmer
            Circle()
                .fill(Color.secondary.opacity(0.1))
                .frame(width: 40, height: 40)
                .shimmer(isAnimating: isAnimating)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.gray.opacity(0.1), lineWidth: 1)
        )
    }
}

// MARK: - Legacy Shimmer Components (for backward compatibility)
struct ShimmerPostCard: View {
    var body: some View {
        PostCardShimmerView()
    }
}

struct ShimmerFavoriteCard: View {
    var body: some View {
        FavoriteCardShimmerView()
    }
}

struct ShimmerFavoriteListItem: View {
    var body: some View {
        FavoriteListItemShimmerView()
    }
}

// MARK: - Preview
#Preview("Posts Shimmer") {
    ShimmerView()
        .background(Color(.systemGray6))
}

#Preview("Favorites Grid Shimmer") {
    FavoritesShimmerView(selectedLayout: .grid)
        .background(
            LinearGradient(
                colors: [Color(.systemGray6), Color(.systemGray5)],
                startPoint: .top,
                endPoint: .bottom
            )
        )
}

#Preview("Favorites List Shimmer") {
    FavoritesShimmerView(selectedLayout: .list)
        .background(
            LinearGradient(
                colors: [Color(.systemGray6), Color(.systemGray5)],
                startPoint: .top,
                endPoint: .bottom
            )
        )
}

#Preview("Individual Components") {
    ScrollView {
        VStack(spacing: 16) {
            PostCardShimmerView()
            FavoriteCardShimmerView()
            FavoriteListItemShimmerView()
        }
        .padding()
    }
    .background(Color(.systemGray6))
}
