import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

// Load the keystore properties safely
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    // 1. NAMESPACE: Must be unique. Matches your package name.
    namespace = "com.example.leave_cal"

    // 2. COMPILE SDK: Hardcoded to 35 to satisfy Google Play 2025 reqs.
    compileSdk = 35
    ndkVersion = flutter.ndkVersion

    compileOptions {
        // 3. JAVA VERSION: Updated to Java 17. 
        // Old Macs default to 11, but Android 15 builds REQUIRE Java 17.
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // 4. APP ID: CHANGE THIS! Google Play rejects "com.example".
        // Example: "com.johnsmith.leavecal"
        applicationId = "com.example.leave_cal" 
        
        // 5. VERSIONS: MinSDK 23 is the safe standard for 2025.
        minSdk = 23
        targetSdk = 35 // Must be 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            // Safe check to prevent crash if key.properties is missing
            if (keystoreProperties.containsKey("keyAlias")) {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = keystoreProperties["storeFile"]?.let { file(it) }
                storePassword = keystoreProperties["storePassword"] as String
            } else {
                println("WARNING: key.properties not found or empty. Release build will fail signing.")
            }
        }
    }

    buildTypes {
        getByName("release") {
            // 6. OPTIMIZATION: Enable these for a smaller, secure app
            isMinifyEnabled = true
            isShrinkResources = true

            // Standard ProGuard rules for Flutter
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}