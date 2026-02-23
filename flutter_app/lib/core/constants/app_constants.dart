/// Application-wide constants for Zippy Ride.
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Zippy Ride';
  static const String appTagline = 'Your fast track to anywhere';

  // Onboarding
  static const int onboardingPageCount = 3;

  // Ride Types
  static const String rideEconomy = 'economy';
  static const String rideXL = 'xl';
  static const String rideLuxury = 'luxury';

  // Multi-Stop
  static const int maxStops = 5;

  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int phoneMinLength = 10;
  static const int phoneMaxLength = 15;

  // Timer
  static const int requestTimeoutSeconds = 30;
  static const int driverAcceptTimeoutSeconds = 22;

  // Pagination
  static const int defaultPageSize = 20;

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  static const String onboardingCompleteKey = 'onboarding_complete';
  static const String themeKey = 'theme_mode';

  // Animation Durations (ms)
  static const int animFast = 150;
  static const int animMedium = 300;
  static const int animSlow = 500;

  // Border Radius
  static const double radiusSmall = 4.0;
  static const double radiusMedium = 8.0;
  static const double radiusLarge = 12.0;
  static const double radiusXL = 16.0;
  static const double radiusXXL = 24.0;
  static const double radiusFull = 9999.0;
}
