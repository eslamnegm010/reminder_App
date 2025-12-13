import 'package:reminder_app/res/theme/app_colors.dart';
import 'package:flutter/material.dart';

Container swaper() {
  return Container(
    width: 60,
    height: 4,
    margin: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      color: AppColors.grayDarkText.withValues(alpha: 0.6),
      borderRadius: BorderRadius.circular(10),
    ),
  );
}
