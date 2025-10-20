# BattleBucks Assignment - SwiftUI Posts App

A modern SwiftUI application built with MVVM architecture that fetches and displays posts from JSONPlaceholder API, featuring an Airbnb-style card layout, search functionality, and favorites management.

## 📱 Features

- **Modern UI**: Airbnb-style card layout with rounded corners and subtle shadows
- **Search**: Real-time search functionality to filter posts by title
- **Favorites**: Heart icon to toggle favorite posts with persistent state
- **Navigation**: Tab-based navigation between "All Posts" and "Favorites"
- **Detail View**: Full-screen post details with favorite toggle
- **Loading States**: Loading indicators and error handling
- **Pull-to-Refresh**: Swipe down to refresh posts
- **Responsive Design**: Grid layout that adapts to different screen sizes

## 🏗️ Architecture

This app follows the **MVVM (Model-View-ViewModel)** pattern:

- **Model**: `Post` struct with Codable conformance
- **View**: SwiftUI views (`PostsListView`, `PostDetailView`, `FavoritesView`)
- **ViewModel**: `PostsViewModel` managing state and business logic
- **Service**: `NetworkService` for API communication

## 🛠️ Setup Instructions

### Prerequisites
- **iOS**: 15.0+
- **Xcode**: 14.0+
- **Swift**: 5.7+

### Installation
1. Clone the repository
2. Open `BattleBucksAssignment.xcodeproj` in Xcode
3. Build and run the project (⌘+R)

### Project Structure
```
BattleBucksAssignment/
├── Models/
│   └── Post.swift
├── Services/
│   └── NetworkService.swift
├── ViewModels/
│   └── PostsViewModel.swift
├── Views/
│   ├── PostsListView.swift
│   ├── PostDetailView.swift
│   └── FavoritesView.swift
├── ContentView.swift
└── BattleBucksAssignmentApp.swift
```

## 🔧 Technical Implementation

### API Integration
- **Endpoint**: `https://jsonplaceholder.typicode.com/posts`
- **Method**: GET
- **Response**: Array of Post objects with `userId`, `id`, `title`, and `body`

### Key Components

#### Post Model
```swift
struct Post: Codable, Identifiable, Hashable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
```

#### NetworkService
- Singleton pattern for shared instance
- Async/await for modern concurrency
- Comprehensive error handling
- URLSession for network requests

#### PostsViewModel
- `@Published` properties for reactive UI updates
- `@MainActor` for UI thread safety
- Computed properties for filtered posts
- State management for loading and errors

#### UI Features
- **Airbnb-style Cards**: Rounded corners, shadows, grid layout
- **Search Bar**: Real-time filtering with `@Published searchText`
- **Heart Icons**: Animated favorite toggle with `withAnimation`
- **Loading States**: Progress indicators and error messages
- **Pull-to-Refresh**: Native SwiftUI `.refreshable` modifier

## 🎨 Design System

### Color Scheme
- **Primary**: System colors for light/dark mode support
- **Accent**: Red for heart icons and tab selection
- **Background**: System grouped background for card separation

### Typography
- **Headlines**: Bold, large titles for post names
- **Body**: Regular text for post content
- **Captions**: Secondary text for metadata

### Layout
- **Grid**: 2-column responsive layout
- **Spacing**: 16pt standard spacing
- **Padding**: 20pt for content areas
- **Corner Radius**: 16pt for cards, 12pt for search bar

## 🚀 Features Breakdown

### 1. Post List Screen
- Grid layout with Airbnb-style cards
- Search bar with real-time filtering
- Loading states and error handling
- Pull-to-refresh functionality

### 2. Search Functionality
- Real-time search as you type
- Case-insensitive title filtering
- Maintains scroll position during search

### 3. Detail Screen
- Full-screen post details
- Shared ViewModel for favorite sync
- Heart icon for favorite toggle
- Clean, readable typography

### 4. Favorites Tab
- Dedicated favorites view
- Same card layout as main list
- Empty state with helpful messaging
- Persistent favorites across app sessions

### 5. Bonus Features
- **Loading Indicators**: Spinner with descriptive text
- **Error Handling**: User-friendly error messages with retry option
- **Pull-to-Refresh**: Native iOS gesture for data refresh
- **Animations**: Smooth transitions for favorite toggles

## 🔄 Data Flow

1. **App Launch**: `PostsViewModel` fetches posts from API
2. **User Interaction**: Search text updates filtered posts
3. **Favorite Toggle**: Updates `favorites` Set, triggers UI refresh
4. **Navigation**: Tab switching maintains state via `@EnvironmentObject`
5. **Detail View**: Shares ViewModel for consistent favorite state

## 🎯 Future Improvements

### Potential Enhancements
- **Images**: Add AsyncImage support for post thumbnails
- **Caching**: Implement local storage for offline support
- **Pagination**: Load more posts as user scrolls
- **Categories**: Filter posts by user or category
- **Animations**: More sophisticated transition animations
- **Accessibility**: VoiceOver and Dynamic Type support
- **Testing**: Unit tests for ViewModel and NetworkService

### Performance Optimizations
- **Lazy Loading**: Only load visible cards
- **Image Caching**: Cache downloaded images
- **Memory Management**: Proper cleanup of network requests
- **Background Refresh**: Update data when app becomes active

## 📱 Screenshots

The app features:
- Clean, modern interface inspired by Airbnb's design language
- Intuitive navigation with tab-based structure
- Responsive grid layout for optimal viewing
- Smooth animations and transitions
- Consistent visual hierarchy

## 🤝 Contributing

This project demonstrates:
- Modern SwiftUI development practices
- MVVM architecture implementation
- Clean code organization
- User experience best practices
- iOS development standards

## 📄 License

This project is created as part of the BattleBucks assignment and demonstrates modern iOS development practices with SwiftUI and MVVM architecture.

