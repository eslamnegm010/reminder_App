import 'package:eslam_s_application/core/utils/app_export.dart';
import 'package:flutter/material.dart';

Widget buildReminderOptions(BuildContext context, bool isDarkMode) {
  final iconColor = isDarkMode ? const Color.fromRGBO(255, 255, 255, 1) : Colors.black87;

  Widget buildOption(String icon, String label, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            decoration: BoxDecoration(
              color: AppColors.getCardBackgroundColor(context),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDarkMode ? AppColors.borderwhite : AppColors.Bordergrey,
              ),
            ),
            child: Column(
              children: [
                SvgPicture.asset(
                  icon,
                  height: 22.h,
                  width: 22.h,
                  colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                ),
                const SizedBox(height: 6),
                SubtitleText(
                  text: label,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      // buildOption(AppAssets.locationIcon, 'location', () {
      //   // TODO: Add location picker logic here
      // }),
      // const SizedBox(width: 10),
      buildOption(AppAssets.calendarIcon, 'date', () {
        // TODO: Add date picker logic here
      }),
      const SizedBox(width: 10),
      buildOption(AppAssets.alarm, 'time', () {
        // TODO: Add time picker logic here
      }),
    ],
  );
}
