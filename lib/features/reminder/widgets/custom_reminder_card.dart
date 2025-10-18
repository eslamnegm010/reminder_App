import 'package:eslam_s_application/core/utils/app_export.dart';
import 'package:eslam_s_application/features/reminder/model/reminder_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReminderCard extends StatelessWidget {
  final ReminderModel reminder;
  final VoidCallback onDelete;
  final ValueChanged<bool?> onToggleCompletion;

  const ReminderCard({
    Key? key,
    required this.reminder,
    required this.onDelete,
    required this.onToggleCompletion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = AppColors.getTextColor(context);
    final iconColor = isDarkMode ? Colors.white70 : Colors.grey[600];
    final bgColor = AppColors.getCardBackgroundColor(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      color: bgColor,
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ===== Checkbox =====
            Checkbox(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              value: reminder.isCompleted,
              onChanged: onToggleCompletion,
              activeColor: AppColors.blueColor,
              checkColor: isDarkMode ? Colors.black : Colors.white,
            ),

            /// ===== Info Section =====
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleText(
                    text: reminder.title,
                    color: reminder.isCompleted ? AppColors.blueColor : textColor,
                    fontWeight: FontWeight.w600,
                    subtractedSize: 10,
                  ),
                  if (reminder.description.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 4),
                      child: Text(
                        reminder.description,
                        style: TextStyle(
                          fontSize: 13,
                          color: textColor.withOpacity(0.8),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  Wrap(
                    spacing: 10,
                    runSpacing: 4,
                    children: [
                      if (reminder.location != null && reminder.location!.isNotEmpty)
                        _infoChip(
                          icon: Icons.location_on_outlined,
                          text: reminder.location!,
                          iconColor: Colors.teal,
                        ),
                      if (reminder.dateTime != null)
                        _infoChip(
                          icon: Icons.calendar_today_outlined,
                          text: DateFormat('MMM d, yyyy – hh:mm a').format(reminder.dateTime!),
                          iconColor: AppColors.orange,
                        ),
                      _infoChip(
                        icon: Icons.flag_rounded,
                        text: reminder.priority,
                        iconColor: _priorityColor(reminder.priority),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            IconButton(
              icon: Icon(Icons.delete_rounded, color: iconColor),
              onPressed: onDelete,
              tooltip: 'Delete Reminder',
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoChip({
    required IconData icon,
    required String text,
    required Color iconColor,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: iconColor),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: iconColor.withOpacity(0.9),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Color _priorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.redAccent;
      case 'medium':
        return Colors.orangeAccent;
      case 'low':
      default:
        return Colors.green;
    }
  }
}
