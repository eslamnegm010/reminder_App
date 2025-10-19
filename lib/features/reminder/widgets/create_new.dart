import 'package:easy_localization/easy_localization.dart';
import 'package:eslam_s_application/features/reminder/enum/reminder_priority.dart';
import 'package:eslam_s_application/features/reminder/cubit/reminder_cubit.dart';
import 'package:eslam_s_application/core/utils/app_export.dart';
import 'package:eslam_s_application/core/validator.dart';
import 'package:eslam_s_application/sheared_widgets/default_button.dart';
import 'package:eslam_s_application/sheared_widgets/others/app_divider.dart';
import 'package:eslam_s_application/sheared_widgets/others/swaper.dart';
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
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) {
      return Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 12,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 12,
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
                    Align(
                      alignment: Alignment.center,
                      child: swaper(),
                    ),
                    Row(
                      children: [
                        TitleText.small(text: "create_new_reminder", color: AppColors.blueColor),
                        const Spacer(),
                        IconButton(
                          onPressed: () => Navigator.pop(ctx),
                          icon: Icon(Icons.close, color: AppColors.greyColor),
                        ),
                      ],
                    ),
                    const SizedBox(height: UIConstants.paddingMedium),

                    // Title field
                    reminderTextField(
                      ctx,
                      controller: titleController,
                      focusNode: titleFocus,
                      isRequired: true,
                      isDarkMode: isDarkMode,
                      validator: Validator().validateEmptyField,
                    ),
                    const SizedBox(height: UIConstants.paddingSmall),

                    // Description
                    reminderTextField(
                      ctx,
                      controller: descController,
                      focusNode: descFocus,
                      isRequired: false,
                      isDarkMode: isDarkMode,
                      maxLines: 4,
                      validator: (_) => null,
                    ),
                    const SizedBox(height: UIConstants.paddingMedium),

                    // Date & Time
                    CustomTitleText(text: "date_and_time", context: ctx),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: AppColors.blueColor.withOpacity(0.12)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              backgroundColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                            ),
                            icon: SvgPicture.asset(
                              AppAssets.calendarIcon,
                              height: 18,
                              width: 18,
                              colorFilter: ColorFilter.mode(AppColors.blueColor, BlendMode.srcIn),
                            ),
                            label: TitleText(
                              subtractedSize: 13,
                              color: AppColors.blueColor,
                              text: selectedDate == null
                                  ? "select_date".tr()
                                  : DateFormat('yyyy-MM-dd').format(selectedDate!),
                            ),
                            onPressed: () async {
                              final pickedDate = await showDatePicker(
                                context: ctx,
                                initialDate: selectedDate ?? DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2100),
                                builder: (c, child) => Theme(data: AppColors.pickerTheme(c), child: child!),
                              );
                              if (pickedDate != null) setState(() => selectedDate = pickedDate);
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: AppColors.blueColor.withOpacity(0.12)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              backgroundColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                            ),
                            icon: SvgPicture.asset(
                              AppAssets.alarm,
                              height: 18,
                              width: 18,
                              colorFilter: ColorFilter.mode(AppColors.blueColor, BlendMode.srcIn),
                            ),
                            label: TitleText(
                              subtractedSize: 13,
                              color: AppColors.blueColor,
                              text: selectedTime == null ? "select_time".tr() : selectedTime!.format(ctx),
                            ),
                            onPressed: () async {
                              final pickedTime = await showTimePicker(
                                context: ctx,
                                initialTime: selectedTime ?? TimeOfDay.now(),
                                builder: (c, child) => Theme(data: AppColors.pickerTheme(c), child: child!),
                                barrierColor: Colors.transparent,
                              );
                              if (pickedTime != null) setState(() => selectedTime = pickedTime);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: UIConstants.paddingMedium),

                    // Priority
                    CustomTitleText(text: "priority", context: ctx),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _optionPriority(
                          text: "low",
                          isSelected: selectedPriority == ReminderPriority.low,
                          onTap: () => setState(() => selectedPriority = ReminderPriority.low),
                          priority: ReminderPriority.low,
                        ),
                        _optionPriority(
                          text: "medium",
                          isSelected: selectedPriority == ReminderPriority.medium,
                          onTap: () => setState(() => selectedPriority = ReminderPriority.medium),
                          priority: ReminderPriority.medium,
                        ),
                        _optionPriority(
                          text: "high",
                          isSelected: selectedPriority == ReminderPriority.high,
                          onTap: () => setState(() => selectedPriority = ReminderPriority.high),
                          priority: ReminderPriority.high,
                        ),
                      ],
                    ),
                    const SizedBox(height: UIConstants.paddingMedium),

                    // Buttons
                    Row(
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
    borderRadius: 12,
    hintColor: AppColors.grayDarkText,
    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
    textColor: AppColors.getTextColor(context),
    borderColor: AppColors.blueColor.withOpacity(0.16),
    fillColor: Colors.transparent,
  );
}

Widget _optionPriority({
  required String text,
  required bool isSelected,
  required VoidCallback onTap,
  required ReminderPriority priority,
}) {
  final border = isSelected ? BorderSide.none : BorderSide(color: AppColors.Bordergrey);
  return ChoiceChip(
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    label: TitleText(text: text, subtractedSize: 14, color: isSelected ? Colors.white : AppColors.greyColor),
    selected: isSelected,
    onSelected: (_) => onTap(),
    selectedColor: AppColors.optionPriorityColors(priority),
    backgroundColor: Colors.transparent,
    side: border,
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
  );
}

Widget reminderButton({
  required String label,
  required VoidCallback onPressed,
  Color backgroundColor = AppColors.blueColor,
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

Row CustomTitleText({
  required String text,
  required BuildContext context,
}) {
  return Row(
    children: [
      TitleText(
        subtractedSize: 12,
        text: text,
        fontWeight: FontWeight.w600,
      ),
      const SizedBox(width: 10),
      Expanded(child: AppBarDivider.getAppBarDivider(context))
    ],
  );
}
