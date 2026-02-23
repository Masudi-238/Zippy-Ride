# Zippy Ride - Flutter Frontend

Production-ready Flutter application for the Zippy Ride ride-sharing platform.

## Architecture

This project follows **Clean Architecture** with a feature-based folder structure:

```
lib/
  main.dart                    # Entry point
  app.dart                     # App widget with routing & DI
  core/
    theme/                     # Design system (colors, typography, theme)
    constants/                 # API & app constants
    config/                    # Environment configuration
    utils/                     # Validators, helpers
  services/
    api/                       # HTTP client, error handling
    auth/                      # Authentication & token storage
    mapbox/                    # Mapbox geocoding & directions
  models/                      # Data models (User, Ride, Wallet, Driver)
  features/
    auth/                      # Login & Registration
    onboarding/                # 3-page onboarding flow
    rider/                     # Rider dashboard, ride selection, history
    driver/                    # Earnings, incoming requests, verification
    wallet/                    # Smart wallet management
  widgets/                     # Shared reusable widgets
```

## Design System

Extracted from the provided HTML designs:

- **Primary Color**: `#13EC6D` (Zippy Green)
- **Font Family**: Plus Jakarta Sans (400-800 weights)
- **Background Light**: `#F6F8F7`
- **Background Dark**: `#102218`
- **Border Radius**: 4px / 8px / 12px / 16px / 24px
- **Icon System**: Material Symbols Outlined

## State Management

Uses **Provider** (ChangeNotifier) pattern:

- `AuthProvider` - Authentication state
- `RiderProvider` - Rider-specific state
- `DriverProvider` - Driver-specific state
- `WalletProvider` - Wallet transactions & balance

## Backend Integration

The app connects to the Express.js backend in `../backend/`:

- JWT authentication with secure token storage
- RESTful API client with proper error handling
- Automatic token refresh on 401 responses

## Mapbox Integration

Configured via environment variables (no hardcoded keys):

```bash
flutter run --dart-define=MAPBOX_ACCESS_TOKEN=your_token_here
flutter run --dart-define=API_BASE_URL=http://your-api.com/api
```

### Features:
- Forward/reverse geocoding
- Driving directions with route coordinates
- Live location tracking (via geolocator)
- Map style customization

## Getting Started

### Prerequisites
- Flutter SDK >= 3.2.0
- Dart SDK >= 3.2.0

### Installation

```bash
cd flutter_app
flutter pub get
```

### Running

```bash
# Development
flutter run --dart-define=API_BASE_URL=http://localhost:3000/api \
            --dart-define=MAPBOX_ACCESS_TOKEN=your_mapbox_token

# Production
flutter run --release --dart-define=PRODUCTION=true \
            --dart-define=API_BASE_URL=https://api.zippyride.com \
            --dart-define=MAPBOX_ACCESS_TOKEN=your_mapbox_token
```

### Running Tests

```bash
flutter test
```

## Screens

| Screen | Route | HTML Source |
|--------|-------|-------------|
| Onboarding (3 pages) | `/onboarding` | onboardCode.html, OnboardFuturescode.html, onboaddriverBenefitcode.html |
| Login | `/login` | Zippy Ride logincode.html |
| Registration | `/register` | Registioncode.html |
| Rider Dashboard | `/rider-dashboard` | Rider dashboard2code.html |
| Ride Selection | `/ride-selection` | Rider Dashboad selection.html |
| Ride History | `/ride-history` | Rider History code.html |
| Driver Earnings | `/driver-earnings` | Diver Eanr dashboard code.html |
| Incoming Request | `/driver-incoming-request` | Driver incomming request code.html |
| Driver Verification | `/driver-verification` | Driver document verification code.html |
| Smart Wallet | `/wallet` | smart wallet management code.html |

## Security

- JWT tokens stored in Flutter Secure Storage
- API keys provided via compile-time `--dart-define` (never hardcoded)
- All API calls include proper authorization headers
- Form validation on all user inputs
