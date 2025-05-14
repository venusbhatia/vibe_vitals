# Vibe Vitals - A Flutter based Health Monitoring App

A modern health monitoring app built with Flutter featuring a premium UI design with glass-morphism effects, health metrics tracking, and integration with Apple HealthKit.

## App Screenshots

<p float="left">
<img src="https://github.com/user-attachments/assets/6724f9e9-a223-4092-aa9e-ff76749ce4ce" width="200" />
<img src="https://github.com/user-attachments/assets/b71c4243-a27f-4697-9ed6-4eeb4dd444e6" width="200" />
  <img src="https://github.com/user-attachments/assets/2b5d36ac-b586-4161-aefd-50b28e1d3259" width="200" />
  <img src="https://github.com/user-attachments/assets/e3b1f042-df2c-4669-b458-07fcd7c7294c" width="200" />
  
</p>

## Project Structure

```
health_monitor/
├── lib/
│   ├── models/
│   │   ├── health_metric.dart     # Health metric data model
│   │   └── user_profile.dart      # User profile data model
│   ├── services/
│   │   ├── health_service.dart    # Health data management
│   │   ├── basic_health_service.dart # Basic health tracking
│   │   └── user_service.dart      # User data management
│   ├── screens/
│   │   ├── home_screen.dart       # Main dashboard with health metrics
│   │   ├── onboarding_screen.dart # User onboarding flow
│   │   ├── profile_screen.dart    # User profile and settings
│   │   ├── health_test_screen.dart # Health data testing
│   │   ├── health_data_screen.dart # Health data visualization
│   │   └── metric_detail_screen.dart # Detailed metric view
│   ├── widgets/
│   │   ├── metric_input_dialog.dart # Dialog for entering health data
│   │   └── profile_avatar.dart    # User profile avatar widget
│   ├── theme/
│   │   └── app_theme.dart         # App theme configuration
│   └── main.dart                  # App entry point and setup
├── assets/
│   └── fonts/                     # Custom fonts
├── ios/                           # iOS-specific configuration
├── HEALTHKIT_SETUP.md             # HealthKit integration guide
├── setup_healthkit.sh             # Script for HealthKit setup
└── README.md                      # Project documentation
```

## Features

1. **Modern UI Design**
   - Glass-morphism effects
   - Smooth animations
   - Premium look and feel
   - Responsive layout

2. **Health Metrics Tracking**
   - Steps count
   - Heart rate monitoring
   - Sleep tracking
   - Water intake
   - Digital detox tracking
   - Active breaks monitoring

3. **HealthKit Integration**
   - Connect with Apple Health
   - Import health data
   - Real-time health metrics
   - Historical data visualization

4. **User Profiles**
   - Personalized health goals
   - Progress tracking
   - Health insights
   - Settings and preferences

5. **Onboarding Experience**
   - User-friendly setup
   - Health permissions management
   - Personalized goal setting
   - Profile creation

## Setup Instructions

1. **Prerequisites**
   ```bash
   # Ensure you have Flutter installed
   flutter --version
   
   # Should be using Flutter 3.7.2 or higher
   ```

2. **Clone the Repository**
   ```bash
   git clone https://github.com/yourusername/health_monitor.git
   cd health_monitor
   ```

3. **Install Dependencies**
   ```bash
   flutter pub get
   ```

4. **Run the App**
   ```bash
   # For development
   flutter run

   # For iOS with HealthKit enabled
   ./run_with_healthkit.sh
   ```

## HealthKit Integration

For detailed instructions on setting up HealthKit integration, please refer to the [HEALTHKIT_SETUP.md](HEALTHKIT_SETUP.md) file.

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  shared_preferences: ^2.2.2
  intl: ^0.19.0
  google_fonts: ^6.1.0
  health: ^12.2.0
```

## Design System

1. **Colors**
   - Primary: Light blue gradient
   - Background: Soft gradient from `Color(0xFFF0F4FF)` to `Color(0xFFEDF6FF)`
   - Glass Effect: White with opacity

2. **Typography**
   - App Title: Gistesy font
   - Body: Google Fonts

3. **Spacing**
   - Container Padding: 16px
   - Item Spacing: 16px
   - Border Radius: 12px-16px

## State Management

The app uses a combination of:
- SharedPreferences for persistent storage
- In-memory caching for performance
- Service classes for business logic

## Navigation

The app uses a main home screen with:
1. Dashboard: Health metrics overview
2. Profile: User settings and information
3. Health Test: Testing HealthKit integration

## Best Practices

1. **Code Organization**
   - Feature-based directory structure
   - Separation of concerns
   - Reusable widgets and services

2. **Performance**
   - Efficient state management
   - In-memory caching
   - Optimized health data processing

3. **UI/UX**
   - Consistent design language
   - Responsive layouts
   - User feedback for actions

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

