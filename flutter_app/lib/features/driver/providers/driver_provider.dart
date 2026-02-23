import 'package:flutter/foundation.dart';
import '../../../models/driver.dart';
import '../../../services/api/api_client.dart';
import '../../../services/api/api_exceptions.dart';
import '../../../core/constants/api_constants.dart';

/// Provider for driver-specific state management.
class DriverProvider extends ChangeNotifier {
  final ApiClient _apiClient;

  DriverProvider({required ApiClient apiClient}) : _apiClient = apiClient;

  bool _isLoading = false;
  bool _isOnline = false;
  String? _errorMessage;
  DriverProfile? _profile;
  IncomingRideRequest? _incomingRequest;
  List<Map<String, dynamic>> _weeklyEarnings = [];

  bool get isLoading => _isLoading;
  bool get isOnline => _isOnline;
  String? get errorMessage => _errorMessage;
  DriverProfile? get profile => _profile;
  IncomingRideRequest? get incomingRequest => _incomingRequest;
  List<Map<String, dynamic>> get weeklyEarnings => _weeklyEarnings;

  Future<void> fetchProfile() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _apiClient.get(ApiConstants.driverStatus);
      _profile = DriverProfile.fromJson(response['driver']);
      _isOnline = _profile!.isOnline;
    } on ApiException catch (e) {
      _errorMessage = e.message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleOnlineStatus() async {
    _isOnline = !_isOnline;
    notifyListeners();
    try {
      await _apiClient.put(ApiConstants.driverStatus, body: {'is_online': _isOnline});
    } on ApiException catch (e) {
      _isOnline = !_isOnline;
      _errorMessage = e.message;
      notifyListeners();
    }
  }

  Future<bool> acceptRequest(String rideId) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _apiClient.post('${ApiConstants.driverIncomingRequests}/$rideId/accept');
      _incomingRequest = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> declineRequest(String rideId) async {
    try {
      await _apiClient.post('${ApiConstants.driverIncomingRequests}/$rideId/decline');
      _incomingRequest = null;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
      return false;
    }
  }

  Future<void> fetchEarnings() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _apiClient.get(ApiConstants.driverEarnings);
      _weeklyEarnings = List<Map<String, dynamic>>.from(response['weekly'] ?? []);
    } on ApiException catch (e) {
      _errorMessage = e.message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
