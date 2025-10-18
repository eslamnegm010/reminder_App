import 'package:eslam_s_application/core/utils/app_export.dart';
import 'package:eslam_s_application/core/local_storage/hive.dart';
import 'package:eslam_s_application/features/reminder/cubit/reminder_cubit.dart';
import 'package:eslam_s_application/features/reminder/cubit/reminder_state.dart';
import 'package:eslam_s_application/features/reminder/widgets/custom_field.dart';
import 'package:eslam_s_application/features/reminder/widgets/custom_reminder_card.dart';
import 'package:eslam_s_application/sheared_widgets/text/title_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReminderPage extends StatelessWidget {
  const ReminderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final box = HiveService.reminderBox;
    return BlocProvider(
      create: (_) => ReminderCubit(box),
      child: const ReminderPageBody(),
    );
  }
}

class ReminderPageBody extends StatelessWidget {
  const ReminderPageBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TitleText.small(text: 'reminder', color: AppColors.blueColor, fontWeight: FontWeight.w500),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            AddReminderField(),
            SizedBox(height: 10.h),
            const SizedBox(height: 10),
            Divider(
              height: 1,
              thickness: .7,
              color: AppColors.greyColor,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: BlocBuilder<ReminderCubit, ReminderState>(
                builder: (context, state) {
                  final reminder = state.reminder;
                  if (reminder.isEmpty) {
                    return Center(
                      child: TitleText.verySmall(
                        text: "no_reminder_yet",
                        color: AppColors.blueColor,
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: reminder.length,
                    itemBuilder: (context, index) {
                      final item = reminder[index];
                      return ReminderCard(
                        reminder: item,
                        onDelete: () => context.read<ReminderCubit>().removeReminder(item.id),
                        onToggleCompletion: (value) => context.read<ReminderCubit>().toggleReminder(item.id),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
