# 🎮 Adsyield Unity SDK Integration Guide
## Complete Implementation for Android & iOS

Welcome to the comprehensive integration guide for the Adsyield SDK within Unity applications. This document provides detailed instructions to help developers successfully implement and leverage Adsyield's advertising capabilities in their Unity games.

## 📋 Table of Contents
- [Prerequisites](#prerequisites)
- [Overview](#overview)
- [SDK Files](#sdk-files)
- [Integration Process](#integration-process)
  - [Android Integration](#android-integration)
  - [iOS Integration](#ios-integration)
- [SDK Initialization & Usage](#sdk-initialization--usage)
- [Testing Implementation](#testing-implementation)
- [Troubleshooting](#troubleshooting)
- [FAQ](#faq)
- [Support & Contact](#support--contact)

## Prerequisites

Before beginning the integration process, ensure you have:

- Unity 2019.4 or newer
- A GitHub account (for accessing Adsyield's SDK repository)
- GitHub read token with package registry access
- CocoaPods installed (for iOS integration)
- Existing mediation platform integration (Applovin MAX, IronSource, or AdMob)
- Basic understanding of Unity's plugins system

## Overview

Adsyield provides adapter SDKs that connect with major mediation platforms. These adapters enable Adsyield's ad network to serve high-performing ads through your existing mediation setup.

> ✅ **Native SDK Formats**: 
> - Android: `.aar` library files
> - iOS: `.xcframework` packages
> 
> ⚙️ **Integration Method**: Unity's `Plugins` system

## SDK Files

The Adsyield SDK is delivered as platform-specific files:

1. **Android**: `adsyield_adapter_for_max.aar` (and other adapter variants Admob-iS)
2. **iOS**: `AdsyieldMaxAdapter.xcframework` (and other adapter variants Admob-iS)

## Integration Process

### Required Folder Structure

Create this folder structure in your Unity project:

```
Your Unity Project/
├── Assets/
│   ├── Plugins/
│   │   ├── Android/
│   │   │   └── adsyield_adapter_for_max.aar
│   │   ├── iOS/
│   │   │   └── AdsyieldMaxAdapter.xcframework
```

### Android Integration

Follow these detailed steps for Android integration:

#### 1. Import SDK Files
   - Create the directory path `Assets/Plugins/Android/` in your Unity project if it doesn't exist
   - Copy all provided `.aar` adapter files into this folder

#### 2. Configure Gradle Template
   - Navigate to: `Edit > Project Settings > Player > Publishing Settings`
   - Check ✅ `Custom Main Gradle Template`
   - This action generates a `mainTemplate.gradle` file in `Assets/Plugins/Android/`

#### 3. Modify Gradle Template
   - Open the `mainTemplate.gradle` file
   - Locate the `allprojects { repositories { ... } }` section
   - Add the following maven repositories:

```groovy
allprojects {
    repositories {
        // Existing repositories (google(), mavenCentral(), etc.)
        
        // Add Adsyield SDK repository
        maven {
            url "https://maven.pkg.github.com/bugranalci/adsyield-sdk"
            credentials {
                username = "bugranalci"  // Replace with actual GitHub username
                password = "YOUR_GITHUB_READ_TOKEN"  // Replace with actual GitHub token
            }
        }
        
        // Add repository (required for certain adapters)
        maven { url "https://jfrog.anythinktech.com/artifactory/overseas_sdk" }
    }
}
```

#### 4. Dependencies Configuration
   - In most cases, no additional Gradle dependencies are required
   - If specific adapter versions require additional dependencies, they will be provided separately
   - You can add them to the `dependencies { ... }` block when needed

#### 5. Build Settings
   - Ensure minimum Android API level is set to 19 or higher
   - Verify `Gradle build system` is selected in Publishing Settings

### iOS Integration

Follow these steps for iOS integration:

#### 1. Import SDK Files
   - Create the directory path `Assets/Plugins/iOS/` in your Unity project
   - Copy all provided `.xcframework` files into this folder

#### 2. Podfile Configuration
   - After building your Unity project for iOS, a Podfile will be generated
   - Open the Podfile located at: `/ios/Podfile` in the Xcode project folder
   - Add the Adsyield adapter pod:

```ruby
# Add this line to your Podfile
pod 'AdsyieldMaxAdapter', :git => 'https://github.com/bugranalci/adsyield-sdk.git', :tag => 'ios-1.0.0'

# For Admob:
pod 'AdmobAdsyieldAdapter', :git => 'https://github.com/bugranalci/adsyield-sdk.git', :tag => 'ios-1.0.0'

# For IronSource:
pod 'ISAdsyieldAdapter', :git => 'https://github.com/bugranalci/adsyield-sdk.git', :tag => 'ios-1.0.0'
```

> **Note**: Replace `ios-1.0.0` with the current version provided by your Adsyield representative

#### 3. CocoaPods Installation
   - Open Terminal
   - Navigate to your Xcode project's iOS folder:
```bash
cd /path/to/your/xcode/project/ios
```
   - Install the dependencies:
```bash
pod install
```

#### 4. Additional iOS Settings
   - Always open the `.xcworkspace` file after CocoaPods installation, not the `.xcodeproj` file
   - Ensure the deployment target is set to iOS 11.0 or higher
   - If using Unity 2019/2020, you may need to add this to Podfile: `platform :ios, '11.0'`

## SDK Initialization & Usage

The Adsyield adapter works with your existing mediation platform. No separate initialization is required.

#### Implementation Flow:

1. Initialize your mediation SDK (MAX, IronSource, or AdMob) as you normally would
2. Adsyield's adapter will automatically register itself with the mediation platform
3. Configure the Adsyield ad network in your mediation dashboard
4. Set up ad units with Adsyield demand

```csharp
// Example with MAX SDK (your actual code may differ)
MaxSdkCallbacks.OnSdkInitializedEvent += sdkConfiguration => {
    // Adsyield adapter will be automatically initialized
    // Create banner, interstitial, and rewarded ads as usual
};
```

## Testing Implementation

Follow these steps to verify correct SDK integration:

1. **Use Test Placements**:
   - Use test ad unit IDs provided by your mediation platform
   - Enable test mode in your mediation SDK when available

2. **Enable Verbose Logging**:
   - Enable detailed logs in your mediation platform
   - For MAX: `MaxSdk.SetVerboseLogging(true);`
   - For IronSource: `IronSource.setAdaptersDebug(true);`

3. **Check for Adapter Registration**:
   - Android: Use `adb logcat | grep -i adsyield` to filter logs
   - iOS: Check Xcode console for "Adsyield" entries

4. **Common Success Indicators**:
   - Log entries showing "Adsyield adapter initialized"
   - Successful ad requests from Adsyield
   - Ad impressions from the Adsyield network

## Troubleshooting

### Common Issues and Solutions

#### Android Issues:

1. **Missing Repository Credentials**:
   - Error: `Failed to resolve: com.adsyield...`
   - Solution: Verify GitHub username and token in `mainTemplate.gradle`

2. **Duplicate Classes**:
   - Error: `Duplicate class ... found in modules`
   - Solution: Check for conflicts between adapters and add exclusions if needed

3. **Minimum SDK Version**:
   - Error: `uses-sdk:minSdkVersion 16 cannot be smaller than version 19`
   - Solution: Update minSdkVersion in Player Settings to 19 or higher

#### iOS Issues:

1. **Pod Installation Failure**:
   - Error: `Unable to find a specification for 'AdsyieldMaxAdapter'`
   - Solution: Verify the pod specification and git URL/tag

2. **Architecture Issues**:
   - Error: `file was built for archive which is not the architecture being linked`
   - Solution: Ensure the proper architecture settings in Xcode

3. **Framework Not Found**:
   - Error: `framework not found AdsyieldMaxAdapter`
   - Solution: Verify the framework was correctly installed by CocoaPods

## FAQ

**Q: Can I use Adsyield with multiple mediation platforms simultaneously?**  
A: Yes, but you'll need to integrate the appropriate adapter for each platform separately.

**Q: Do I need to modify AndroidManifest.xml?**  
A: Generally no. However, specific ad networks like Ogury or IronSource may require additional manifest entries. These will be provided as needed.

**Q: How do I update the Adsyield SDK?**  
A: Replace the existing adapter files with the new versions and update any version references in your Podfile.

**Q: Does Adsyield support Unity IL2CPP?**  
A: Yes, Adsyield adapters are compatible with both Mono and IL2CPP scripting backends.

**Q: Do I need to run CocoaPods manually for iOS?**  
A: Yes, after adding the pod entry in your Podfile, you must run `pod install` manually.

**Q: How do I know if my integration is working correctly?**  
A: Check the mediation platform's reporting dashboard for Adsyield ad impressions and revenue.

## Support & Contact

If you encounter any issues during integration or have questions, we're here to help:

📧 **Email Support**: bnalci@adsyield.com  
💬 **Real-time Support**: Slack or Skype support is available upon request

When reporting an issue, please include:
- Unity version
- iOS/Android target platform and version
- Mediation platform and version
- Complete error logs
- Steps to reproduce the issue

---

## 💬 Support

bnalci@adsyield.com  
Slack / Skype support available on request 💙