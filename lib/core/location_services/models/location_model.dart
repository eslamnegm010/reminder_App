/*
import 'package:latlong2/latlong.dart';

class LocationSearchResult {
  final String displayName;
  final String type;
  final LatLng location;
  final Map<String, dynamic> address;

  LocationSearchResult({
    required this.displayName,
    required this.type,
    required this.location,
    required this.address,
  });

  factory LocationSearchResult.fromJson(Map<String, dynamic> json) {
    final lat = double.tryParse('${json['lat']}') ?? 0.0;
    final lon = double.tryParse('${json['lon']}') ?? 0.0;

    return LocationSearchResult(
      displayName: json['display_name'] ?? '',
      type: json['type'] ?? 'location',
      location: LatLng(lat, lon),
      address: (json['address'] as Map<String, dynamic>?) ?? {},
    );
  }

  String get shortAddress {
    if (address.isEmpty) return displayName;

    final parts = <String>[];
    if (address['road'] != null) parts.add(address['road']);
    if (address['city'] != null) parts.add(address['city']);
    if (address['country'] != null) parts.add(address['country']);

    return parts.isEmpty ? displayName : parts.join(', ');
  }
}

class SavedLocation {
  final String id;
  final String name;
  final LatLng coordinates;
  final String? address;
  final LocationType type;
  final DateTime createdAt;

  SavedLocation({
    required this.id,
    required this.name,
    required this.coordinates,
    this.address,
    required this.type,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'lat': coordinates.latitude,
        'lng': coordinates.longitude,
        'address': address,
        'type': type.index,
        'createdAt': createdAt.toIso8601String(),
      };

  factory SavedLocation.fromJson(Map<String, dynamic> json) => SavedLocation(
        id: json['id'] as String,
        name: json['name'] as String,
        coordinates: LatLng((json['lat'] as num).toDouble(), (json['lng'] as num).toDouble()),
        address: json['address'] as String?,
        type: LocationType.values[(json['type'] as int)],
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

enum LocationType { home, work, favorite, other }

class FamousLocation {
  final String name;
  final LatLng location;
  final String emoji;

  const FamousLocation(this.name, this.location, this.emoji);
}
*/
