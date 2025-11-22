# How to Get the APK Build File

This document explains the different ways you can obtain an APK build file for the Sari Scan application.

## Option 1: GitHub Actions (Recommended for Distribution)

The easiest way to get an APK without setting up Flutter locally:

1. **Wait for Workflow Approval** (First-time only)
   - After this PR is merged, the repository owner may need to approve the workflow run
   - This is a one-time security measure for new workflows

2. **Access the Actions Tab**
   - Go to: https://github.com/jedymatt/sari_scan/actions
   - Click on the latest "Build APK" workflow run
   - Scroll down to the "Artifacts" section

3. **Download the APK**
   - Download `app-debug` for a debug version (always available)
   - Download `app-release-apks` for release versions (if signing is configured)
   - The artifacts are kept for 30 days

## Option 2: Local Build with Script (Recommended for Development)

If you have Flutter installed:

```bash
# Make the script executable (first time only)
chmod +x build-apk.sh

# Run the build script
./build-apk.sh
```

The script will:
- Check your Flutter installation
- Install dependencies
- Build both debug and release APKs
- Tell you where to find the APK files

**Output location:** `build/app/outputs/flutter-apk/`

## Option 3: Manual Build

For manual control:

```bash
# Install dependencies
flutter pub get

# Build debug APK (works without signing)
flutter build apk --debug

# Build release APK (requires signing configuration)
flutter build apk --release
```

## APK Types

- **Debug APK** (`app-debug.apk`): For testing, larger file size, not optimized
- **Release APK** (`app-release.apk`): For distribution, smaller, optimized, requires signing

## Signing Configuration

Release builds require a signing key. If you don't have one:

1. Generate a keystore:
   ```bash
   keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```

2. Create `android/key.properties`:
   ```properties
   storePassword=your_password
   keyPassword=your_password
   keyAlias=upload
   storeFile=/path/to/upload-keystore.jks
   ```

3. Ensure `key.properties` is in `.gitignore`

## Troubleshooting

### "Flutter not found"
Install Flutter from https://flutter.dev/docs/get-started/install

### "Release build failed"
This is normal if you haven't configured signing. Use the debug APK instead.

### "Workflow requires approval"
The repository owner needs to approve new workflows. This is a GitHub security feature.

## Installation

Once you have the APK file:

1. **On Android device:**
   - Enable "Install from unknown sources" in settings
   - Transfer the APK to your device
   - Tap the APK file to install

2. **Using ADB:**
   ```bash
   adb install path/to/app-debug.apk
   ```

3. **Using Flutter:**
   ```bash
   flutter install
   ```

## Need Help?

- Check the [README.md](README.md) for detailed build instructions
- Review the [GitHub Actions workflow](.github/workflows/build-apk.yml)
- Open an issue if you encounter problems
