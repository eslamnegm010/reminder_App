// /home/ubuntu/app/eslam_s_application/lib/routes/app_routes.dart

import 'package:reminder_app/features/reminder/page/reminder_page.dart';
import 'package:flutter/material.dart';
import '../features/app_home_screen/page/app_home_screen.dart';

import '../features/settings/pages/privacy_policy_page.dart';

class AppRoutes {
  static const String remainderPage = "/reminder_page.dart";
  static const String appNavigationScreen = '/app_navigation_screen';
  static const String privacyPolicyPage = '/privacy_policy_page';
  static const String initialRoute = '/initialRoute';

  static Map<String, WidgetBuilder> get routes => {
        initialRoute: (context) => const AppNavigationScreen(),
        appNavigationScreen: (context) => const AppNavigationScreen(),
        remainderPage: (context) => const ReminderPage(),
        privacyPolicyPage: (context) => const PrivacyPolicyPage(),
      };
}
