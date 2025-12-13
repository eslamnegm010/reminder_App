import 'package:hive/hive.dart';
import 'package:reminder_app/features/reminder/model/reminder_model.dart';
import 'package:reminder_app/core/notifications/notification_service.dart';
import 'dart:developer';

class ReminderRescheduler {
  static Future<void> rescheduleAll({String boxName = 'reminders'}) async {
    Box? box;
    try {
      box = Hive.box(boxName);
    } catch (_) {
      log('ReminderRescheduler: box "$boxName" not found');
    }

    try {
      if (box == null || !box.isOpen) {
        box = await Hive.openBox(boxName);
      }

      for (final dynamic raw in box.values) {
        try {
          if (raw is ReminderModel) {
            final rem = raw;
            if (!rem.isCompleted && rem.dateTime != null) {
              await NotificationService.instance.scheduleReminder(rem);
            } else {
              await NotificationService.instance.cancelReminder(rem.id);
            }
          } else if (raw is Map) {
            final id = raw['id']?.toString();
            final completed = raw['isCompleted'] as bool? ?? false;
            final date = raw['dateTime'] != null ? DateTime.tryParse(raw['dateTime'].toString()) : null;
            final title = raw['title']?.toString() ?? '';
            final desc = raw['description']?.toString() ?? '';
            log('ReminderRescheduler: found Map id=$id, completed=$completed, dateTime=$date');

            if (id != null && date != null && !completed) {
              final rem =
                  ReminderModel(id: id, title: title, description: desc, dateTime: date, isCompleted: completed);
              await NotificationService.instance.scheduleReminder(rem);
            } else if (id != null) {
              await NotificationService.instance.cancelReminder(id);
            }
          }
        } catch (e, st) {
          log('ReminderRescheduler: item error: $e\n$st');
        }
      }
    } catch (e, st) {
      log('ReminderRescheduler: rescheduleAll failed: $e\n$st');
    }
  }
}




// 
