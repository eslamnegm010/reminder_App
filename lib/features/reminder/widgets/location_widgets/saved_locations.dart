import 'package:eslam_s_application/core/location_services/Extensions/latLng_extensions.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/location_services/models/location_model.dart';
import '../../../../core/utils/app_export.dart';

class SavedLocationsList extends StatelessWidget {
  final List<SavedLocation> locations;
  final ValueChanged<SavedLocation> onLocationSelected;
  final ValueChanged<SavedLocation>? onLocationDeleted;

  const SavedLocationsList({
    Key? key,
    required this.locations,
    required this.onLocationSelected,
    this.onLocationDeleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (locations.isEmpty) return SizedBox.shrink();
    //_buildEmptyState(context);

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: locations.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) => _buildLocationCard(context, locations[index]),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.location_off_outlined, size: 64, color: AppColors.getGrayTextColor(context).withOpacity(0.4)),
          const SizedBox(height: 16),
          Text('no_saved_locations'.tr(),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.getGrayTextColor(context))),
          const SizedBox(height: 8),
          Text('tap_to_save_location'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppColors.getGrayTextColor(context).withOpacity(0.7))),
        ],
      ),
    );
  }

  Widget _buildLocationCard(BuildContext context, SavedLocation location) {
    return Dismissible(
      key: Key(location.id),
      direction: DismissDirection.endToStart,
      background: Container(
        decoration: BoxDecoration(color: AppColors.redColor, borderRadius: BorderRadius.circular(16)),
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
                  colors: [AppColors.blueColor.withOpacity(0.08), AppColors.blueColor.withOpacity(0.04)]),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.blueColor.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration:
                      BoxDecoration(color: _getIconColor(location.type).withOpacity(0.15), shape: BoxShape.circle),
                  child: Icon(_getIconData(location.type), color: _getIconColor(location.type), size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(location.name,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.getTextColor(context))),
                      const SizedBox(height: 4),
                      Text(location.address ?? location.coordinates.toFormattedString(),
                          style: TextStyle(fontSize: 12, color: AppColors.getGrayTextColor(context)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: AppColors.blueColor),
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
