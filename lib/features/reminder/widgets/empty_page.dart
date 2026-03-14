import 'package:easy_localization/easy_localization.dart';
import 'package:reminder_app/core/utils/app_export.dart';
import 'package:flutter/material.dart';

ListView buildEmptyList(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return ListView(
    physics: const AlwaysScrollableScrollPhysics(),
    children: [
      SizedBox(height: 100.h),
      TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 600),
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(offset: Offset(0, 20 * (1 - value)), child: child),
          );
        },
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.blueColor.withValues(alpha: isDark ? 0.08 : 0.04),
              ),
              child: const Icon(
                Icons.event_note_rounded,
                size: 80,
                color: AppColors.blueColor,
              ),
            ),
            const SizedBox(height: 24),
            TitleText(
              text: 'no_reminder_yet'.tr(),
              subtractedSize: 4,
              fontWeight: FontWeight.w800,
              color: AppColors.blueColor,
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: SubtitleText(
                text: 'Tap + to add your first reminder',
                subtractedSize: 6,
                textAlign: TextAlign.center,
                color: AppColors.getTextColor(context).withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
