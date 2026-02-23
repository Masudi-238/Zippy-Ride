import 'package:equatable/equatable.dart';

/// Types of wallet transactions.
enum TransactionType { debit, credit, reward }

/// Represents the user's wallet.
class Wallet extends Equatable {
  final String id;
  final String userId;
  final double balance;
  final String currency;
  final bool isActive;

  const Wallet({
    required this.id,
    required this.userId,
    required this.balance,
    this.currency = 'USD',
    this.isActive = true,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      balance: (json['balance'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'USD',
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  @override
  List<Object?> get props => [id, userId, balance];
}

/// Represents a single wallet transaction.
class WalletTransaction extends Equatable {
  final String id;
  final TransactionType type;
  final double amount;
  final String description;
  final String? referenceId;
  final DateTime createdAt;

  const WalletTransaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.description,
    this.referenceId,
    required this.createdAt,
  });

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    return WalletTransaction(
      id: json['id'] as String,
      type: TransactionType.values.firstWhere(
        (t) => t.name == (json['type'] as String).toLowerCase(),
        orElse: () => TransactionType.debit,
      ),
      amount: (json['amount'] as num).toDouble(),
      description: json['description'] as String,
      referenceId: json['reference_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  @override
  List<Object?> get props => [id, type, amount, createdAt];
}
