# 📲 Adsyield Android SDK Integration Guide

Hello! 👋  
This guide explains **exactly where and how** to place the Adsyield SDK integration code inside your Android or Flutter project.

---

## 🔧 Project Structure Overview

In a typical Android or Flutter project, there are **two `build.gradle` files**:

| File                            | Purpose                    |
|---------------------------------|-----------------------------|
| `android/build.gradle`          | Project-level configuration |
| `android/app/build.gradle`      | App-level configuration     |

> We will add:
> - `repositories` → in `android/build.gradle`
> - `dependencies` → in `android/app/build.gradle`
> - Initialization code → in your Application class or main Activity

---

## 📋 Prerequisites

Before starting integration:

- Android Studio 4.0 or later
- Minimum SDK version 21 (Android 5.0) or higher
- Android Gradle Plugin 7.0 or later
- JDK 11 or higher
- GitHub account for accessing the SDK repository

---

## ✅ Integration Steps

### 🤖 Native Android Integration

#### 1. `android/build.gradle` (Project-level)

Open `android/build.gradle` and locate the `allprojects { repositories { ... } }` block.

**Add the following inside it:**

```groovy
allprojects {
    repositories {
        google()
        mavenCentral()

        // ✅ Adsyield SDK GitHub Maven
        maven {
            url = uri("https://maven.pkg.github.com/bugranalci/adsyield-sdk")
            credentials {
                username = "YOUR_GITHUB_USERNAME"
                password = "YOUR_GITHUB_READ_TOKEN"
            }
        }

        // ✅ Maven
        maven { url "https://jfrog.anythinktech.com/artifactory/overseas_sdk" }

        // ✅ Other ad network repositories (if needed)
        // maven { url "https://android-sdk.is.com/" }  // IronSource
        // maven { url "https://sdk.tapjoy.com/" }      // Tapjoy
        // maven { url "https://dl-maven-android.mintegral.com/repository/mbridge_android_sdk_oversea" } // Mintegral
    }
}
```

#### 2. `android/app/build.gradle` (App-level)

Open `android/app/build.gradle` and add these configurations:

**Android configuration section:**

```groovy
android {
    // Your existing configurations...
    
    // Required for some ad SDKs
    compileOptions {
        sourceCompatibility JavaVersion.VERSION_11
        targetCompatibility JavaVersion.VERSION_11
    }
    
    // For Kotlin projects
    kotlinOptions {
        jvmTarget = '11'
    }
    
    // Prevent conflicts in ad SDKs
    packagingOptions {
        exclude 'META-INF/DEPENDENCIES'
        exclude 'META-INF/LICENSE'
        exclude 'META-INF/LICENSE.txt'
        exclude 'META-INF/license.txt'
        exclude 'META-INF/NOTICE'
        exclude 'META-INF/NOTICE.txt'
        exclude 'META-INF/notice.txt'
        exclude 'META-INF/*.kotlin_module'
    }
}
```

**Dependencies section:**

```groovy
dependencies {
    // Your existing dependencies...
    
    // Select ONE Adsyield adapter based on your mediation platform:
    implementation 'com.adsyield:adapter-for-max:1.0.0'       // For AppLovin MAX
    // OR
    implementation 'com.adsyield:adapter-for-ironsource:1.0.0' // For IronSource
    // OR
    implementation 'com.adsyield:adapter-for-admob:1.0.0'      // For Google AdMob
    
    // Sample SDK components
    api "com.anythink.sdk:core-tpn:6.4.69"
    api "com.anythink.sdk:nativead-tpn:6.4.69"
    api "com.anythink.sdk:banner-tpn:6.4.69"
    api "com.anythink.sdk:interstitial-tpn:6.4.69"
    api "com.anythink.sdk:rewardedvideo-tpn:6.4.69"
    api "com.anythink.sdk:splash-tpn:6.4.69"
    
    // Note: Additional network-specific dependencies will be provided by 
    // the Adsyield team based on your ad network configuration
}
```

#### 3. AndroidManifest.xml

Add the necessary permissions to your `AndroidManifest.xml`:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="your.package.name">

    <!-- Required permissions -->
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    
    <!-- Optional but recommended -->
    <uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
    
    <application
        ...>
        <!-- Your activities and other elements -->
        
        <!-- Required for Google Play Services Ads ID -->
        <meta-data
            android:name="com.google.android.gms.ads.APPLICATION_ID"
            android:value="YOUR_ADMOB_APP_ID"/>
            
    </application>
