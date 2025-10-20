// lib/core/local_storage/hive_service.dart
import 'package:eslam_s_application/features/user/model/user.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:eslam_s_application/features/reminder/model/reminder_model.dart';

class HiveService {
  static const String _reminderBoxName = 'remindersBox';
  static const String _userBoxName = 'userBox';
  static const String _settingsBoxName = 'settingsBox';

  /// Initialize Hive
  static Future<void> init() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(ReminderModelAdapter().typeId)) {
      Hive.registerAdapter(ReminderModelAdapter());
    }

    if (!Hive.isAdapterRegistered(UserModelAdapter().typeId)) {
      Hive.registerAdapter(UserModelAdapter());
    }

    await Hive.openBox<ReminderModel>(_reminderBoxName);
    await Hive.openBox<UserModel>(_userBoxName);
    await Hive.openBox(_settingsBoxName);
  }

  static Box<ReminderModel> get reminderBox => Hive.box<ReminderModel>(_reminderBoxName);
  static Box<UserModel> get userBox => Hive.box<UserModel>(_userBoxName);
  static Box get settingsBox => Hive.box(_settingsBoxName);
}
