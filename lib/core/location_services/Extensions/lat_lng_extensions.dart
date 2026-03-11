/*
import 'package:latlong2/latlong.dart';
import 'dart:math' as math;

extension LatLngExtensions on LatLng {
  String toFormattedString({int decimals = 5}) {
    return '${latitude.toStringAsFixed(decimals)}, ${longitude.toStringAsFixed(decimals)}';
  }

  double distanceTo(LatLng other) {
    const distance = Distance();
    return distance.as(LengthUnit.Meter, this, other);
  }

  double bearingTo(LatLng other) {
    final lat1 = latitude * math.pi / 180;
    final lat2 = other.latitude * math.pi / 180;
    final dLon = (other.longitude - longitude) * math.pi / 180;

    final y = math.sin(dLon) * math.cos(lat2);
    final x = math.cos(lat1) * math.sin(lat2) - math.sin(lat1) * math.cos(lat2) * math.cos(dLon);

    final bearing = math.atan2(y, x) * 180 / math.pi;
    return (bearing + 360) % 360;
  }

  LatLng pointAtDistanceAndBearing(double distanceMeters, double bearingDegrees) {
    const earthRadius = 6371000.0;

    final lat1 = latitude * math.pi / 180;
    final lon1 = longitude * math.pi / 180;
    final bearing = bearingDegrees * math.pi / 180;

    final lat2 = math.asin(
      math.sin(lat1) * math.cos(distanceMeters / earthRadius) +
          math.cos(lat1) * math.sin(distanceMeters / earthRadius) * math.cos(bearing),
    );

    final lon2 = lon1 +
        math.atan2(
          math.sin(bearing) * math.sin(distanceMeters / earthRadius) * math.cos(lat1),
          math.cos(distanceMeters / earthRadius) - math.sin(lat1) * math.sin(lat2),
        );

    return LatLng(lat2 * 180 / math.pi, lon2 * 180 / math.pi);
  }

  bool isWithinRadius(LatLng center, double radiusMeters) {
    return distanceTo(center) <= radiusMeters;
  }

  String toGoogleMapsUrl() {
    return 'https://www.google.com/maps?q=$latitude,$longitude';
  }

  String toAppleMapsUrl() {
    return 'https://maps.apple.com/?ll=$latitude,$longitude';
  }
}

class LocationStorageHelper {
  static LatLng? fromString(String? locationString) {
    if (locationString == null || locationString.isEmpty) return null;

    final parts = locationString.split(',');
    if (parts.length != 2) return null;

    final lat = double.tryParse(parts[0].trim());
    final lng = double.tryParse(parts[1].trim());

    if (lat == null || lng == null) return null;
    if (lat < -90 || lat > 90 || lng < -180 || lng > 180) return null;

    return LatLng(lat, lng);
  }

  static String toLocationString(LatLng location) {
    return '${location.latitude},${location.longitude}';
  }

  static bool isValidLocationString(String? locationString) {
    return fromString(locationString) != null;
  }
}

class DistanceFormatter {
  static String format(double meters) {
    if (meters < 1000) {
      return '${meters.round()} m';
    } else {
      return '${(meters / 1000).toStringAsFixed(1)} km';
    }
  }
}

class CompassHelper {
  static String getDirection(double bearing) {
    const directions = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    final index = ((bearing + 22.5) / 45).floor() % 8;
    return directions[index];
  }

  static String getFullDirection(double bearing) {
    const directions = ['North', 'Northeast', 'East', 'Southeast', 'South', 'Southwest', 'West', 'Northwest'];
    final index = ((bearing + 22.5) / 45).floor() % 8;
    return directions[index];
  }
}
*/
