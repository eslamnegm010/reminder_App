// ignore_for_file: prefer_const_declarations

import 'package:easy_localization/easy_localization.dart';
import 'package:upgrader/upgrader.dart';
import 'package:reminder_app/core/utils/app_export.dart';
import 'package:reminder_app/features/app_home_screen/cubit/cubit/theme_cubit.dart';
import 'package:reminder_app/features/user/pages/user_form_page.dart';
import 'package:reminder_app/features/user/user_cubit/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reminder_app/core/local_storage/hive.dart';
import 'package:reminder_app/core/notifications/notification_service.dart';
import 'package:page_transition/page_transition.dart';

class AppNavigationScreen extends StatefulWidget {
  const AppNavigationScreen({super.key});

  @override
  State<AppNavigationScreen> createState() => _AppNavigationScreenState();
}

class _AppNavigationScreenState extends State<AppNavigationScreen> {
  @override
  void initState() {
    super.initState();
    _checkAndShowWelcomeNotification();
  }

  void _checkAndShowWelcomeNotification() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final bool hasSeenWelcome = HiveService.settingsBox.get(
        'has_seen_welcome',
        defaultValue: false,
      );

      if (!hasSeenWelcome) {
        await NotificationService.instance.welcomeImmediateShow();
        await HiveService.settingsBox.put('has_seen_welcome', true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool forceUpdate = false;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return UpgradeAlert(
      showIgnore: !forceUpdate,
      showLater: true,
      dialogStyle: UpgradeDialogStyle.cupertino,
      cupertinoButtonTextStyle: const TextStyle(
        color: AppColors.blueColor,
        fontWeight: FontWeight.bold,
      ),
      upgrader: Upgrader(
        messages: UpgraderMessages(code: context.locale.languageCode),
        durationUntilAlertAgain: const Duration(seconds: 1),
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: _buildAppBar(context),
        body: Stack(
          children: [
            // Top background gradient wash
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 300,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.blueColor.withValues(alpha: isDark ? 0.12 : 0.08),
                      Colors.transparent,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            _buildPageBody(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPageBody(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final mq = MediaQuery.of(context);
    final logoSize = mq.size.width * 0.60;

    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: 'app_logo',
                  child: Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.blueColor.withValues(
                        alpha: isDarkMode ? 0.08 : 0.04,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.blueColor.withValues(alpha: 0.05),
                          blurRadius: 40,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: SizedBox(
                      height: logoSize * 0.65,
                      width: logoSize * 0.65,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Image.asset(AppAssets.appLogoLight),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 52.h),
                TitleText(
                  text: 'reminder_create',
                  subtractedSize: 6,
                  color: AppColors.getTextColor(context),
                  fontWeight: FontWeight.w400,
                  textAlign: TextAlign.start,
                  alignment: AlignmentDirectional.centerStart,
                ),
                const SizedBox(height: 14),
                // Premium CTA Card
                Container(
                  height: 90.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    gradient: LinearGradient(
                      colors: isDarkMode
                          ? [
                              Colors.white.withValues(alpha: 0.08),
                              Colors.white.withValues(alpha: 0.03),
                            ]
                          : [Colors.white, Colors.white.withValues(alpha: 0.9)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDarkMode
                            ? Colors.black26
                            : AppColors.blueColor.withValues(alpha: 0.08),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                    border: Border.all(
                      color: AppColors.white.withValues(alpha: isDarkMode ? 0.05 : 0.4),
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(22),
                      onTap: () => onTapScreenTitle(context),
                      child: Row(
                        children: [
                          // Gradient Accent bar
                          Container(
                            width: 8,
                            margin: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 12,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.blueColor,
                                  AppColors.blueColor.withValues(alpha: 0.5),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const TitleText(
                                  text: 'create_now',
                                  color: AppColors.blueColor,
                                  subtractedSize: 2,
                                  fontWeight: FontWeight.w800,
                                ),
                                const SizedBox(height: 6),
                                SubtitleText(
                                  text: 'start_adding_reminders',
                                  subtractedSize: 5,
                                  color: AppColors.getTextColor(
                                    context,
                                  ).withValues(alpha: 0.7),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 18.h, left: 12.h),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.blueColor.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: AppColors.blueColor,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 36.h),
                _buildChangeLanguageButton(context),
              ],
            ),
          ),
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
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
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
          const Icon(Icons.language, size: 18, color: AppColors.greyColor),
        ],
      ),
    );
  }

  void onTapScreenTitle(BuildContext context) {
    final user = context.read<UserCubit>().state.user;
    final hasUser = user != null && user.name.trim().isNotEmpty;
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
    final isDark = themeCubit.state.isDark;

    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      titleSpacing: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.getCardBackgroundColor(context),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: AppColors.blueColor.withValues(alpha: 0.1)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return ScaleTransition(
                        scale: CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeInOut,
                        ),
                        child: FadeTransition(opacity: animation, child: child),
                      );
                    },
                    child: SvgPicture.asset(
                      isDark ? AppAssets.sunIcon : AppAssets.moonIcon,
                      key: ValueKey<bool>(isDark),
                      height: 20.h,
                      width: 20.h,
                      colorFilter: const ColorFilter.mode(
                        AppColors.blueColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                Transform.scale(
                  scale: 0.75,
                  child: Switch.adaptive(
                    activeColor: AppColors.blueColor,
                    value: isDark,
                    onChanged: (_) => context.read<ThemeCubit>().toggleTheme(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
