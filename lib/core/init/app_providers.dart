import 'package:reminder_app/core/local_storage/hive.dart';
import 'package:reminder_app/features/app_home_screen/cubit/cubit/theme_cubit.dart';
import 'package:reminder_app/features/reminder/cubit/reminder_cubit.dart';
import 'package:reminder_app/features/user/user_cubit/user_cubit.dart';
import 'package:reminder_app/core/update/cubit/update_cubit.dart';
import 'package:reminder_app/core/update/update_prefs_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProviders {
  static final box = HiveService.reminderBox;

  /// Must be called after SharedPreferences is initialized.
  /// Pass the [SharedPreferences] instance from `main()`.
  static List<BlocProvider> providers(SharedPreferences prefs) {
    final updatePrefsService = UpdatePrefsService(prefs);

    return [
      BlocProvider<UpdateCubit>(
        create: (_) => UpdateCubit(prefsService: updatePrefsService),
        lazy: false,
      ),
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
}
