enum Environment { development, staging, production }

class AppConfig {
  static late Environment _environment;
  static late String _apiBaseUrl;
  static late String _wsBaseUrl;

  static Environment get environment => _environment;
  static String get apiBaseUrl => _apiBaseUrl;
  static String get wsBaseUrl => _wsBaseUrl;

  static Future<void> initialize(Environment env) async {
    _environment = env;

    switch (env) {
      case Environment.development:
        _apiBaseUrl = 'http://localhost:3000/api/v1';
        _wsBaseUrl = 'ws://localhost:3000';
        break;
      case Environment.staging:
        _apiBaseUrl = 'https://staging-api.zippyride.com/api/v1';
        _wsBaseUrl = 'wss://staging-api.zippyride.com';
        break;
      case Environment.production:
        _apiBaseUrl = 'https://api.zippyride.com/api/v1';
        _wsBaseUrl = 'wss://api.zippyride.com';
        break;
    }
  }

  static bool get isDevelopment => _environment == Environment.development;
  static bool get isProduction => _environment == Environment.production;
}
