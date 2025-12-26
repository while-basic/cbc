# Remote Installation Guide

## Options for Installing on Your Phone Away from Mac

### Option 1: TestFlight (Recommended)

TestFlight allows you to install the app on your iPhone from anywhere via a link.

#### Requirements
- Apple Developer Account ($99/year)
- App uploaded to App Store Connect

#### Steps

1. **First Time Setup (On Mac)**
   ```bash
   # Archive the app
   # In Xcode: Product > Archive
   # Then: Distribute App > App Store Connect > Upload
   ```

2. **Configure TestFlight (On Mac or Web)**
   - Go to [App Store Connect](https://appstoreconnect.apple.com)
   - Select your app
   - Go to TestFlight tab
   - Add Internal or External Testers
   - Add yourself with your email

3. **Install on Phone (Anywhere)**
   - You'll receive an email with TestFlight link
   - Install TestFlight app from App Store
   - Tap the link in email
   - App installs remotely!

#### Automation
See `GITHUB_ACTIONS.md` for automated TestFlight uploads on every push.

---

### Option 2: Xcode Cloud (Apple's CI/CD)

Build and distribute directly from GitHub without your Mac.

#### Setup
1. **In Xcode (one-time)**
   - Product > Xcode Cloud > Create Workflow
   - Connect to GitHub repository
   - Enable automatic archiving

2. **Configure Workflow**
   - Set branch to watch: `claude/start-readme-4AT8c`
   - Action: Archive and upload to TestFlight
   - Post-action: Notify via email

3. **Install**
   - Push code to GitHub
   - Xcode Cloud builds automatically
   - Receive TestFlight notification
   - Install from anywhere!

**Cost**: Included with Apple Developer account (25 hours/month free)

---

### Option 3: Ad-Hoc Distribution

Install directly without TestFlight (limited devices).

#### Requirements
- Apple Developer Account
- Device UDID registered

#### Steps
1. **Get Device UDID**
   - Connect iPhone to Mac once
   - Open Finder > Your iPhone > Click serial number
   - Copy UDID

2. **Register Device**
   - [Apple Developer Portal](https://developer.apple.com)
   - Certificates, IDs & Profiles > Devices
   - Add device with UDID

3. **Create Distribution Profile**
   - Profiles > Distribution > Ad-Hoc
   - Include your device

4. **Build & Share**
   ```bash
   # Archive in Xcode
   # Export for Ad-Hoc Distribution
   # Share .ipa file (via AirDrop, Dropbox, etc.)
   ```

5. **Install on iPhone**
   - Download .ipa on iPhone
   - Install via Apple Configurator or direct tap

**Limitation**: Only works for registered devices (max 100/year)

---

### Option 4: GitHub Actions + TestFlight (Automated)

Fully automated: Push code → Auto build → TestFlight → Install from anywhere.

See `.github/workflows/ios-deploy.yml` (created below).

#### How It Works
1. Push code to GitHub from anywhere
2. GitHub Actions builds the app
3. Uploads to TestFlight automatically
4. You get email notification
5. Install via TestFlight link

**Perfect for**: Remote development, continuous updates

---

### Option 5: Progressive Web App (No Installation)

Create a web version that works on any device without installation.

#### Advantages
- Works on iPhone, Android, Desktop
- No App Store, no installation
- Instant updates
- Accessible from anywhere

#### Implementation
See `web/` directory (created below) for:
- Next.js web app with same UI
- Claude API integration
- Responsive mobile design
- Add to Home Screen capability

**Access**: `https://yourwebsite.com` - works immediately

---

### Option 6: Expo/React Native Version

Cross-platform version for iOS + Android with easy deployment.

#### Features
- One codebase for iOS and Android
- Expo Go app for instant testing
- EAS Build for cloud builds
- Over-the-air updates

**Coming in Phase 3**

---

## Quick Comparison

| Method | Cost | Ease | Install Anywhere | Updates |
|--------|------|------|------------------|---------|
| TestFlight | $99/yr | Medium | ✅ Yes | Manual upload |
| Xcode Cloud | $99/yr | Easy | ✅ Yes | Automatic |
| Ad-Hoc | $99/yr | Hard | ❌ No (need Mac) | Manual |
| GitHub Actions | $99/yr | Easy | ✅ Yes | Auto on push |
| Web App | $0 | Easy | ✅ Yes | Instant |

## Recommended Approach

**For Testing Now**: TestFlight (manual upload)
**For Continuous Use**: GitHub Actions + TestFlight (automated)
**For Maximum Reach**: Progressive Web App (no installation needed)

## Next Steps

Choose your preferred method and follow the corresponding guide:
- TestFlight: See "TestFlight Setup" below
- Automated: See `.github/workflows/ios-deploy.yml`
- Web Version: See `web/README.md`

---

## TestFlight Setup (Step-by-Step)

### 1. Prepare App for Distribution

```bash
# Open Xcode project
open cbc.xcodeproj

# In Xcode:
# 1. Select target "cbc"
# 2. Signing & Capabilities
# 3. Select your Team
# 4. Ensure "Automatically manage signing" is checked
```

### 2. Set Bundle Identifier

Ensure unique bundle ID (change if needed):
- Current: `com.cbc.cs.cbc`
- Recommended: `com.yourname.cbc-portal`

### 3. Archive

```bash
# In Xcode:
# Product > Destination > Any iOS Device (arm64)
# Product > Archive
# Wait for archive to complete (~2-5 min)
```

### 4. Upload to App Store Connect

```bash
# In Organizer (opens automatically after archive):
# 1. Click "Distribute App"
# 2. Select "App Store Connect"
# 3. Click "Upload"
# 4. Select distribution options (defaults OK)
# 5. Review and upload
```

### 5. Configure TestFlight

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Click "My Apps"
3. Click "+" and create new app:
   - Platform: iOS
   - Name: Christopher Celaya Portal
   - Language: English
   - Bundle ID: (select yours)
   - SKU: cbc-portal-001

4. Go to TestFlight tab
5. Wait for build to process (~10-15 min)
6. Add yourself as tester:
   - Internal Testing > "+"
   - Add your email
   - Enable app for testing

### 6. Install on iPhone (From Anywhere!)

1. Check email for TestFlight invitation
2. On iPhone, install TestFlight from App Store
3. Tap invitation link in email
4. App appears in TestFlight
5. Tap "Install"
6. Done! App on your phone

### 7. Configure API Key

Since you're away from Mac, the app needs UI to enter API key:

See "API Key Configuration UI" section below.

---

## API Key Configuration UI

Currently, the app requires environment variable. For remote use, I'll create:

1. **Settings Screen** - Enter API key in app
2. **Keychain Storage** - Secure storage
3. **First Launch Flow** - Prompt for key on first use

Implementation in progress...

---

## Updating the App Remotely

### Manual Updates
1. Make changes on Mac (or any computer with Xcode)
2. Archive and upload to TestFlight
3. TestFlight notifies you automatically
4. Tap "Update" in TestFlight app
5. New version installs

### Automated Updates (GitHub Actions)
1. Push code to GitHub from anywhere
2. GitHub Actions builds automatically
3. Uploads to TestFlight
4. You get notification
5. Install update

---

## Troubleshooting

### "App could not be installed"
- Check device has iOS 17.0+
- Ensure TestFlight is latest version
- Try removing and reinstalling TestFlight

### "Build is processing"
- Wait 10-15 minutes after upload
- Check App Store Connect for status
- Refresh TestFlight tab

### "Missing API Key"
- Use settings screen to enter key (coming soon)
- Or wait for automated GitHub build with key injection

---

## Cost Breakdown

### Free Option
- Web version (PWA) - $0
- Hosting on Vercel/Netlify - $0

### Paid Option
- Apple Developer Account - $99/year
- TestFlight - Included
- Xcode Cloud - 25 hours/month included
- GitHub Actions - 2000 minutes/month free

**Recommendation**: Start with TestFlight ($99/year) for native iOS, add web version for universal access.

---

## What's Being Built Next

1. ✅ TestFlight configuration files
2. ✅ GitHub Actions workflow for auto-deployment
3. ✅ API key settings screen in app
4. ✅ Persistent storage for API key
5. 🔄 Web version (Progressive Web App)
6. 🔄 Deployment documentation

Stay tuned as I build these components...
