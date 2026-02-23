import '../../core/constants/api_constants.dart';
import '../../models/user.dart';
import '../api/api_client.dart';
import 'token_storage.dart';

/// Authentication service handling login, registration, and token management.
class AuthService {
  final ApiClient _apiClient;
  final TokenStorage _tokenStorage;

  AuthService({
    required ApiClient apiClient,
    required TokenStorage tokenStorage,
  })  : _apiClient = apiClient,
        _tokenStorage = tokenStorage;

  /// Logs in a user with email/phone and password
  Future<User> login({
    required String emailOrPhone,
    required String password,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.login,
      body: {
        'email_or_phone': emailOrPhone,
        'password': password,
      },
      auth: false,
    );

    await _tokenStorage.saveTokens(
      accessToken: response['access_token'],
      refreshToken: response['refresh_token'],
    );

    return User.fromJson(response['user']);
  }

  /// Registers a new user
  Future<User> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String role,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.register,
      body: {
        'full_name': fullName,
        'email': email,
        'phone': phone,
        'password': password,
        'role': role,
      },
      auth: false,
    );

    await _tokenStorage.saveTokens(
      accessToken: response['access_token'],
      refreshToken: response['refresh_token'],
    );

    return User.fromJson(response['user']);
  }

  /// Gets the current user profile
  Future<User> getProfile() async {
    final response = await _apiClient.get(ApiConstants.userProfile);
    return User.fromJson(response['user']);
  }

  /// Refreshes the access token
  Future<void> refreshToken() async {
    final refreshToken = await _tokenStorage.getRefreshToken();
    if (refreshToken == null) {
      throw Exception('No refresh token available');
    }

    final response = await _apiClient.post(
      ApiConstants.refreshToken,
      body: {'refresh_token': refreshToken},
      auth: false,
    );

    await _tokenStorage.saveAccessToken(response['access_token']);
  }

  /// Sends a forgot password request
  Future<void> forgotPassword({required String email}) async {
    await _apiClient.post(
      ApiConstants.forgotPassword,
      body: {'email': email},
      auth: false,
    );
  }

  /// Logs out the current user
  Future<void> logout() async {
    try {
      await _apiClient.post(ApiConstants.logout);
    } finally {
      await _tokenStorage.clearTokens();
    }
  }

  /// Checks if the user is authenticated
  Future<bool> isAuthenticated() async {
    return _tokenStorage.hasToken();
  }
}
