import 'package:flutter/material.dart';
import 'package:reminder_app/core/utils/app_export.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:reminder_app/core/constans/app_constants.dart';
import 'package:reminder_app/core/utils/app_launcher.dart';

class AppAboutPage extends StatelessWidget {
  const AppAboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,

        title: TitleText(
          text: 'about'.tr().toUpperCase(),
          subtractedSize: 10,
          color: AppColors.getTextColor(context),
          fontWeight: FontWeight.w700,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // App Logo
            Container(
              height: 100,
              width: 100,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.blueColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Image.asset(AppAssets.appLauncher),
            ),
            const SizedBox(height: 16),
            // App Name
            const TitleText(
              text: AppConstants.appName,
              subtractedSize: 4,
              fontWeight: FontWeight.w900,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            // Version
            FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) {
                final versionText = snapshot.hasData ? snapshot.data!.version : '...';
                return TitleText(
                  text: 'version'.tr(args: [versionText]),
                  subtractedSize: 12,
                  color: AppColors.greyColor,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w500,
                );
              },
            ),
            const SizedBox(height: 40),
            // Our Mission
            _buildSection(context, 'about_mission_title'.tr(), 'about_mission_body'.tr()),
            const SizedBox(height: 40),
            // Key Features
            TitleText(
              text: 'about_features_title'.tr(),
              subtractedSize: 10,

              color: AppColors.getTextColor(context),
              fontWeight: FontWeight.w700,
              alignment: AlignmentDirectional.topStart,
            ),
            const SizedBox(height: 16),
            _buildFeatureItem(
              context,
              Icons.auto_awesome_outlined,
              'about_feature_simple_title'.tr(),
              'about_feature_simple_body'.tr(),
            ),
            const SizedBox(height: 16),
            _buildFeatureItem(
              context,
              Icons.shield_outlined,
              'about_feature_privacy_title'.tr(),
              'about_feature_privacy_body'.tr(),
            ),
            const SizedBox(height: 16),
            _buildFeatureItem(
              context,
              Icons.notifications_active_outlined,
              'about_feature_notifications_title'.tr(),
              'about_feature_notifications_body'.tr(),
            ),
            const SizedBox(height: 40),
            // Contact Section
            TitleText(
              text: 'contact_us'.tr(),
              subtractedSize: 11,

              fontWeight: FontWeight.w700,
              alignment: AlignmentDirectional.topStart,
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () async {
                await launchEmail(email: AppConstants.myEmail);
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.blueColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.blueColor.withValues(alpha: 0.2)),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.alternate_email_rounded,
                      color: AppColors.blueColor,
                      size: 24,
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TitleText(
                            text: 'email',
                            subtractedSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.blueColor,
                          ),
                          SubtitleText(
                            text: AppConstants.myEmail,
                            color: AppColors.blueColor,
                            isBold: true,
                            subtractedSize: 5,
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.open_in_new_rounded, color: AppColors.blueColor, size: 18),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleText(
          text: title,
          subtractedSize: 10,
          color: AppColors.getTextColor(context),
          fontWeight: FontWeight.w700,
        ),
        const SizedBox(height: 12),
        SubtitleText(
          text: content,
          color: AppColors.getTextColor(context).withValues(alpha: 0.8),
          subtractedSize: 4,
          height: 1.6,
        ),
      ],
    );
  }

  Widget _buildFeatureItem(
    BuildContext context,
    IconData icon,
    String title,
    String description,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.blueColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.blueColor, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleText(
                text: title,
                subtractedSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.getTextColor(context),
              ),
              const SizedBox(height: 4),
              SubtitleText(
                text: description,
                color: AppColors.getTextColor(context).withValues(alpha: 0.7),
                subtractedSize: 4,
                height: 1.4,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