</manifest>
```

---

### 🧩 Flutter Integration

#### 1. Follow Native Android Setup

For Flutter projects, you'll need to make all the above changes in your `android/` folder structure.

#### 2. Additional Flutter-specific Steps

After completing the native Android integration steps above:

**pubspec.yaml modifications (optional):**

If you're using any Flutter ad packages, make sure they're compatible with the native SDKs:

```yaml
dependencies:
  flutter:
    sdk: flutter
  # If using any Flutter wrappers for your mediation platforms:
  # applovin_max: ^2.0.0
  # google_mobile_ads: ^2.0.0
```

**Run Flutter commands:**

After setting up the Native Android part:

```bash
flutter clean
flutter pub get
flutter build apk --debug    # Test with debug build first
```

---

## 🔐 GitHub Authentication

You need a **GitHub Personal Access Token (PAT)** with `read:packages` scope.

### How to create a GitHub PAT:

1. Go to: https://github.com/settings/tokens?type=classic
2. Click `Generate new token (classic)`
3. Name your token (e.g., "Adsyield SDK Access")
4. Set expiration as needed (recommended: 90 days)
5. Check only: `read:packages`
6. Click "Generate token"
7. **IMPORTANT**: Copy the token immediately - it won't be shown again!
8. Use this token in your `password` field in the Gradle configuration

### Storing your credentials securely (recommended):

Create or edit the `~/.gradle/gradle.properties` file on your development machine:

```properties
# GitHub Credentials for Adsyield SDK
GITHUB_USERNAME=your_github_username
GITHUB_TOKEN=your_github_token
```

Then in your project's `android/build.gradle`, replace the hardcoded values:

```groovy
maven {
    url = uri("https://maven.pkg.github.com/bugranalci/adsyield-sdk")
    credentials {
        username = project.findProperty("GITHUB_USERNAME") ?: System.getenv("GITHUB_USERNAME")
        password = project.findProperty("GITHUB_TOKEN") ?: System.getenv("GITHUB_TOKEN")
    }
}
```

---

## 🚀 SDK Initialization

### In Native Android:

Add to your Application class:

```java
// YourApplication.java
public class YourApplication extends Application {
    @Override
    public void onCreate() {
        super.onCreate();
        
        // Initialize Adsyield SDK
        AdsyieldSDK.initialize(this, "YOUR_APP_KEY", new InitCallback() {
            @Override
            public void onSuccess() {
                Log.d("Adsyield", "SDK initialized successfully");
            }
            
            @Override
            public void onError(int errorCode, String errorMessage) {
                Log.e("Adsyield", "SDK initialization failed: " + errorMessage);
            }
        });
    }
}
```

For Kotlin:

```kotlin
// YourApplication.kt
class YourApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        
        // Initialize Adsyield SDK
        AdsyieldSDK.initialize(this, "YOUR_APP_KEY", object : InitCallback {
            override fun onSuccess() {
                Log.d("Adsyield", "SDK initialized successfully")
            }
            
            override fun onError(errorCode: Int, errorMessage: String) {
                Log.e("Adsyield", "SDK initialization failed: $errorMessage")
            }
        })
    }
}
```

Remember to register your Application class in AndroidManifest.xml:

```xml
<application
    android:name=".YourApplication"
    ...>
```

### In Flutter:

Create a method to initialize the SDK in your main app:

```dart
import 'package:flutter/services.dart';

class AdsyieldService {
  static const MethodChannel _channel = MethodChannel('your_app/adsyield');
  
  static Future<bool> initializeSDK() async {
    try {
      final bool result = await _channel.invokeMethod('initializeAdsyield');
      print('Adsyield SDK initialized: $result');
      return result;
    } on PlatformException catch (e) {
      print('Failed to initialize Adsyield SDK: ${e.message}');
      return false;
    }
  }
}
```

Then create the corresponding native method channel in your MainActivity.kt:

```kotlin
class MainActivity: FlutterActivity() {
    private val CHANNEL = "your_app/adsyield"
    
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "initializeAdsyield") {
                // Initialize Adsyield SDK
                AdsyieldSDK.initialize(applicationContext, "YOUR_APP_KEY", object : InitCallback {
                    override fun onSuccess() {
                        result.success(true)
                    }
                    
                    override fun onError(errorCode: Int, errorMessage: String) {
                        result.error("INIT_ERROR", errorMessage, null)
                    }
                })
            } else {
                result.notImplemented()
            }
        }
    }
}
```

---

## 📱 Ad Formats Implementation

The Adsyield SDK supports multiple ad formats. Below are examples of how to implement each:

### Banner Ads

```java
// Create a banner ad
AdsyieldBannerAd bannerAd = new AdsyieldBannerAd(this, "PLACEMENT_ID");

