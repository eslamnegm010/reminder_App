import 'package:eslam_s_application/core/constans/app_constants.dart';
import 'package:eslam_s_application/features/reminder/widgets/setting_item.dart';
import 'package:eslam_s_application/features/user/pages/user_form_page.dart';
import 'package:eslam_s_application/features/user/user_cubit/user_cubit.dart';
import 'package:eslam_s_application/features/user/user_cubit/user_state.dart';
import 'package:eslam_s_application/features/user/widgets/profile_header.dart';
import 'package:eslam_s_application/sheared_widgets/others/app_about_dialog.dart';
import 'package:eslam_s_application/sheared_widgets/others/snack_bar.dart';
import 'package:eslam_s_application/sheared_widgets/others/swaper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eslam_s_application/core/utils/app_export.dart';
import 'package:eslam_s_application/features/reminder/cubit/reminder_cubit.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eslam_s_application/features/app_home_screen/cubit/cubit/theme_cubit.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:page_transition/page_transition.dart';

void showSettings(BuildContext context) {
  final currentLocale = context.locale;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) {
      return DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.28,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, controller) {
          return Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Column(
              children: [
                swaper(),
                _buildHeader(ctx),
                const SizedBox(height: UIConstants.marginLarge),
                Expanded(
                    child: _buildSettingsList(
                  context,
                  ctx,
                  controller,
                  currentLocale,
                )),
                SafeArea(
                  top: false,
                  bottom: true,
                  left: false,
                  right: false,
                  child: _buildFooter(),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

// HEADER SECTION
Widget _buildHeader(BuildContext ctx) {
  return Row(
    children: [
      SizedBox(width: UIConstants.marginSmall),
      Expanded(
        child: BlocBuilder<UserCubit, UserState>(
          builder: (context, uState) {
            final user = uState.user;
            final displayName = user?.name ?? 'guest_user';
            final displayEmail = user?.email ?? 'guest@example.com';
            return ProfileHeader(
              nameCtrl: displayName,
              emailCtrl: displayEmail,
              isDark: Theme.of(ctx).brightness == Brightness.dark,
              mq: MediaQuery.of(ctx),
            );
          },
        ),
      ),
    ],
  );
}

// SETTINGS LIST SECTION
Widget _buildSettingsList(
  BuildContext context,
  BuildContext sheetContext,
  ScrollController controller,
  Locale currentLocale,
) {
  return ListView(
    controller: controller,
    children: [
      _buildEditProfileItem(context, sheetContext),
      const SizedBox(height: 8),
      _buildThemeItem(context),
      const SizedBox(height: 8),
      _buildLanguageItem(context, sheetContext, currentLocale),
      const SizedBox(height: 8),
      _buildAboutItem(context, sheetContext),
      const SizedBox(height: 8),
      _buildClearRemindersItem(context, sheetContext),
      const SizedBox(height: 8),
      _buildSignOutItem(context, sheetContext),
      const SizedBox(height: 16),
    ],
  );
}

// INDIVIDUAL ITEMS
Widget _buildThemeItem(BuildContext context) {
  return SettingItem(
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
  );
}

Widget _buildLanguageItem(BuildContext context, BuildContext sheetContext, Locale currentLocale) {
  return SettingItem(
    icon: Icons.language,
    title: currentLocale.languageCode == 'ar' ? 'English' : 'عربي',
    subtitle: currentLocale.languageCode == 'ar' ? 'Switch to English' : 'التبديل إلى العربية',
    onTap: () async {
      await context.setLocale(currentLocale.languageCode == 'ar' ? const Locale('en') : const Locale('ar'));
      Navigator.pop(sheetContext);
    },
  );
}

Widget _buildEditProfileItem(BuildContext context, BuildContext sheetContext) {
  return SettingItem(
    icon: Icons.person_outline,
    title: 'edit_profile',
    subtitle: 'edit_your_profile',
    onTap: () {
      Navigator.pop(sheetContext);
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.rightToLeft,
          duration: const Duration(milliseconds: 320),
          child: const UserProfilePage(),
        ),
      );
    },
  );
}

Widget _buildClearRemindersItem(BuildContext context, BuildContext sheetContext) {
  return SettingItem(
    icon: Icons.delete_sweep_outlined,
    title: 'clear_all_reminders',
    subtitle: 'remove_all_saved_reminders',
    color: AppColors.redColor,
    onTap: () async {
      Navigator.pop(sheetContext);
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dCtx) => AlertDialog(
          title: TitleText(
            text: 'confirm',
            subtractedSize: 10,
            color: AppColors.redColor,
            textAlign: TextAlign.start,
          ),
          content: TitleText(
            text: 'are_you_sure_remove_all_reminders',
            subtractedSize: 12,
            textAlign: TextAlign.start,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dCtx, false),
              child: TitleText(subtractedSize: 13, text: 'cancel', color: AppColors.redColor),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dCtx, true),
              child: TitleText(subtractedSize: 13, text: 'yes'),
            ),
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
  );
}

Widget _buildAboutItem(BuildContext context, BuildContext sheetContext) {
  return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        final versionText = snapshot.hasData ? '${snapshot.data!.version}' : '...';

        return SettingItem(
          icon: Icons.info_outline,
          title: 'about',
          subtitle: 'version'.tr(args: [versionText]),
          onTap: () {
            showDialog(
              context: context,
              builder: (ctx) => const AppAboutDialog(),
            );
          },
        );
      });
}

Widget _buildSignOutItem(BuildContext context, BuildContext sheetContext) {
  return SettingItem(
    icon: Icons.logout,
    title: 'sign_out',
    onTap: () {
      Navigator.pop(sheetContext);
      context.read<UserCubit>().clearUser();
      showSnackbar(context, message: 'you_have_been_signed_out');
    },
  );
}

// FOOTER SECTION
Widget _buildFooter() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        '© ${DateTime.now().year} ${AppConstants.appName}',
        style: TextStyle(color: AppColors.greyColor, fontSize: 12),
      ),
    ],
  );
}
