import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../utils/app_export.dart';
import 'models/location_model.dart';

class LocationTypeSelector extends StatelessWidget {
  final LocationType? selectedType;
  final ValueChanged<LocationType> onTypeSelected;

  const LocationTypeSelector({Key? key, this.selectedType, required this.onTypeSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: LocationType.values.map((type) {
        final isSelected = selectedType == type;
        return _buildTypeChip(context, type, isSelected);
      }).toList(),
    );
  }

  Widget _buildTypeChip(BuildContext context, LocationType type, bool isSelected) {
    return InkWell(
      onTap: () => onTypeSelected(type),
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? _getTypeColor(type) : _getTypeColor(type).withOpacity(0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _getTypeColor(type).withOpacity(isSelected ? 1.0 : 0.3), width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_getTypeIcon(type), size: 18, color: isSelected ? Colors.white : _getTypeColor(type)),
            const SizedBox(width: 8),
            Text(_getTypeName(type),
                style: TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : _getTypeColor(type))),
          ],
        ),
      ),
    );
  }

  IconData _getTypeIcon(LocationType type) {
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

  Color _getTypeColor(LocationType type) {
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

  String _getTypeName(LocationType type) {
    switch (type) {
      case LocationType.home:
        return 'home'.tr();
      case LocationType.work:
        return 'work'.tr();
      case LocationType.favorite:
        return 'favorite'.tr();
      case LocationType.other:
        return 'other'.tr();
    }
  }
}
