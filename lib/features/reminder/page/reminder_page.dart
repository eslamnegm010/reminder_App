import 'package:eslam_s_application/core/utils/app_export.dart';
import 'package:eslam_s_application/core/local_storage/hive.dart';
import 'package:eslam_s_application/features/reminder/cubit/reminder_cubit.dart';
import 'package:eslam_s_application/features/reminder/cubit/reminder_state.dart';
import 'package:eslam_s_application/features/reminder/page/search_page.dart';
import 'package:eslam_s_application/features/reminder/widgets/empty_page.dart';
import 'package:eslam_s_application/features/reminder/widgets/page_header.dart';
import 'package:eslam_s_application/features/reminder/widgets/custom_reminder_card.dart';
import 'package:eslam_s_application/features/reminder/widgets/create_new.dart';
import 'package:eslam_s_application/sheared_widgets/others/app_divider.dart';
import 'package:eslam_s_application/sheared_widgets/others/dismissible_wrapper.dart';
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
        appBar: _buildAppBar(
          context,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => showAddReminderBottomSheet(context),
          child: const Icon(Icons.add),
          backgroundColor: AppColors.blueColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        body: _buildBody(
          context,
        ));
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          PageHeader(),
          SizedBox(height: 10.h),
          AppBarDivider.getAppBarDivider(context),
          const SizedBox(height: 10),
          BlocBuilder<ReminderCubit, ReminderState>(
            builder: (context, state) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip(context, 'all', FilterType.all),
                    const SizedBox(width: 8),
                    _buildFilterChip(context, 'active', FilterType.active),
                    const SizedBox(width: 8),
                    _buildFilterChip(context, 'completed', FilterType.completed),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          Expanded(
            child: BlocBuilder<ReminderCubit, ReminderState>(
              builder: (context, state) {
                final cubit = context.read<ReminderCubit>();
                final reminders = cubit.visibleReminders();

                if (reminders.isEmpty) {
                  return buildEmptyList();
                }

                return ListView.separated(
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
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    String label,
    FilterType type,
  ) {
    final cubit = context.read<ReminderCubit>();
    final active = cubit.filter == type;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ChoiceChip(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      label: TitleText(
        subtractedSize: 12,
        text: label,
        color: (isDark || active) ? Colors.white : AppColors.Dark,
      ),
      selected: active,
      checkmarkColor: active ? Colors.white : AppColors.Dark,
      onSelected: (_) => cubit.setFilter(type),
      selectedColor: AppColors.blueColor,
      backgroundColor: AppColors.getCardBackgroundColor(context),
    );
  }
}

enum FilterType { all, active, completed }

AppBar _buildAppBar(
  BuildContext context,
) =>
    AppBar(
      title: TitleText.small(text: 'reminder', color: AppColors.blueColor, fontWeight: FontWeight.w500),
      centerTitle: true,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.search_rounded),
          onPressed: () => _openSearch(context),
        ),
        PopupMenuButton<FilterType>(
          onSelected: (v) => context.read<ReminderCubit>().setFilter(v),
          itemBuilder: (_) => [
            PopupMenuItem(value: FilterType.all, child: Text('All')),
            PopupMenuItem(value: FilterType.active, child: Text('Active')),
            PopupMenuItem(value: FilterType.completed, child: Text('Completed')),
          ],
          icon: const Icon(Icons.filter_list_rounded),
        ),
      ],
    );
void _openSearch(BuildContext context) {
  showSearch<String>(
    context: context,
    delegate: ReminderSearchDelegate(onQueryUpdate: (txt) => context.read<ReminderCubit>().setSearch(txt)),
  );
}
