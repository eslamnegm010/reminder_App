/*
import 'package:flutter/material.dart';
import 'package:reminder_app/res/theme/app_colors.dart';
import 'package:reminder_app/sheared_widgets/text/title_text.dart';

class LocationSheetHeader extends StatelessWidget {
  const LocationSheetHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        _buildDragHandle(isDark),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.blueColor.withValues(alpha: 0.2),
                      AppColors.blueColor.withValues(alpha: 0.1),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.map_outlined, color: AppColors.blueColor, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TitleText(
                      text: 'select_location',
                      subtractedSize: 8,
                      fontWeight: FontWeight.w700,
                      color: AppColors.blueTextColor(context),
                    ),
                    const SizedBox(height: 2),
                    TitleText(
                      text: 'tap_map_or_search',
                      subtractedSize: 13,
                      color: AppColors.getGrayTextColor(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDragHandle(bool isDark) => Container(
    margin: const EdgeInsets.only(top: 12, bottom: 8),
    width: 50,
    height: 5,
    decoration: BoxDecoration(
      color: isDark ? Colors.white24 : Colors.grey.shade300,
      borderRadius: BorderRadius.circular(10),
    ),
  );
}
*/
