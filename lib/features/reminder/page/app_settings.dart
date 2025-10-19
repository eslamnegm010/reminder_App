import 'package:eslam_s_application/core/constans/app_constants.dart';
import 'package:eslam_s_application/features/reminder/widgets/drawer_item.dart';
import 'package:eslam_s_application/features/user/pages/user_form_page.dart';
import 'package:eslam_s_application/features/user/user_cubit/user_cubit.dart';
import 'package:eslam_s_application/features/user/user_cubit/user_state.dart';
import 'package:eslam_s_application/sheared_widgets/others/app_about_dialog.dart';
import 'package:eslam_s_application/sheared_widgets/others/snack_bar.dart';
import 'package:eslam_s_application/sheared_widgets/others/swaper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eslam_s_application/core/utils/app_export.dart';
import 'package:eslam_s_application/features/reminder/cubit/reminder_cubit.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eslam_s_application/features/app_home_screen/cubit/cubit/theme_cubit.dart';
import 'package:page_transition/page_transition.dart';

void showSettings(BuildContext context) {
  // final isDark = Theme.of(context).brightness == Brightness.dark;
  final currentLocale = context.locale;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) {
      return DraggableScrollableSheet(
        initialChildSize: 0.45,
        minChildSize: 0.28,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, controller) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Column(
              children: [
                swaper(),
                Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: AppColors.greyColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
                        ],
                      ),
                      child: ClipOval(
                        child: SvgPicture.asset(
                          AppAssets.userCircleIcon,
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(AppColors.blueColor, BlendMode.srcIn),
                        ),
                      ),
                    ),
                    SizedBox(width: UIConstants.marginSmall),
                    BlocBuilder<UserCubit, UserState>(
                      builder: (context, uState) {
                        final user = uState.user;
                        final displayName = user?.name ?? 'Guest User';
                        final displayEmail = user?.email ?? 'guest@example.com';
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TitleText(text: displayName, subtractedSize: 6),
                            const SizedBox(height: 4),
                            SubtitleText(text: displayEmail, subtractedSize: 2),
                          ],
                        );
                      },
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(ctx),
                      icon: Icon(Icons.close, color: AppColors.getTextColor(ctx)),
                    )
                  ],
                ),
                const SizedBox(height: UIConstants.marginLarge),
                Expanded(
                  child: ListView(
                    controller: controller,
                    children: [
                      SettingItem(
                        icon: Icons.light_mode_outlined,
                        title: 'theme',
                        trailing: BlocBuilder<ThemeCubit, ThemeState>(
                          builder: (context, state) {
                            return Transform.scale(
                              scale: 0.8,
                              child: Switch.adaptive(
                                activeColor: AppColors.blueColor,
                                value: state.isDark,
                                onChanged: (_) => context.read<ThemeCubit>().toggleTheme(),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      SettingItem(
                        icon: Icons.language,
                        title: currentLocale.languageCode == 'ar' ? 'English' : 'عربي',
                        subtitle: currentLocale.languageCode == 'ar' ? 'Switch to English' : 'التبديل إلى العربية',
                        onTap: () async {
                          await context
                              .setLocale(currentLocale.languageCode == 'ar' ? const Locale('en') : const Locale('ar'));
                          Navigator.pop(ctx);
                        },
                      ),
                      const SizedBox(height: 8),
                      SettingItem(
                        icon: Icons.person_outline,
                        title: 'edit_profile',
                        subtitle: 'edit_your_profile',
                        onTap: () {
                          Navigator.pop(ctx);
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.rightToLeft,
                              duration: const Duration(milliseconds: 320),
                              child: const UserProfilePage(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      SettingItem(
                        icon: Icons.delete_sweep_outlined,
                        title: 'clear_all_reminders',
                        subtitle: 'remove_all_saved_reminders',
                        color: AppColors.redColor,
                        onTap: () async {
                          Navigator.pop(ctx);
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (dCtx) => AlertDialog(
                              title: TitleText(
                                text: 'confirm',
                                subtractedSize: 10,
                                color: AppColors.redColor,
                                textAlign: TextAlign.start,
                                // alignment: Alignment.center,
                              ),
                              content: TitleText(
                                text: 'are_you_sure_remove_all_reminders',
                                subtractedSize: 12,
                                textAlign: TextAlign.start,
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(dCtx, false),
                                    child: TitleText(subtractedSize: 13, text: 'cancel', color: AppColors.redColor)),
                                TextButton(
                                    onPressed: () => Navigator.pop(dCtx, true),
                                    child: TitleText(subtractedSize: 13, text: 'yes')),
                              ],
                            ),
                          );
                          if (confirmed == true) {
                            final reminderCubit = context.read<ReminderCubit>();
                            reminderCubit.clearAll();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: TitleText.verySmall(text: 'all_reminders_removed')),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 8),
                      SettingItem(
                        icon: Icons.info_outline,
                        title: 'about',
                        subtitle: 'version'.tr(args: [AppConstants.appVersion]),
                        onTap: () {
                          Navigator.pop(ctx);
                          showDialog(
                            context: context,
                            builder: (ctx) => const AppAboutDialog(),
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      SettingItem(
                        icon: Icons.logout,
                        title: 'sign_out',
                        onTap: () {
                          Navigator.pop(ctx);
                          context.read<UserCubit>().clearUser();
                          showSnackbar(context, message: 'you_have_been_signed_out');
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('© ${DateTime.now().year} ${AppConstants.appName}',
                        style: TextStyle(color: AppColors.greyColor, fontSize: 12)),
                  ],
                )
              ],
            ),
          );
        },
      );
    },
  );
}
