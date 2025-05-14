# Vibe Vitals App Installation Guide

## Method 1: Direct Install via Flutter (Recommended)

If you have Flutter installed on your computer:

1. Clone the repository
2. Connect your Android phone to your computer via USB cable  
3. Enable USB debugging on your phone (Settings > Developer options > USB debugging)
4. Run the installation script:

```bash
./install_app.sh
```

## Method 2: Manual APK Build and Install

If you want to build the APK yourself:

1. Make sure you have Flutter and Android SDK installed
2. Go to the project directory
3. Run the following command:

```bash
flutter build apk --release
```

4. The APK will be generated at `build/app/outputs/flutter-apk/app-release.apk`
5. Transfer this APK to your Android device and install it

## Troubleshooting

- **"No device detected"**: Make sure your device is properly connected and USB debugging is enabled
- **Build errors**: Make sure you have the latest Flutter version by running `flutter upgrade`
- **App crashes**: Ensure your Android device meets the minimum requirements (Android 6.0+)

## Features

The Vibe Vitals health monitoring app tracks:

- Steps
- Water intake
- Sleep
- Screen-off time
- Outstanding time

All metrics are personalized based on your profile data, providing tailored health recommendations.

## Support

If you encounter any issues during installation, please contact support at support@vibevitals.com 