import 'package:easy_localization/easy_localization.dart';
import 'package:reminder_app/core/local_storage/hive.dart';
import 'package:reminder_app/core/notifications/boot_channel.dart';
import 'package:reminder_app/core/notifications/notification_service.dart';
import 'package:reminder_app/core/notifications/reminder_rescheduler.dart';
import 'package:reminder_app/core/notifications/timezone_util.dart';
import 'package:flutter/widgets.dart';

class AppInitializer {
  static Future<void> init() async {
    //  Ensure Flutter bindings
    WidgetsFlutterBinding.ensureInitialized();

    //  Localization

    await EasyLocalization.ensureInitialized();

    //  Timezone (sets tz.local via TimezoneUtil)

    await TimezoneUtil.configureLocalTimeZone();

    //  Hive (local storage)

    await HiveService.init();

    //  Notification service init

    await NotificationService.instance.init();

    // Reschedule reminders on app start BEFORE welcome notification

    await ReminderRescheduler.rescheduleAll();

    // 6) Show welcome notification (after rescheduling to avoid overlap)
    // await NotificationService.instance.welcomeImmediateShow();

    // 7) Boot handler - reschedule reminders after device boot

    BootChannel.setBootHandler(() async {
      await ReminderRescheduler.rescheduleAll(boxName: 'reminders');
    });
  }
}
