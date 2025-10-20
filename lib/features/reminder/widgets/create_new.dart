import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:eslam_s_application/features/reminder/enum/reminder_priority.dart';
import 'package:eslam_s_application/features/reminder/cubit/reminder_cubit.dart';
import 'package:eslam_s_application/core/utils/app_export.dart';
import 'package:eslam_s_application/core/validator.dart';
import 'package:eslam_s_application/features/reminder/model/reminder_model.dart';
import 'package:eslam_s_application/sheared_widgets/default_button.dart';
import 'package:eslam_s_application/sheared_widgets/others/app_divider.dart';
import 'package:eslam_s_application/sheared_widgets/others/swaper.dart';
import 'package:eslam_s_application/sheared_widgets/text_field/default_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> showAddReminderBottomSheet(BuildContext context, {ReminderModel? reminder}) async {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final titleFocus = FocusNode();
  final descFocus = FocusNode();

  ReminderPriority? selectedPriority;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  if (reminder != null) {
    titleController.text = reminder.title;
    descController.text = reminder.description;
    final priorityString = reminder.priority;
    selectedPriority = ReminderPriority.values.firstWhere(
      (e) => e.name == priorityString,
      orElse: () => ReminderPriority.values.firstWhere(
        (e) => e.toText == priorityString,
        orElse: () => ReminderPriority.medium,
      ),
    );
    selectedDate = reminder.dateTime;
    selectedTime = TimeOfDay.fromDateTime(reminder.dateTime!);
  }

  final isDark = Theme.of(context).brightness == Brightness.dark;

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: isDark ? const Color(0xFF1C1C1E) : Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) {
      return Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 12,
          bottom: 0,
        ),
        child: StatefulBuilder(
          builder: (ctx, setState) {
            return SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(alignment: Alignment.center, child: swaper()),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        TitleText.small(
                          text: "create_new_reminder",
                          color: AppColors.blueColor,
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => Navigator.pop(ctx),
                          icon: const Icon(Icons.close),
                          color: AppColors.greyColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    reminderTextField(
                      ctx,
                      controller: titleController,
                      focusNode: titleFocus,
                      validator: Validator().validateEmptyField,
                      isRequired: true,
                      isDarkMode: isDark,
                    ),
                    const SizedBox(height: 10),
                    reminderTextField(
                      ctx,
                      controller: descController,
                      focusNode: descFocus,
                      validator: (_) => null,
                      isRequired: false,
                      isDarkMode: isDark,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 20),
                    CustomTitleText(text: "date_and_time", context: ctx),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDateTimeButton(
                            icon: AppAssets.calendarIcon,
                            label: selectedDate == null
                                ? "select_date".tr()
                                : DateFormat('yyyy-MM-dd').format(selectedDate!),
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: ctx,
                                initialDate: selectedDate ?? DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2100),
                                builder: (c, child) => Theme(data: AppColors.pickerTheme(c), child: child!),
                              );
                              if (picked != null) setState(() => selectedDate = picked);
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildDateTimeButton(
                            icon: AppAssets.alarm,
                            label: selectedTime == null ? "select_time".tr() : selectedTime!.format(ctx),
                            onTap: () async {
                              final picked = await showTimePicker(
                                context: ctx,
                                initialTime: selectedTime ?? TimeOfDay.now(),
                                builder: (c, child) => Theme(data: AppColors.pickerTheme(c), child: child!),
                                barrierColor: Colors.transparent,
                              );
                              if (picked != null) setState(() => selectedTime = picked);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    CustomTitleText(text: "priority", context: ctx),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: _priorityCard(
                            title: "Low",
                            color: Colors.greenAccent,
                            icon: Icons.arrow_downward_rounded,
                            isSelected: selectedPriority == ReminderPriority.low,
                            onTap: () => setState(() => selectedPriority = ReminderPriority.low),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _priorityCard(
                            title: "Medium",
                            color: Colors.orangeAccent,
                            icon: Icons.horizontal_rule_rounded,
                            isSelected: selectedPriority == ReminderPriority.medium,
                            onTap: () => setState(() => selectedPriority = ReminderPriority.medium),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _priorityCard(
                            title: "High",
                            color: Colors.redAccent,
                            icon: Icons.arrow_upward_rounded,
                            isSelected: selectedPriority == ReminderPriority.high,
                            onTap: () => setState(() => selectedPriority = ReminderPriority.high),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    SafeArea(
                      left: false,
                      right: false,
                      child: Row(
                        children: [
                          Expanded(
                            child: reminderButton(
                              label: "cancel",
                              backgroundColor: Colors.grey.withOpacity(.3),
                              labelColor: AppColors.getTextColor(ctx),
                              onPressed: () => Navigator.pop(ctx),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: reminderButton(
                              label: reminder == null ? "create" : "save",
                              onPressed: () => handleAddReminder(
                                  context: context,
                                  ctx: ctx,
                                  formKey: formKey,
                                  titleController: titleController,
                                  descController: descController,
                                  selectedPriority: selectedPriority,
                                  selectedDate: selectedDate,
                                  selectedTime: selectedTime,
                                  reminderId: reminder?.id),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    },
  );
}

// Date / Time button
Widget _buildDateTimeButton({
  required String icon,
  required String label,
  required VoidCallback onTap,
}) {
  return OutlinedButton.icon(
    onPressed: onTap,
    style: OutlinedButton.styleFrom(
      // ignore: deprecated_member_use
      side: BorderSide(color: AppColors.blueColor.withOpacity(0.1)),
      // ignore: deprecated_member_use
      backgroundColor: AppColors.blueColor.withOpacity(0.05),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    icon: SvgPicture.asset(icon,
        height: 20, width: 20, colorFilter: ColorFilter.mode(AppColors.blueColor, BlendMode.srcIn)),
    label: TitleText(subtractedSize: 12, text: label, color: AppColors.blueColor),
  );
}

// Priority card style
Widget _priorityCard({
  required String title,
  required IconData icon,
  required Color color,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  return AnimatedContainer(
    duration: const Duration(milliseconds: 250),
    curve: Curves.easeInOut,
    decoration: BoxDecoration(
      // ignore: deprecated_member_use
      color: isSelected ? color.withOpacity(.85) : color.withOpacity(.15),
      borderRadius: BorderRadius.circular(16),
      boxShadow: isSelected
          ? [
              BoxShadow(
                color: color.withOpacity(.4),
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
            ]
          : [],
    ),
    child: InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? Colors.white : color.withOpacity(.8), size: 22),
            const SizedBox(height: 4),
            TitleText(
              text: title,
              subtractedSize: 12,
              color: isSelected ? Colors.white : AppColors.greyColor,
            ),
          ],
        ),
      ),
    ),
  );
}

Widget reminderTextField(
  BuildContext context, {
  required TextEditingController controller,
  required FocusNode focusNode,
  required String? Function(String?) validator,
  required bool isDarkMode,
  int maxLines = 1,
  bool isRequired = false,
}) {
  return DefaultTextFormField(
    autovalidateMode: AutovalidateMode.onUserInteraction,
    currentController: controller,
    currentFocusNode: focusNode,
    hint: "type_here..",
    isRequired: isRequired,
    maxLines: maxLines,
    validator: validator,
    borderRadius: 14,
    hintColor: AppColors.grayDarkText,
    contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
    textColor: AppColors.getTextColor(context),
    borderColor: AppColors.blueColor.withOpacity(0.16),
    fillColor: Colors.transparent,
  );
}

Widget reminderButton({
  required String label,
  required VoidCallback onPressed,
  Color backgroundColor = AppColors.blueColor,
  Color labelColor = Colors.white,
}) {
  return DefaultButton.verySmall(
    label: label,
    labelColor: labelColor,
    backgroundColor: backgroundColor,
    onPressed: onPressed,
  );
}

// void handleAddReminder({
//   required BuildContext context,
//   required BuildContext ctx,
//   required GlobalKey<FormState> formKey,
//   required TextEditingController titleController,
//   required TextEditingController descController,
//   required ReminderPriority? selectedPriority,
//   required DateTime? selectedDate,
//   required TimeOfDay? selectedTime,
//   required String? reminderId,
// }) {
//   if (formKey.currentState!.validate()) {
//     final reminderCubit = context.read<ReminderCubit>();

//     DateTime? finalDateTime;
//     if (selectedDate != null && selectedTime != null) {
//       finalDateTime = DateTime(
//         selectedDate.year,
//         selectedDate.month,
//         selectedDate.day,
//         selectedTime.hour,
//         selectedTime.minute,
//       );
//     } else if (selectedDate != null) {
//       finalDateTime = selectedDate;
//     }

//     reminderCubit.addReminder(
//       title: titleController.text,
//       description: descController.text,
//       priority: selectedPriority?.toText ?? ReminderPriority.medium.toText,
//       dateTime: finalDateTime,
//       id: reminderId,
//     );

//     Navigator.pop(ctx);
//   }
// }
void handleAddReminder({
  required BuildContext context,
  required BuildContext ctx,
  required GlobalKey<FormState> formKey,
  required TextEditingController titleController,
  required TextEditingController descController,
  required ReminderPriority? selectedPriority,
  required DateTime? selectedDate,
  required TimeOfDay? selectedTime,
  required String? reminderId,
}) {
  if (formKey.currentState!.validate()) {
    final reminderCubit = context.read<ReminderCubit>();

    DateTime? finalDateTime;
    if (selectedDate != null && selectedTime != null) {
      finalDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );
    } else if (selectedDate != null) {
      finalDateTime = selectedDate;
    }

    reminderCubit.addReminder(
      title: titleController.text,
      description: descController.text,
      priority: selectedPriority?.toText ?? ReminderPriority.medium.toText,
      dateTime: finalDateTime,
      id: reminderId,
    );

    // Show user feedback: if date/time provided notify scheduled time
    if (finalDateTime != null) {
      final formatted = DateFormat('yyyy-MM-dd • hh:mm a').format(finalDateTime);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('reminder_scheduled_for'.tr(args: [formatted]))),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('reminder_saved'.tr())),
      );
    }

    Navigator.pop(ctx);
  }
}


Row CustomTitleText({
  required String text,
  required BuildContext context,
}) {
  return Row(
    children: [
      TitleText(subtractedSize: 12, text: text, fontWeight: FontWeight.w600),
      const SizedBox(width: 10),
      Expanded(child: AppBarDivider.getAppBarDivider(context))
    ],
  );
}
