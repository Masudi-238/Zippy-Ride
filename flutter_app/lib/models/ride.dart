import 'package:equatable/equatable.dart';

/// Status of a ride.
enum RideStatus { pending, accepted, inProgress, completed, cancelled }

/// Type/tier of ride service.
enum RideType { economy, xl, luxury }

/// Represents a ride in the Zippy Ride system.
class Ride extends Equatable {
  final String id;
  final String riderId;
  final String? driverId;
  final RideType type;
  final RideStatus status;
  final RideLocation pickup;
  final RideLocation dropoff;
  final List<RideLocation> stops;
  final double estimatedPrice;
  final double? finalPrice;
  final double? distance;
  final double? duration;
  final int? rating;
  final DateTime createdAt;
  final DateTime? completedAt;

  const Ride({
    required this.id,
    required this.riderId,
    this.driverId,
    required this.type,
    required this.status,
    required this.pickup,
    required this.dropoff,
    this.stops = const [],
    required this.estimatedPrice,
    this.finalPrice,
    this.distance,
    this.duration,
    this.rating,
    required this.createdAt,
    this.completedAt,
  });

  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride(
      id: json['id'] as String,
      riderId: json['rider_id'] as String,
      driverId: json['driver_id'] as String?,
      type: RideType.values.firstWhere(
        (t) => t.name == (json['type'] as String).toLowerCase(),
        orElse: () => RideType.economy,
      ),
      status: RideStatus.values.firstWhere(
        (s) => s.name == _camelCase(json['status'] as String),
        orElse: () => RideStatus.pending,
      ),
      pickup: RideLocation.fromJson(json['pickup']),
      dropoff: RideLocation.fromJson(json['dropoff']),
      stops: json['stops'] != null
          ? (json['stops'] as List)
              .map((s) => RideLocation.fromJson(s))
              .toList()
          : [],
      estimatedPrice: (json['estimated_price'] as num).toDouble(),
      finalPrice: (json['final_price'] as num?)?.toDouble(),
      distance: (json['distance'] as num?)?.toDouble(),
      duration: (json['duration'] as num?)?.toDouble(),
      rating: json['rating'] as int?,
      createdAt: DateTime.parse(json['created_at'] as String),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rider_id': riderId,
      'driver_id': driverId,
      'type': type.name,
      'status': status.name,
      'pickup': pickup.toJson(),
      'dropoff': dropoff.toJson(),
      'stops': stops.map((s) => s.toJson()).toList(),
      'estimated_price': estimatedPrice,
      'final_price': finalPrice,
      'distance': distance,
      'duration': duration,
      'rating': rating,
      'created_at': createdAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
    };
  }

  static String _camelCase(String input) {
    final parts = input.split('_');
    if (parts.length <= 1) return input.toLowerCase();
    return parts.first.toLowerCase() +
        parts.skip(1).map((p) => p[0].toUpperCase() + p.substring(1)).join();
  }

  @override
  List<Object?> get props => [id, status, type, estimatedPrice];
}

/// Represents a location within a ride.
class RideLocation extends Equatable {
  final double latitude;
  final double longitude;
  final String address;
  final String? label;

  const RideLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
    this.label,
  });

  factory RideLocation.fromJson(Map<String, dynamic> json) {
    return RideLocation(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'] as String,
      label: json['label'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'label': label,
    };
  }

  @override
  List<Object?> get props => [latitude, longitude, address];
}
