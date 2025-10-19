import 'package:eslam_s_application/core/utils/app_export.dart';
import 'package:eslam_s_application/core/local_storage/hive.dart';
import 'package:eslam_s_application/features/reminder/cubit/reminder_cubit.dart';
import 'package:eslam_s_application/features/reminder/cubit/reminder_state.dart';
import 'package:eslam_s_application/features/reminder/enum/filter_type.dart';
import 'package:eslam_s_application/features/reminder/page/search_page.dart';
import 'package:eslam_s_application/features/reminder/page/app_settings.dart';
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
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
                    children: [
                      _buildFilterChip(context, 'all', FilterType.all),
                      const SizedBox(width: 8),
                      _buildFilterChip(context, 'active', FilterType.active),
                      const SizedBox(width: 8),
                      _buildFilterChip(context, 'completed', FilterType.completed),
                    ],
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
// import 'dart:ui' as ui;
// import 'package:easy_localization/easy_localization.dart';
// import 'package:eslam_s_application/core/utils/app_export.dart';
// import 'package:eslam_s_application/core/local_storage/hive.dart';
// import 'package:eslam_s_application/features/reminder/cubit/reminder_cubit.dart';
// import 'package:eslam_s_application/features/reminder/cubit/reminder_state.dart';
// import 'package:eslam_s_application/features/reminder/enum/filter_type.dart';
// import 'package:eslam_s_application/features/reminder/page/search_page.dart';
// import 'package:eslam_s_application/features/reminder/page/app_settings.dart';
// import 'package:eslam_s_application/features/reminder/model/reminder_model.dart';
// import 'package:eslam_s_application/features/reminder/widgets/custom_reminder_card.dart';
// import 'package:eslam_s_application/features/reminder/widgets/empty_page.dart';
// import 'package:eslam_s_application/sheared_widgets/others/app_divider.dart';
// import 'package:eslam_s_application/sheared_widgets/others/dismissible_wrapper.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../widgets/create_new.dart';

// // ----------------------------------------------
// // Main Reminder Page
// // ----------------------------------------------
// class ReminderPage extends StatelessWidget {
//   const ReminderPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final box = HiveService.reminderBox;
//     return BlocProvider(
//       create: (_) => ReminderCubit(box),
//       child: const ReminderPageBody(),
//     );
//   }
// }

// class ReminderPageBody extends StatelessWidget {
//   const ReminderPageBody({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ReminderCubit, ReminderState>(
//       builder: (context, state) {
//         final cubit = context.read<ReminderCubit>();
//         final reminders = cubit.visibleReminders();
//         final isDark = Theme.of(context).brightness == Brightness.dark;

//         return Scaffold(
//           backgroundColor: isDark ? Colors.black : Colors.grey[100],
//           appBar: _buildAppBar(context),
//           floatingActionButton: FloatingActionButton(
//             onPressed: () => showAddReminderBottomSheet(context),
//             backgroundColor: AppColors.blueColor,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(100),
//             ),
//             child: const Icon(Icons.add, size: 28),
//           ),
//           body: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12.0),
//             child: Column(
//               children: [
//                 const PageHeader(),
//                 SizedBox(height: 10.h),
//                 AppBarDivider.getAppBarDivider(context),
//                 const SizedBox(height: 10),
//                 _buildFilterRow(context),
//                 const SizedBox(height: 10),
//                 Expanded(
//                   child: reminders.isEmpty
//                       ? buildEmptyList()
//                       : ListView.separated(
//                           itemCount: reminders.length,
//                           separatorBuilder: (_, __) => const SizedBox(height: 8),
//                           itemBuilder: (context, index) {
//                             final item = reminders[index];
//                             return DismissibleWrapper(
//                               id: item.id,
//                               isCompleted: item.isCompleted,
//                               onDelete: () => cubit.removeReminder(item.id),
//                               onComplete: () => cubit.toggleReminder(item.id),
//                               child:  ReminderCard(
//                                  reminder: item,
//                                  onDelete: () => cubit.removeReminder(item.id),
//                                  onToggleCompletion: (_) => cubit.toggleReminder(item.id),
//                                ),
//                             );
//                           },
//                         ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildFilterRow(BuildContext context) {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         children: [
//           _buildFilterChip(context, 'all', FilterType.all),
//           const SizedBox(width: 8),
//           _buildFilterChip(context, 'active', FilterType.active),
//           const SizedBox(width: 8),
//           _buildFilterChip(context, 'completed', FilterType.completed),
//         ],
//       ),
//     );
//   }

//   Widget _buildFilterChip(
//     BuildContext context,
//     String label,
//     FilterType type,
//   ) {
//     final cubit = context.read<ReminderCubit>();
//     final active = cubit.filter == type;
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return ChoiceChip(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       label: TitleText(
//         subtractedSize: 12,
//         text: label,
//         color: active
//             ? Colors.white
//             : isDark
//                 ? Colors.white70
//                 : AppColors.Dark,
//       ),
//       selected: active,
//       checkmarkColor: Colors.white,
//       onSelected: (_) => cubit.setFilter(type),
//       selectedColor: AppColors.blueColor,
//       backgroundColor:
//           isDark ? Colors.white.withOpacity(0.05) : Colors.blueGrey.shade50,
//     );
//   }
// }

// AppBar _buildAppBar(BuildContext context) => AppBar(
//       title: TitleText.small(
//         text: 'reminder',
//         color: AppColors.blueColor,
//         fontWeight: FontWeight.w500,
//       ),
//       centerTitle: true,
//       elevation: 0,
//       actions: [
//         IconButton(
//           icon: const Icon(Icons.search_rounded),
//           onPressed: () => _openSearch(context),
//         ),
//         IconButton(
//           icon: SvgPicture.asset(
//             AppAssets.userCircleIcon,
//             height: 24,
//             width: 24,
//             colorFilter: ColorFilter.mode(AppColors.getTextColor(context), BlendMode.srcIn),
//           ),
//           onPressed: () => showSettings(context),
//         ),
//       ],
//     );

// void _openSearch(BuildContext context) {
//   showSearch<String>(
//     context: context,
//     delegate: ReminderSearchDelegate(
//       onQueryUpdate: (txt) => context.read<ReminderCubit>().setSearch(txt),
//     ),
//   );
// }

// // ----------------------------------------------
// // PageHeader
// // ----------------------------------------------
// class PageHeader extends StatelessWidget {
//   const PageHeader({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           GestureDetector(
//             onTap: () => showAddReminderBottomSheet(context),
//             child: Container(
//               height: 58,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(20),
//                 gradient: LinearGradient(
//                   colors: [
//                     AppColors.blueColor.withOpacity(0.85),
//                     AppColors.blueColor.withOpacity(0.55),
//                   ],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: AppColors.blueColor.withOpacity(0.25),
//                     blurRadius: 10,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 children: [
//                   Container(
//                     width: 15,
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.85),
//                       borderRadius: const BorderRadius.only(
//                         topLeft: Radius.circular(20),
//                         bottomLeft: Radius.circular(20),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: TitleText(
//                       text: 'add_your_reminder',
//                       color: Colors.white,
//                       subtractedSize: 10,
//                     ),
//                   ),
//                   const Padding(
//                     padding: EdgeInsets.only(right: 14.0),
//                     child: Icon(Icons.add_circle_rounded, color: Colors.white, size: 28),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(height: 16),
//           TitleText(
//             text: "reminder_info_options",
//             color: AppColors.blueColor,
//             subtractedSize: 12,
//           ),
//           const SizedBox(height: 10),
//         ],
//       ),
//     );
//   }
// }
