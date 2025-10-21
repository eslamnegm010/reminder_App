import 'package:eslam_s_application/features/reminder/widgets/main_widgets/create_new.dart';
import 'package:flutter/material.dart';
import 'package:eslam_s_application/core/utils/app_export.dart';

class PageHeader extends StatelessWidget {
  const PageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => showAddReminderBottomSheet(context),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  color: isDarkMode ? AppColors.blueColor : AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.blueColor.withOpacity(0.12)),
                  boxShadow: [
                    BoxShadow(
                      color: isDarkMode ? Colors.black26 : Colors.grey.withOpacity(0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: double.infinity,
                      decoration: BoxDecoration(color: isDarkMode ? Colors.white : AppColors.blueColor),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TitleText(
                        text: 'add_your_reminder',
                        color: isDarkMode ? Colors.white : AppColors.blueColor,
                        subtractedSize: 10,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Padding(
                      padding: const EdgeInsets.only(right: 14.0),
                      child: Icon(Icons.add_circle_rounded,
                          color: isDarkMode ? Colors.white : AppColors.blueColor, size: 28),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TitleText(
            padding: const EdgeInsetsDirectional.only(start: 5),
            subtractedSize: 12,
            text: "reminder_info_options",
            color: AppColors.blueColor,
            textAlign: TextAlign.start,
            alignment: AlignmentDirectional.centerStart,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
