import 'package:reminder_app/core/utils/app_export.dart';
import 'package:reminder_app/features/reminder/cubit/reminder_cubit.dart';
import 'package:reminder_app/features/reminder/cubit/reminder_state.dart';
import 'package:reminder_app/features/reminder/enum/filter_type.dart';
import 'package:reminder_app/features/reminder/page/search_page.dart';
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
  const ReminderPageBody({Key? key}) : super(key: key);

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
            child: const Icon(Icons.add),
            backgroundColor: AppColors.blueColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                PageHeader(),
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

  AppBar _buildAppBar(BuildContext context) => AppBar(
    title: TitleText.small(
      text: 'reminder',
      color: AppColors.blueColor,
      fontWeight: FontWeight.w500,
    ),
    centerTitle: true,
    elevation: 0,
    actions: [
      IconButton(
        icon: const Icon(Icons.search_rounded),
        onPressed: () => _openSearch(context),
      ),
      IconButton(
        icon: SvgPicture.asset(
          AppAssets.userCircleIcon,
          height: 24,
          width: 24,
          colorFilter: ColorFilter.mode(AppColors.getTextColor(context), BlendMode.srcIn),
        ),
        onPressed: () => showSettings(context),
      ),
    ],
  );

  void _openSearch(BuildContext context) {
    showSearch<String>(
      context: context,
      delegate: ReminderSearchDelegate(
        onQueryUpdate: (txt) => context.read<ReminderCubit>().setSearch(txt),
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
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Icon(Icons.check_circle, color: Colors.white, size: 18),
              ),
            TitleText(subtractedSize: 12, text: label, color: textColor),
          ],
        ),
      ),
    );
  }
}
