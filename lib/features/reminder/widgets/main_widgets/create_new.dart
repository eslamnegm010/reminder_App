import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:reminder_app/core/utils/app_export.dart';
import 'package:reminder_app/features/reminder/enum/reminder_priority.dart';
import 'package:reminder_app/features/reminder/model/reminder_model.dart';
import 'package:reminder_app/core/utils/validator.dart';
import '../add_reminder_sheet/date_time_picker_button.dart';
import '../add_reminder_sheet/notification_toggle.dart';
import '../add_reminder_sheet/priority_selector_card.dart';
import '../add_reminder_sheet/reminder_action_button.dart';
import '../add_reminder_sheet/reminder_text_field.dart';
import '../add_reminder_sheet/section_title_text.dart';
import '../add_reminder_sheet/add_reminder_logic.dart';

enum ReminderType { time, location }

Future<void> showAddReminderBottomSheet(
  BuildContext context, {
  ReminderModel? reminder,
}) async {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final titleFocus = FocusNode();
  final descFocus = FocusNode();

  ReminderPriority? selectedPriority;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  bool notificationsEnabled = reminder?.notificationsEnabled ?? true;

  // Initialize Type
  ReminderType reminderType = ReminderType.time; // Default

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
    selectedTime = reminder.dateTime != null
        ? TimeOfDay.fromDateTime(reminder.dateTime!)
        : null;

    reminderType = ReminderType.time;
  }

  final isDark = Theme.of(context).brightness == Brightness.dark;

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) {
      return DraggableScrollableSheet(
        initialChildSize: 0.96,
        minChildSize: 0.8,
        maxChildSize: 0.96,
        builder: (_, scrollController) {
          return Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            child: StatefulBuilder(
              builder: (ctx, setState) {
                return Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          controller: scrollController,
                          padding: EdgeInsets.zero,
                          children: [
                            Row(
                              children: [
                                TitleText.small(
                                  padding: EdgeInsets.zero,
                                  text: reminder != null
                                      ? "update_your_reminder"
                                      : "create_new_reminder",
                                  color: AppColors.blueTextColor(context),
                                ),
                                const Spacer(),
                                SizedBox(
                                  height: 30,
                                  child: ClipOval(
                                    child: Image.asset(
                                      AppAssets.appLauncher,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),

                            const SizedBox(height: 20),

                            ReminderTextField(
                              controller: titleController,
                              focusNode: titleFocus,
                              validator: Validator().validateEmptyField,
                              isRequired: true,
                              isDarkMode: isDark,
                            ),
                            const SizedBox(height: 10),
                            ReminderTextField(
                              controller: descController,
                              focusNode: descFocus,
                              validator: (_) => null,
                              isRequired: false,
                              isDarkMode: isDark,
                              maxLines: 3,
                            ),
                            const SizedBox(height: 20),

                            // Time & Date Section
                            if (reminderType == ReminderType.time) ...[
                              const SectionTitleText(text: "date_and_time"),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: DateTimePickerButton(
                                      icon: AppAssets.calendarIcon,
                                      label: selectedDate == null
                                          ? "select_date".tr()
                                          : DateFormat(
                                              'yyyy-MM-dd',
                                            ).format(selectedDate!),
                                      onTap: () async {
                                        final picked = await showDatePicker(
                                          context: ctx,
                                          initialDate: selectedDate ?? DateTime.now(),
                                          firstDate: DateTime(2020),
                                          lastDate: DateTime(2100),
                                          builder: (c, child) => Theme(
                                            data: AppColors.pickerTheme(c),
                                            child: child!,
                                          ),
                                        );
                                        if (picked != null)
                                          setState(() => selectedDate = picked);
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: DateTimePickerButton(
                                      icon: AppAssets.alarm,
                                      label: selectedTime == null
                                          ? "select_time".tr()
                                          : selectedTime!.format(ctx),
                                      onTap: () async {
                                        final picked = await showTimePicker(
                                          context: ctx,
                                          initialTime: selectedTime ?? TimeOfDay.now(),
                                          builder: (c, child) => Theme(
                                            data: AppColors.pickerTheme(c),
                                            child: child!,
                                          ),
                                          barrierColor: Colors.transparent,
                                        );
                                        if (picked != null)
                                          setState(() => selectedTime = picked);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                            ],

                            const SectionTitleText(text: "priority"),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: PrioritySelectorCard(
                                    title: "Low",
                                    color: Colors.greenAccent,
                                    icon: Icons.arrow_downward_rounded,
                                    isSelected: selectedPriority == ReminderPriority.low,
                                    onTap: () => setState(
                                      () => selectedPriority = ReminderPriority.low,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: PrioritySelectorCard(
                                    title: "Medium",
                                    color: Colors.orangeAccent,
                                    icon: Icons.horizontal_rule_rounded,
                                    isSelected:
                                        selectedPriority == ReminderPriority.medium,
                                    onTap: () => setState(
                                      () => selectedPriority = ReminderPriority.medium,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: PrioritySelectorCard(
                                    title: "High",
                                    color: Colors.redAccent,
                                    icon: Icons.arrow_upward_rounded,
                                    isSelected: selectedPriority == ReminderPriority.high,
                                    onTap: () => setState(
                                      () => selectedPriority = ReminderPriority.high,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),


                            NotificationToggle(
                              value: notificationsEnabled,
                              onChanged: (v) => setState(() => notificationsEnabled = v),
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                      SafeArea(
                        right: false,
                        left: false,
                        child: Row(
                          children: [
                            Expanded(
                              child: ReminderActionButton(
                                label: "cancel",
                                backgroundColor: Colors.grey.withValues(alpha: .3),
                                labelColor: AppColors.getTextColor(ctx),
                                onPressed: () => Navigator.pop(ctx),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ReminderActionButton(
                                label: reminder == null ? "create" : "save",
                                onPressed: () {
                                  handleAddReminder(
                                    context: context,
                                    ctx: ctx,
                                    formKey: formKey,
                                    titleController: titleController,
                                    descController: descController,
                                    selectedPriority: selectedPriority,
                                    selectedDate: reminderType == ReminderType.time
                                        ? selectedDate
                                        : null,
                                    selectedTime: reminderType == ReminderType.time
                                        ? selectedTime
                                        : null,
                                    notificationsEnabled: notificationsEnabled,
                                    reminderId: reminder?.id,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                );
              },
            ),
          );
        },
      );
    },
  );
}
