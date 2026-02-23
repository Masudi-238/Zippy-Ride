import 'package:flutter/foundation.dart';
import '../../../services/api/api_client.dart';
import '../../../services/api/api_exceptions.dart';

/// Provider for manager-specific state management.
class ManagerProvider extends ChangeNotifier {
  final ApiClient _apiClient;

  ManagerProvider({required ApiClient apiClient}) : _apiClient = apiClient;

  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic> _fleetData = {};
  Map<String, dynamic> _reportData = {};
  Map<String, dynamic> _analyticsData = {};

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic> get fleetData => _fleetData;
  Map<String, dynamic> get reportData => _reportData;
  Map<String, dynamic> get analyticsData => _analyticsData;

  Future<void> fetchFleetData() async {
    _isLoading = true; notifyListeners();
    try {
      _fleetData = await _apiClient.get('/manager/fleet') ?? {};
    } on ApiException catch (e) { _errorMessage = e.message; }
    finally { _isLoading = false; notifyListeners(); }
  }

  Future<void> fetchReports() async {
    _isLoading = true; notifyListeners();
    try {
      _reportData = await _apiClient.get('/manager/reports') ?? {};
    } on ApiException catch (e) { _errorMessage = e.message; }
    finally { _isLoading = false; notifyListeners(); }
  }

  Future<void> fetchAnalytics() async {
    _isLoading = true; notifyListeners();
    try {
      _analyticsData = await _apiClient.get('/manager/analytics') ?? {};
    } on ApiException catch (e) { _errorMessage = e.message; }
    finally { _isLoading = false; notifyListeners(); }
  }

  Future<bool> requestPayout() async {
    try {
      await _apiClient.post('/manager/payout');
      return true;
    } on ApiException catch (e) { _errorMessage = e.message; notifyListeners(); return false; }
  }

  Future<bool> updateCommission({required int economyRate, required int premiumRate, required bool peakPricing}) async {
    try {
      await _apiClient.put('/manager/reports/commission', body: {'economy_rate': economyRate, 'premium_rate': premiumRate, 'peak_pricing_enabled': peakPricing});
      return true;
    } on ApiException catch (e) { _errorMessage = e.message; notifyListeners(); return false; }
  }

  void clearError() { _errorMessage = null; notifyListeners(); }
}
