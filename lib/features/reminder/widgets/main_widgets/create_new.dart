import 'package:eslam_s_application/features/reminder/widgets/location_widgets/location_picker.dart';
import 'package:eslam_s_application/core/location_services/models/location_model.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eslam_s_application/core/utils/app_export.dart';
import 'package:eslam_s_application/features/reminder/cubit/reminder_cubit.dart';
import 'package:eslam_s_application/features/reminder/enum/reminder_priority.dart';
import 'package:eslam_s_application/features/reminder/model/reminder_model.dart';
import 'package:eslam_s_application/core/utils/validator.dart';
import 'package:eslam_s_application/sheared_widgets/default_button.dart';
import 'package:eslam_s_application/sheared_widgets/others/app_divider.dart';
import 'package:eslam_s_application/sheared_widgets/others/snack_bar.dart';
import 'package:eslam_s_application/sheared_widgets/text_field/default_text_form_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  LocationSearchResult? selectedLocation;

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
    if (reminder.location != null &&
        reminder.latitude != null &&
        reminder.longitude != null) {
      selectedLocation = LocationSearchResult(
        displayName: reminder.location!,
        type: 'saved', // or 'unknown'
        location: LatLng(reminder.latitude!, reminder.longitude!),
        address: {},
      );
    } else if (reminder.location != null && reminder.location!.isNotEmpty) {
      // Fallback for legacy data if any
      final parts = reminder.location!.split(',');
      if (parts.length == 2) {
        final lat = double.tryParse(parts[0].trim());
        final lng = double.tryParse(parts[1].trim());
        if (lat != null && lng != null) {
          selectedLocation = LocationSearchResult(
            displayName: reminder.location!,
            type: 'legacy',
            location: LatLng(lat, lng),
            address: {},
          );
        }
      }
    }
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
                                  child: _buildDateTimeButton(
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
                                    onTap: () => setState(
                                      () => selectedPriority = ReminderPriority.low,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _priorityCard(
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
                                  child: _priorityCard(
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
                            CustomTitleText(text: "location", context: ctx),
                            const SizedBox(height: 10),
                            LocationPicker(
                              location: selectedLocation?.location,
                              hint: 'select_location',
                              helper: 'location_helper_text',
                              onLocationSelected: (loc) =>
                                  setState(() => selectedLocation = loc),
                              onClear: () => setState(() => selectedLocation = null),
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
                              child: reminderButton(
                                label: "cancel",
                                backgroundColor: Colors.grey.withValues(alpha: .3),
                                labelColor: AppColors.getTextColor(ctx),
                                onPressed: () => Navigator.pop(ctx),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: reminderButton(
                                label: reminder == null ? "create" : "save",
                                onPressed: () {
                                  handleAddReminder(
                                    context: context,
                                    ctx: ctx,
                                    formKey: formKey,
                                    titleController: titleController,
                                    descController: descController,
                                    selectedPriority: selectedPriority,
                                    selectedDate: selectedDate,
                                    selectedTime: selectedTime,
                                    notificationsEnabled: notificationsEnabled,
                                    reminderId: reminder?.id,
                                    selectedLocation: selectedLocation,
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

Widget _buildDateTimeButton({
  required String icon,
  required String label,
  required VoidCallback onTap,
}) {
  return OutlinedButton.icon(
    onPressed: onTap,
    style: OutlinedButton.styleFrom(
      side: BorderSide(color: AppColors.blueColor.withValues(alpha: 0.1)),
      backgroundColor: AppColors.blueColor.withValues(alpha: 0.05),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    icon: SvgPicture.asset(
      icon,
      height: 20,
      width: 20,
      colorFilter: ColorFilter.mode(AppColors.blueColor, BlendMode.srcIn),
    ),
    label: TitleText(subtractedSize: 12, text: label, color: AppColors.blueColor),
  );
}

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
      color: isSelected ? color.withValues(alpha: .85) : color.withValues(alpha: .15),
      borderRadius: BorderRadius.circular(16),
      boxShadow: isSelected
          ? [
              BoxShadow(
                color: color.withValues(alpha: .4),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
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
            Icon(
              icon,
              color: isSelected ? Colors.white : color.withValues(alpha: .8),
              size: 22,
            ),
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
    borderColor: AppColors.blueColor.withValues(alpha: 0.16),
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

void handleAddReminder({
  required BuildContext context,
  required BuildContext ctx,
  required GlobalKey<FormState> formKey,
  required TextEditingController titleController,
  required TextEditingController descController,
  required ReminderPriority? selectedPriority,
  required DateTime? selectedDate,
  required TimeOfDay? selectedTime,
  required bool notificationsEnabled,
  required String? reminderId,
  required LocationSearchResult? selectedLocation,
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
      notificationsEnabled: notificationsEnabled,
      location: selectedLocation?.displayName,
      latitude: selectedLocation?.location.latitude ?? 0,
      longitude: selectedLocation?.location.longitude ?? 0,
    );

    if (finalDateTime != null && notificationsEnabled) {
      final formatted = DateFormat('yyyy-MM-dd • hh:mm a').format(finalDateTime);
      showSnackbar(context, message: "reminder_scheduled_for".tr(args: [formatted]));
    } else {
      showSnackbar(context, message: "reminder_scheduled_for");
    }

    Navigator.pop(ctx);
  }
}

Row CustomTitleText({required String text, required BuildContext context}) {
  return Row(
    children: [
      TitleText(
        subtractedSize: 11,
        text: text,
        fontWeight: FontWeight.w600,
        color: AppColors.blueTextColor(context),
      ),
      const SizedBox(width: 10),
      Expanded(child: AppBarDivider.getAppBarDivider(context)),
    ],
  );
}

class NotificationToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String title;

  const NotificationToggle({
    super.key,
    required this.value,
    required this.onChanged,
    this.title = "notify_for_this_reminder",
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: isDark ? Colors.white12 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: TitleText(
              text: title,
              subtractedSize: 12,
              fontWeight: FontWeight.w500,
              padding: const EdgeInsetsDirectional.only(start: 8),
              color: AppColors.getGrayTextColor(context),
            ),
          ),
          Switch.adaptive(
            activeColor: AppColors.blueColor,
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
