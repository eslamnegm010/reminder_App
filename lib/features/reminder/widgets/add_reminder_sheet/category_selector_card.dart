import 'package:flutter/material.dart';
import '../../../../sheared_widgets/text/title_text.dart';
import '../../enum/reminder_category.dart';

class CategorySelectorCard extends StatelessWidget {
  final ReminderCategory category;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDarkMode;

  const CategorySelectorCard({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? category.color.withValues(alpha: 0.2)
              : isDarkMode
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.black.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? category.color
                : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              category.icon,
              size: 18,
              color: isSelected 
                  ? category.color 
                  : isDarkMode ? Colors.white70 : Colors.black87,
            ),
            const SizedBox(width: 8),
            TitleText(
              text: category.label,
              subtractedSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected 
                  ? category.color 
                  : isDarkMode ? Colors.white70 : Colors.black87,
            ),
          ],
        ),
      ),
    );
  }
}
