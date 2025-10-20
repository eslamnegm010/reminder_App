// lib/core/notifications/reminder_rescheduler.dart
import 'package:hive/hive.dart';
import 'package:eslam_s_application/features/reminder/model/reminder_model.dart';
import 'package:eslam_s_application/core/notifications/notification_service.dart';
import 'dart:developer';
import 'package:timezone/timezone.dart' as tz;

class ReminderRescheduler {
  /// Reschedule all reminders stored in the provided boxName (default 'reminders').
  static Future<void> rescheduleAll({String boxName = 'reminders'}) async {
    Box? box;
    try {
      box = Hive.box(boxName);
      log('ReminderRescheduler: box "$boxName" already open');
    } catch (_) {
      log('ReminderRescheduler: box "$boxName" not open, will open now');
    }

    try {
      if (box == null || !box.isOpen) {
        box = await Hive.openBox(boxName);
        log('ReminderRescheduler: box "$boxName" opened');
      }

      for (final dynamic raw in box.values) {
        try {
          if (raw is ReminderModel) {
            final rem = raw;
            log('ReminderRescheduler: found ReminderModel id=${rem.id}, completed=${rem.isCompleted}, dateTime=${rem.dateTime}');
            if (!rem.isCompleted && rem.dateTime != null) {
              await NotificationService.instance.scheduleReminder(rem);
              log('ReminderRescheduler: scheduled reminder id=${rem.id}');
            } else {
              await NotificationService.instance.cancelReminder(rem.id);
              log('ReminderRescheduler: canceled reminder id=${rem.id}');
            }
          } else if (raw is Map) {
            final id = raw['id']?.toString();
            final completed = raw['isCompleted'] as bool? ?? false;
            final date = raw['dateTime'] != null ? DateTime.tryParse(raw['dateTime'].toString()) : null;
            final title = raw['title']?.toString() ?? '';
            final desc = raw['description']?.toString() ?? '';
            log('ReminderRescheduler: found Map id=$id, completed=$completed, dateTime=$date');

            if (id != null && date != null && !completed) {
              final rem = ReminderModel(
                  id: id, title: title, description: desc, dateTime: date, isCompleted: completed);
              await NotificationService.instance.scheduleReminder(rem);
              log('ReminderRescheduler: scheduled reminder id=$id');
            } else if (id != null) {
              await NotificationService.instance.cancelReminder(id);
              log('ReminderRescheduler: canceled reminder id=$id');
            }
          }
        } catch (e, st) {
          log('ReminderRescheduler: item error: $e\n$st');
        }
      }
      log('ReminderRescheduler: rescheduleAll completed successfully');
    } catch (e, st) {
      log('ReminderRescheduler: rescheduleAll failed: $e\n$st');
    }
  }
}




// 
