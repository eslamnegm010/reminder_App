import 'package:bloc/bloc.dart';
import 'package:eslam_s_application/core/location_services/location_manger.dart';
import 'package:eslam_s_application/core/location_services/location_search_service.dart';
import 'package:eslam_s_application/core/location_services/models/location_model.dart';
import 'package:eslam_s_application/features/reminder/widgets/location_sheet/location_map_controls.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'location_picker_state.dart';

class LocationPickerCubit extends Cubit<LocationPickerState> {
  LocationPickerCubit() : super(const LocationPickerState());

  String userAgentPackageName = "com.reminder.en";
  String getMapTileUrl(MapType mapType) {
    return mapType == MapType.satellite
        ? 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}'
        : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  }

  void init(LatLng? initialLocation) async {
    emit(state.copyWith(pickedLocation: initialLocation));
    await loadSavedLocations();
    if (initialLocation != null) {
      loadAddress(initialLocation);
      emit(state.copyWith(showLocationOptions: true));
    }
  }

  Future<void> loadSavedLocations() async {
    emit(state.copyWith(isLoading: true));
    final locations = await LocationManager.getSavedLocations();
    emit(state.copyWith(savedLocations: locations, isLoading: false));
  }

  Future<void> loadAddress(LatLng location) async {
    final addr = await LocationSearchService.reverseGeocode(location);
    emit(state.copyWith(locationAddress: addr));
  }

  // --- Map and Search Logic ---

  Future<void> searchLocations(String query) async {
    if (query.trim().isEmpty) return;

    emit(state.copyWith(isSearching: true));
    try {
      final results = await LocationSearchService.search(query);
      emit(state.copyWith(searchResults: results, isSearching: false));
    } catch (e) {
      emit(
        state.copyWith(isSearching: false, searchResults: []),
      ); // Handle error gracefully
    }
  }

  void clearSearch() {
    emit(state.copyWith(searchResults: [], isSearching: false));
  }

  void updateZoom(double zoom) {
    emit(state.copyWith(currentZoom: zoom));
  }

  void updateMapType(MapType type) {
    emit(state.copyWith(selectedMapType: type));
  }

  void selectSuggestion(LocationSearchResult result) {
    emit(
      state.copyWith(
        pickedLocation: result.location,
        searchResults: [], // Clear suggestions
        // Explicitly update address if available from search result
        locationAddress: result.displayName,
      ),
    );
  }

  void selectMapLocation(LatLng location) {
    emit(state.copyWith(pickedLocation: location));
    // Optional: Reverse geocode immediately or wait for explicit save?
    // Let's stick to updating the marker position for now.
  }

  // --- Selection & Actions ---

  Future<void> saveCustomLocation(String name, BuildContext context) async {
    if (state.pickedLocation == null) return;

    try {
      final address = await LocationSearchService.reverseGeocode(state.pickedLocation!);

      final newSaved = SavedLocation(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        coordinates: state.pickedLocation!,
        address: address,
        type: LocationType.other,
        createdAt: DateTime.now(),
      );

      await LocationManager.saveLocation(newSaved);
      // We don't emit a new state here necessarily as the sheet usually closes
      // but we should refresh the list if the picker stays open.
      await loadSavedLocations();
    } catch (e) {
      // Ideally emit an error state or let the UI handle it via listener
      // For now, we rely on the caller to handle success/failure UI feedback
      rethrow;
    }
  }

  // Refactored existing method to be used by LocationPicker widget
  Future<void> handleLocationSelection({
    required LocationSearchResult result,
    required ValueChanged<LocationSearchResult> onSelected,
  }) async {
    onSelected(result);

    emit(state.copyWith(showLocationOptions: true, locationAddress: result.displayName));

    if (result.type == 'saved') {
      return;
    }

    // Logic for auto-saving newly picked locations when selected from the main picker (not sheet)
    // This maintains existing behavior of LocationPicker
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final newSavedLocation = SavedLocation(
      createdAt: DateTime.now(),
      id: id,
      name: 'Saved Location ${DateTime.now().minute}',
      coordinates: result.location,
      address: result.displayName,
      type: LocationType.other,
    );

    await LocationManager.saveLocation(newSavedLocation);
    await loadSavedLocations();
  }

  Future<void> deleteSavedLocation({
    required SavedLocation loc,
    required LatLng? currentSelectedCoordinates,
    required ValueChanged<LocationSearchResult?> onSelected,
    required VoidCallback? onClear,
  }) async {
    await LocationManager.deleteSavedLocation(loc.id);

    if (currentSelectedCoordinates != null &&
        currentSelectedCoordinates.latitude == loc.coordinates.latitude &&
        currentSelectedCoordinates.longitude == loc.coordinates.longitude) {
      onSelected(null);
      onClear?.call();
      emit(state.copyWith(locationAddress: null, showLocationOptions: false));
    }

    await loadSavedLocations();
  }

  void clearSelection({
    required ValueChanged<LocationSearchResult?> onSelected,
    required VoidCallback? onClear,
  }) {
    onSelected(null);
    onClear?.call();
    emit(state.copyWith(showLocationOptions: false));
  }
}
