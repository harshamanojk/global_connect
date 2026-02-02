plugins {
    id("com.android.application")
    id("com.google.gms.google-services")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.global_connect"
    compileSdk = 36

    defaultConfig {
        applicationId = "com.example.global_connect"
        minSdk = flutter.minSdkVersion // Must be 21 or higher for BlinkID
        targetSdk = 36
        versionCode = 1
        versionName = "1.0.0"
        multiDexEnabled = true // Required for BlinkID classes
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    buildTypes {
        debug {
            isDebuggable = true
        }

        release {
            isMinifyEnabled = false
            isShrinkResources = false
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    buildFeatures {
        buildConfig = true
    }
}

flutter {
    source = "../.."
}
