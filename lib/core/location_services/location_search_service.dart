import 'dart:convert';
import 'package:eslam_s_application/core/location_services/models/location_model.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class LocationSearchService {
  static const String _baseUrl = 'https://nominatim.openstreetmap.org'; // TODO Change with free  map api
  static const String _userAgent = 'com.reminder.en';

  /// Search for locations based on query string
  static Future<List<LocationSearchResult>> search(String query) async {
    if (query.trim().isEmpty) return [];

    try {
      final uri = Uri.parse('$_baseUrl/search').replace(
        queryParameters: {
          'q': query,
          'format': 'json',
          'limit': '8',
          'addressdetails': '1',
          'accept-language': 'en',
        },
      );

      final response = await http.get(uri, headers: {'User-Agent': _userAgent}).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Failed to search locations: ${response.statusCode}');
      }

      final List<dynamic> data = json.decode(response.body) as List<dynamic>;
      return data.map((e) => LocationSearchResult.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      // Consider using logging instead of print in production
      print('Location search error: $e');
      return [];
    }
  }

  /// Reverse geocode coordinates to get address
  static Future<String?> reverseGeocode(LatLng location) async {
    try {
      final uri = Uri.parse('$_baseUrl/reverse').replace(
        queryParameters: {
          'lat': location.latitude.toString(),
          'lon': location.longitude.toString(),
          'format': 'json',
          'addressdetails': '1',
          'accept-language': 'en',
        },
      );

      final response = await http.get(uri, headers: {'User-Agent': _userAgent}).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) return null;

      final data = json.decode(response.body) as Map<String, dynamic>;
      return data['display_name'] as String?;
    } catch (e) {
      print('Reverse geocode error: $e');
      return null;
    }
  }

  /// Get nearby places using a bounded viewbox (approximate)
  static Future<List<LocationSearchResult>> getNearbyPlaces(
    LatLng location, {
    int radiusMeters = 1000,
  }) async {
    try {
      final degreeOffset = radiusMeters / 111320;

      final viewbox = [
        (location.longitude - degreeOffset).toString(),
        (location.latitude - degreeOffset).toString(),
        (location.longitude + degreeOffset).toString(),
        (location.latitude + degreeOffset).toString(),
      ].join(',');

      final uri = Uri.parse('$_baseUrl/search').replace(
        queryParameters: {
          'q': 'nearby',
          'format': 'json',
          'limit': '10',
          'addressdetails': '1',
          'viewbox': viewbox,
          'bounded': '1',
        },
      );

      final response = await http.get(uri, headers: {'User-Agent': _userAgent}).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) return [];

      final List<dynamic> data = json.decode(response.body) as List<dynamic>;
      return data.map((e) => LocationSearchResult.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Get nearby places error: $e');
      return [];
    }
  }
}
