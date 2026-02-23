import 'package:equatable/equatable.dart';

/// User roles in the Zippy Ride system.
enum UserRole { rider, driver, manager, admin }

/// Represents a user in the Zippy Ride application.
class User extends Equatable {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final UserRole role;
  final String? avatarUrl;
  final bool isVerified;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    this.avatarUrl,
    this.isVerified = false,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      fullName: json['full_name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      role: UserRole.values.firstWhere(
        (r) => r.name == (json['role'] as String).toLowerCase(),
        orElse: () => UserRole.rider,
      ),
      avatarUrl: json['avatar_url'] as String?,
      isVerified: json['is_verified'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'role': role.name,
      'avatar_url': avatarUrl,
      'is_verified': isVerified,
      'created_at': createdAt.toIso8601String(),
    };
  }

  User copyWith({
    String? fullName,
    String? email,
    String? phone,
    UserRole? role,
    String? avatarUrl,
    bool? isVerified,
  }) {
    return User(
      id: id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props => [id, fullName, email, phone, role, isVerified];
}
