//
//  ContentView.swift
//  BattleBucksAssignment
//
//  Created by Md Akhlak on 18/10/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var postsViewModel = PostsViewModel()
    
    var body: some View {
        TabView {
            PostsListView()
                .environmentObject(postsViewModel)
                .tabItem {
                    Image(systemName: "list.bullet.rectangle")
                    Text("Posts")
                }
            
            FavoritesView()
                .environmentObject(postsViewModel)
                .tabItem {
                    Image(systemName: "heart")
                    Text("Favorites")
                }
        }
        .accentColor(.red)
        .onAppear {
            // Customize tab bar appearance
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.systemBackground
            
            // Active tab styling
            appearance.stackedLayoutAppearance.normal.iconColor = UIColor.systemGray
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
                .foregroundColor: UIColor.systemGray
            ]
            
            // Selected tab styling
            appearance.stackedLayoutAppearance.selected.iconColor = UIColor.systemRed
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
                .foregroundColor: UIColor.systemRed
            ]
            
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

#Preview {
    ContentView()
}
