import 'package:eslam_s_application/core/location_services/Extensions/latLng_extensions.dart';
import 'package:eslam_s_application/core/location_services/ensure_location_permissions.dart';
import 'package:eslam_s_application/core/location_services/location_manger.dart';
import 'package:eslam_s_application/core/location_services/location_search_service.dart';
import 'package:eslam_s_application/core/location_services/models/location_model.dart';
import 'package:eslam_s_application/features/reminder/widgets/location_widgets/saved_locations.dart';
import 'package:eslam_s_application/features/reminder/widgets/main_widgets/location_sheet.dart';
import 'package:eslam_s_application/sheared_widgets/others/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/utils/app_export.dart';

class LocationPicker extends StatefulWidget {
  final LatLng? location;
  final String hint;
  final String helper;
  final ValueChanged<LatLng?> onLocationSelected;
  final VoidCallback? onClear;

  const LocationPicker({
    Key? key,
    this.location,
    required this.hint,
    required this.helper,
    required this.onLocationSelected,
    this.onClear,
  }) : super(key: key);

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  bool showLocationOptions = false;
  String? locationAddress;

  @override
  void initState() {
    super.initState();
    _loadLocationAddress();
  }

  @override
  void didUpdateWidget(LocationPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.location != oldWidget.location) {
      _loadLocationAddress();
    }
  }

  Future<void> _loadLocationAddress() async {
    if (widget.location != null) {
      final addr = await LocationSearchService.reverseGeocode(widget.location!);
      if (mounted) {
        setState(() => locationAddress = addr);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _buildLocationButton(context),
            ),
            if (widget.location != null) ...[
              const SizedBox(width: 8),
              _buildClearButton(context),
            ],
          ],
        ),
        // implementaion for saved Locations
        const SizedBox(height: 8),
        savedPlaces(),
        const SizedBox(height: 8),

        if (widget.location != null && showLocationOptions) ...[
          const SizedBox(height: 16),
          _buildLocationDetails(context),
        ],
      ],
    );
  }

  Widget _buildLocationButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: _openLocationPicker,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.blueColor.withOpacity(0.08),
        foregroundColor: AppColors.blueColor,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: AppColors.blueColor.withOpacity(0.2)),
        ),
        elevation: 0,
      ),
      icon: Icon(Icons.location_on_rounded, size: 20),
      label: Text(
        widget.location != null ? widget.location!.toFormattedString() : widget.hint.tr(),
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: widget.location != null ? AppColors.blueColor : AppColors.getGrayTextColor(context),
        ),
      ),
    );
  }

  Widget _buildClearButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        widget.onLocationSelected(null);
        widget.onClear?.call();
        setState(() => showLocationOptions = false);
      },
      style: IconButton.styleFrom(
        backgroundColor: AppColors.redColor.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: Icon(Icons.close_rounded, color: AppColors.redColor, size: 20),
    );
  }

  Widget _buildLocationDetails(BuildContext context) {
    // Card for location details after selection
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.blueColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow(
            context,
            Icons.pin_drop_rounded,
            'coordinates'.tr(),
            widget.location!.toFormattedString(),
          ),
          if (locationAddress != null) ...[
            const SizedBox(height: 12),
            _buildDetailRow(context, Icons.location_city_rounded, 'address'.tr(), locationAddress!),
          ],
          const SizedBox(height: 5),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(color: AppColors.blueColor.withOpacity(0.12), shape: BoxShape.circle),
          child: Icon(icon, size: 16, color: AppColors.blueColor),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleText(
                  text: label,
                  subtractedSize: 12,
                  color: AppColors.getGrayTextColor(context),
                  fontWeight: FontWeight.w500),
              const SizedBox(height: 2),
              TitleText(
                text: value,
                subtractedSize: 11,
                color: AppColors.getGrayTextColor(context),
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget savedPlaces() {
    return FutureBuilder<List<SavedLocation>>(
      future: LocationManager.getSavedLocations(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        final locations = snapshot.data!;
        return SavedLocationsList(
          locations: locations,
          onLocationSelected: (loc) {
            Navigator.pop(context, loc.coordinates);
          },
          onLocationDeleted: (loc) async {
            await LocationManager.deleteSavedLocation(loc.id);
          },
        );
      },
    );
  }

  Future<void> _openLocationPicker() async {
    // the main function to open the location picker
    final picked = await showModalBottomSheet<LatLng>(
      context: context,
      isScrollControlled: true,
      builder: (_) => LocationSelectionSheet(
        initialLocation: widget.location,
      ),
    );

    if (picked != null) {
      _handleLocationSelected(picked);
    }
  }

  // void _handleLocationSelected(LatLng location) {
  //   widget.onLocationSelected(location);
  //   _loadLocationAddress();
  //   setState(() => showLocationOptions = true);
  // }
  // void _handleLocationSelected(LatLng location) async {
  //   widget.onLocationSelected(location);
  //   _loadLocationAddress();
  //   setState(() => showLocationOptions = true);

  //   final newSavedLocation = SavedLocation(
  //     createdAt: DateTime.now(), // TODO
  //     id: DateTime.now().millisecondsSinceEpoch.toString(),
  //     name: 'Saved Location ${DateTime.now().minute}',
  //     coordinates: location,
  //     address: locationAddress,
  //     type: LocationType.other,
  //   );

  //   await LocationManager.saveLocation(newSavedLocation);
  // }
  void _handleLocationSelected(LatLng location) async {
    // final ok = await ensureLocationPermissions(context);
    // if (!ok) {
    //   showSnackbar(context, message: 'Please enable background location to set location reminders.');
    //   return;
    // }
    widget.onLocationSelected(location);
    _loadLocationAddress();
    setState(() => showLocationOptions = true);

    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final newSavedLocation = SavedLocation(
      createdAt: DateTime.now(),
      id: id,
      name: 'Saved Location ${DateTime.now().minute}',
      coordinates: location,
      address: locationAddress,
      type: LocationType.other,
    );

    await LocationManager.saveLocation(newSavedLocation);
    // final service = LocationReminderService();
    // try {
    //   await service.startMonitoring(
    //     id: id,
    //     lat: location.latitude,
    //     lng: location.longitude,
    //     radiusMeters: 100,
    //     title: 'Reminder',
    //     message: 'You reached your saved place',
    //   );
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Location reminder set')),
    //   );
    // } catch (e) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Failed to start monitoring: $e')),
    //   );
    // }
  }
}
