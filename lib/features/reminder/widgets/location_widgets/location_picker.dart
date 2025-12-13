import 'package:reminder_app/core/location_services/Extensions/latLng_extensions.dart';
import 'package:reminder_app/core/location_services/models/location_model.dart';
import 'package:reminder_app/features/reminder/widgets/location_widgets/saved_locations.dart';
import 'package:reminder_app/features/reminder/widgets/main_widgets/location_sheet.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/utils/app_export.dart';

import 'package:reminder_app/features/reminder/cubit/location_picker_cubit.dart';
import 'package:reminder_app/features/reminder/cubit/location_picker_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocationPicker extends StatefulWidget {
  final LatLng? location;
  final String hint;
  final String helper;
  final ValueChanged<LocationSearchResult?> onLocationSelected;
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
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LocationPickerCubit()..init(widget.location),
      child: Builder(
        builder: (context) => _LocationPickerContent(
          location: widget.location,
          hint: widget.hint,
          helper: widget.helper,
          onLocationSelected: widget.onLocationSelected,
          onClear: widget.onClear,
        ),
      ),
    );
  }
}

class _LocationPickerContent extends StatelessWidget {
  final LatLng? location;
  final String hint;
  final String helper;
  final ValueChanged<LocationSearchResult?> onLocationSelected;
  final VoidCallback? onClear;

  const _LocationPickerContent({
    Key? key,
    this.location,
    required this.hint,
    required this.helper,
    required this.onLocationSelected,
    this.onClear,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationPickerCubit, LocationPickerState>(
      builder: (context, state) {
        final cubit = context.read<LocationPickerCubit>();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: _buildLocationButton(context, cubit)),
                if (location != null) ...[
                  const SizedBox(width: 8),
                  _buildClearButton(context, cubit),
                ],
              ],
            ),
            const SizedBox(height: 8),
            _buildSavedPlaces(context, cubit, state),

            if (location != null && state.showLocationOptions) ...[
              _buildLocationDetails(context, state),
            ],
          ],
        );
      },
    );
  }

  Widget _buildLocationButton(BuildContext context, LocationPickerCubit cubit) {
    return ElevatedButton.icon(
      onPressed: () => _openLocationPicker(context, cubit),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.blueColor.withValues(alpha: 0.08),
        foregroundColor: AppColors.blueColor,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: AppColors.blueColor.withValues(alpha: 0.2)),
        ),
        elevation: 0,
      ),
      icon: Icon(Icons.location_on_rounded, size: 20),
      label: Text(
        location != null ? location!.toFormattedString() : hint.tr(),
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: location != null
              ? AppColors.blueColor
              : AppColors.getGrayTextColor(context),
        ),
      ),
    );
  }

  Widget _buildClearButton(BuildContext context, LocationPickerCubit cubit) {
    return IconButton(
      onPressed: () =>
          cubit.clearSelection(onSelected: onLocationSelected, onClear: onClear),
      style: IconButton.styleFrom(
        backgroundColor: AppColors.redColor.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: Icon(Icons.close_rounded, color: AppColors.redColor, size: 20),
    );
  }

  Widget _buildLocationDetails(BuildContext context, LocationPickerState state) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.blueColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (state.locationAddress != null) ...[
            _buildDetailRow(
              context,
              Icons.location_city_rounded,
              'address'.tr(),
              state.locationAddress!,
            ),
          ],
          const SizedBox(height: 5),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.blueColor.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
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
                fontWeight: FontWeight.w500,
              ),
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

  Widget _buildSavedPlaces(
    BuildContext context,
    LocationPickerCubit cubit,
    LocationPickerState state,
  ) {
    if (state.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return SavedLocationsList(
      locations: state.savedLocations,
      selectedLocation: location,
      onLocationSelected: (loc) {
        final result = LocationSearchResult(
          displayName: loc.name,
          type: 'saved',
          location: loc.coordinates,
          address: {'address': loc.address},
        );
        cubit.handleLocationSelection(result: result, onSelected: onLocationSelected);
      },
      onLocationDeleted: (loc) {
        cubit.deleteSavedLocation(
          loc: loc,
          currentSelectedCoordinates: location,
          onSelected: onLocationSelected,
          onClear: onClear,
        );
      },
    );
  }

  Future<void> _openLocationPicker(
    BuildContext context,
    LocationPickerCubit cubit,
  ) async {
    final picked = await showModalBottomSheet<LocationSearchResult>(
      context: context,
      isScrollControlled: true,
      builder: (_) => LocationSelectionSheet(initialLocation: location),
    );

    if (picked != null) {
      cubit.handleLocationSelection(result: picked, onSelected: onLocationSelected);
    }
  }
}
