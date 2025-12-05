import 'package:flutter/material.dart';
import '../../../../core/utils/app_export.dart';

class PrioritySelectorCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const PrioritySelectorCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isSelected ? color.withValues(alpha: .85) : color.withValues(alpha: .15),
        borderRadius: BorderRadius.circular(16),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: color.withValues(alpha: .4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : color.withValues(alpha: .8),
                size: 22,
              ),
              const SizedBox(height: 4),
              TitleText(
                text: title,
                subtractedSize: 12,
                color: isSelected ? Colors.white : AppColors.greyColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
