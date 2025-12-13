import 'package:reminder_app/core/utils/size_utils.dart';
import 'package:reminder_app/features/reminder/enum/reminder_priority.dart';
import 'package:flutter/material.dart';

class AppColors {
  //  static const blueColor = Color.fromARGB(255, 39, 194, 241);
  static const blueColor = Color.fromARGB(255, 86, 140, 188);
  static const bluedark = Color.fromARGB(255, 38, 67, 91);
  static const bluelight = Color.fromARGB(255, 209, 219, 245);

  static const greyColor = Colors.grey;

  static Color getCardBackgroundColor(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode ? Colors.white.withValues(alpha: 0.1) : Colors.grey.shade200;
  }

  static Color getOrangColor(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode ? AppColors.orange.shade100 : Colors.orangeAccent.shade200;
  }

  static Color getTextColor(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode ? AppColors.white : AppColors.Dark;
  }

  static Color getGrayTextColor(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode ? AppColors.graylightText : AppColors.grayDarkText;
  }

  static final Color Bordergrey = Colors.grey.shade300;
  static const scaffoldBackgroundColorLight = Color(0XFFFFFFFF);
  static const scaffoldBackgroundColorDark = Color(0xFF000000);
  static const white = Color(0xFFFFFFFF);
  static final Color borderwhite = Colors.white.withValues(alpha: 0.15);
  static const Dark = Color(0xFF000000);
  static const grayDarkText = Color.fromARGB(255, 128, 125, 125);
  static const graylightText = Color.fromARGB(255, 241, 235, 235);
  static final cardGreyColor = Colors.grey[850];
  static final orange = Colors.orangeAccent;
  static const redColor = Colors.redAccent;

  static ThemeData pickerTheme(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = AppColors.blueColor;
    final onPrimary = Colors.white;
    final surface = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final onSurface = isDarkMode ? Colors.white : Colors.black;

    return ThemeData(
      useMaterial3: true,
      colorScheme: isDarkMode
          ? ColorScheme.dark(
              primary: primaryColor,
              onPrimary: onPrimary,
              surface: surface,
              onSurface: onSurface,
              primaryContainer: primaryColor.withValues(alpha: 0.3),
              onPrimaryContainer: Colors.white,
            )
          : ColorScheme.light(
              primary: primaryColor,
              onPrimary: onPrimary,
              surface: surface,
              onSurface: onSurface,
              primaryContainer: primaryColor.withValues(alpha: 0.2),
              onPrimaryContainer: AppColors.bluedark,
            ),
      scaffoldBackgroundColor: surface,
      dialogBackgroundColor: surface,
      datePickerTheme: DatePickerThemeData(
        headerBackgroundColor: primaryColor,
        headerForegroundColor: onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        headerHelpStyle: TextStyle(
          color: isDarkMode ? Colors.white70 : Colors.white,
          fontSize: 16.h,
        ),
        headerHeadlineStyle: TextStyle(
          color: onPrimary,
          fontSize: 24.h,
          fontWeight: FontWeight.bold,
        ),
        dayStyle: const TextStyle(fontWeight: FontWeight.w500),
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        hourMinuteShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        dayPeriodBorderSide: BorderSide(color: AppColors.blueColor),
        dayPeriodColor: AppColors.blueColor,
        dayPeriodShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        dialHandColor: AppColors.blueColor,
        dialBackgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
        entryModeIconColor: AppColors.blueColor,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
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
    }
  }

  static Color priorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.redAccent.shade200;
      case 'medium':
        return Colors.orangeAccent.shade200;
      case 'low':
      default:
        return Colors.green.shade300;
    }
  }

  static const COMPOUND_GRADIENT = LinearGradient(
    colors: [Color(0xFF2E55A5), Color(0xFF2E55A3)],
  );

  static Color blueTextColor(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode ? bluelight : bluedark;
  }
}
// decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //     colors: [
        //       AppColors.blueColor.withOpacity(0.08),
        //       Theme.of(context).scaffoldBackgroundColor,
        //     ],
        //     begin: Alignment.topCenter,
        //     end: Alignment.bottomCenter,
        //   ),
        // ),