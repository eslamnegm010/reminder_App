/*
import 'dart:convert';
import 'package:reminder_app/core/location_services/models/location_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationManager {
  static const String _storageKey = 'saved_locations';

  static Future<void> saveLocation(SavedLocation location) async {
    final prefs = await SharedPreferences.getInstance();
    final locations = await getSavedLocations();
    locations.add(location);
    final encoded = locations.map((e) => e.toJson()).toList();
    await prefs.setString(_storageKey, jsonEncode(encoded));
  }

  static Future<List<SavedLocation>> getSavedLocations() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    if (jsonString == null) return [];
    final List data = jsonDecode(jsonString) as List;
    return data.map((e) => SavedLocation.fromJson(e as Map<String, dynamic>)).toList();
  }

  static Future<void> deleteSavedLocation(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final locations = await getSavedLocations();
    locations.removeWhere((element) => element.id == id);
    final encoded = locations.map((e) => e.toJson()).toList();
    await prefs.setString(_storageKey, jsonEncode(encoded));
  }

  static Future<SavedLocation?> getLocationById(String id) async {
    final locations = await getSavedLocations();
    try {
      return locations.firstWhere((element) => element.id == id);
    } catch (_) {
      return null;
    }
  }

  static Future<bool> updateLocation(SavedLocation updatedLocation) async {
    final prefs = await SharedPreferences.getInstance();
    final locations = await getSavedLocations();
    final index = locations.indexWhere((element) => element.id == updatedLocation.id);

    if (index != -1) {
      locations[index] = updatedLocation;
      final encoded = locations.map((e) => e.toJson()).toList();
      await prefs.setString(_storageKey, jsonEncode(encoded));
      return true;
    }
    return false;
  }
}
*/
