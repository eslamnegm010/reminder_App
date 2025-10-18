import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:eslam_s_application/core/utils/app_export.dart';
import 'package:eslam_s_application/features/reminder/model/reminder_model.dart';
import 'package:flutter/material.dart';

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
    final priorityColor = _priorityColor(reminder.priority);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  priorityColor.withOpacity(0.12),
                  AppColors.getCardBackgroundColor(context).withOpacity(0.85),
                ],
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: isDarkMode ? Colors.black26 : Colors.grey.withOpacity(0.12),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
              border: Border.all(
                color: priorityColor.withOpacity(0.14),
                width: 1.0,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                splashFactory: InkRipple.splashFactory,
                borderRadius: BorderRadius.circular(18),
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 5,
                        height: 90.h,
                        decoration: BoxDecoration(
                          color: priorityColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () => onToggleCompletion(!reminder.isCompleted),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: reminder.isCompleted
                                ? LinearGradient(
                                    colors: [priorityColor.withOpacity(0.9), priorityColor],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                : null,
                            color: reminder.isCompleted ? null : AppColors.getCardBackgroundColor(context),
                            border: Border.all(
                              color: reminder.isCompleted ? priorityColor : Colors.grey.withOpacity(0.18),
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isDarkMode ? Colors.black26 : Colors.grey.withOpacity(0.06),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Center(
                            child: reminder.isCompleted
                                ? Icon(Icons.check, size: 20, color: Colors.white)
                                : Icon(Icons.circle_outlined, size: 18, color: Colors.grey[500]),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              reminder.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: reminder.isCompleted ? priorityColor : textColor,
                                decoration: reminder.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (reminder.description.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 6, bottom: 6),
                                child: Text(
                                  reminder.description,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: textColor.withOpacity(0.78),
                                    height: 1.2,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            Wrap(
                              spacing: 8,
                              runSpacing: 6,
                              children: [
                                if (reminder.location != null && reminder.location!.isNotEmpty)
                                  _infoChip(
                                    icon: Icons.location_on_outlined,
                                    text: reminder.location!,
                                    bgColor: isDarkMode ? Colors.white10 : Colors.black.withOpacity(0.04),
                                    iconColor: Colors.teal,
                                  ),
                                if (reminder.dateTime != null)
                                  _infoChip(
                                    icon: Icons.free_cancellation_outlined,
                                    text: DateFormat('MMM d, yyyy • hh:mm a').format(reminder.dateTime!),
                                    bgColor: isDarkMode ? Colors.white10 : Colors.black.withOpacity(0.04),
                                    iconColor: AppColors.getTextColor(context).withOpacity(.6),
                                  ),
                                _infoChip(
                                  icon: Icons.flag_circle_sharp,
                                  text: reminder.priority,
                                  bgColor: isDarkMode ? Colors.white10 : Colors.black.withOpacity(0.04),
                                  iconColor: _priorityColor(reminder.priority),
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
                          IconButton(
                            icon: Icon(Icons.edit_notifications, color: AppColors.blueColor),
                            onPressed: () {
                              // Handle edit action
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete_rounded, color: AppColors.redColor),
                            onPressed: onDelete,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
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
    required Color bgColor,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: iconColor),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: iconColor,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
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
