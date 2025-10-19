import 'package:flutter/material.dart';

import '../../../core/utils/app_export.dart';

/// Small helper widget for drawer rows
class SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Color? color;
  final String? image;
  final Widget? trailing;

  const SettingItem({
    Key? key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.color,
    this.trailing,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textColor = AppColors.getTextColor(context);
    return Material(
      color: Colors.transparent,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 4),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: (color ?? AppColors.blueColor).withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color ?? AppColors.blueColor),
        ),
        title: TitleText(
          text: title,
          subtractedSize: 7,
          color: color ?? textColor,
          fontWeight: FontWeight.w500,
        ),
        subtitle:
            subtitle == null ? null : SubtitleText(text: subtitle!, subtractedSize: 2, color: AppColors.greyColor),
        trailing: trailing,
      ),
    );
  }
}
