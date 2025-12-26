# watchOS App Setup Instructions

## Adding watchOS Target to Xcode Project

Since the watchOS target needs to be added through Xcode's UI, follow these steps:

### Step 1: Add watchOS Target
1. Open `cbc.xcodeproj` in Xcode
2. Click on the project in the navigator (top item)
3. Click the "+" button at the bottom of the targets list
4. Select "watchOS" → "App"
5. Name it "cbc Watch App"
6. Set Bundle Identifier to: `com.cbc.cs.cbc.watchkitapp`
7. Set Language to Swift
8. Uncheck "Include Notification Scene" (unless you want notifications)

### Step 2: Configure Target Settings
1. Select the "cbc Watch App" target
2. In "General" tab:
   - Set Deployment Target to watchOS 10.0 or later
   - Set Development Team to your team (APHMV4Q24X)
3. In "Build Settings":
   - Set "Supported Platforms" to include `watchos`
   - Set "WATCHOS_DEPLOYMENT_TARGET" to 10.0

### Step 3: Add Files to Target
1. Select all files in the "cbc Watch App" folder
2. In File Inspector, check "cbc Watch App" target membership
3. For shared code (Models, Services, ViewModels, Extensions):
   - Select these files in the main "cbc" folder
   - In File Inspector, check BOTH "cbc" and "cbc Watch App" targets

### Step 4: Configure App Groups (for data sharing)
1. Select "cbc" target → "Signing & Capabilities"
2. Click "+ Capability" → Add "App Groups"
3. Create group: `group.com.cbc.cs.cbc`
4. Repeat for "cbc Watch App" target with same group

### Step 5: Build and Run
1. Select "cbc Watch App" scheme
2. Choose a watchOS simulator or paired Apple Watch
3. Build and run (⌘R)

## File Structure Created

```
cbc Watch App/
├── cbcWatchApp.swift          # watchOS app entry point
├── WatchContentView.swift      # Main watchOS view
├── WatchMessageBubbleView.swift
├── WatchChatInputView.swift
├── WatchProjectCardView.swift
└── Assets.xcassets/
    └── AppIcon.appiconset/
```

## Shared Code
The following are shared between iOS and watchOS:
- Models/ (Message, Project, KnowledgeBase)
- Services/ (ClaudeService)
- ViewModels/ (ChatViewModel)
- Extensions/ (Color+Hex)

Make sure these files are included in both targets!
