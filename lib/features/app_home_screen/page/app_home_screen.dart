import 'package:easy_localization/easy_localization.dart';
import 'package:eslam_s_application/core/utils/app_export.dart';
import 'package:eslam_s_application/core/constans/app_assets.dart';
import 'package:eslam_s_application/features/app_home_screen/cubit/cubit/theme_cubit.dart';
import 'package:eslam_s_application/sheared_widgets/text/subtitle_text.dart';
import 'package:eslam_s_application/sheared_widgets/text/title_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui' as ui;

import 'package:flutter_svg/flutter_svg.dart';

class AppNavigationScreen extends StatefulWidget {
  const AppNavigationScreen({Key? key}) : super(key: key);

  @override
  State<AppNavigationScreen> createState() => _AppNavigationScreenState();
}

class _AppNavigationScreenState extends State<AppNavigationScreen> {
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Directionality(
            textDirection: ui.TextDirection.ltr,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SvgPicture.asset(
                  isDarkMode ? AppAssets.themeDarkIcon : AppAssets.themeLightIcon,
                  height: 26.h,
                  width: 26.h,
                ),
                Transform.scale(
                  scale: 0.75,
                  child: Switch(
                    activeColor: AppColors.blueColor,
                    value: context.watch<ThemeCubit>().state.isDark,
                    onChanged: (value) {
                      context.read<ThemeCubit>().toggleTheme();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  AppAssets.appLogoLight,
                  height: 250,
                  width: 250,
                ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  children: [
                    TitleText(
                      text: 'reminder_create',
                      subtractedSize: 3,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 60.h,
                  width: double.infinity,
                  child: Card(
                    color: AppColors.greyColor,
                    elevation: 30,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: _buildScreenTitle(
                      context,
                      screenTitle: "create_now",
                      onTapScreenTitle: () => onTapScreenTitle(
                        context,
                        AppRoutes.remainderPage,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                Align(child: _buildChangeLanguageButton(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChangeLanguageButton(BuildContext context) {
    final currentLocale = context.locale;
    final fontFamily = currentLocale.languageCode == 'en' ? 'Cairo' : null;
    final isArabic = currentLocale == const Locale('ar');
    return Align(
      alignment: AlignmentDirectional.center,
      child: TextButton(
        style: TextButton.styleFrom(padding: EdgeInsets.zero),
        child: SubtitleText(
          text: isArabic ? 'English' : 'عربي',
          isBold: true,
          fontFamily: fontFamily,
          subtractedSize: isArabic ? -1 : -3,
        ),
        onPressed: () async {
          await context.setLocale(isArabic ? const Locale('en') : const Locale('ar'));
        },
      ),
    );
  }

  /// Common widget
  Widget _buildScreenTitle(
    BuildContext context, {
    required String screenTitle,
    Function? onTapScreenTitle,
  }) {
    return GestureDetector(
      onTap: () {
        onTapScreenTitle?.call();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.h),
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: AppColors.blueColor, width: .5)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TitleText.verySmall(
                text: screenTitle,
                color: AppColors.blueColor,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.bold),
            Icon(Icons.arrow_forward, color: Color(0XFF343330)),
          ],
        ),
      ),
    );
  }

  /// Common click event
  void onTapScreenTitle(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }
}
