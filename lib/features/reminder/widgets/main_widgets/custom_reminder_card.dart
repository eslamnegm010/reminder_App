import 'package:easy_localization/easy_localization.dart';
import 'package:reminder_app/core/utils/app_export.dart';
import 'package:reminder_app/features/reminder/model/reminder_model.dart';
import 'package:flutter/material.dart';
import '../../../../sheared_widgets/text/title_text.dart';
import '../../enum/reminder_category.dart';
import '../done_button.dart';

class ReminderCard extends StatelessWidget {
  final ReminderModel reminder;
  final VoidCallback onDelete;
  final ValueChanged<bool?> onToggleCompletion;
  final VoidCallback onEdit;
  final VoidCallback onNotifiTapped;

  const ReminderCard({
    super.key,
    required this.reminder,
    required this.onDelete,
    required this.onEdit,
    required this.onToggleCompletion,
    required this.onNotifiTapped,
  });

  Widget _categoryBadge(String categoryText, bool isDark) {
    final category = ReminderCategoryExtension.fromText(categoryText);
    return Container(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: category.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: category.color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(category.icon, size: 14, color: category.color),
          const SizedBox(width: 4),
          TitleText(
            text: category.label,
            subtractedSize: 13,
            fontWeight: FontWeight.w600,
            color: category.color,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final priorityColor = AppColors.priorityColor(reminder.priority);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : AppColors.blueColor.withValues(alpha: 0.06),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 8,
                  margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  decoration: BoxDecoration(
                    color: priorityColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(4, 16, 16, 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: DoneButton(
                            isCompleted: reminder.isCompleted,
                            color: priorityColor,
                            onToggle: onToggleCompletion,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TitleText(
                                padding: const EdgeInsetsDirectional.only(end: 5),
                                subtractedSize: 7,
                                text: reminder.title,
                                color: reminder.isCompleted
                                    ? AppColors.getTextColor(
                                        context,
                                      ).withValues(alpha: 0.4)
                                    : AppColors.getTextColor(context),
                                decoration: reminder.isCompleted
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                fontWeight: FontWeight.w800,
                                textAlign: TextAlign.left,
                              ),
                              if (reminder.description.isNotEmpty) ...[
                                const SizedBox(height: 10),
                                TitleText(
                                  padding: const EdgeInsetsDirectional.only(end: 5),
                                  text: reminder.description,
                                  maxLines: 2,
                                  subtractedSize: 11,
                                  color: AppColors.getTextColor(
                                    context,
                                  ).withValues(alpha: 0.5),
                                  height: 1.4,
                                ),
                              ],
                              const SizedBox(height: 14),
                              Wrap(
                                spacing: 14,
                                runSpacing: 6,
                                children: [
                                  if (reminder.dateTime != null)
                                    _metaInfo(
                                      context,
                                      Icons.access_time_rounded,
                                      DateFormat(
                                        'MMM d, hh:mm a',
                                        context.locale.toString(),
                                      ).format(reminder.dateTime!),
                                      isDark,
                                    ),
                                  if (reminder.repeatType != 'None')
                                    _metaInfo(
                                      context,
                                      reminder.repeatType == 'Daily'
                                          ? Icons.calendar_today
                                          : reminder.repeatType == 'Weekly'
                                          ? Icons.calendar_view_week
                                          : Icons.calendar_month,
                                      reminder.repeatType.tr(),
                                      isDark,
                                    ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  _priorityBadge(
                                    reminder.priority,
                                    priorityColor,
                                    isDark,
                                  ),
                                  const SizedBox(width: 10),
                                  _categoryBadge(reminder.category, isDark),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _actionIcon(Icons.edit_rounded, AppColors.blueColor, onEdit),
                            const SizedBox(height: 12),
                            _actionIcon(
                              Icons.delete_outline_rounded,
                              AppColors.redColor,
                              onDelete,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _priorityBadge(String priority, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: TitleText(
        text: priority.toUpperCase(),
        subtractedSize: 14,
        fontWeight: FontWeight.w900,
        color: color,
      ),
    );
  }

  Widget _metaInfo(BuildContext context, IconData icon, String text, bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.blueColor.withValues(alpha: 0.5)),
        const SizedBox(width: 6),
        TitleText(
          text: text,
          subtractedSize: 11,
          fontWeight: FontWeight.w500,
          color: AppColors.getTextColor(context).withValues(alpha: 0.5),
        ),
      ],
    );
  }

  Widget _actionIcon(IconData icon, Color color, VoidCallback onTap) {
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
