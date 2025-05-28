// /home/ubuntu/app/eslam_s_application/lib/routes/app_routes.dart

import 'package:flutter/material.dart';
import '../presentation/profile_screen/profile_screen.dart';
import '../presentation/mark_zuckerberg_threads_profile_page/mark_zuckerberg_threads_profile_page.dart';
import '../presentation/threads_app_architecture_overview/threads_app_architecture_overview.dart';
import '../presentation/app_navigation_screen/app_navigation_screen.dart';

class AppRoutes {
  static const String profileScreen = '/profile_screen';
  static const String markZuckerbergThreadsProfilePage = '/mark-zuckerberg-threads-profile-page';
  static const String threadsAppArchitectureOverview = '/threads-app-architecture-overview';
  static const String appNavigationScreen = '/app_navigation_screen';
  static const String initialRoute = '/initialRoute';

  static Map<String, WidgetBuilder> get routes => {
    profileScreen: (context) => ProfileScreen(),
    markZuckerbergThreadsProfilePage: (context) => MarkZuckerbergThreadsProfilePage(),
    threadsAppArchitectureOverview: (context) => ThreadsAppArchitectureOverview(),
    appNavigationScreen: (context) => AppNavigationScreen(),
    initialRoute: (context) => AppNavigationScreen(),
  };
}
