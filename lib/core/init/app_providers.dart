import 'package:reminder_app/core/local_storage/hive.dart';
import 'package:reminder_app/features/app_home_screen/cubit/cubit/theme_cubit.dart';
import 'package:reminder_app/features/reminder/cubit/reminder_cubit.dart';
import 'package:reminder_app/features/user/user_cubit/user_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppProviders {
  static final box = HiveService.reminderBox;

  static final List<BlocProvider> providers = [
    BlocProvider<ThemeCubit>(
      create: (_) => ThemeCubit(),
    ),
    BlocProvider<ReminderCubit>(
      create: (_) => ReminderCubit(box),
    ),
    BlocProvider<UserCubit>(
      create: (_) => UserCubit(HiveService.userBox),
    ),
  ];
}
