import 'package:flutter/material.dart';
import '../../../../core/utils/app_export.dart';

class DateTimePickerButton extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;

  const DateTimePickerButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return OutlinedButton.icon(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: isDarkMode
              ? Colors.white.withValues(alpha: 0.1)
              : AppColors.blueColor.withValues(alpha: 0.1),
        ),
        backgroundColor: isDarkMode
            ? Colors.white.withValues(alpha: 0.03)
            : AppColors.blueColor.withValues(alpha: 0.04),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
      ),
      icon: SvgPicture.asset(
        icon,
        height: 18,
        width: 18,
        colorFilter: ColorFilter.mode(
          isDarkMode ? Colors.white70 : AppColors.blueColor,
          BlendMode.srcIn,
        ),
      ),
      label: TitleText(
        subtractedSize: 12,
        text: label,
        fontWeight: FontWeight.w600,
        color: isDarkMode ? Colors.white70 : AppColors.blueColor,
      ),
    );
  }
}
