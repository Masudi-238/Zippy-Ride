import 'package:flutter/foundation.dart';
import '../../../services/api/api_client.dart';
import '../../../services/api/api_exceptions.dart';

/// Provider for super admin state management.
class AdminProvider extends ChangeNotifier {
  final ApiClient _apiClient;
  AdminProvider({required ApiClient apiClient}) : _apiClient = apiClient;

  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic> _dashboardData = {};
  List<dynamic> _verificationQueue = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic> get dashboardData => _dashboardData;
  List<dynamic> get verificationQueue => _verificationQueue;

  Future<void> fetchDashboard() async {
    _isLoading = true; notifyListeners();
    try { _dashboardData = await _apiClient.get('/admin/dashboard') ?? {}; }
    on ApiException catch (e) { _errorMessage = e.message; }
    finally { _isLoading = false; notifyListeners(); }
  }

  Future<void> fetchVerificationQueue() async {
    _isLoading = true; notifyListeners();
    try { final resp = await _apiClient.get('/admin/verification-queue'); _verificationQueue = resp?['queue'] ?? []; }
    on ApiException catch (e) { _errorMessage = e.message; }
    finally { _isLoading = false; notifyListeners(); }
  }

  Future<bool> approveDriver(String id) async {
    try { await _apiClient.post('/admin/verification-queue/$id/approve'); return true; }
    on ApiException catch (e) { _errorMessage = e.message; notifyListeners(); return false; }
  }

  Future<bool> rejectDriver(String id, String reason) async {
    try { await _apiClient.post('/admin/verification-queue/$id/reject', body: {'reason': reason}); return true; }
    on ApiException catch (e) { _errorMessage = e.message; notifyListeners(); return false; }
  }

  Future<bool> updateSurge(String zone, double multiplier) async {
    try { await _apiClient.put('/admin/surge-control', body: {'zone': zone, 'multiplier': multiplier}); return true; }
    on ApiException catch (e) { _errorMessage = e.message; notifyListeners(); return false; }
  }

  void clearError() { _errorMessage = null; notifyListeners(); }
}
