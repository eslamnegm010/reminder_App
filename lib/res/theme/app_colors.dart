import 'package:eslam_s_application/features/reminder/enum/reminder_priority.dart';
import 'package:flutter/material.dart';

class AppColors {
//  static const blueColor = Color.fromARGB(255, 39, 194, 241);
  static const blueColor = Color.fromARGB(255, 86, 140, 188);

  static const greyColor = Colors.grey;

  static Color getCardBackgroundColor(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode ? Colors.white.withOpacity(0.1) : Colors.grey.shade200;
  }

  static Color getTextColor(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode ? AppColors.white : AppColors.Dark;
  }

  static final Color Bordergrey = Colors.grey.shade300;
  static const scaffoldBackgroundColorLight = Color(0XFFFFFFFF);
  static const scaffoldBackgroundColorDark = Color(0xFF000000);
  static const white = Color(0xFFFFFFFF);
  static final Color borderwhite = Colors.white.withOpacity(0.15);
  static const Dark = Color(0xFF000000);
  static const grayDarkText = Color.fromARGB(255, 128, 125, 125);
  static const graylightText = Color.fromARGB(255, 241, 235, 235);
  static final cardGreyColor = Colors.grey[850];
  static final orange = Colors.orangeAccent;
  static const redColor = Colors.redAccent;

  static ThemeData pickerTheme(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Theme.of(context).copyWith(
      colorScheme: ColorScheme.light(
        primary: AppColors.blueColor,
        onPrimary: AppColors.Dark,
        onSurface: isDarkMode ? AppColors.white : AppColors.Dark,
        surface: Theme.of(context).scaffoldBackgroundColor,
      ),
      dialogBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.blueColor,
        ),
      ),
      useMaterial3: false,
    );
  }

  static Color optionPriorityColors(ReminderPriority priority) {
    switch (priority) {
      case ReminderPriority.high:
        return Colors.redAccent;
      case ReminderPriority.medium:
        return Colors.orangeAccent;
      case ReminderPriority.low:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  static const COMPOUND_GRADIENT = LinearGradient(colors: [
    Color(0xFF2E55A5),
    Color(0xFF2E55A3),
  ]);
}
