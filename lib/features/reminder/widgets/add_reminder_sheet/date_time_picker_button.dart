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
    return OutlinedButton.icon(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: AppColors.blueColor.withValues(alpha: 0.1)),
        backgroundColor: AppColors.blueColor.withValues(alpha: 0.05),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      icon: SvgPicture.asset(
        icon,
        height: 20,
        width: 20,
        colorFilter: ColorFilter.mode(AppColors.blueColor, BlendMode.srcIn),
      ),
      label: TitleText(subtractedSize: 12, text: label, color: AppColors.blueColor),
    );
  }
}
