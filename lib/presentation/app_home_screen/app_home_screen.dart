import 'package:easy_localization/easy_localization.dart';
import 'package:eslam_s_application/widgets/subtitle_text.dart';
import 'package:eslam_s_application/widgets/text.dart';
import 'package:flutter/material.dart';

import '../../core/app_export.dart';

class AppNavigationScreen extends StatelessWidget {
  const AppNavigationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0XFFFFFFFF),
        ),
        backgroundColor: Color(0XFFFFFFFF),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TitleText(
                  text: 'reminder_create',
                  subtractedSize: 3,
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
          await context
              .setLocale(isArabic ? const Locale('en') : const Locale('ar'));
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
            color: Color(0XFFFFFFFF),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: AppColors.blueColor, width: .5)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TitleText.verySmall(
              text:  screenTitle,
               color: AppColors.blueColor,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.bold
            ),
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
