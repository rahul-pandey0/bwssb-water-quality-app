# BWSSB Water Quality Monitoring System

A Flutter mobile application for the Bangalore Water Supply and Sewerage Board (BWSSB) to monitor and manage water quality data across service stations, water treatment plants, and sewage treatment plants.

## Features

- 🔐 **Authentication** - Secure login system for field officers
- 📊 **Dashboard** - Overview of water quality monitoring activities
- 📍 **Location Integration** - GPS location capture for sample collection
- 📝 **Data Entry** - Forms for recording water quality samples
- 🗂️ **Sample Categories** - Support for daily, monthly, and yearly samples
- 🏢 **Station Management** - Service stations, WTP, and STP monitoring
- 📱 **Responsive UI** - Clean, modern interface matching BWSSB branding

## Screenshots Reference

The app is designed based on the provided UI mockups showing:
- Splash screen with BWSSB logo and branding
- Login screen with username/password authentication
- Dashboard with water quality data access
- Sample collection forms with location integration
- Navigation drawer with organized menu sections

## Technical Stack

- **Framework**: Flutter 3.x
- **State Management**: Provider
- **Maps**: Google Maps Flutter
- **Location Services**: Geolocator, Permission Handler
- **HTTP Client**: HTTP package
- **Local Storage**: SharedPreferences

## Setup Instructions

### Prerequisites

1. Install Flutter SDK (3.0 or higher)
2. Install Android Studio / VS Code with Flutter plugin
3. Set up Android/iOS development environment

### Installation

1. **Clone/Download the project**
   ```bash
   cd "c:\PROJECTS\BWSSB APP"
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Google Maps (Required for location features)**
   
   **Android:**
   - Get a Google Maps API key from Google Cloud Console
   - Replace `YOUR_GOOGLE_MAPS_API_KEY_HERE` in `android/app/src/main/AndroidManifest.xml`
   
   **iOS:**
   - Add your API key to `ios/Runner/AppDelegate.swift`:
   ```swift
   GMSServices.provideAPIKey("YOUR_API_KEY_HERE")
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   └── water_quality_models.dart
├── screens/                  # UI screens
│   ├── splash_screen.dart
│   ├── login_screen.dart
│   ├── dashboard_screen.dart
│   ├── water_quality_samples_screen.dart
│   ├── add_sample_screen.dart
│   └── location_picker_screen.dart
├── services/                 # Business logic
│   ├── auth_service.dart
│   └── water_quality_service.dart
└── widgets/                  # Reusable components
    └── app_drawer.dart
```

## Configuration

### API Integration

The app is currently configured with mock data. To integrate with real APIs:

1. Update the `baseUrl` in `lib/services/water_quality_service.dart`
2. Implement proper authentication tokens in API calls
3. Replace mock methods with actual HTTP requests

### Environment Variables

Create a `.env` file for sensitive configuration:
```
GOOGLE_MAPS_API_KEY=your_api_key_here
API_BASE_URL=https://your-api-url.com
```

## App Flow

1. **Splash Screen** → **Login** → **Dashboard**
2. **Dashboard** → **View Water Quality Data** → **Sample Categories**
3. **Sample Categories** → **Add Sample** → **Location Selection**
4. **Navigation Drawer** → Various sections (Service Stations, WTP, STP, Reports)

## Development Notes

### Login Credentials
For testing, the app accepts any non-empty username and password.

### Location Services
- Requires location permissions on both Android and iOS
- Falls back to Bangalore coordinates if location access is denied
- Google Maps integration for precise location selection

### Sample Types
- **Service Station**: Water quality at distribution points
- **WTP**: Water Treatment Plant monitoring
- **STP**: Sewage Treatment Plant monitoring

## Customization

### Theming
- Primary color: `#2196F3` (Blue)
- Secondary color: `#21CBF3` (Light Blue)
- Success color: `#4CAF50` (Green)
- Warning color: `#FF9800` (Orange)

### Branding
- BWSSB logo and colors throughout the app
- Consistent with provided design mockups
- Professional, government-appropriate styling

## Deployment

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## Troubleshooting

1. **Location not working**: Check permissions in device settings
2. **Maps not loading**: Verify Google Maps API key configuration
3. **Build errors**: Run `flutter clean` and `flutter pub get`

## Future Enhancements

- [ ] Offline data synchronization
- [ ] Report generation and export
- [ ] Real-time data validation
- [ ] Push notifications for alerts
- [ ] Advanced filtering and search
- [ ] Data visualization charts
- [ ] Multi-language support

## Support

For technical support or questions about the BWSSB Water Quality Monitoring System, contact the development team.

---

**Note**: This app is designed specifically for BWSSB field officers and authorized personnel for official water quality monitoring activities.