//
//  ShimmerView.swift
//  BattleBucksAssignment
//
//  Created by Md Akhlak on 18/10/25.
//

import SwiftUI

struct ShimmerView: View, ShapeStyle {
    @State private var isAnimating = false
    
    var body: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [
                        Color.gray.opacity(0.2),
                        Color.gray.opacity(0.4),
                        Color.gray.opacity(0.2)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .mask(
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.clear,
                                Color.white.opacity(0.8),
                                Color.clear
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .rotationEffect(.degrees(30))
                    .offset(x: isAnimating ? 200 : -200)
            )
            .onAppear {
                withAnimation(
                    .linear(duration: 1.5)
                    .repeatForever(autoreverses: false)
                ) {
                    isAnimating = true
                }
            }
    }
}

struct ShimmerPostCard: View {
    var body: some View {
        HStack(spacing: 16) {
            // Left side - Post icon and ID shimmer (matching PostCardView)
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(ShimmerView())
                        .frame(width: 40, height: 40)
                }
                
                Rectangle()
                    .fill(ShimmerView())
                    .frame(width: 20, height: 10)
                    .cornerRadius(5)
            }
            
            // Center - Content shimmer (matching PostCardView)
            VStack(alignment: .leading, spacing: 8) {
                Rectangle()
                    .fill(ShimmerView())
                    .frame(height: 16)
                    .cornerRadius(4)
                
                Rectangle()
                    .fill(ShimmerView())
                    .frame(height: 14)
                    .cornerRadius(4)
                    .frame(width: UIScreen.main.bounds.width * 0.6)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Right side - Favorite button shimmer (matching PostCardView)
            VStack {
                Circle()
                    .fill(ShimmerView())
                    .frame(width: 40, height: 40)
                
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

struct ShimmerFavoriteCard: View {
    var body: some View {
        VStack(spacing: 12) {
            // Top section with user info and favorite button
            HStack {
                Circle()
                    .fill(ShimmerView())
                    .frame(width: 32, height: 32)
                
                Spacer()
                
                Circle()
                    .fill(ShimmerView())
                    .frame(width: 40, height: 40)
            }
            
            // Content
            VStack(alignment: .leading, spacing: 8) {
                Rectangle()
                    .fill(ShimmerView())
                    .frame(height: 14)
                    .cornerRadius(4)
                
                Rectangle()
                    .fill(ShimmerView())
                    .frame(height: 12)
                    .cornerRadius(4)
                
                Rectangle()
                    .fill(ShimmerView())
                    .frame(height: 10)
                    .cornerRadius(4)
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

struct ShimmerFavoriteListItem: View {
    var body: some View {
        HStack(spacing: 16) {
            // User avatar shimmer
            VStack(alignment: .center, spacing: 4) {
                Circle()
                    .fill(ShimmerView())
                    .frame(width: 48, height: 48)
                
                Rectangle()
                    .fill(ShimmerView())
                    .frame(width: 30, height: 10)
                    .cornerRadius(5)
            }
            
            // Content shimmer
            VStack(alignment: .leading, spacing: 8) {
                Rectangle()
                    .fill(ShimmerView())
                    .frame(height: 18)
                    .cornerRadius(4)
                
                Rectangle()
                    .fill(ShimmerView())
                    .frame(height: 16)
                    .cornerRadius(4)
                    .frame(width: UIScreen.main.bounds.width * 0.5)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Heart button shimmer
            Circle()
                .fill(ShimmerView())
                .frame(width: 40, height: 40)
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

#Preview {
    VStack(spacing: 16) {
        ShimmerPostCard()
        ShimmerPostCard()
        ShimmerPostCard()
    }
    .padding()
    .background(Color(.systemGray6))
}
