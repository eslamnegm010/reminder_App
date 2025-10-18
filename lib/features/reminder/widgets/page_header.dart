import 'package:eslam_s_application/features/reminder/widgets/create_new.dart';
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
                  color: AppColors.getCardBackgroundColor(context),
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
                      width: 6,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.blueColor.withOpacity(0.95),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TitleText(
                        text: 'add_your_reminder',
                        color: AppColors.blueColor,
                        subtractedSize: 10,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Icon(Icons.add, color: AppColors.blueColor),
                    )
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
