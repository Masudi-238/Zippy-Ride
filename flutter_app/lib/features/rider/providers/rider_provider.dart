import 'package:flutter/foundation.dart';
import '../../../models/ride.dart';
import '../../../services/api/api_client.dart';
import '../../../services/api/api_exceptions.dart';
import '../../../core/constants/api_constants.dart';

/// Provider for rider-specific state management.
class RiderProvider extends ChangeNotifier {
  final ApiClient _apiClient;

  RiderProvider({required ApiClient apiClient}) : _apiClient = apiClient;

  // State
  bool _isLoading = false;
  String? _errorMessage;
  List<Ride> _rideHistory = [];
  Ride? _currentRide;
  RideType _selectedRideType = RideType.economy;
  String _pickupAddress = '';
  String _dropoffAddress = '';
  double _walletBalance = 42.50; // Mock initial balance

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Ride> get rideHistory => _rideHistory;
  Ride? get currentRide => _currentRide;
  RideType get selectedRideType => _selectedRideType;
  String get pickupAddress => _pickupAddress;
  String get dropoffAddress => _dropoffAddress;
  double get walletBalance => _walletBalance;

  /// Sets the selected ride type
  void selectRideType(RideType type) {
    _selectedRideType = type;
    notifyListeners();
  }

  /// Sets pickup address
  void setPickupAddress(String address) {
    _pickupAddress = address;
    notifyListeners();
  }

  /// Sets dropoff address
  void setDropoffAddress(String address) {
    _dropoffAddress = address;
    notifyListeners();
  }

  /// Fetches ride history from the API
  Future<void> fetchRideHistory() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiClient.get(ApiConstants.rideHistory);
      final rides = (response['rides'] as List)
          .map((r) => Ride.fromJson(r))
          .toList();
      _rideHistory = rides;
    } on ApiException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Failed to load ride history.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Books a ride
  Future<bool> bookRide() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiClient.post(
        ApiConstants.rides,
        body: {
          'type': _selectedRideType.name,
          'pickup_address': _pickupAddress,
          'dropoff_address': _dropoffAddress,
        },
      );
      _currentRide = Ride.fromJson(response['ride']);
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

  /// Cancels the current ride
  Future<bool> cancelRide(String rideId) async {
    try {
      await _apiClient.post(
        ApiConstants.rideCancel,
        body: {'ride_id': rideId},
      );
      _currentRide = null;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
      return false;
    }
  }

  /// Rates a completed ride
  Future<bool> rateRide(String rideId, int rating) async {
    try {
      await _apiClient.post(
        ApiConstants.rideRate,
        body: {'ride_id': rideId, 'rating': rating},
      );
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
