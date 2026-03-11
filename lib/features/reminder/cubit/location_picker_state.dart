/*
import 'package:reminder_app/core/location_services/models/location_model.dart';
import 'package:reminder_app/features/reminder/widgets/location_sheet/location_map_controls.dart';
import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';

enum LocationPickerStateType { initial, loading, success, error }

@immutable
class LocationPickerState {
  final List<SavedLocation> savedLocations;
  final String? locationAddress;
  final bool showLocationOptions;
  final bool isLoading;
  final String? error;
  final LocationPickerStateType stateType;

  // New fields for LocationSelectionSheet
  final List<LocationSearchResult> searchResults;
  final bool isSearching;
  final MapType selectedMapType;
  final LatLng? pickedLocation;
  final double currentZoom;

  const LocationPickerState({
    this.savedLocations = const [],
    this.locationAddress,
    this.error,
    this.stateType = LocationPickerStateType.initial,
    this.showLocationOptions = false,
    this.isLoading = false,
    this.searchResults = const [],
    this.isSearching = false,
    this.selectedMapType = MapType.standard,
    this.pickedLocation,
    this.currentZoom = 13.0,
  });

  LocationPickerState copyWith({
    List<SavedLocation>? savedLocations,
    String? locationAddress,
    bool? showLocationOptions,
    bool? isLoading,
    String? error,
    LocationPickerStateType? stateType,
    List<LocationSearchResult>? searchResults,
    bool? isSearching,
    MapType? selectedMapType,
    LatLng? pickedLocation,
    double? currentZoom,
  }) {
    return LocationPickerState(
      savedLocations: savedLocations ?? this.savedLocations,
      locationAddress: locationAddress ?? this.locationAddress,
      showLocationOptions: showLocationOptions ?? this.showLocationOptions,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      stateType: stateType ?? this.stateType,
      searchResults: searchResults ?? this.searchResults,
      isSearching: isSearching ?? this.isSearching,
      selectedMapType: selectedMapType ?? this.selectedMapType,
      pickedLocation: pickedLocation ?? this.pickedLocation,
      currentZoom: currentZoom ?? this.currentZoom,
    );
  }
}
*/
