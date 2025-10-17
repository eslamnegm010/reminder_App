import 'package:easy_localization/easy_localization.dart';
import 'package:eslam_s_application/presentation/reminder/enum/reminder_priority.dart';
import 'package:eslam_s_application/presentation/reminder/cubit/reminder_cubit.dart';
import 'package:eslam_s_application/core/utils/app_export.dart';
import 'package:eslam_s_application/core/validator.dart';
import 'package:eslam_s_application/sheared_widgets/default_button.dart';
import 'package:eslam_s_application/sheared_widgets/text_field/default_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> showAddReminderBottomSheet(BuildContext context) async {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final titleFocus = FocusNode();
  final descFocus = FocusNode();
  final formKey = GlobalKey<FormState>();
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;

  ReminderPriority? selectedPriority;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) {
      return Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: StatefulBuilder(
          builder: (ctx, setState) {
            return Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// ===== Title =====
                    TitleText.small(
                      text: "Add Reminder",
                    ),
                    const SizedBox(height: 20),

                    /// ===== Title Field =====
                    reminderTextField(
                      ctx,
                      controller: titleController,
                      focusNode: titleFocus,
                      hint: "Title".tr(),
                      isRequired: true,
                      isDarkMode: isDarkMode,
                      validator: Validator().validateEmptyField,
                    ),
                    const SizedBox(height: 15),

                    /// ===== Description Field =====
                    reminderTextField(
                      ctx,
                      controller: descController,
                      focusNode: descFocus,
                      hint: "Description".tr(),
                      isRequired: false,
                      isDarkMode: isDarkMode,
                      maxLines: 5,
                      validator: (_) => null,
                    ),
                    const SizedBox(height: 20),

                    /// ===== Date & Time =====
                    CustomTitleText(
                      text: "Date & Time",
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: SvgPicture.asset(
                              AppAssets.calendarIcon,
                              height: 18,
                              width: 18,
                              colorFilter: ColorFilter.mode(AppColors.orange, BlendMode.srcIn),
                            ),
                            label: TitleText(
                              subtractedSize: 14,
                              color: AppColors.orange,
                              text: selectedDate == null
                                  ? "Select Date".tr()
                                  : DateFormat('yyyy-MM-dd').format(selectedDate!),
                            ),
                            onPressed: () async {
                              final pickedDate = await showDatePicker(
                                builder: (context, child) {
                                  return Theme(
                                    data: AppColors.pickerTheme(context),
                                    child: child!,
                                  );
                                },
                                context: ctx,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2100),
                              );
                              if (pickedDate != null) {
                                setState(() => selectedDate = pickedDate);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: SvgPicture.asset(
                              AppAssets.alarm,
                              height: 18,
                              width: 18,
                              colorFilter: ColorFilter.mode(AppColors.orange, BlendMode.srcIn),
                            ),
                            label: TitleText(
                              subtractedSize: 14,
                              color: AppColors.orange,
                              text: selectedTime == null ? "Select Time".tr() : selectedTime!.format(ctx),
                            ),
                            onPressed: () async {
                              final pickedTime = await showTimePicker(
                                context: ctx,
                                initialTime: TimeOfDay.now(),
                                barrierColor: Colors.transparent,
                                builder: (context, child) {
                                  return Theme(
                                    data: AppColors.pickerTheme(context),
                                    child: child!,
                                  );
                                },
                              );

                              if (pickedTime != null) {
                                setState(() => selectedTime = pickedTime);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    /// ===== Priority =====
                    CustomTitleText(
                      text: "Priority",
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 10,
                      children: [
                        _optionChip("Low", selectedPriority == ReminderPriority.low, () {
                          setState(() => selectedPriority = ReminderPriority.low);
                        }, isDarkMode),
                        _optionChip("Medium", selectedPriority == ReminderPriority.medium, () {
                          setState(() => selectedPriority = ReminderPriority.medium);
                        }, isDarkMode),
                        _optionChip("High", selectedPriority == ReminderPriority.high, () {
                          setState(() => selectedPriority = ReminderPriority.high);
                        }, isDarkMode),
                      ],
                    ),
                    const SizedBox(height: 25),

                    /// ===== Buttons =====
                    SafeArea(
                      child: Row(
                        children: [
                          Expanded(
                            child: reminderButton(
                              label: "cancel",
                              backgroundColor: Colors.redAccent,
                              onPressed: () => Navigator.pop(ctx),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: reminderButton(
                              label: "add",
                              onPressed: () => handleAddReminder(
                                context: context,
                                ctx: ctx,
                                formKey: formKey,
                                titleController: titleController,
                                descController: descController,
                                selectedPriority: selectedPriority,
                                selectedDate: selectedDate,
                                selectedTime: selectedTime,
                              ),
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

Widget reminderTextField(
  BuildContext context, {
  required TextEditingController controller,
  required FocusNode focusNode,
  required String hint,
  required String? Function(String?) validator,
  required bool isDarkMode,
  int maxLines = 1,
  bool isRequired = false,
}) {
  return DefaultTextFormField(
    currentController: controller,
    currentFocusNode: focusNode,
    hint: hint,
    isRequired: isRequired,
    maxLines: maxLines,
    validator: validator,
    borderRadius: 15,
    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
    textColor: isDarkMode ? AppColors.graylightText : AppColors.grayDarkText,
    borderColor: isDarkMode ? AppColors.blueColor : AppColors.Bordergrey,
    fillColor: Colors.transparent,
  );
}

Widget _optionChip(String text, bool isSelected, VoidCallback onTap, bool isDarkMode) {
  return ChoiceChip(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    label: TitleText(text: text, subtractedSize: 14),
    selected: isSelected,
    onSelected: (_) => onTap(),
    selectedColor: AppColors.blueColor,
    backgroundColor: Colors.transparent,
    side: BorderSide(
      color: isDarkMode ? AppColors.blueColor : AppColors.Bordergrey,
    ),
  );
}

Widget reminderButton({
  required String label,
  required VoidCallback onPressed,
  Color backgroundColor = Colors.blue,
}) {
  return DefaultButton.verySmall(
    label: label,
    labelColor: Colors.white,
    backgroundColor: backgroundColor,
    onPressed: onPressed,
  );
}

void handleAddReminder({
  required BuildContext context,
  required BuildContext ctx,
  required GlobalKey<FormState> formKey,
  required TextEditingController titleController,
  required TextEditingController descController,
  required ReminderPriority? selectedPriority,
  required DateTime? selectedDate,
  required TimeOfDay? selectedTime,
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
    );

    Navigator.pop(ctx);
  }
}

TitleText CustomTitleText({
  required String text,
}) =>
    TitleText.verySmall(
      text: text,
      color: AppColors.white,
      fontWeight: FontWeight.w600,
    );
