// import 'package:eslam_s_application/core/constans/app_assets.dart';
// import 'package:eslam_s_application/core/utils/app_export.dart';
// import 'package:eslam_s_application/presentation/app_home_screen/page/app_home_screen.dart';
// import 'package:flutter/material.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
// void initState() {
//   super.initState();
  
//   WidgetsBinding.instance.addPostFrameCallback((_) {
//     Future.delayed(const Duration(seconds: 3), () {
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (context) => const AppNavigationScreen()),
//       );
//     });
//   });
// }


//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     return Scaffold(
//       backgroundColor: isDark
//           ? AppColors.scaffoldBackgroundColorDark
//           : AppColors.scaffoldBackgroundColorLight,
//       body: Center(
//         child: Image.asset(
//           AppAssets.appLogoLight,
//           width: 150,
//           height: 150,
//         ),
//       ),
//     );
//   }
// }
