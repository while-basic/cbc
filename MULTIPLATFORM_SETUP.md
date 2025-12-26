# Multiplatform App Setup - iOS Companion & watchOS

This project is now configured as a multiplatform app with:
- **iOS Companion App** - Full-featured chat interface
- **watchOS App** - Compact watch interface
- **macOS App** - Desktop version
- **Shared Code** - Models, Services, ViewModels, Extensions

## Project Structure

```
cbc/
├── cbc/                          # Main app (iOS/macOS)
│   ├── cbcApp.swift              # App entry (platform-aware)
│   ├── ContentView.swift         # macOS view
│   ├── ContentView_iOS.swift     # iOS view
│   ├── Models/                   # Shared models
│   ├── Services/                 # Shared services
│   ├── ViewModels/               # Shared view models
│   ├── Views/                    # iOS/macOS views
│   └── Extensions/               # Shared extensions
│
└── cbc Watch App/                # watchOS app
    ├── cbcWatchApp.swift         # watchOS entry point
    ├── WatchContentView.swift    # Main watch view
    ├── WatchMessageBubbleView.swift
    ├── WatchChatInputView.swift
    └── WatchProjectCardView.swift
```

## Platform-Specific Features

### iOS Companion App
- Full-screen chat interface
- Optimized for iPhone and iPad
- Uses `ContentView_iOS.swift`

### watchOS App
- Compact interface optimized for Apple Watch
- Simplified input and message display
- Uses watchOS-specific views

### macOS App
- Desktop-optimized layout
- Uses `ContentView.swift`

## Shared Components

All platforms share:
- **Models**: `Message`, `Project`, `KnowledgeBase`
- **Services**: `ClaudeService` (API communication)
- **ViewModels**: `ChatViewModel` (shared state management)
- **Extensions**: `Color+Hex` (color utilities)

## Next Steps

1. **Add watchOS Target in Xcode**:
   - See `SETUP_WATCHOS.md` for detailed instructions
   - Add target through Xcode UI
   - Configure target membership for shared files

2. **Configure App Groups** (for data sharing between iOS and watchOS):
   - Add App Groups capability to both iOS and watchOS targets
   - Use group: `group.com.cbc.cs.cbc`

3. **Test on Devices**:
   - Build and run iOS app on iPhone/iPad
   - Build and run watchOS app on Apple Watch or simulator
   - Test data synchronization between devices

## Building

### iOS
```bash
# Build for iOS simulator
xcodebuild -project cbc.xcodeproj -scheme cbc -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 17 Pro Max'
```

### watchOS
```bash
# Build for watchOS simulator
xcodebuild -project cbc.xcodeproj -scheme "cbc Watch App" -sdk watchsimulator
```

### All Platforms
```bash
# Build all targets
xcodebuild -project cbc.xcodeproj -scheme cbc -sdk iphonesimulator build
xcodebuild -project cbc.xcodeproj -scheme "cbc Watch App" -sdk watchsimulator build
```

## Code Sharing Strategy

- **Conditional Compilation**: Use `#if os(iOS)`, `#if os(watchOS)`, `#if os(macOS)` for platform-specific code
- **Shared Targets**: Models, Services, ViewModels are included in all targets
- **Platform Views**: Each platform has its own view implementations optimized for its UI constraints

## Notes

- The watchOS app uses simplified UI components optimized for small screens
- All platforms share the same `ChatViewModel` for consistent state
- API calls through `ClaudeService` work across all platforms
- Color extensions work on all platforms
