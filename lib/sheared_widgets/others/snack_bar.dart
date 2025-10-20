import 'package:flutter/material.dart';

import '../../core/utils/app_export.dart';

void showSnackbar(BuildContext context, {required String message}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: AppColors.white,
      content: TitleText.verySmall(text: message, color: AppColors.bluedark, fontWeight: FontWeight.w600, maxLines: 2),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
