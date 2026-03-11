import 'package:flutter/material.dart';
import 'app_colors.dart';

double bodySmall = 20.0;
double bodyMedium = 16.0;
double bodyLarge = 30.0;
double headlineSmall = 22.0;
double headlineMedium = 24.0;
double headlineLarge = 25.0;
ThemeData getDefaultThemeLight(BuildContext context) {
  return ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    scaffoldBackgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor,
    textTheme: TextTheme(
      bodySmall: _normalText(context, bodySmall),
      bodyMedium: _normalText(context, bodyMedium),
      bodyLarge: _normalText(context, bodyLarge),
      headlineSmall: _boldText(context, headlineSmall),
      headlineMedium: _boldText(context, headlineMedium),
      headlineLarge: _boldText(context, headlineLarge),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor,
      iconTheme: IconThemeData(color: AppColors.Dark),
    ),
    textSelectionTheme: TextSelectionThemeData(cursorColor: AppColors.white),
    colorScheme: ColorScheme.light(),
    cardColor: AppColors.white,
  );
}

ThemeData getThemeDark(BuildContext context) {
  return ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    scaffoldBackgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor,
    appBarTheme: AppBarTheme(
      backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor,
      iconTheme: IconThemeData(color: AppColors.white),
    ),
    colorScheme: ColorScheme.dark(),
    cardColor: AppColors.white,
    textSelectionTheme: TextSelectionThemeData(cursorColor: AppColors.white),
    textTheme: TextTheme(
      bodySmall: _normalText(context, bodySmall),
      bodyMedium: _normalText(context, bodyMedium),
      bodyLarge: _normalText(context, bodyLarge),
      headlineSmall: _boldText(context, headlineSmall),
      headlineMedium: _boldText(context, headlineMedium),
      headlineLarge: _boldText(context, headlineLarge),
    ),
  );
}

TextStyle _normalText(BuildContext context, double size, {bool isLight = false}) {
  return TextStyle(
    color: isLight ? AppColors.Dark : AppColors.white,
    fontWeight: FontWeight.w400,
    fontSize: size,
    // fontFamily: context.locale.languageCode == 'en'
    //     ? UIConstants.englishTextTheme
    //     : UIConstants.arabicTextThemeName,
  );
}

TextStyle _boldText(BuildContext context, double size, {bool isLight = false}) {
  return TextStyle(
    color: isLight ? AppColors.Dark : AppColors.white,
    fontWeight: FontWeight.bold,
    fontSize: size,
    // fontFamily: context.locale.languageCode == 'en'
    //     ? UIConstants.englishTextTheme
    //     : UIConstants.arabicTextThemeName,
  );
}
