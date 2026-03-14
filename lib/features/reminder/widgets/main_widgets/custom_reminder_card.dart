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
    final backgroundColor = isDark ? const Color(0xFF1E1E1E) : const Color(0xFFFFFFFF);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Card(
        elevation: 1,
        margin: EdgeInsets.zero,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 6,
                    decoration: BoxDecoration(
                      color: priorityColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
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
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label(context, "title"),
                                TitleText(
                                  padding: const EdgeInsetsDirectional.only(end: 5),
                                  subtractedSize: 9,
                                  text: reminder.title,
                                  color: reminder.isCompleted
                                      ? AppColors.getTextColor(
                                          context,
                                        ).withValues(alpha: 0.5)
                                      : AppColors.getTextColor(context),
                                  decoration: reminder.isCompleted
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                  fontWeight: FontWeight.bold,
                                  textAlign: TextAlign.left,
                                ),
                                if (reminder.description.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  _label(context, "description"),
                                  TitleText(
                                    padding: const EdgeInsetsDirectional.only(end: 5),
                                    text: reminder.description,
                                    maxLines: 3,
                                    subtractedSize: 11,
                                    color: AppColors.getTextColor(
                                      context,
                                    ).withValues(alpha: 0.6),
                                    height: 1.3,
                                  ),
                                ],
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 12,
                                  runSpacing: 4,
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
                                        reminder.repeatType == 'Daily' ? Icons.calendar_today :
                                        reminder.repeatType == 'Weekly' ? Icons.calendar_view_week :
                                        Icons.calendar_month,
                                        reminder.repeatType.tr(),
                                        isDark,
                                      ),
                                    // _categoryBadge(reminder.category, isDark),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    _priorityBadge(
                                      reminder.priority,
                                      priorityColor,
                                      isDark,
                                    ),
                                    const SizedBox(width: 12),
                                    _categoryBadge(reminder.category, isDark),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              _actionIcon(
                                Icons.edit_rounded,
                                AppColors.blueColor,
                                onEdit,
                              ),
                              const SizedBox(height: 8),
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
      ),
    );
  }

  Widget _label(BuildContext context, String key) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: TitleText(
        text: "${key.tr()}:",
        subtractedSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.getTextColor(context).withValues(alpha: 0.4),
      ),
    );
  }

  Widget _priorityBadge(String priority, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TitleText(
            text: "${"priority".tr()}:",
            subtractedSize: 13,
            fontWeight: FontWeight.w600,
            color: color,
          ),
          const SizedBox(width: 4),
          TitleText(
            text: priority.toLowerCase(),
            subtractedSize: 13,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ],
      ),
    );
  }

  Widget _metaInfo(BuildContext context, IconData icon, String text, bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: isDark ? Colors.white54 : Colors.black45),
        const SizedBox(width: 4),
        Expanded(
          child: TitleText(
            text: text,
            subtractedSize: 10,
            fontWeight: FontWeight.w500,
            color: AppColors.grayDarkText,
          ),
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
