// /home/ubuntu/app/eslam_s_application/lib/routes/app_routes.dart

import 'package:eslam_s_application/features/reminder/page/reminder_page.dart';
import 'package:flutter/material.dart';
import '../features/app_home_screen/page/app_home_screen.dart';

class AppRoutes {
  static const String remainderPage = "/reminder_page.dart";
  static const String appNavigationScreen = '/app_navigation_screen';
  static const String initialRoute = '/initialRoute';

  static Map<String, WidgetBuilder> get routes => {
        appNavigationScreen: (context) => AppNavigationScreen(),
        initialRoute: (context) => AppNavigationScreen(),
        remainderPage: (context) => ReminderPage(),
      };
}
