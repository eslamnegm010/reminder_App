import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../sheared_widgets/others/snack_bar.dart';
import '../../cubit/reminder_cubit.dart';
import '../../enum/reminder_priority.dart';

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
  required String category,
  required String repeatType,
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
      priority: selectedPriority?.name ?? ReminderPriority.medium.name,
      dateTime: finalDateTime,
      id: reminderId,
      notificationsEnabled: notificationsEnabled,
      category: category,
      repeatType: repeatType,
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
