import 'package:reminder_app/core/location_services/Extensions/latLng_extensions.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/location_services/models/location_model.dart';
import '../../../../core/utils/app_export.dart';

class SavedLocationsList extends StatelessWidget {
  final List<SavedLocation> locations;
  final ValueChanged<SavedLocation> onLocationSelected;
  final ValueChanged<SavedLocation>? onLocationDeleted;
  final LatLng? selectedLocation;

  const SavedLocationsList({
    Key? key,
    required this.locations,
    required this.onLocationSelected,
    this.onLocationDeleted,
    this.selectedLocation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (locations.isEmpty) return SizedBox.shrink();

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: locations.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) => _buildLocationCard(context, locations[index]),
    );
  }

  Widget _buildLocationCard(BuildContext context, SavedLocation location) {
    bool isSelected = false;
    if (selectedLocation != null) {
      if (location.coordinates.latitude == selectedLocation!.latitude &&
          location.coordinates.longitude == selectedLocation!.longitude) {
        isSelected = true;
      }
    }

    return Dismissible(
      key: Key(location.id),
      direction: DismissDirection.endToStart,
      background: Container(
        decoration: BoxDecoration(
          color: AppColors.redColor,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
      ),
      onDismissed: (_) => onLocationDeleted?.call(location),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onLocationSelected(location),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.blueColor.withValues(alpha: 0.08),
                  AppColors.blueColor.withValues(alpha: 0.04),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? AppColors.blueColor
                    : AppColors.blueColor.withValues(alpha: 0.2),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getIconColor(location.type).withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getIconData(location.type),
                    color: _getIconColor(location.type),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleText(
                        text: location.name,
                        color: AppColors.getTextColor(context),
                        fontWeight: FontWeight.w600,
                        subtractedSize: 10,
                      ),
                      const SizedBox(height: 4),
                      SubtitleText(
                        text:
                            location.address ?? location.coordinates.toFormattedString(),
                        color: AppColors.getGrayTextColor(context),
                        maxLines: 1,
                        subtractedSize: 5,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIconData(LocationType type) {
    switch (type) {
      case LocationType.home:
        return Icons.home_rounded;
      case LocationType.work:
        return Icons.work_rounded;
      case LocationType.favorite:
        return Icons.favorite_rounded;
      case LocationType.other:
        return Icons.location_on_rounded;
    }
  }

  Color _getIconColor(LocationType type) {
    switch (type) {
      case LocationType.home:
        return Colors.teal;
      case LocationType.work:
        return Colors.orange;
      case LocationType.favorite:
        return Colors.red;
      case LocationType.other:
        return AppColors.blueColor;
    }
  }
}
