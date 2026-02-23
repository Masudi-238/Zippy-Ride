import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/config/environment.dart';

/// Service for Mapbox API integration.
/// Handles geocoding, directions, and map configuration.
class MapboxService {
  final http.Client _httpClient;
  static const String _baseUrl = 'https://api.mapbox.com';

  MapboxService({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  String get _accessToken => Environment.mapboxAccessToken;
  String get styleUrl => Environment.mapboxStyleUrl;

  /// Forward geocode: address text -> coordinates
  Future<List<MapboxPlace>> geocode(String query) async {
    final uri = Uri.parse(
      '$_baseUrl/geocoding/v5/mapbox.places/${Uri.encodeComponent(query)}.json'
      '?access_token=$_accessToken&limit=5',
    );

    final response = await _httpClient.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Geocoding failed: ${response.statusCode}');
    }

    final data = jsonDecode(response.body);
    final features = data['features'] as List;

    return features.map((f) => MapboxPlace.fromJson(f)).toList();
  }

  /// Reverse geocode: coordinates -> address
  Future<MapboxPlace?> reverseGeocode(double lat, double lng) async {
    final uri = Uri.parse(
      '$_baseUrl/geocoding/v5/mapbox.places/$lng,$lat.json'
      '?access_token=$_accessToken&limit=1',
    );

    final response = await _httpClient.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Reverse geocoding failed: ${response.statusCode}');
    }

    final data = jsonDecode(response.body);
    final features = data['features'] as List;

    if (features.isEmpty) return null;
    return MapboxPlace.fromJson(features.first);
  }

  /// Get driving directions between two points
  Future<MapboxDirections> getDirections({
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
    List<List<double>>? waypoints,
  }) async {
    final coordinates = StringBuffer('$originLng,$originLat');

    if (waypoints != null) {
      for (final wp in waypoints) {
        coordinates.write(';${wp[1]},${wp[0]}');
      }
    }

    coordinates.write(';$destLng,$destLat');

    final uri = Uri.parse(
      '$_baseUrl/directions/v5/mapbox/driving/$coordinates'
      '?access_token=$_accessToken'
      '&geometries=geojson'
      '&overview=full'
      '&steps=true',
    );

    final response = await _httpClient.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Directions request failed: ${response.statusCode}');
    }

    final data = jsonDecode(response.body);
    return MapboxDirections.fromJson(data);
  }

  void dispose() {
    _httpClient.close();
  }
}

/// Represents a place result from Mapbox geocoding
class MapboxPlace {
  final String id;
  final String name;
  final String fullAddress;
  final double latitude;
  final double longitude;

  const MapboxPlace({
    required this.id,
    required this.name,
    required this.fullAddress,
    required this.latitude,
    required this.longitude,
  });

  factory MapboxPlace.fromJson(Map<String, dynamic> json) {
    final center = json['center'] as List;
    return MapboxPlace(
      id: json['id'] as String,
      name: json['text'] as String,
      fullAddress: json['place_name'] as String,
      latitude: (center[1] as num).toDouble(),
      longitude: (center[0] as num).toDouble(),
    );
  }
}

/// Represents directions response from Mapbox
class MapboxDirections {
  final double distanceMeters;
  final double durationSeconds;
  final List<List<double>> routeCoordinates;

  const MapboxDirections({
    required this.distanceMeters,
    required this.durationSeconds,
    required this.routeCoordinates,
  });

  double get distanceMiles => distanceMeters / 1609.344;
  double get durationMinutes => durationSeconds / 60.0;

  factory MapboxDirections.fromJson(Map<String, dynamic> json) {
    final route = (json['routes'] as List).first;
    final geometry = route['geometry'];
    final coordinates = (geometry['coordinates'] as List)
        .map((c) => [(c[1] as num).toDouble(), (c[0] as num).toDouble()])
        .toList();

    return MapboxDirections(
      distanceMeters: (route['distance'] as num).toDouble(),
      durationSeconds: (route['duration'] as num).toDouble(),
      routeCoordinates: coordinates,
    );
  }
}
