# BattleBucks Assignment - SwiftUI Posts App

A SwiftUI application that fetches posts from JSONPlaceholder API and allows users to view, search, and manage favorite posts.

## 📱 Features

- **Post List**: Display all posts with title and userId
- **Search**: Real-time search functionality to filter posts by title
- **Favorites**: Heart icon to mark/unmark posts as favorite
- **Detail View**: Navigate to post details with full content
- **Favorites Tab**: Dedicated tab for favorite posts
- **Loading States**: Loading indicators while fetching posts
- **Error Handling**: Network failure handling with retry option
- **Pull-to-Refresh**: Swipe down to refresh posts

## 🏗️ Architecture

This app follows the **MVVM (Model-View-ViewModel)** pattern:

- **Model**: `Post` struct with Codable conformance for API data
- **View**: SwiftUI views (`PostsListView`, `PostDetailView`, `FavoritesView`)
- **ViewModel**: `PostsViewModel` managing state and business logic
- **Service**: `NetworkService` for API communication (separated from View)

## 🛠️ Project Setup Instructions

### Prerequisites
- **iOS**: 15.0+
- **Xcode**: 14.0+
- **Swift**: 5.7+

### Installation Steps
1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/BattleBucksAssignment.git
   cd BattleBucksAssignment
   ```

2. **Open the project in Xcode**
   - Open `BattleBucksAssignment.xcodeproj` in Xcode
   - Wait for Xcode to resolve dependencies

3. **Build and run the project**
   - Select your target device or simulator
   - Press ⌘+R or click the "Run" button
   - The app will build and launch automatically

### Project Configuration
- **Deployment Target**: iOS 15.0
- **Swift Version**: 5.7
- **No additional dependencies required** - uses only SwiftUI and Foundation frameworks

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
├── Extension/
│   └── Views.swift
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
- Handles all API communication
- Async/await for modern concurrency
- Comprehensive error handling
- Separated from View layer as per requirements

#### PostsViewModel
- `@Published` properties for reactive UI updates
- `@MainActor` for UI thread safety
- Computed properties for filtered posts
- State management for loading and errors

## 🚀 Features Implementation

### 1. Post List Screen
- Display posts in a List with title and userId
- Heart icon to mark/unmark posts as favorite
- Search TextField at the top for real-time filtering

### 2. Search Functionality
- Real-time search as you type
- Case-insensitive title filtering
- Maintains scroll position during search

### 3. Detail Screen
- Navigate to post details on tap
- Show title (large text) and body (regular text)
- Heart icon for favorite toggle

### 4. Favorites Tab
- Dedicated tab for favorite posts
- Display all favorited posts
- Same information as main list

### 5. Bonus Features
- **Loading Indicators**: Show loading state while fetching posts
- **Error Handling**: Handle network failures with retry option
- **Pull-to-Refresh**: Native iOS gesture for data refresh

## 🎯 Assumptions & Future Improvements

### Assumptions Made
- Used UserDefaults for persistent favorites storage
- Implemented basic error handling for network failures
- Added loading states for better user experience
- Used modern SwiftUI patterns (async/await, @MainActor)

### Improvements with More Time
- **Caching**: Implement local storage for offline support
- **Pagination**: Load more posts as user scrolls
- **Images**: Add support for post thumbnails if API provided them
- **Testing**: Unit tests for ViewModel and NetworkService
- **Accessibility**: VoiceOver and Dynamic Type support
- **Performance**: Lazy loading and memory optimization
- **Animations**: More sophisticated transition animations

## 📄 License

This project is created as part of the BattleBucks assignment and demonstrates SwiftUI development with MVVM architecture.

