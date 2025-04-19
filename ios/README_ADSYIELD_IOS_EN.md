# �� Adsyield iOS SDK – Complete Integration Guide

## 📱 Overview

Welcome to the Adsyield iOS SDK integration guide! 👋

This comprehensive documentation helps iOS app publishers integrate and monetize with the Adsyield SDK.
* **Google AdMob**
* **ironSource**
* **AppLovin MAX**

## ✅ Prerequisites

Before beginning integration, ensure you have:

* Xcode 13.0 or higher
* iOS deployment target 11.0+
* CocoaPods installed (or use manual integration)
* An active Adsyield publisher account
* Your unique App ID and placement IDs from the Adsyield dashboard

## 📁 SDK Components

| Adapter Name | Description | Format | Current Version |
|--------------|-------------|--------|----------------|
| **AdsyieldMaxAdapter** | MAX (AppLovin) integration adapter | `.xcframework` + podspec | ios-1.0.0 |
| **AdmobAdsyieldAdapter** | Google AdMob integration adapter | `.xcframework` + podspec | ios-1.0.0 |
| **ISAdsyieldAdapter** | ironSource integration adapter | `.xcframework` + podspec | ios-1.0.0 |

## 🛠️ Integration Methods

We offer two methods to integrate Adsyield into your iOS app:

### Method 1: CocoaPods Integration (Recommended)

CocoaPods provides the simplest way to manage dependencies in iOS projects.

#### Step 1: Configure your Podfile

Open your `Podfile` located at the root of your iOS project (same folder as your `.xcodeproj` or `.xcworkspace`). If you don't have a Podfile yet, create one by running:

```bash
pod init
```

#### Step 2: Add Adsyield adapters to your Podfile

```ruby
platform :ios, '11.0'

target 'YourAppName' do
  use_frameworks!
  
  # ADD ONLY THE ADAPTER FOR YOUR MEDIATION PLATFORM
  
  # For AppLovin MAX integration:
  pod 'AdsyieldMaxAdapter', :git => 'https://github.com/bugranalci/adsyield-sdk.git', :tag => 'ios-1.0.0'
  
  # For Google AdMob integration:
  pod 'AdmobAdsyieldAdapter', :git => 'https://github.com/bugranalci/adsyield-sdk.git', :tag => 'ios-1.0.0'
  
  # For ironSource integration:
  pod 'ISAdsyieldAdapter', :git => 'https://github.com/bugranalci/adsyield-sdk.git', :tag => 'ios-1.0.0'
  
  # Additional ad network dependencies will be provided by Adsyield support
  # Example:
  # pod 'Google-Mobile-Ads-SDK', '9.14.0'
  # pod 'AppLovinSDK', '11.10.1'
end

# Important: You only need to include the adapter(s) for your specific mediation platform.
```

#### Step 3: Install dependencies

Run this command in your terminal from the project directory:

```bash
pod install --repo-update
```

#### Step 4: Open workspace and build

After pod installation completes, always use the `.xcworkspace` file to open your project:

```bash
open YourAppName.xcworkspace
```

### Method 2: Manual Framework Integration

If you prefer not using CocoaPods, you can manually integrate our SDK:

#### Step 1: Download SDK components
Contact our support team to receive the latest `.xcframework` files or download them from our repository.

#### Step 2: Add frameworks to your project
1. In Xcode, select your project in the Project Navigator
2. Select your application target under "Targets"
3. Select the "General" tab
4. Scroll to "Frameworks, Libraries, and Embedded Content"
5. Click the "+" button
6. Select "Add Other..." and navigate to the downloaded `.xcframework` files
7. Select the appropriate adapter(s) for your mediation platform
8. Ensure "Embed & Sign" is selected for each framework

#### Step 3: Update Info.plist
Add the required privacy descriptions:

```xml
<key>NSUserTrackingUsageDescription</key>
<string>This identifier will be used to deliver personalized ads to you.</string>

<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

## 📊 Implementing Ad Units

### Initialization

The Adsyield SDK automatically initializes when you implement an ad unit. However, we recommend explicit initialization early in your app lifecycle:

#### Swift
```swift
// In AppDelegate.swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Initialize your mediation SDK (AdMob, AppLovin MAX, or ironSource)
    // The Adsyield adapter will be automatically initialized
    
    return true
}
```

#### Objective-C
```objc
// In AppDelegate.m
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Initialize your mediation SDK (AdMob, AppLovin MAX, or ironSource)
    // The Adsyield adapter will be automatically initialized
    
    return YES;
}
```

### Implementing Banner Ads

Implement banner ads following your mediation platform's standard implementation. The Adsyield adapter will automatically handle the ad serving when properly configured in your mediation dashboard.

### Implementing Interstitial Ads

Follow your mediation platform's standard implementation for interstitial ads. Ensure your placement IDs match those configured in your Adsyield dashboard.

### Implementing Rewarded Ads

Implement rewarded ads according to your mediation platform's documentation. The Adsyield adapter will handle the ad serving when the placement is properly configured.

## ⚙️ Advanced Configuration

### App Tracking Transparency (ATT)

For iOS 14.5+, implement ATT request to improve ad performance:

```swift
import AppTrackingTransparency
import AdSupport

func requestIDFA() {
    if #available(iOS 14.5, *) {
        ATTrackingManager.requestTrackingAuthorization { status in
            // Continue with ad initialization
        }
    }
}
```

### COPPA Compliance

If your app targets children under 13, ensure COPPA compliance by setting the appropriate flag in your mediation platform.

### GDPR Compliance

For European users, implement appropriate consent mechanisms and pass consent information to the SDK.

## 🔍 Troubleshooting

### Common Issues

1. **Pod installation fails**
   - Ensure you have the latest CocoaPods version
   - Try using `pod install --repo-update`
   - Check network connectivity to GitHub

2. **No ads appearing**
   - Verify placement IDs in your mediation dashboard
   - Check Xcode console for error messages
   - Ensure test devices are properly configured

3. **Build errors**
   - Verify minimum iOS version (11.0+)
   - Ensure all required frameworks are embedded
   - Check for architecture compatibility issues

### Debug Mode

Enable verbose logging to diagnose integration issues (refer to your mediation platform documentation).

## ❓ FAQ

**Q: Which adapter should I choose?**  
A: Select the adapter matching your primary mediation platform (AdMob, MAX, or ironSource).

**Q: Can I use multiple mediation platforms simultaneously?**  
A: While technically possible, we recommend using a single mediation platform for optimal performance.

**Q: What does the `:tag => 'ios-1.0.0'` parameter mean?**  
A: This specifies the SDK version to install. Your Adsyield account manager will inform you when updates are available.

**Q: How do I update the SDK?**  
A: Update the tag version in your Podfile and run `pod update`.


**Q: How do I test the integration?**  
A: Request test credentials from your Adsyield account manager.

## 📱 Platform Requirements

* **iOS Version**: iOS 11.0 or above
* **Xcode**: 13.0 or above
* **Swift**: Compatible with Swift 5.0+
* **Architecture**: arm64, x86_64 (simulator)

## 🔄 Version History

* **ios-1.0.0** (Current)
  - Initial release with AdMob, MAX, and ironSource support
  - Compatible with iOS 11.0+

## 💬 Support

Our dedicated support team is ready to assist with your integration:

* **Email**: bnalci@adsyield.com
* **Technical Support**: Contact your Publisher Manager directly via Slack/Skype
* **Documentation**: Additional resources available in your Adsyield dashboard

We're committed to your success and maximizing your app's revenue potential!

— The Adsyield Tech Team 💙