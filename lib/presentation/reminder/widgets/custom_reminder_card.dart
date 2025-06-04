import 'package:eslam_s_application/core/utils/app_export.dart';
import 'package:eslam_s_application/presentation/reminder/model/reminder_model.dart';
import 'package:eslam_s_application/sheared_widgets/text/title_text.dart';
import 'package:flutter/material.dart';
class ReminderCard extends StatelessWidget {
  final ReminderModel reminder;
  final VoidCallback onDelete;
  final ValueChanged<bool?> onToggleCompletion;

  ReminderCard({
    required this.reminder,
    required this.onDelete,
    required this.onToggleCompletion,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDarkMode ? AppColors.cardGreyColor : Colors.white;
    final textColor = isDarkMode ? AppColors.white : AppColors.Dark;
    final iconColor = isDarkMode ? Colors.white70 : Colors.grey[600];

    return Card(
      margin: EdgeInsets.symmetric(vertical: 5),
      color: cardColor,
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(
          color: Colors.transparent,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Checkbox(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: .8,
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
            value: reminder.isCompleted,
            onChanged: onToggleCompletion,
            activeColor: AppColors.blueColor,
            checkColor: isDarkMode ? Colors.black : Colors.white,
          ),
          Expanded(
            child: TitleText(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              text: reminder.title,
              subtractedSize: 11,
              color: reminder.isCompleted ? const Color.fromARGB(255, 104, 167, 222) : textColor,
              fontWeight: FontWeight.normal,
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete_rounded, color: iconColor),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
