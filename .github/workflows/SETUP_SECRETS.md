# GitHub Actions Secrets Setup

To enable automated TestFlight deployment, you need to configure these secrets in your GitHub repository.

## Required Secrets

Go to: `Settings > Secrets and variables > Actions > New repository secret`

### 1. BUILD_CERTIFICATE_BASE64
Your Apple Distribution certificate in base64 format.

**How to get it:**
```bash
# Export certificate from Keychain (on Mac)
# 1. Open Keychain Access
# 2. Find "Apple Distribution: Your Name"
# 3. Right-click > Export "Apple Distribution..."
# 4. Save as certificate.p12 with password

# Convert to base64
base64 -i certificate.p12 | pbcopy
# Paste in GitHub secret
```

### 2. P12_PASSWORD
The password you used when exporting the certificate.

### 3. KEYCHAIN_PASSWORD
Any secure password for temporary keychain (e.g., `TempKeychain123!`)

### 4. PROVISIONING_PROFILE_BASE64
Your provisioning profile in base64 format.

**How to get it:**
```bash
# Download from Apple Developer Portal
# 1. Go to https://developer.apple.com
# 2. Certificates, IDs & Profiles > Profiles
# 3. Download your App Store profile (.mobileprovision)

# Convert to base64
base64 -i YourProfile.mobileprovision | pbcopy
# Paste in GitHub secret
```

### 5. APP_STORE_CONNECT_API_KEY_ID
Your App Store Connect API Key ID.

**How to get it:**
```
1. Go to https://appstoreconnect.apple.com
2. Users and Access > Keys > App Store Connect API
3. Generate new key (select "Admin" access)
4. Copy the Key ID (looks like: ABC123DEFG)
```

### 6. APP_STORE_CONNECT_ISSUER_ID
Your App Store Connect Issuer ID.

**How to get it:**
```
1. Same page as API Key
2. Copy "Issuer ID" at top (looks like: a1b2c3d4-e5f6-...)
```

### 7. APP_STORE_CONNECT_API_KEY_BASE64
Your App Store Connect API Key in base64 format.

**How to get it:**
```bash
# When you create API key, download AuthKey_ABC123DEFG.p8

# Convert to base64
base64 -i AuthKey_ABC123DEFG.p8 | pbcopy
# Paste in GitHub secret
```

### 8. EXPORT_OPTIONS_PLIST
Export options for archiving.

**Create this file:**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>app-store</string>
    <key>teamID</key>
    <string>YOUR_TEAM_ID</string>
    <key>uploadBitcode</key>
    <false/>
    <key>compileBitcode</key>
    <false/>
    <key>uploadSymbols</key>
    <true/>
    <key>signingStyle</key>
    <string>manual</string>
    <key>provisioningProfiles</key>
    <dict>
        <key>com.cbc.cs.cbc</key>
        <string>YOUR_PROVISIONING_PROFILE_NAME</string>
    </dict>
</dict>
</plist>
```

**Convert to base64:**
```bash
base64 -i ExportOptions.plist | pbcopy
# Paste in GitHub secret
```

## Quick Setup Checklist

- [ ] Export distribution certificate as .p12
- [ ] Get BUILD_CERTIFICATE_BASE64 (base64 of .p12)
- [ ] Note P12_PASSWORD (password used for export)
- [ ] Set KEYCHAIN_PASSWORD (any secure password)
- [ ] Download provisioning profile
- [ ] Get PROVISIONING_PROFILE_BASE64 (base64 of .mobileprovision)
- [ ] Create App Store Connect API key
- [ ] Get APP_STORE_CONNECT_API_KEY_ID
- [ ] Get APP_STORE_CONNECT_ISSUER_ID
- [ ] Get APP_STORE_CONNECT_API_KEY_BASE64 (base64 of .p8)
- [ ] Create and encode EXPORT_OPTIONS_PLIST
- [ ] Add all secrets to GitHub repository

## Testing the Workflow

Once secrets are configured:

```bash
git add .
git commit -m "Add GitHub Actions workflow"
git push origin claude/start-readme-4AT8c
```

Check: `Actions` tab in GitHub to see build progress.

## Troubleshooting

### "Certificate not found"
- Verify BUILD_CERTIFICATE_BASE64 is correct
- Check P12_PASSWORD is correct
- Ensure certificate is valid (not expired)

### "Provisioning profile doesn't match"
- Bundle ID in profile must match app: `com.cbc.cs.cbc`
- Profile must include distribution certificate
- Profile must not be expired

### "API authentication failed"
- Verify all three API secrets are correct
- Ensure API key has "Admin" access
- Check key is not expired

### "Archive failed"
- Check Xcode version compatibility
- Verify scheme "cbc" exists
- Check for code signing issues

## Support

For issues:
1. Check Actions logs in GitHub
2. Review error messages
3. Verify all secrets are base64 encoded
4. Test build locally first with Xcode

## Next Steps After Setup

1. Push code to trigger build
2. Wait ~10-15 minutes for build
3. Check TestFlight for new build
4. Install on your iPhone from anywhere!
