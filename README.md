# Sari-Sari Store Price Scanner (WIP)

Built using flutter but for android mobile device.

An android mobile application for determining the price of the products from the barcode. It aims to aid small scale business like sari-sari store for tracking and managing prices of products at their fingertips.

## To-Do Features

- [ ] Use camera to detect barcode and redirect to price result or product screen.
- [ ] Display list of products. 
- [ ] Register product along with price option when a barcode does not exist in local storage.
- [ ] Manage the products and prices screen.
- [ ] Export and import file for backup and restore data.
- [ ] (Optional and is only for convenience) Standalone static website for managing the products and prices, without backend. Utilizes import and export file. The exported file will be used to import in android application. 

## Build Instructions

### Prerequisites
- Flutter SDK (minimum version 3.2.3 as specified in pubspec.yaml)
- Java Development Kit (JDK) 11 or higher
- Android SDK

**Note:** The GitHub Actions workflow uses Flutter 3.24.5 for consistent automated builds.

### Building the APK

#### Using the Build Script (Recommended)

The easiest way to build the APK is to use the provided build script:

```bash
./build-apk.sh
```

This script will:
- Check if Flutter is installed
- Install dependencies
- Clean previous builds
- Build both debug and release APKs (if signing is configured)

#### Manual Build

1. **Install dependencies:**
   ```bash
   flutter pub get
   ```

2. **Build the release APK:**
   ```bash
   flutter build apk --release
   ```

   The APK file will be generated at: `build/app/outputs/flutter-apk/app-release.apk`
   
   **Note:** Release builds require a signing key. To build without signing, use the debug build instead.

3. **Build debug APK (for testing):**
   ```bash
   flutter build apk --debug
   ```

### APK Signing Configuration

For release builds, you need to set up signing:

1. Create a keystore file:
   ```bash
   keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```

2. Create a `key.properties` file in the `android` directory:
   ```properties
   storePassword=<your_store_password>
   keyPassword=<your_key_password>
   keyAlias=upload
   storeFile=<path_to_keystore>/upload-keystore.jks
   ```

3. Ensure `key.properties` is listed in `.gitignore` to avoid committing sensitive data.

### Automated Builds

This repository includes a GitHub Actions workflow that automatically builds the APK on every push to the main/master branch. You can download the built APK from the Actions tab:

1. Go to the "Actions" tab in the GitHub repository
2. Click on the latest "Build APK" workflow run
3. Download the `app-release` artifact

## Limitations

It relies on barcode and is not for products without barcode such as eggs, onion, garlic, and etc.

## Screenshots

|                                            #1                                             |                                            #2                                             |
|:-----------------------------------------------------------------------------------------:|:-----------------------------------------------------------------------------------------:|
| ![image](https://github.com/user-attachments/assets/d6bc85ed-a2f3-421d-b319-e1cbd2dd2823) | ![image](https://github.com/user-attachments/assets/02fd48d1-6c6a-4513-b034-692c8f46c3aa) |
