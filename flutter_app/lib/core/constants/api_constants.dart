/// API endpoint constants for the Zippy Ride backend.
class ApiConstants {
  ApiConstants._();

  // Base URL - configured via environment
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000/api',
  );

  // Auth Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String forgotPassword = '/auth/forgot-password';

  // User Endpoints
  static const String userProfile = '/users/profile';
  static const String updateProfile = '/users/profile';

  // Ride Endpoints
  static const String rides = '/rides';
  static const String rideEstimate = '/rides/estimate';
  static const String rideHistory = '/rides/history';
  static const String rideCancel = '/rides/cancel';
  static const String rideRate = '/rides/rate';

  // Driver Endpoints
  static const String driverStatus = '/driver/status';
  static const String driverEarnings = '/driver/earnings';
  static const String driverTrips = '/driver/trips';
  static const String driverVerification = '/driver/verification';
  static const String driverDocuments = '/driver/documents';
  static const String driverIncomingRequests = '/driver/requests';

  // Wallet Endpoints
  static const String wallet = '/wallet';
  static const String walletTopUp = '/wallet/top-up';
  static const String walletTransfer = '/wallet/transfer';
  static const String walletWithdraw = '/wallet/withdraw';
  static const String walletTransactions = '/wallet/transactions';

  // Map Endpoints
  static const String geocode = '/map/geocode';
  static const String reverseGeocode = '/map/reverse-geocode';
  static const String directions = '/map/directions';
}
