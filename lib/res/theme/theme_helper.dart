import 'package:flutter/material.dart';
import 'app_colors.dart';

ThemeData getDefaultThemeLight(BuildContext context) {
  return ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    scaffoldBackgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor,

    // AppColors.scaffoldBackgroundColorLight,
    appBarTheme: AppBarTheme(
      backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor,
      //AppColors.scaffoldBackgroundColorLight,
      // systemOverlayStyle: SystemUiOverlayStyle.dark,
      iconTheme: IconThemeData(color: AppColors.Dark),
    ),
    colorScheme: ColorScheme.light(),
    cardColor: AppColors.white,
  );
}

ThemeData getThemeDark(BuildContext context) {
  return ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    scaffoldBackgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor,
    //  AppColors.scaffoldBackgroundColorDark,
    appBarTheme: AppBarTheme(
      backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor,
      // AppColors.Dark,
      // systemOverlayStyle: SystemUiOverlayStyle.light,
      iconTheme: IconThemeData(color: AppColors.white),
    ),
    colorScheme: ColorScheme.dark(),
    cardColor: AppColors.white,
  );
}
