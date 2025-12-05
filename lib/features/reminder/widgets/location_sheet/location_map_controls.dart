import 'package:flutter/material.dart';
import 'package:eslam_s_application/res/theme/app_colors.dart';
import 'package:eslam_s_application/sheared_widgets/text/title_text.dart';

class LocationMapControls extends StatelessWidget {
  final String selectedMapType;
  final ValueChanged<String> onMapTypeChanged;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onCenterLocation;

  const LocationMapControls({
    super.key,
    required this.selectedMapType,
    required this.onMapTypeChanged,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onCenterLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _buildMapTypeChip(context, 'standard', 'standard', Icons.map_outlined),
          const SizedBox(width: 5),
          _buildMapTypeChip(
            context,
            'satellite',
            'satellite',
            Icons.satellite_alt_outlined,
          ),
          const SizedBox(width: 5),
          _buildZoomControls(),
        ],
      ),
    );
  }

  Widget _buildMapTypeChip(
    BuildContext context,
    String type,
    String label,
    IconData icon,
  ) {
    final isSelected = selectedMapType == type;
    return InkWell(
      onTap: () => onMapTypeChanged(type),
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.blueColor
              : AppColors.blueColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.blueColor.withValues(alpha: isSelected ? 1.0 : 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: isSelected ? Colors.white : AppColors.blueColor),
            const SizedBox(width: 6),
            TitleText(
              text: label,
              subtractedSize: 13,
              color: isSelected ? Colors.white : AppColors.blueColor,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildZoomControls() {
    return Row(
      children: [
        _buildZoomButton(Icons.remove_rounded, onZoomOut),
        const SizedBox(width: 8),
        _buildZoomButton(Icons.add_rounded, onZoomIn),
        const SizedBox(width: 8),
        _buildZoomButton(Icons.my_location_rounded, onCenterLocation),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildZoomButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.blueColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.blueColor.withValues(alpha: 0.3)),
        ),
        child: Icon(icon, size: 20, color: AppColors.blueColor),
      ),
    );
  }
}
