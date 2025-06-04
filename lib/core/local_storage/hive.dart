// lib/core/local_storage/hive_service.dart
import 'package:hive_flutter/hive_flutter.dart';
import 'package:eslam_s_application/presentation/reminder/model/reminder_model.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ReminderModelAdapter());
    }

    await Hive.openBox<ReminderModel>('remindersBox');
  }

  static Box<ReminderModel> get reminderBox =>
      Hive.box<ReminderModel>('remindersBox');
}
