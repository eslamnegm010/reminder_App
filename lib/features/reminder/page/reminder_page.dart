import 'package:easy_localization/easy_localization.dart';
import 'package:reminder_app/core/utils/app_export.dart';
import 'package:reminder_app/features/reminder/cubit/reminder_cubit.dart';
import 'package:reminder_app/features/reminder/cubit/reminder_state.dart';
import 'package:reminder_app/features/reminder/enum/filter_type.dart';
import 'package:reminder_app/features/reminder/widgets/empty_page.dart';
import 'package:reminder_app/features/reminder/widgets/page_header.dart';
import 'package:reminder_app/features/reminder/widgets/main_widgets/custom_reminder_card.dart';
import 'package:reminder_app/features/reminder/widgets/main_widgets/create_new.dart';
import 'package:reminder_app/features/settings/settings_sheet.dart';
import 'package:reminder_app/sheared_widgets/others/app_divider.dart';
import 'package:reminder_app/sheared_widgets/others/dismissible_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReminderPage extends StatelessWidget {
  const ReminderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ReminderPageBody();
  }
}

class ReminderPageBody extends StatelessWidget {
  const ReminderPageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReminderCubit, ReminderState>(
      builder: (context, state) {
        final cubit = context.read<ReminderCubit>();
        final reminders = cubit.visibleReminders();

        return Scaffold(
          appBar: _buildAppBar(context),
          floatingActionButton: FloatingActionButton(
            onPressed: () => showAddReminderBottomSheet(context),
            backgroundColor: AppColors.blueColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
            child: const Icon(Icons.add),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                const PageHeader(),
                SizedBox(height: 10.h),
                AppBarDivider.getAppBarDivider(context),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: FilterType.values.map((type) {
                      final label = type.name;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: _buildFilterButton(context, label, type),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: reminders.isEmpty
                      ? buildEmptyList()
                      : ListView.separated(
                          itemCount: reminders.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 0),
                          itemBuilder: (context, index) {
                            final item = reminders[index];
                            return DismissibleWrapper(
                              id: item.id,
                              isCompleted: item.isCompleted,
                              onDelete: () => cubit.removeReminder(item.id),
                              onComplete: () => cubit.toggleReminder(item.id),
                              child: ReminderCard(
                                reminder: item,
                                onDelete: () => cubit.removeReminder(item.id),
                                onToggleCompletion: (_) => cubit.toggleReminder(item.id),
                                onNotifiTapped: () {
                                  final updated = item.copyWith(
                                    notificationsEnabled: !item.notificationsEnabled,
                                  );
                                  cubit.editReminder(updated);
                                },
                                onEdit: () =>
                                    showAddReminderBottomSheet(context, reminder: item),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(70),
      child: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        flexibleSpace: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TitleText.small(
                        text: 'reminder',
                        color: AppColors.getTextColor(context),
                        fontWeight: FontWeight.bold,
                      ),
                      SubtitleText(
                        text: 'manage_tasks_efficiently',
                        subtractedSize: 2,
                        color: AppColors.getGrayTextColor(context),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.getCardBackgroundColor(context),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.blueColor.withValues(alpha: 0.1)),
                  ),
                  child: IconButton(
                    padding: const EdgeInsets.all(12),
                    icon: SvgPicture.asset(
                      AppAssets.userCircleIcon,
                      height: 24,
                      width: 24,
                      colorFilter: ColorFilter.mode(AppColors.blueColor, BlendMode.srcIn),
                    ),
                    onPressed: () => showSettings(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton(BuildContext context, String label, FilterType type) {
    final cubit = context.read<ReminderCubit>();
    final active = cubit.filter == type;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = active
        ? AppColors.blueColor
        : AppColors.getCardBackgroundColor(context);
    final textColor = active
        ? Colors.white
        : (isDark ? Colors.white70 : AppColors.Dark.withValues(alpha: 0.8));

    return GestureDetector(
      onTap: () => cubit.setFilter(type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: active
                ? AppColors.blueColor.withValues(alpha: 0.9)
                : Colors.transparent,
            width: 1.2,
          ),
          boxShadow: active
              ? [
                  BoxShadow(
                    color: AppColors.blueColor.withValues(alpha: 0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: isDark ? Colors.black26 : Colors.grey.withValues(alpha: 0.12),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
        ),
        child: Row(
          children: [
            if (active)
              const Padding(
                padding: EdgeInsets.only(right: 6),
                child: Icon(Icons.check_circle, color: Colors.white, size: 18),
              ),
            TitleText(subtractedSize: 12, text: label, color: textColor),
          ],
        ),
      ),
    );
  }
}
