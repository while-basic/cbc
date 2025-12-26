# Quick Start: Install on iPhone Away from Mac

## 🎯 Goal
Get this app on your iPhone when you're not near your Mac.

## ✅ What's Built
Your app is now **production-ready** with:
- ✅ In-app API key configuration (no environment variables needed)
- ✅ Secure Keychain storage for API key
- ✅ Persistent chat history across launches
- ✅ Settings screen for configuration
- ✅ GitHub Actions for automated builds
- ✅ TestFlight deployment ready

## 📱 Best Options for Remote Installation

### Option 1: TestFlight (Recommended - Takes 1 hour)

**Perfect if you have**: Apple Developer account ($99/year)

#### Step 1: Upload to TestFlight (One Time, On Mac)
```bash
# Open Xcode
open cbc.xcodeproj

# Archive the app
# Product > Archive (⌘B first to ensure it builds)
# Wait ~2-5 minutes

# Upload to App Store Connect
# In Organizer window that opens:
# 1. Click "Distribute App"
# 2. Select "App Store Connect"
# 3. Click "Upload"
# 4. Wait ~5-10 minutes for upload
```

#### Step 2: Configure TestFlight (On Mac or Any Browser)
```
1. Go to https://appstoreconnect.apple.com
2. Sign in with Apple ID
3. Click "My Apps"
4. Click "+" to create new app:
   - Name: Christopher Celaya Portal
   - Bundle ID: com.cbc.cs.cbc
   - SKU: cbc-portal-001
5. Go to "TestFlight" tab
6. Wait 10-15 minutes for build processing
7. Once build appears, click it
8. Under "Internal Testing" click "+"
9. Add yourself as tester (your email)
10. Enable build for testing
```

#### Step 3: Install on iPhone (From Anywhere!)
```
1. Check your email for TestFlight invitation
2. On iPhone, download "TestFlight" from App Store
3. Tap the invitation link from email
4. Tap "Install" in TestFlight
5. App appears on your home screen!
```

#### Step 4: Configure API Key (On iPhone)
```
1. Open the app
2. Tap the gear icon (top right)
3. Enter your Anthropic API key
   - Get it from: https://console.anthropic.com
   - It looks like: sk-ant-...
4. Tap "Save API Key Securely"
5. Done! Start chatting
```

**Total Time**: ~1 hour (most is waiting for processing)
**Cost**: $99/year for Apple Developer account
**Updates**: Repeat Step 1 to upload new versions

---

### Option 2: Automated GitHub Actions (Best for Continuous Updates)

**Perfect if you**: Want automatic deployments on every code push

#### Setup (One Time, ~30 minutes)

See `.github/workflows/SETUP_SECRETS.md` for complete guide.

**Quick Overview**:
1. Export certificates and provisioning profiles
2. Create App Store Connect API key
3. Add 8 secrets to GitHub repository
4. Push code → Automatic build → TestFlight

**After Setup**:
- Every git push triggers automatic build
- No Mac needed
- Uploads to TestFlight automatically
- You get email when build is ready
- Install via TestFlight

**Cost**: $99/year Apple Developer + Free GitHub Actions (2000 min/month)

---

### Option 3: Ad-Hoc Distribution (Limited Devices)

**Perfect if you**: Only need it on 1-2 devices, no subscription

#### Process
1. Register device UDID in Apple Developer Portal
2. Create Ad-Hoc provisioning profile
3. Archive and export with Ad-Hoc profile
4. Share .ipa file (AirDrop, Dropbox, etc.)
5. Install via Apple Configurator or direct tap

**Limitations**:
- Max 100 devices per year
- Still need Apple Developer account ($99/year)
- More complex than TestFlight
- Must re-register for updates

---

### Option 4: Xcode Cloud (Apple's CI/CD)

**Perfect if you**: Want Apple's native solution

#### Setup
1. In Xcode: Product > Xcode Cloud > Create Workflow
2. Connect to GitHub repository
3. Configure to archive on push
4. Enable TestFlight distribution

**After Setup**:
- Push code → Xcode Cloud builds
- Automatic TestFlight upload
- Email notification
- Install anywhere

**Cost**: Included with Apple Developer ($99/year), 25 hours/month free

---

## 🚀 Recommended Path

### For Immediate Testing:
1. Use **TestFlight** (Option 1)
2. Takes 1 hour
3. Works from anywhere after initial upload

### For Long-term Development:
1. Set up **GitHub Actions** (Option 2)
2. One-time 30-min setup
3. Automatic deployments forever

### For Maximum Accessibility:
1. Build **Web Version** (coming in Phase 3)
2. No installation needed
3. Works on any device
4. Instant updates

