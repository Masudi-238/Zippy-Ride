import 'package:flutter/foundation.dart';
import '../../../models/wallet.dart';
import '../../../services/api/api_client.dart';
import '../../../services/api/api_exceptions.dart';
import '../../../core/constants/api_constants.dart';

/// Provider for wallet state management.
class WalletProvider extends ChangeNotifier {
  final ApiClient _apiClient;

  WalletProvider({required ApiClient apiClient}) : _apiClient = apiClient;

  bool _isLoading = false;
  String? _errorMessage;
  Wallet? _wallet;
  List<WalletTransaction> _transactions = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Wallet? get wallet => _wallet;
  List<WalletTransaction> get transactions => _transactions;
  double get balance => _wallet?.balance ?? 0.0;

  Future<void> fetchWallet() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _apiClient.get(ApiConstants.wallet);
      _wallet = Wallet.fromJson(response['wallet']);
      if (response['transactions'] != null) {
        _transactions = (response['transactions'] as List).map((t) => WalletTransaction.fromJson(t)).toList();
      }
    } on ApiException catch (e) {
      _errorMessage = e.message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> topUp(double amount) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _apiClient.post(ApiConstants.walletTopUp, body: {'amount': amount});
      await fetchWallet();
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> withdraw(double amount) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _apiClient.post(ApiConstants.walletWithdraw, body: {'amount': amount});
      await fetchWallet();
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
