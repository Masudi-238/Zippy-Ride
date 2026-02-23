import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/constants/app_constants.dart';

/// Secure token storage using flutter_secure_storage.
/// Stores JWT access and refresh tokens.
class TokenStorage {
  final FlutterSecureStorage _storage;

  TokenStorage({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage(
          aOptions: AndroidOptions(encryptedSharedPreferences: true),
        );

  /// Stores the access token
  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: AppConstants.tokenKey, value: token);
  }

  /// Retrieves the access token
  Future<String?> getAccessToken() async {
    return _storage.read(key: AppConstants.tokenKey);
  }

  /// Stores the refresh token
  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: AppConstants.refreshTokenKey, value: token);
  }

  /// Retrieves the refresh token
  Future<String?> getRefreshToken() async {
    return _storage.read(key: AppConstants.refreshTokenKey);
  }

  /// Stores both tokens at once
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      saveAccessToken(accessToken),
      saveRefreshToken(refreshToken),
    ]);
  }

  /// Checks if a valid token exists
  Future<bool> hasToken() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  /// Clears all stored tokens
  Future<void> clearTokens() async {
    await Future.wait([
      _storage.delete(key: AppConstants.tokenKey),
      _storage.delete(key: AppConstants.refreshTokenKey),
    ]);
  }

  /// Clears all secure storage
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