---

## 📋 Current Status

### ✅ Ready Now
- [x] In-app API key configuration
- [x] Secure Keychain storage
- [x] Persistent chat history
- [x] Settings screen
- [x] Complete TestFlight workflow
- [x] GitHub Actions configuration
- [x] All deployment documentation

### ⚡ Quick Start
1. Archive app in Xcode (5 min)
2. Upload to TestFlight (10 min)
3. Configure in App Store Connect (5 min)
4. Install on iPhone from email link (2 min)
5. Enter API key in app settings (1 min)
6. Start using! (0 min)

**Total**: ~25 minutes + 10-15 min processing time

---

## 🎓 Step-by-Step Guide for Complete Beginners

### Prerequisites
- [ ] Mac with Xcode installed
- [ ] Apple Developer account ($99/year)
- [ ] Anthropic API key (free tier available)
- [ ] iPhone running iOS 17.0+

### Part 1: Build the App (5 minutes)
```bash
# 1. Open the project
cd ~/cbc
open cbc.xcodeproj

# 2. In Xcode:
#    - Select your development team (Signing & Capabilities)
#    - Select "Any iOS Device" as destination
#    - Press ⌘B to build
#    - Fix any signing issues if needed
```

### Part 2: Archive (5 minutes)
```bash
# In Xcode:
# 1. Product > Archive
# 2. Wait for archive to complete
# 3. Organizer window opens automatically
```

### Part 3: Upload (10 minutes)
```bash
# In Organizer:
# 1. Select your archive
# 2. Click "Distribute App"
# 3. Choose "App Store Connect"
# 4. Click "Upload"
# 5. Follow prompts (use defaults)
# 6. Wait for upload to complete
```

### Part 4: TestFlight Setup (10 minutes)
```bash
# 1. Open https://appstoreconnect.apple.com
# 2. Create new app (if first time)
# 3. Go to TestFlight tab
# 4. Wait for build to process
# 5. Add yourself as tester
# 6. Enable build
```

### Part 5: Install on iPhone (2 minutes)
```bash
# 1. Check email on iPhone
# 2. Install TestFlight app
# 3. Tap invitation link
# 4. Tap "Install"
# 5. App appears on home screen
```

### Part 6: Configure (1 minute)
```bash
# 1. Open app
# 2. Tap gear icon
# 3. Get API key from console.anthropic.com
# 4. Paste and save
# 5. Start chatting!
```

---

## 📖 Documentation Reference

- **Complete Guide**: `DEPLOYMENT.md`
- **GitHub Actions Setup**: `.github/workflows/SETUP_SECRETS.md`
- **App Configuration**: `SETUP.md`
- **Project Overview**: `PROJECT_README.md`
- **Build Summary**: `BUILD_SUMMARY.md`

---

## 🆘 Quick Troubleshooting

### "No valid signing identity found"
- Go to Signing & Capabilities
- Select your Team
- Enable "Automatically manage signing"

### "Build processing" for >30 minutes
- Check App Store Connect for errors
- Verify bundle ID is unique
- Check email for rejection notice

### "API key not working"
- Verify key starts with `sk-ant-`
- Check key has valid permissions
- Ensure key not expired

### "App won't install from TestFlight"
- Check iPhone is iOS 17.0+
- Update TestFlight app
- Try removing and reinstalling TestFlight

---

## 💡 Pro Tips

1. **Save Time**: Set up GitHub Actions once, never manually upload again
2. **Test First**: Use TestFlight internal testing before external
3. **API Key**: Create separate key for mobile (easier to revoke)
4. **Updates**: TestFlight auto-notifies testers of new builds
5. **Storage**: Chat history persists, API key secure in Keychain

---

## 🎉 Success Checklist

After following this guide, you should have:
- [ ] App archived and uploaded to TestFlight
- [ ] TestFlight configured with you as tester
- [ ] App installed on iPhone
- [ ] API key configured in app
- [ ] First conversation completed
- [ ] Chat history persisting across app launches

**You're done!** The app now works completely remotely.

---

## 📞 Next Steps

### Immediate
- Test all demo queries
- Verify API key is secure
- Confirm chat history persists
- Share TestFlight link with others

### Soon
- Set up GitHub Actions for automated builds
- Create custom app icon
- Add more projects to knowledge base
- Record demo video

### Future
- Progressive Web App version
- Notion API integration for live data
- Voice input support
- Media playback

---

**Questions?** Check `DEPLOYMENT.md` for comprehensive details.

**Ready to start?** Open Xcode and follow Part 1 above!
