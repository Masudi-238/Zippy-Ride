class UserModel {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String phone;
  final String role;
  final bool isVerified;

  const UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.role,
    required this.isVerified,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      phone: json['phone'] as String,
      role: json['role'] as String,
      isVerified: json['isVerified'] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'firstName': firstName,
    'lastName': lastName,
    'phone': phone,
    'role': role,
    'isVerified': isVerified,
  };

  String get fullName => '$firstName $lastName';
  bool get isRider => role == 'rider';
  bool get isDriver => role == 'driver';
  bool get isManager => role == 'manager';
  bool get isAdmin => role == 'super_admin';
}
