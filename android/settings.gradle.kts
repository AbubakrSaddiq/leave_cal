pluginManagement {
    val flutterSdkPath = runCatching {
        val properties = java.util.Properties()
        properties.load(java.io.FileInputStream(java.io.File("local.properties")))
        properties.getProperty("flutter.sdk")
    }.getOrNull()

    val flutterSdk = flutterSdkPath ?: System.getenv("FLUTTER_ROOT") ?: error("Flutter SDK not found. Define location with flutter.sdk in the local.properties file.")

    includeBuild("$flutterSdk/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }

    plugins {
        // ERROR FIXER: This version (8.3.2) enables Java 17 and Android 15 support
        id("com.android.application") version "8.3.2" 

        // KOTLIN FIXER: This version matches the Android Gradle Plugin above
        id("org.jetbrains.kotlin.android") version "1.9.22" 

        // FLUTTER: Loads the Flutter tools
        id("dev.flutter.flutter-gradle-plugin") version "1.0.0" apply false
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") apply false
    id("org.jetbrains.kotlin.android") apply false
}

include(":app")