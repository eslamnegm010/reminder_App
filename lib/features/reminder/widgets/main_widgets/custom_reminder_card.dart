import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:reminder_app/core/utils/app_export.dart';
import 'package:reminder_app/features/reminder/model/reminder_model.dart';
import 'package:flutter/material.dart';
import '../done_button.dart';

class ReminderCard extends StatelessWidget {
  final ReminderModel reminder;
  final VoidCallback onDelete;
  final ValueChanged<bool?> onToggleCompletion;
  final VoidCallback onEdit;
  final VoidCallback onNotifiTapped;

  const ReminderCard({
    Key? key,
    required this.reminder,
    required this.onDelete,
    required this.onEdit,
    required this.onToggleCompletion,
    required this.onNotifiTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = AppColors.getTextColor(context);
    final priorityColor = AppColors.priorityColor(reminder.priority);
    final notEnabled = reminder.notificationsEnabled;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  priorityColor.withValues(alpha: 0.14),
                  isDark
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.blueGrey.withValues(alpha: 0.04),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: priorityColor.withValues(alpha: 0.35),
                width: 1.1,
              ),
              boxShadow: [
                BoxShadow(
                  color: priorityColor.withValues(alpha: 0.2),
                  blurRadius: 10,
                  spreadRadius: 1,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DoneButton(
                    isCompleted: reminder.isCompleted,
                    color: priorityColor,
                    onToggle: onToggleCompletion,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitleText(
                          subtractedSize: 9,
                          color: reminder.isCompleted
                              ? textColor.withValues(alpha: 0.45)
                              : textColor,
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.left,
                          decoration: reminder.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          text: reminder.title,
                        ),
                        const SizedBox(height: 2),
                        if (reminder.description.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 6, bottom: 10),
                            child: TitleText(
                              subtractedSize: 11,
                              color: textColor.withValues(alpha: 0.6),
                              text: reminder.description,
                            ),
                          ),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: [
                            if (reminder.dateTime != null)
                              _infoChip(
                                icon: Icons.access_time_rounded,
                                text: DateFormat(
                                  'MMM d, yyyy • hh:mm a',
                                ).format(reminder.dateTime!),
                                color: AppColors.blueColor,
                                isDark: isDark,
                              ),
                            if (reminder.location?.isNotEmpty ?? false)
                              _infoChip(
                                icon: Icons.location_on_outlined,
                                text: reminder.location!,
                                color: Colors.tealAccent.shade700,
                                isDark: isDark,
                              ),
                            _infoChip(
                              icon: Icons.flag_circle_rounded,
                              text: reminder.priority,
                              color: priorityColor,
                              isDark: isDark,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _actionButton(
                        icon: Icons.edit_rounded,
                        color: AppColors.blueColor,
                        onTap: onEdit,
                      ),
                      const SizedBox(height: 10),
                      _actionButton(
                        icon: Icons.delete_outline_rounded,
                        color: AppColors.redColor,
                        onTap: onDelete,
                      ),
                      const SizedBox(height: 10),
                      _notificationButton(
                        icon: notEnabled
                            ? Icons.notifications_off_sharp
                            : Icons.notifications_on_sharp,
                        color: notEnabled ? Colors.grey : Colors.tealAccent.shade700,
                        onTap: onNotifiTapped,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoChip({
    required IconData icon,
    required String text,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.15),
            color.withValues(alpha: isDark ? 0.1 : 0.07),
          ],
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(fontSize: 12.5, color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [color.withValues(alpha: 0.25), color.withValues(alpha: 0.12)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.25),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }
}

Widget _notificationButton({
  required IconData icon,
  required Color color,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(50),
    child: Container(
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.25), color.withValues(alpha: 0.12)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.25),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Icon(icon, color: color, size: 20),
    ),
  );
}
