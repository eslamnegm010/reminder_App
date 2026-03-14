import 'package:easy_localization/easy_localization.dart';
import 'package:reminder_app/core/utils/app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:reminder_app/core/constans/app_constants.dart';
import 'package:reminder_app/core/utils/app_export.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppAboutDialog extends StatelessWidget {
  const AppAboutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.all(20),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
            padding: const EdgeInsets.all(12),
            child: Image.asset(AppAssets.appLauncher),
          ),
          const TitleText(
            text: AppConstants.appName,
            subtractedSize: 5,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              final versionText = snapshot.hasData ? snapshot.data!.version : '...';
              return TitleText(
                text: 'version'.tr(args: [versionText]),
                subtractedSize: 13,
                color: AppColors.greyColor,
                textAlign: TextAlign.center,
              );
            },
          ),
          const SizedBox(height: 16),
          const TitleText(
            text: 'about_app_description',
            textAlign: TextAlign.center,
            subtractedSize: 13,
            color: AppColors.greyColor,
          ),
          const SizedBox(height: 16),
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () async {
              await launchEmail(email: AppConstants.myEmail);
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.attach_email_outlined, size: 20, color: AppColors.blueColor),
                SizedBox(width: 6),
                TitleText(
                  subtractedSize: 11,
                  text: AppConstants.myEmail,
                  color: AppColors.blueColor,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // TextButton(
          //   onPressed: () async {
          //     // TODO: Update with your real Privacy Policy URL
          //     await launchURL(
          //       url:
          //           'https://gist.githubusercontent.com/eslamnegm010/eb6441ad736a8bd7a8ec8e376547d76a/raw/fa045baa8b5dde5108fb98eef8e647c4ab114c8f/privacy_policy.md',
          //     );
          //   },
          //   child: const TitleText(
          //     text: 'privacy_policy',
          //     subtractedSize: 11,
          //     color: AppColors.blueColor,
          //     fontWeight: FontWeight.w500,
          //   ),
          // ),
          // const SizedBox(height: 10),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const TitleText(
              text: 'close',
              subtractedSize: 10,
              color: AppColors.greyColor,
            ),
          ),
        ],
      ),
    );
  }
}
