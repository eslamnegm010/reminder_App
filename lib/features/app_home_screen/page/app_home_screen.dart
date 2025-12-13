import 'package:easy_localization/easy_localization.dart';
import 'package:reminder_app/core/utils/app_export.dart';
import 'package:reminder_app/features/app_home_screen/cubit/cubit/theme_cubit.dart';
import 'package:reminder_app/features/user/pages/user_form_page.dart';
import 'package:reminder_app/features/user/user_cubit/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui' as ui;

import 'package:page_transition/page_transition.dart';

class AppNavigationScreen extends StatelessWidget {
  const AppNavigationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(appBar: _buildAppBar(context), body: _buildPageBody(context)),
    );
  }

  Widget _buildPageBody(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final mq = MediaQuery.of(context);
    final logoSize = mq.size.width * 0.60;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: logoSize,
              width: logoSize,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Image.asset(AppAssets.appLogoLight),
              ),
            ),
            SizedBox(height: 36.h),
            TitleText(
              text: 'reminder_create',
              subtractedSize: 7,
              color: AppColors.getTextColor(context),
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.start,
              alignment: AlignmentDirectional.centerStart,
            ),
            const SizedBox(height: UIConstants.paddingMedium),
            SizedBox(
              height: 72.h,
              width: double.infinity,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => onTapScreenTitle(context),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.getCardBackgroundColor(context),
                      border: Border.all(
                        color: AppColors.blueColor.withValues(alpha: 0.08),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isDarkMode
                              ? Colors.black26
                              : Colors.grey.withValues(alpha: 0.06),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.blueColor,
                            borderRadius: const BorderRadiusDirectional.only(
                              topStart: Radius.circular(20),
                              bottomStart: Radius.circular(20),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TitleText(
                                text: 'create_now',
                                color: AppColors.getTextColor(context),
                                subtractedSize: 3,
                                fontWeight: FontWeight.w700,
                              ),
                              const SizedBox(height: 6),
                              SubtitleText(
                                text: 'start_adding_reminders',
                                subtractedSize: 5,
                                color: AppColors.getTextColor(context),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.blueColor.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.arrow_forward, color: AppColors.blueColor),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30.h),
            _buildChangeLanguageButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildChangeLanguageButton(BuildContext context) {
    final currentLocale = context.locale;
    final isArabic = currentLocale.languageCode == 'ar';
    final fontFamily = currentLocale.languageCode == 'en' ? 'Cairo' : null;

    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        backgroundColor: AppColors.getCardBackgroundColor(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () async {
        await context.setLocale(isArabic ? const Locale('en') : const Locale('ar'));
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SubtitleText(
            text: isArabic ? 'English' : 'عربي',
            isBold: true,
            fontFamily: fontFamily,
            subtractedSize: isArabic ? 4 : 2,
            color: AppColors.getTextColor(context),
          ),
          const SizedBox(width: 8),
          Icon(Icons.language, size: 18, color: AppColors.greyColor),
        ],
      ),
    );
  }

  void onTapScreenTitle(BuildContext context) {
    final user = context.read<UserCubit>().state.user;
    final hasUser =
        user != null && user.name.trim().isNotEmpty && user.email.trim().isNotEmpty;
    if (hasUser) {
      Navigator.pushReplacementNamed(context, AppRoutes.remainderPage);
    } else {
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.rightToLeft,
          duration: const Duration(milliseconds: 350),
          child: const UserProfilePage(),
        ),
      );
    }
  }

  AppBar _buildAppBar(BuildContext context) {
    final themeCubit = context.watch<ThemeCubit>();

    return AppBar(
      elevation: 0,
      titleSpacing: 0,
      title: Directionality(
        textDirection: ui.TextDirection.ltr,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(
                    scale: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
                    child: RotationTransition(
                      turns: Tween<double>(begin: .3, end: 1.0).animate(animation),
                      child: FadeTransition(opacity: animation, child: child),
                    ),
                  );
                },
                child: SvgPicture.asset(
                  themeCubit.state.isDark ? AppAssets.sunIcon : AppAssets.moonIcon,
                  key: ValueKey<bool>(themeCubit.state.isDark),
                  height: 26.h,
                  width: 26.h,
                  colorFilter: ColorFilter.mode(
                    AppColors.getTextColor(context),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            Transform.scale(
              scale: 0.85,
              child: Switch.adaptive(
                activeColor: AppColors.blueColor,
                value: themeCubit.state.isDark,
                onChanged: (_) => context.read<ThemeCubit>().toggleTheme(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