// Set a listener
bannerAd.setAdListener(new BannerAdListener() {
    @Override
    public void onAdLoaded() {
        // Ad loaded successfully
    }
    
    @Override
    public void onAdLoadFailed(int errorCode, String errorMessage) {
        // Ad failed to load
    }
    
    // Other callback methods...
});

// Load the ad
bannerAd.loadAd();

// Add to your layout
yourAdContainer.addView(bannerAd);
```

### Interstitial Ads

```java
// Create an interstitial ad
AdsyieldInterstitialAd interstitialAd = new AdsyieldInterstitialAd(this, "PLACEMENT_ID");

// Set a listener
interstitialAd.setAdListener(new InterstitialAdListener() {
    @Override
    public void onAdLoaded() {
        // Ad loaded successfully
    }
    
    @Override
    public void onAdLoadFailed(int errorCode, String errorMessage) {
        // Ad failed to load
    }
    
    @Override
    public void onAdDisplayed() {
        // Ad displayed
    }
    
    // Other callback methods...
});

// Load the ad
interstitialAd.loadAd();

// Show when ready (e.g., between game levels)
if (interstitialAd.isReady()) {
    interstitialAd.show();
}
```

### Rewarded Video Ads

```java
// Create a rewarded video ad
AdsyieldRewardedAd rewardedAd = new AdsyieldRewardedAd(this, "PLACEMENT_ID");

// Set a listener
rewardedAd.setAdListener(new RewardedAdListener() {
    @Override
    public void onAdLoaded() {
        // Ad loaded successfully
    }
    
    @Override
    public void onAdLoadFailed(int errorCode, String errorMessage) {
        // Ad failed to load
    }
    
    @Override
    public void onRewarded(String currency, int amount) {
        // User earned a reward
        // Give the reward to the user
    }
    
    // Other callback methods...
});

// Load the ad
rewardedAd.loadAd();

// Show when ready (e.g., when user clicks "Watch ad for reward")
if (rewardedAd.isReady()) {
    rewardedAd.show();
}
```

---

## 🛡️ ProGuard Configuration

If you're using ProGuard in your release builds, add these rules to your `proguard-rules.pro`:

```proguard
# Adsyield SDK
-keep class com.adsyield.** { *; }

#SDK
-keep class com.anythink.** { *; }
-keepclassmembers class com.anythink.** { *; }

# Google Play Services
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

# Additional network-specific rules will be provided based on your integration
```

---

## ❓ Troubleshooting

### Common Issues and Solutions:

#### 1. Gradle Sync Failure

**Issue:** `Failed to resolve: com.adsyield:adapter-for-xxx:1.0.0`

**Solution:**
- Verify GitHub credentials are correct
- Check internet connection
- Ensure the Maven URL is correctly formatted
- Try running with `--refresh-dependencies`

#### 2. Duplicate Classes

**Issue:** `Duplicate class com.xxx.yyy found in modules`

**Solution:**
- Add these to your app-level build.gradle:
```groovy
configurations.all {
    resolutionStrategy {
        force 'com.google.android.gms:play-services-ads:22.0.0' // Use latest version
    }
}
```

#### 3. Missing Initialization

**Issue:** `Adsyield SDK not initialized` error in logs

**Solution:**
- Ensure SDK is initialized in Application.onCreate() before using any ad functions
- Check if the initialization callback reports any errors

#### 4. Ads Not Showing

**Issue:** Ads load but don't display

**Solution:**
- Verify placement IDs are correct
- Check integration with your mediation platform
- Ensure the device is not in test mode or has ad limitations
- Check logcat for any error messages

---

## 📊 Version Compatibility

| Adsyield SDK Version | Minimum Android API | Recommended Android API | Compatible Mediation Versions |
|----------------------|---------------------|-------------------------|------------------------------|
| 1.0.0                | 21 (Android 5.0)    | 30+ (Android 11+)       | AppLovin MAX 11.0.0+         |
|                      |                     |                         | IronSource 7.2.0+            |
|                      |                     |                         | AdMob 22.0.0+                |

SDK version compatibility:
- Core SDK: 6.4.69+
- Network adapters: Corresponding versions will be provided by the Adsyield team

---

## 📞 Support & Contact

If you face any issues during integration or have questions:

- **Technical Support:** 📧 bnalci@adsyield.com
- **Documentation:** [GitHub Repository](https://github.com/bugranalci/adsyield-sdk)
- **SDK Updates:** Check the GitHub repository for the latest releases and changelogs

Our team is committed to providing timely support and ensuring a smooth integration experience.