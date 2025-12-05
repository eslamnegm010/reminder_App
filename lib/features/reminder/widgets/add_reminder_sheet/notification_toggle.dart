import 'package:flutter/material.dart';
import '../../../../core/utils/app_export.dart';

class NotificationToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String title;

  const NotificationToggle({
    super.key,
    required this.value,
    required this.onChanged,
    this.title = "notify_for_this_reminder",
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: isDark ? Colors.white12 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: TitleText(
              text: title,
              subtractedSize: 12,
              fontWeight: FontWeight.w500,
              padding: const EdgeInsetsDirectional.only(start: 8),
              color: AppColors.getGrayTextColor(context),
            ),
          ),
          Switch.adaptive(
            activeColor: AppColors.blueColor,
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
