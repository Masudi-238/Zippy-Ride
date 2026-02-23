import 'package:equatable/equatable.dart';

/// Verification status for driver documents.
enum VerificationStatus { pending, verified, rejected, actionRequired }

/// Represents driver-specific data.
class DriverProfile extends Equatable {
  final String userId;
  final bool isOnline;
  final double rating;
  final int totalTrips;
  final double totalEarnings;
  final double todayEarnings;
  final Duration totalOnlineTime;
  final List<DriverDocument> documents;

  const DriverProfile({
    required this.userId,
    this.isOnline = false,
    this.rating = 0.0,
    this.totalTrips = 0,
    this.totalEarnings = 0.0,
    this.todayEarnings = 0.0,
    this.totalOnlineTime = Duration.zero,
    this.documents = const [],
  });

  int get verifiedDocumentCount =>
      documents.where((d) => d.status == VerificationStatus.verified).length;

  bool get isFullyVerified =>
      documents.isNotEmpty &&
      documents.every((d) => d.status == VerificationStatus.verified);

  factory DriverProfile.fromJson(Map<String, dynamic> json) {
    return DriverProfile(
      userId: json['user_id'] as String,
      isOnline: json['is_online'] as bool? ?? false,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      totalTrips: json['total_trips'] as int? ?? 0,
      totalEarnings: (json['total_earnings'] as num?)?.toDouble() ?? 0.0,
      todayEarnings: (json['today_earnings'] as num?)?.toDouble() ?? 0.0,
      totalOnlineTime: Duration(
        minutes: json['online_minutes'] as int? ?? 0,
      ),
      documents: json['documents'] != null
          ? (json['documents'] as List)
              .map((d) => DriverDocument.fromJson(d))
              .toList()
          : [],
    );
  }

  @override
  List<Object?> get props => [userId, isOnline, rating, totalTrips];
}

/// Represents a driver verification document.
class DriverDocument extends Equatable {
  final String id;
  final String name;
  final String type;
  final VerificationStatus status;
  final String? verifiedDate;
  final String? iconName;

  const DriverDocument({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    this.verifiedDate,
    this.iconName,
  });

  factory DriverDocument.fromJson(Map<String, dynamic> json) {
    return DriverDocument(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      status: VerificationStatus.values.firstWhere(
        (s) => s.name == _camelCase(json['status'] as String),
        orElse: () => VerificationStatus.pending,
      ),
      verifiedDate: json['verified_date'] as String?,
      iconName: json['icon_name'] as String?,
    );
  }

  static String _camelCase(String input) {
    final parts = input.split('_');
    if (parts.length <= 1) return input.toLowerCase();
    return parts.first.toLowerCase() +
        parts.skip(1).map((p) => p[0].toUpperCase() + p.substring(1)).join();
  }

  @override
  List<Object?> get props => [id, name, status];
}

/// Represents an incoming ride request for a driver.
class IncomingRideRequest extends Equatable {
  final String rideId;
  final double estimatedEarnings;
  final double surgeMultiplier;
  final String pickupAddress;
  final String dropoffAddress;
  final double pickupDistance;
  final int pickupMinutes;
  final double tripDistance;
  final int tripMinutes;
  final int timeoutSeconds;
  final String rideType;

  const IncomingRideRequest({
    required this.rideId,
    required this.estimatedEarnings,
    this.surgeMultiplier = 1.0,
    required this.pickupAddress,
    required this.dropoffAddress,
    required this.pickupDistance,
    required this.pickupMinutes,
    required this.tripDistance,
    required this.tripMinutes,
    this.timeoutSeconds = 22,
    this.rideType = 'Premier',
  });

  factory IncomingRideRequest.fromJson(Map<String, dynamic> json) {
    return IncomingRideRequest(
      rideId: json['ride_id'] as String,
      estimatedEarnings: (json['estimated_earnings'] as num).toDouble(),
      surgeMultiplier:
          (json['surge_multiplier'] as num?)?.toDouble() ?? 1.0,
      pickupAddress: json['pickup_address'] as String,
      dropoffAddress: json['dropoff_address'] as String,
      pickupDistance: (json['pickup_distance'] as num).toDouble(),
      pickupMinutes: json['pickup_minutes'] as int,
      tripDistance: (json['trip_distance'] as num).toDouble(),
      tripMinutes: json['trip_minutes'] as int,
      timeoutSeconds: json['timeout_seconds'] as int? ?? 22,
      rideType: json['ride_type'] as String? ?? 'Premier',
    );
  }

  @override
  List<Object?> get props => [rideId, estimatedEarnings];
}
