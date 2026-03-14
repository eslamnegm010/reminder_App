import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'dart:developer';
import 'dart:io' show Platform;
import 'dart:typed_data';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:reminder_app/features/reminder/model/reminder_model.dart';
import 'package:reminder_app/core/notifications/timezone_util.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _inited = false;
  bool _tzInited = false;

  Future<void> init() async {
    if (_inited) return;
    // Ensure timezone initialized (uses TimezoneUtil)
    await _ensureTimeZoneInitialized();

    await _checkAndRequestExactAlarmPermission();

    if (Platform.isAndroid) {
      const channel = AndroidNotificationChannel(
        'reminder_channel',
        'Reminders',
        description: 'Reminder notifications',
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
        showBadge: true,
      );

      await _plugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(android: androidInit, iOS: iosInit);

    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse resp) {},
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    if (Platform.isAndroid) {
      await _requestAndroidNotificationPermission();
    }

    _inited = true;
  }

  Future<void> _ensureTimeZoneInitialized() async {
    if (_tzInited) return;

    try {
      await TimezoneUtil.configureLocalTimeZone();
    } catch (e) {
      log('NotificationService: _ensureTimeZoneInitialized failed: $e');
      try {
        tz.setLocalLocation(tz.getLocation('UTC'));
      } catch (_) {}
    }

    _tzInited = true;
  }

  Future<void> _requestAndroidNotificationPermission() async {
    try {
      final status = await Permission.notification.status;
      if (!status.isGranted) {
        final result = await Permission.notification.request();
        log(
          'NotificationService._requestAndroidNotificationPermission: request result=$result',
        );
      }
    } catch (e) {
      log('NotificationService._requestAndroidNotificationPermission failed: $e');
    }
  }

  Future<void> _checkAndRequestExactAlarmPermission() async {
    if (!Platform.isAndroid) return;
    try {
      final androidPlugin = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      if (androidPlugin != null) {
        final canScheduleExactAlarms = await androidPlugin
            .canScheduleExactNotifications();
        if (canScheduleExactAlarms == false) {
          await androidPlugin.requestExactAlarmsPermission();
        }
      }
    } catch (e) {
      log('NotificationService: Error with exact alarm permission: $e');
    }
  }

  int _stableId(String s) {
    const int fnvPrime = 0x01000193;
    const int offset = 0x811C9DC5;
    int hash = offset;
    final bytes = Uint8List.fromList(utf8.encode(s));
    for (final b in bytes) {
      hash ^= b;
      hash = (hash * fnvPrime) & 0xFFFFFFFF;
    }
    final intId = hash & 0x7FFFFFFF;
    return intId;
  }

  NotificationDetails _platformDetails() {
    const android = AndroidNotificationDetails(
      'reminder_channel',
      'Reminders',
      channelDescription: 'Reminder notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      channelShowBadge: true,
      ticker: 'reminder_ticker',
    );

    const ios = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    return const NotificationDetails(android: android, iOS: ios);
  }

  Future<void> scheduleReminder(ReminderModel rem) async {
    if (rem.dateTime == null) {
      log('NotificationService.scheduleReminder: no dateTime provided');
      return;
    }

    await init();
    try {
      await _ensureTimeZoneInitialized();

      final localTZ = tz.local;
      final reminderDateTime = rem.dateTime!;
      var scheduled = tz.TZDateTime.from(reminderDateTime, localTZ);
      final now = tz.TZDateTime.now(localTZ);

      if (!scheduled.isAfter(now)) {
        scheduled = now.add(const Duration(seconds: 1));
      }
      final id = _stableId(rem.id);

      DateTimeComponents? matchDateTimeComponents;
      if (rem.repeatType == 'Daily') {
        matchDateTimeComponents = DateTimeComponents.time;
      } else if (rem.repeatType == 'Weekly') {
        matchDateTimeComponents = DateTimeComponents.dayOfWeekAndTime;
      } else if (rem.repeatType == 'Monthly') {
        matchDateTimeComponents = DateTimeComponents.dayOfMonthAndTime;
      }

      try {
        await _plugin.zonedSchedule(
          id,
          (rem.title.isNotEmpty) ? rem.title : 'Reminder',
          (rem.description.isNotEmpty) ? rem.description : null,
          scheduled,
          _platformDetails(),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          matchDateTimeComponents: matchDateTimeComponents,
          payload: jsonEncode({'id': rem.id}),
        );
      } catch (exactError) {
        log(
          'NotificationService.scheduleReminder:-- Exact scheduling failed: $exactError',
        );
        await _plugin.zonedSchedule(
          id,
          (rem.title.isNotEmpty) ? rem.title : 'Reminder',
          (rem.description.isNotEmpty) ? rem.description : null,
          scheduled,
          _platformDetails(),
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          matchDateTimeComponents: matchDateTimeComponents,
          payload: jsonEncode({'id': rem.id}),
        );
      }

      final pending = await _plugin.pendingNotificationRequests();
      final scheduledIds = pending.map((p) => p.id).toList();

      if (!scheduledIds.contains(id)) {
        log(
          'NotificationService.scheduleReminder:  WARNING - Notification ID $id NOT found in pending list!',
        );
      }
    } catch (e, stack) {
      log('NotificationService.scheduleReminder:  CRITICAL ERROR - $e');
      log('NotificationService.scheduleReminder: Stack trace - $stack');
    }
  }

  Future<void> cancelReminder(String reminderId) async {
    await init();
    await _plugin.cancel(_stableId(reminderId));
  }

  Future<void> cancelAll() async {
    log('NotificationService.cancelAll: canceling all notifications');
    await init();
    await _plugin.cancelAll();
    final remaining = await _plugin.pendingNotificationRequests();
    log('NotificationService.cancelAll: Remaining notifications: ${remaining.length}');
    if (remaining.isEmpty) {
      log('NotificationService.cancelAll: ✅ All notifications cleared successfully');
    } else {
      log(
        'NotificationService.cancelAll: ⚠️ WARNING - ${remaining.length} notifications still pending',
      );
    }
  }

  Future<List<int>?> pendingNotificationIds() async {
    final pending = await _plugin.pendingNotificationRequests();
    final ids = pending.map((r) => r.id).toSet().toList()..sort();
    return ids;
  }

  Future<void> welcomeImmediateShow() async {
    await _plugin.show(
      _stableId('welcome_show'),
      'welcome_notification_title'.tr(),
      'welcome_notification_body'.tr(),
      _platformDetails(),
      payload: 'welcome_show',
    );
  }

  Future<void> debugNotificationStatus() async {
    await init();
    if (Platform.isAndroid) {
      final androidPlugin = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      if (androidPlugin != null) {
        final canScheduleExact = await androidPlugin.canScheduleExactNotifications();
        log('Can schedule exact alarms: $canScheduleExact');
        final channels = await androidPlugin.getNotificationChannels();
        log('Available notification channels:');
        if (channels != null && channels.isNotEmpty) {
          for (var channel in channels) {
            log('  - ${channel.id}: ${channel.name} (importance: ${channel.importance})');
          }
        } else {
          log('  No channels found!');
        }
        final permissionStatus = await Permission.notification.status;
        log('Notification permission: $permissionStatus');
        final pending = await _plugin.pendingNotificationRequests();
        log('Total pending notifications: ${pending.length}');
        if (pending.isNotEmpty) {
          log('Pending notification IDs: ${pending.map((p) => p.id).toList()}');
          for (var p in pending.take(3)) {
            log('  - ID ${p.id}: "${p.title}"');
          }
        }
      }
    }
    log('Current time: ${DateTime.now()}');
    await _ensureTimeZoneInitialized();
    log('TZ time: ${tz.TZDateTime.now(tz.local)}');
    log('Timezone: ${tz.local}');
    log('========== DEBUG COMPLETE ==========');
  }

  // showImmediate for location
  Future<void> showImmediate(String title, String body, {String? payload}) async {
    await init();
    await _plugin.show(
      _stableId(title + (body)),
      title,
      body,
      _platformDetails(),
      payload: payload,
    );
  }
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {
  log(
    '[NOTIFICATION TAPPED] Background notification tapped. payload=${response.payload}',
  );
}
