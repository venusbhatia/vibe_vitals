#!/bin/bash

echo "Vibe Vitals App Installation"
echo "============================="

if ! command -v flutter &> /dev/null; then
    echo "Flutter is not installed or not in your PATH. Please install Flutter first."
    exit 1
fi

echo "1. Connect your Android phone via USB cable"
echo "2. Enable USB debugging on your phone (Settings > Developer options > USB debugging)"
echo "3. Make sure your phone is detected by ADB (Android Debug Bridge)"
echo ""
echo "Checking for connected devices..."

# Check if any device is connected
DEVICES=$(flutter devices)
if [[ $DEVICES == *"No devices detected."* ]]; then
    echo "No device detected. Please connect your Android phone and try again."
    exit 1
fi

echo "Device(s) found!"
echo "$DEVICES"
echo ""
echo "Installing Vibe Vitals to your device..."
echo ""

# Build and install the debug version directly to the connected device
flutter run --release

echo ""
echo "Installation complete. Vibe Vitals app should now be on your device." 