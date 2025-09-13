# GitHub Actions CI/CD Setup - Mhfatha App

## نعم، هذا المستودع يحتوي على GitHub Actions مكونة بشكل صحيح! 
## Yes, this repository has properly configured GitHub Actions!

This repository contains a complete CI/CD pipeline using GitHub Actions for both iOS and Android deployments.

## 📱 Available Workflows

### 1. iOS App Store Deployment (`AppstoreDeployment.yml`)
- **Trigger**: Manual dispatch (`workflow_dispatch`)
- **Platform**: macOS runner
- **Purpose**: Deploy to TestFlight for iOS App Store
- **Flutter Version**: 3.16.6

**Features:**
- ✅ Automatic Xcode setup to latest stable
- ✅ Flutter installation and caching
- ✅ iOS build without code signing
- ✅ Fastlane integration for TestFlight deployment
- ✅ Secure handling of certificates and provisioning profiles

### 2. Android Play Store Deployment (`android-deploy.yml`)
- **Trigger**: Manual dispatch (`workflow_dispatch`)
- **Platform**: Ubuntu 22.04
- **Purpose**: Deploy to Google Play Store internal track
- **Flutter Version**: 3.16.6

**Features:**
- ✅ Two-stage pipeline (Build → Deploy)
- ✅ Android App Bundle (AAB) generation
- ✅ Encrypted keystore handling
- ✅ Artifact upload to GitHub
- ✅ Fastlane integration for Play Store deployment

## 🔧 Configuration Details

### Required Secrets

#### iOS Deployment Secrets:
- `ITC_TEAM_ID` - App Store Connect Team ID
- `APPLICATON_ID` - Apple Application ID
- `BUNDLE_IDENTIFIER` - iOS Bundle Identifier
- `DEVELOPER_PORTAL_TEAM_ID` - Apple Developer Portal Team ID
- `FASTLANE_APPLE_EMAIL_ID` - Apple ID email
- `APP_SPECIFIC_PASSWORD` - App-specific password
- `MATCH_PASSWORD` - Fastlane Match password
- `GIT_AUTHORIZATION` - Git authorization for certificates
- `PROVISIONING_PROFILE_SPECIFIER` - Provisioning profile name
- `TEMP_KEYCHAIN_PASSWORD` - Temporary keychain password
- `TEMP_KEYCHAIN_USER` - Temporary keychain user

#### Android Deployment Secrets:
- `PASSPHRASE` - GPG passphrase for decrypting Android keystore

### Security Features

#### Android Security:
- **Encrypted Keystore**: Android signing keys are encrypted using GPG
- **Secure Decryption**: Automated decryption during CI/CD pipeline
- **Key Files**: Stored as `android/key_files.zip.gpg`

#### iOS Security:
- **Fastlane Match**: Certificate and provisioning profile management
- **Temporary Keychains**: Secure handling of signing certificates
- **Environment Variables**: All sensitive data stored as GitHub secrets

## 🚀 Deployment Tracks

### Android Tracks (via Fastlane):
1. **Internal** - Development builds
2. **Alpha** - Limited testing
3. **Beta** - Extended testing
4. **Production** - Public release

### iOS Tracks:
1. **TestFlight** - Internal and external testing

## 📋 Usage Instructions

### Triggering Deployments:

1. **Go to Actions tab** in GitHub repository
2. **Select desired workflow**:
   - "Appstore Deployment" for iOS
   - "Playstore deployment" for Android
3. **Click "Run workflow"**
4. **Select branch** (usually `main` or `master`)
5. **Click "Run workflow"** button

### Prerequisites:
- All required secrets must be configured in repository settings
- Android keystore must be encrypted and committed as `android/key_files.zip.gpg`
- iOS certificates must be properly configured in Fastlane Match

## 🔄 Workflow Status

Both workflows are currently configured for **manual deployment only** to prevent accidental releases. To enable automatic deployment on push:

1. Uncomment the `push` trigger in workflow files
2. Specify target branch (e.g., `main`, `master`, or `release`)

```yaml
on: 
  workflow_dispatch
  push:
    branches:
      - main  # or your preferred branch
```

## 📊 Build Information

- **App Version**: 1.2.4+45 (from `pubspec.yaml`)
- **Flutter SDK**: 3.16.6
- **Android Target**: API level varies based on `android/build.gradle`
- **iOS Target**: Configured in Xcode project

## 🛠️ Maintenance

### Regular Tasks:
- ✅ Update Flutter version in workflows when needed
- ✅ Renew iOS certificates and provisioning profiles
- ✅ Update Android keystore if needed
- ✅ Monitor workflow execution for failures
- ✅ Update dependencies in `pubspec.yaml`

### Troubleshooting:
- Check GitHub Actions logs for detailed error information
- Verify all secrets are properly configured
- Ensure Android keystore decryption is working
- Validate iOS certificate and provisioning profile setup

---

**الخلاصة**: نعم، هذا المستودع يحتوي على نظام GitHub Actions متكامل لنشر التطبيق على متجري Apple App Store و Google Play Store. النظام مكون بشكل احترافي ومؤمن.

**Summary**: Yes, this repository has a complete GitHub Actions system for deploying the app to both Apple App Store and Google Play Store. The system is professionally configured and secured.