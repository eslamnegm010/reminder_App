import 'package:eslam_s_application/core/location_services/location_service.dart';
import 'package:eslam_s_application/core/location_services/location_manger.dart';
import 'package:eslam_s_application/core/location_services/models/location_model.dart';
import 'package:eslam_s_application/core/location_services/location_search_service.dart';
import 'package:eslam_s_application/sheared_widgets/others/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/utils/app_export.dart';
import '../location_sheet/location_map_controls.dart';
import '../location_sheet/location_search_bar.dart';
import '../location_sheet/location_sheet_header.dart';
import '../location_sheet/location_suggestions_list.dart';

const initialEgyptLocation = LatLng(30.0444, 31.2357);

class LocationSelectionSheet extends StatefulWidget {
  final LatLng? initialLocation;

  const LocationSelectionSheet({Key? key, this.initialLocation}) : super(key: key);

  @override
  State<LocationSelectionSheet> createState() => _LocationSelectionSheetState();
}

class _LocationSelectionSheetState extends State<LocationSelectionSheet>
    with SingleTickerProviderStateMixin {
  LatLng? _pickedLocation;
  late TextEditingController _searchController;
  late MapController _mapController;
  late AnimationController _animController;

  List<LocationSearchResult> _suggestions = [];
  bool _isSearching = false;
  String _selectedMapType = 'standard';
  double _currentZoom = 13.0;

  @override
  void initState() {
    super.initState();
    _pickedLocation = widget.initialLocation;
    _searchController = TextEditingController();
    _mapController = MapController();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DraggableScrollableSheet(
      initialChildSize: 0.95,
      minChildSize: 0.7,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            children: [
              const LocationSheetHeader(),
              const SizedBox(height: 16),
              LocationSearchBar(
                controller: _searchController,
                onClear: _clearSearch,
                onChanged: _onSearchChanged,
                onSubmitted: _performSearch,
                isSearching: _isSearching,
              ),
              if (_suggestions.isNotEmpty)
                LocationSuggestionsList(
                  suggestions: _suggestions,
                  onSelect: _selectSuggestion,
                ),
              const SizedBox(height: 12),
              LocationMapControls(
                selectedMapType: _selectedMapType,
                onMapTypeChanged: (type) => setState(() => _selectedMapType = type),
                onZoomIn: _zoomIn,
                onZoomOut: _zoomOut,
                onCenterLocation: _centerOnLocation,
              ),
              const SizedBox(height: 12),
              Expanded(child: _buildMap(context)),
              _buildBottomActions(context, isDark),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMap(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _pickedLocation ?? initialEgyptLocation,
                initialZoom: _currentZoom,
                onTap: (tapPos, latlng) => _onMapTapped(latlng),
                onPositionChanged: (position, hasGesture) {
                  if (hasGesture
                  //  && position.zoom != null
                  )
                    setState(() => _currentZoom = position.zoom);
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: _getMapTileUrl(),
                  userAgentPackageName: 'com.reminder.en',
                ),
                if (_pickedLocation != null) _buildMarkerLayer(),
              ],
            ),
            if (_pickedLocation != null) _buildLocationInfo(context),
          ],
        ),
      ),
    );
  }

  String _getMapTileUrl() {
    // TODO TO Change with free map api
    return _selectedMapType == 'satellite'
        ? 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}'
        : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  }

  Widget _buildMarkerLayer() {
    return MarkerLayer(
      markers: [
        Marker(
          point: _pickedLocation!,
          width: 50,
          height: 50,
          child: AnimatedScale(
            scale: 1.0,
            duration: const Duration(milliseconds: 300),
            child: Icon(
              Icons.location_on_rounded,
              color: AppColors.redColor,
              size: 50,
              shadows: [
                Shadow(color: AppColors.redColor.withValues(alpha: 0.4), blurRadius: 8),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationInfo(BuildContext context) {
    return Positioned(
      top: 12,
      left: 12,
      right: 12,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.pin_drop_rounded, color: AppColors.blueColor, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'selected_coordinates'.tr(),
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.getGrayTextColor(context),
                    ),
                  ),
                  Text(
                    '${_pickedLocation!.latitude.toStringAsFixed(6)}, ${_pickedLocation!.longitude.toStringAsFixed(6)}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blueColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context, bool isDark) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    label: 'cancel'.tr(),
                    icon: Icons.close_rounded,
                    backgroundColor: isDark ? Colors.white12 : Colors.grey.shade200,
                    textColor: AppColors.getTextColor(context),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    label: 'confirm'.tr(),
                    icon: Icons.check_rounded,
                    backgroundColor: AppColors.blueColor,
                    textColor: Colors.white,
                    onPressed: _pickedLocation != null
                        ? () {
                            // If confirming, try to use a name if we have one (from search or just coords)
                            String name = '';

                            // If search text matches, usage it
                            if (_searchController.text.isNotEmpty) {
                              name = _searchController.text;
                            }

                            // If we have suggestions and one matches exact coords (unlikely but possible)

                            final result = LocationSearchResult(
                              displayName: name.isNotEmpty
                                  ? name
                                  : '${_pickedLocation!.latitude.toStringAsFixed(4)}, ${_pickedLocation!.longitude.toStringAsFixed(4)}',
                              type: 'picked',
                              location: _pickedLocation!,
                              address:
                                  {}, // We don't have full address here easily without async
                            );
                            Navigator.pop(context, result);
                          }
                        : null,
                  ),
                ),
              ],
            ),
            if (_pickedLocation != null) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: _buildActionButton(
                  label: 'Save for later',
                  icon: Icons.bookmark_border_rounded,
                  backgroundColor: AppColors.blueColor.withValues(alpha: 0.1),
                  textColor: AppColors.blueColor,
                  onPressed: () => _showSaveLocationDialog(context),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _showSaveLocationDialog(BuildContext context) async {
    final nameController = TextEditingController();
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Name this location'),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(
            hintText: 'e.g., Home, Work, Gym',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.trim().isNotEmpty) {
                await _saveLocationWithName(nameController.text.trim());
                if (mounted) Navigator.pop(ctx);

                // Also return this as the result!
                final result = LocationSearchResult(
                  displayName: nameController.text.trim(),
                  type: 'saved',
                  location: _pickedLocation!,
                  address: {},
                );
                if (mounted) Navigator.pop(context, result);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.blueColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Future<void> _saveLocationWithName(String name) async {
    if (_pickedLocation == null) return;
    try {
      final address = await LocationSearchService.reverseGeocode(_pickedLocation!);
      final newSaved = SavedLocation(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        coordinates: _pickedLocation!,
        address: address,
        type: LocationType.other,
        createdAt: DateTime.now(),
      );
      await LocationManager.saveLocation(newSaved);
      if (mounted) {
        showSnackbar(context, message: 'Location saved as "$name"');
      }
    } catch (e) {
      if (mounted) {
        showSnackbar(context, message: 'Failed to save location: $e');
      }
    }
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color backgroundColor,
    required Color textColor,
    VoidCallback? onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 0,
      ),
      icon: Icon(icon, size: 20),
      label: Text(
        label,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    );
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _suggestions = [];
    });
  }

  void _onSearchChanged(String value) {
    if (value.isEmpty) setState(() => _suggestions = []);
  }

  Future<void> _performSearch() async {
    if (_searchController.text.trim().isEmpty) return;

    setState(() => _isSearching = true);
    try {
      final results = await LocationSearchService.search(_searchController.text);
      setState(() {
        _suggestions = results;
        _isSearching = false;
      });
    } catch (e) {
      setState(() => _isSearching = false);
    }
  }

  void _selectSuggestion(LocationSearchResult result) {
    setState(() {
      _pickedLocation = result.location;
      _suggestions = [];
      _searchController.text = result.displayName;
    });
    _mapController.move(result.location, 15);
  }

  void _onMapTapped(LatLng location) {
    setState(() => _pickedLocation = location);
  }

  void _zoomIn() {
    final newZoom = (_currentZoom + 1).clamp(1.0, 18.0);
    setState(() => _currentZoom = newZoom);
    final center = _pickedLocation ?? initialEgyptLocation;
    _mapController.move(center, newZoom);
  }

  void _zoomOut() {
    final newZoom = (_currentZoom - 1).clamp(1.0, 18.0);
    setState(() => _currentZoom = newZoom);
    final center = _pickedLocation ?? initialEgyptLocation;
    _mapController.move(center, newZoom);
  }

  Future<void> _centerOnLocation() async {
    try {
      final position = await LocationService.instance.determinePosition();
      final newLoc = LatLng(position.latitude, position.longitude);

      setState(() {
        _pickedLocation = newLoc;
        // Optional: Zoom in slightly when finding user location for better UX
        // _currentZoom = 15.0;
      });
      _mapController.move(newLoc, _currentZoom);
    } catch (e) {
      showSnackbar(context, message: 'Could not get current location: $e');
    }
  }

  Future<void> saveLocation(LatLng coordinates) async {
    final address = await LocationSearchService.reverseGeocode(coordinates);
    final newSaved = SavedLocation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: 'Custom Location',
      coordinates: coordinates,
      address: address,
      type: LocationType.other,
      createdAt: DateTime.now(),
    );
    await LocationManager.saveLocation(newSaved);
    showSnackbar(context, message: 'Location saved successfully');
  }
}

// Move the map to the selected location with the current zoom level
