import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';

ThemeData getDefaultThemeLight(BuildContext? context) {
  return ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    scaffoldBackgroundColor: AppColors.scaffoldBackgroundColorLight,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.scaffoldBackgroundColorLight,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      iconTheme: IconThemeData(color: AppColors.Dark),
    ),
    colorScheme: ColorScheme.light(),
    cardColor: AppColors.white,
  );
}

ThemeData getThemeDark(BuildContext? context) {
  return ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    scaffoldBackgroundColor: AppColors.scaffoldBackgroundColorDark,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.Dark,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      iconTheme: IconThemeData(color: AppColors.white),
    ),
    colorScheme: ColorScheme.dark(),
    cardColor: AppColors.white,
  );
}
