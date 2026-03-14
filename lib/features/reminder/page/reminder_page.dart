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
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: _buildAppBar(context),
          floatingActionButton: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.blueColor.withValues(alpha: 0.35),
                  blurRadius: 18,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: FloatingActionButton(
              onPressed: () => showAddReminderBottomSheet(context),
              backgroundColor: AppColors.blueColor,
              elevation: 0,
              highlightElevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
              child: const Icon(Icons.add, color: Colors.white, size: 28),
            ),
          ),
          body: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 220,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.blueColor.withValues(alpha: isDark ? 0.12 : 0.08),
                        Colors.transparent,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.h),
                  child: Column(
                    children: [
                      const PageHeader(),
                      SizedBox(height: 12.h),
                      AppBarDivider.getAppBarDivider(context),
                      const SizedBox(height: 16),
                      Row(
                        children: FilterType.values.map((type) {
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.0.h),
                              child: _buildFilterButton(context, type.name, type),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: reminders.isEmpty
                            ? buildEmptyList(context)
                            : ListView.separated(
                                itemCount: reminders.length,
                                padding: const EdgeInsets.only(bottom: 100),
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
                                      onToggleCompletion: (_) =>
                                          cubit.toggleReminder(item.id),
                                      onNotifiTapped: () {
                                        final updated = item.copyWith(
                                          notificationsEnabled:
                                              !item.notificationsEnabled,
                                        );
                                        cubit.editReminder(updated);
                                      },
                                      onEdit: () => showAddReminderBottomSheet(
                                        context,
                                        reminder: item,
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      toolbarHeight: 80,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TitleText(
                  text: 'reminder',
                  color: AppColors.getTextColor(context),
                  fontWeight: FontWeight.w800,
                  subtractedSize: 2,
                ),
                TitleText(
                  text: 'manage_tasks_efficiently'.tr(),
                  subtractedSize: 13,
                  fontWeight: FontWeight.w400,
                  color: AppColors.getTextColor(context).withValues(alpha: 0.6),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.getCardBackgroundColor(context),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.blueColor.withValues(alpha: 0.15)),
            ),
            child: IconButton(
              padding: const EdgeInsets.all(12),
              icon: SvgPicture.asset(
                AppAssets.userCircleIcon,
                height: 24,
                width: 24,
                colorFilter: const ColorFilter.mode(AppColors.blueColor, BlendMode.srcIn),
              ),
              onPressed: () => showSettings(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(BuildContext context, String label, FilterType type) {
    final cubit = context.read<ReminderCubit>();
    final active = cubit.filter == type;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final allReminders = cubit.state.reminder;

    final int count = switch (type) {
      FilterType.active => allReminders.where((r) => !r.isCompleted).length,
      FilterType.completed => allReminders.where((r) => r.isCompleted).length,
      _ => allReminders.length,
    };

    final (IconData icon, Color accentColor) = switch (type) {
      FilterType.active => (Icons.pending_actions_rounded, AppColors.blueColor),
      FilterType.completed => (Icons.task_alt_rounded, AppColors.blueColor),
      _ => (Icons.apps_rounded, AppColors.blueColor),
    };

    return GestureDetector(
      onTap: () => cubit.setFilter(type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOut,
        height: 72,
        decoration: BoxDecoration(
          color: isDark
              ? (active
                    ? accentColor.withValues(alpha: 0.18)
                    : Colors.white.withValues(alpha: 0.05))
              : (active ? accentColor.withValues(alpha: 0.1) : Colors.white),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: active
                ? accentColor.withValues(alpha: 0.6)
                : (isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.black.withValues(alpha: 0.06)),
            width: active ? 1.5 : 1.0,
          ),
          boxShadow: active
              ? [
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.25),
                    blurRadius: 14,
                    spreadRadius: 0,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withValues(alpha: 0.2)
                        : Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Top accent bar
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                height: 3,
                color: active ? accentColor : Colors.transparent,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          icon,
                          size: 18,
                          color: active
                              ? accentColor
                              : (isDark
                                    ? Colors.white30
                                    : Colors.black.withValues(alpha: 0.25)),
                        ),
                        // Count badge
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: active
                                ? accentColor
                                : (isDark
                                      ? Colors.white.withValues(alpha: 0.1)
                                      : Colors.black.withValues(alpha: 0.06)),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TitleText(
                            subtractedSize: 12,
                            text: '$count',
                            color: active
                                ? Colors.white
                                : (isDark ? Colors.white54 : Colors.black54),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                        color: active
                            ? accentColor
                            : (isDark
                                  ? Colors.white38
                                  : Colors.black.withValues(alpha: 0.4)),
                      ),
                      child: TitleText(
                        text: label,
                        subtractedSize: 12,
                        fontWeight: FontWeight.w500,
                        color: active
                            ? accentColor
                            : (isDark ? Colors.white : Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
