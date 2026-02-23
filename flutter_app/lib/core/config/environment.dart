/// Environment configuration for the application.
/// Uses compile-time constants via --dart-define for secure key management.
class Environment {
  Environment._();

  /// API base URL
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000/api',
  );

  /// Mapbox access token - MUST be provided via --dart-define
  static const String mapboxAccessToken = String.fromEnvironment(
    'MAPBOX_ACCESS_TOKEN',
    defaultValue: '',
  );

  /// Mapbox style URL
  static const String mapboxStyleUrl = String.fromEnvironment(
    'MAPBOX_STYLE_URL',
    defaultValue: 'mapbox://styles/mapbox/streets-v12',
  );

  /// Whether we are in debug/development mode
  static const bool isProduction = bool.fromEnvironment(
    'PRODUCTION',
    defaultValue: false,
  );

  /// Connection timeout in seconds
  static const int connectionTimeout = int.fromEnvironment(
    'CONNECTION_TIMEOUT',
    defaultValue: 30,
  );

  /// Validates that required environment variables are set
  static bool get isConfigured {
    return mapboxAccessToken.isNotEmpty;
  }
}
