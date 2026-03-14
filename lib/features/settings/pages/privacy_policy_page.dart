import 'package:flutter/material.dart';
import 'package:reminder_app/core/utils/app_export.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.getTextColor(context),
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: TitleText(
          text: 'privacy_policy',
          subtractedSize: 10,
          color: AppColors.getTextColor(context),
          fontWeight: FontWeight.w700,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              context,
              'privacy_policy_header'.tr(),
              'privacy_policy_last_updated'.tr(),
              isHeader: true,
            ),
            const SizedBox(height: 20),
            _buildText(
              context,
              'privacy_policy_intro'.tr(),
            ),
            const SizedBox(height: 24),
            _buildSection(
              context,
              'privacy_policy_info_collection_title'.tr(),
              'privacy_policy_info_collection_body'.tr(),
            ),
            const SizedBox(height: 16),
            _buildSubSection(
              context,
              'privacy_policy_no_personal_data_title'.tr(),
              'privacy_policy_no_personal_data_body'.tr(),
            ),
            const SizedBox(height: 16),
            _buildSubSection(
              context,
              'privacy_policy_no_location_data_title'.tr(),
              'privacy_policy_no_location_data_body'.tr(),
            ),
            const SizedBox(height: 16),
            _buildSubSection(
              context,
              'privacy_policy_local_storage_title'.tr(),
              'privacy_policy_local_storage_body'.tr(),
            ),
            const SizedBox(height: 24),
            _buildSection(
              context,
              'privacy_policy_notifications_title'.tr(),
              'privacy_policy_notifications_body'.tr(),
            ),
            const SizedBox(height: 24),
            _buildSection(
              context,
              'privacy_policy_data_safety_title'.tr(),
              'privacy_policy_data_safety_intro'.tr(),
            ),
            const SizedBox(height: 12),
            _buildBulletPoint(
              context,
              'privacy_policy_data_encrypted'.tr(),
            ),
            _buildBulletPoint(
              context,
              'privacy_policy_data_deletion'.tr(),
            ),
            _buildBulletPoint(
              context,
              'privacy_policy_data_sharing'.tr(),
            ),
            const SizedBox(height: 24),
            _buildSection(
              context,
              'privacy_policy_changes_title'.tr(),
              'privacy_policy_changes_body'.tr(),
            ),
            const SizedBox(height: 24),
            _buildSection(
              context,
              'privacy_policy_contact_title'.tr(),
              'privacy_policy_contact_body'.tr(),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () async {
                final Uri emailLaunchUri = Uri(
                  scheme: 'mailto',
                  path: 'eslamnegm010@gmail.com',
                );
                if (await canLaunchUrl(emailLaunchUri)) {
                  await launchUrl(emailLaunchUri);
                }
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.blueColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.blueColor.withValues(alpha: 0.2)),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.email_outlined,
                      color: AppColors.blueColor,
                      size: 20,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: SubtitleText(
                        text: 'eslamnegm010@gmail.com',
                        color: AppColors.blueColor,
                        isBold: true,
                      ),
                    ),
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

  Widget _buildSection(
    BuildContext context,
    String title,
    String content, {
    bool isHeader = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleText(
          text: title,
          subtractedSize: isHeader ? 8 : 12,
          color: AppColors.getTextColor(context),
          fontWeight: FontWeight.w700,
        ),
        const SizedBox(height: 8),
        _buildText(context, content),
      ],
    );
  }

  Widget _buildSubSection(BuildContext context, String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleText(
          text: title,
          subtractedSize: 13,
          color: AppColors.getTextColor(context),
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(height: 6),
        _buildText(context, content),
      ],
    );
  }

  Widget _buildBulletPoint(BuildContext context, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: AppColors.blueColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: _buildText(context, content)),
        ],
      ),
    );
  }

  Widget _buildText(BuildContext context, String text) {
    return SubtitleText(
      text: text,
      color: AppColors.getTextColor(context).withValues(alpha: 0.8),
      subtractedSize: 4,
      height: 1.5,
    );
  }
}
