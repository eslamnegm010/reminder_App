import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ThemeHelper {
  static ThemeMode _appTheme = ThemeMode.light;

  static void changeTheme(ThemeMode newTheme) {
    _appTheme = newTheme;
  }

  static ThemeMode get currentTheme => _appTheme;

  static ThemeData themeData([BuildContext? context]) {
    if (_appTheme == ThemeMode.light) {
      return getDefaultThemeLight(context);
    } else {
      return getThemeDark(context);
    }
  }
}

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
  );
}

class AppColors {
  static const blueColor = Color.fromARGB(255, 39, 194, 241);
  static const greyColor = Colors.grey;
  static const scaffoldBackgroundColorLight = Color(0XFFFFFFFF);
  static const scaffoldBackgroundColorDark = Color(0xFF000000);
  static const white = Color(0xFFFFFFFF);
  static const Dark = Color(0xFF000000);
}
