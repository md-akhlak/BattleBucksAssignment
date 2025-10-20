//
//  PostDetailView.swift
//  BattleBucksAssignment
//
//  Created by Md Akhlak on 18/10/25.
//

import SwiftUI

struct PostDetailView: View {
    let post: Post
    @EnvironmentObject var viewModel: PostsViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var isFavorite = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    // Hero Section with gradient background
                    VStack(alignment: .leading, spacing: 0) {
                        // Title and metadata
                        VStack(alignment: .leading, spacing: 12) {
                            // User info with avatar
                            HStack(spacing: 12) {
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
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Spacer()
                                    
                                    Text("User \(post.userId)")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.primary)
                                    
                                    Spacer()
                                }
                                
                                Spacer()
                                
                                
                                Button(action: {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                        viewModel.toggleFavorite(for: post)
                                        isFavorite.toggle()
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
                            }
                            
                            // Main title
                            Text(post.title)
                                .font(.system(size: 28, weight: .bold, design: .default))
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.leading)
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                    }
                    
                    // Content Card
                    VStack(alignment: .leading, spacing: 0) {
                        VStack(alignment: .leading, spacing: 20) {
                            // Content header
                            HStack {
                                Text("About this post")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(.primary)
                                
                                Spacer()
                            }
                            
                            // Content body
                            Text(post.body)
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(.primary)
                                .lineSpacing(6)
                                .multilineTextAlignment(.leading)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(24)
                    }
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                    
                    // Additional info card
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "info.circle")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.blue)
                            
                            Text("Post Information")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            Spacer()
                        }
                        
                        VStack(spacing: 12) {
                            HStack {
                                Text("Post ID")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.secondary)
                                
                                Spacer()
                                
                                Text("#\(post.id)")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.primary)
                            }
                            
                            Divider()
                            
                            HStack {
                                Text("User ID")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.secondary)
                                
                                Spacer()
                                
                                Text("#\(post.userId)")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                    .padding(20)
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarHidden(true)
        }
        .onAppear {
            isFavorite = viewModel.isFavorite(post)
        }
    }
}

#Preview {
    PostDetailView(post: Post(userId: 1, id: 1, title: "Sample Post Title", body: "This is a sample post body content that demonstrates how the detail view will look with longer text content."))
        .environmentObject(PostsViewModel())
}

