import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:eslam_s_application/core/local_storage/hive.dart';
import 'package:eslam_s_application/core/notifications/boot_channel.dart';
import 'package:eslam_s_application/core/notifications/notification_service.dart';
import 'package:eslam_s_application/core/notifications/reminder_rescheduler.dart';
import 'package:eslam_s_application/core/notifications/timezone_util.dart';
import 'package:flutter/widgets.dart';
import 'package:timezone/timezone.dart' as tz;


class AppInitializer {
  static Future<void> init() async {

     WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

     await TimezoneUtil.configureLocalTimeZone();
    await HiveService.init();

    await NotificationService.instance.init();
    log('AppInitializer: Notifications initialized');

    // 3) Show welcome notification
   await NotificationService.instance.welcomeImmediateShow();
    // 4) Reschedule all reminders on app start
   // await ReminderRescheduler.rescheduleAll();
     log('AppInitializer: Reminders rescheduled');

    // 5) set BootChannel handler
    BootChannel.setBootHandler(() async {
      log('BootChannel: Rescheduling reminders after boot');
     // await ReminderRescheduler.rescheduleAll(boxName: 'reminders');
    });
    
    log('AppInitializer: Initialization completed successfully');
  }
}
// import 'dart:developer';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:eslam_s_application/core/local_storage/hive.dart';
// import 'package:eslam_s_application/core/notifications/boot_channel.dart';
// import 'package:eslam_s_application/core/notifications/notification_service.dart';
// import 'package:eslam_s_application/core/notifications/reminder_rescheduler.dart';
// import 'package:eslam_s_application/core/notifications/timezone_util.dart';
// import 'package:flutter/widgets.dart';

// class AppInitializer {
//   static Future<void> init() async {
//     WidgetsFlutterBinding.ensureInitialized();
//     await EasyLocalization.ensureInitialized();
//     await TimezoneUtil.configureLocalTimeZone();
//     await HiveService.init();
//     await NotificationService.instance.init();
//     await ReminderRescheduler.rescheduleAll();
//     BootChannel.setBootHandler(() async {
//       await ReminderRescheduler.rescheduleAll(boxName: 'reminders');
//     });
//     await NotificationService.instance.welcomeImmediateShow();
//     log('AppInitializer: Initialization completed successfully');
//   }
// }
