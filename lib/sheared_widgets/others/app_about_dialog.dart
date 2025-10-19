import 'package:eslam_s_application/core/utils/app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:eslam_s_application/core/constans/app_constants.dart';
import 'package:eslam_s_application/core/utils/app_export.dart';

class AppAboutDialog extends StatelessWidget {
  const AppAboutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: Theme.of(context).cardColor,
      contentPadding: const EdgeInsets.all(20),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(12),
            child: Image.asset(AppAssets.appLauncher),
          ),
          TitleText(
            text: AppConstants.appName,
            subtractedSize: 5,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          TitleText(
            text: 'version ${AppConstants.appVersion}',
            subtractedSize: 13,
            color: AppColors.greyColor,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Short bio
          TitleText(
            text: 'about_app_description',
            textAlign: TextAlign.center,
            subtractedSize: 13,
            color: AppColors.greyColor,
          ),
          const SizedBox(height: 16),
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () async {
              await launchEmail(
                email: AppConstants.myEmail,
              );
              Navigator.pop(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.attach_email_outlined, size: 20, color: AppColors.blueColor),
                const SizedBox(width: 6),
                TitleText(
                    subtractedSize: 11,
                    text: 'eslammohameddev2@gmail.com',
                    color: AppColors.blueColor,
                    fontWeight: FontWeight.w500),
              ],
            ),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const TitleText(text: 'close', subtractedSize: 10, color: AppColors.greyColor),
          ),
        ],
      ),
    );
  }
}
