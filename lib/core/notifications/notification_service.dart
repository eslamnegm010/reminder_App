
import 'dart:convert';
import 'dart:developer';
import 'dart:io' show Platform;
import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:eslam_s_application/features/reminder/model/reminder_model.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _inited = false;
  bool _tzInited = false;


  Future<void> init() async {
    if (_inited) return;
    
    log('NotificationService.init: starting initialization');
    _ensureTimeZoneInitialized();
    await _checkAndRequestExactAlarmPermission();

    if (Platform.isAndroid) {
      log('NotificationService.init: Pre-creating Android notification channel');
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

      log('NotificationService.init: Channel created successfully');
    }

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    final iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final settings = InitializationSettings(android: androidInit, iOS: iosInit);

    log('NotificationService.init: calling _plugin.initialize');
    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse resp) {
        log('Notification tapped: ${resp.payload}');
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    if (Platform.isAndroid) {
      log('NotificationService.init: requesting Android notification permission');
      await _requestAndroidNotificationPermission();
    }

    _inited = true;
    log('NotificationService.init: completed');
  }

  // void _ensureTimeZoneInitialized() {
  //   if (_tzInited) return;
  //   tzdata.initializeTimeZones();
  //   _tzInited = true;
  //   log('NotificationService: Timezone database initialized. Local TZ: ${tz.local}');
  // }

Future<void> _ensureTimeZoneInitialized() async {
  if (_tzInited) return;
  tzdata.initializeTimeZones();

  try {
   // final localTimeZone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation('Africa/Cairo'));
    // log('NotificationService: Timezone database initialized. Local TZ: $localTimeZone');
  } catch (e) {
    tz.setLocalLocation(tz.getLocation('UTC'));
    log('NotificationService: ⚠️ Failed to get local timezone, fallback to UTC. Error: $e');
  }

  _tzInited = true;
}


  Future<void> _requestAndroidNotificationPermission() async {
    try {
      final status = await Permission.notification.status;
      log('NotificationService._requestAndroidNotificationPermission: current status=$status');
      if (!status.isGranted) {
        log('NotificationService._requestAndroidNotificationPermission: requesting permission...');
        final result = await Permission.notification.request();
        log('NotificationService._requestAndroidNotificationPermission: request result=$result');
      }
    } catch (e) {
      log('NotificationService._requestAndroidNotificationPermission failed: $e');
    }
  }

  Future<void> _checkAndRequestExactAlarmPermission() async {
    if (!Platform.isAndroid) return;
    try {
      final androidPlugin = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlugin != null) {
        final canScheduleExactAlarms = await androidPlugin.canScheduleExactNotifications();
        log('NotificationService: Can schedule exact alarms: $canScheduleExactAlarms');
        if (canScheduleExactAlarms == false) {
          log('NotificationService: Requesting exact alarm permission');
          await androidPlugin.requestExactAlarmsPermission();
        }
      }
    } catch (e) {
      log('NotificationService: Error with exact alarm permission: $e');
    }
  }

  int _stableId(String s) {
    // 32-bit FNV-1a for stable hashing across runs/platforms
    const int fnvPrime = 0x01000193;
    const int offset = 0x811C9DC5;
    int hash = offset;
    final bytes = Uint8List.fromList(utf8.encode(s));
    for (final b in bytes) {
      hash ^= b;
      hash = (hash * fnvPrime) & 0xFFFFFFFF;
    }
    // Make it positive 31-bit int for Android
    final intId = hash & 0x7FFFFFFF;
    log('NotificationService._stableId: "$s" -> $intId');
    return intId;
  }

  NotificationDetails _platformDetails() {
    log('NotificationService._platformDetails: creating details');
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
    log('NotificationService.scheduleReminder: scheduling reminder id=${rem.id}, time=${rem.dateTime}');

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

      log('NotificationService.scheduleReminder: original time=$reminderDateTime');
      log('NotificationService.scheduleReminder: scheduled=$scheduled (${scheduled.timeZoneName})');
      log('NotificationService.scheduleReminder: now=$now (${now.timeZoneName})');

      final id = _stableId(rem.id);

      try {
        await _plugin.zonedSchedule(
          id,
          (rem.title.isNotEmpty ) ? rem.title : 'Reminder',
          (rem.description.isNotEmpty ) ? rem.description : null,
          scheduled,
          _platformDetails(),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          // uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          payload: jsonEncode({'id': rem.id}),
        );
        log('NotificationService.scheduleReminder: ✅ SUCCESS - Exact scheduling for id=$id at $scheduled');
      } catch (exactError) {
        log('NotificationService.scheduleReminder: ⚠️ Exact scheduling failed: $exactError');
        await _plugin.zonedSchedule(
          id,
          (rem.title.isNotEmpty ) ? rem.title : 'Reminder',
          (rem.description.isNotEmpty ) ? rem.description : null,
          scheduled,
          _platformDetails(),
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          // uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          payload: jsonEncode({'id': rem.id}),
        );
        log('NotificationService.scheduleReminder: ✅ SUCCESS - Inexact scheduling for id=$id');
      }

      final pending = await _plugin.pendingNotificationRequests();
      final scheduledIds = pending.map((p) => p.id).toList();
      log('NotificationService.scheduleReminder: Total pending notifications: ${pending.length}');
      log('NotificationService.scheduleReminder: Pending IDs: $scheduledIds');

      if (!scheduledIds.contains(id)) {
        log('NotificationService.scheduleReminder: ❌ WARNING - Notification ID $id NOT found in pending list!');
      }
    } catch (e, stack) {
      log('NotificationService.scheduleReminder: ❌ CRITICAL ERROR - $e');
      log('NotificationService.scheduleReminder: Stack trace - $stack');
    }
  }

  Future<void> cancelReminder(String reminderId) async {
    log('NotificationService.cancelReminder: canceling reminderId=$reminderId');
    await init();
    await _plugin.cancel(_stableId(reminderId));
    log('NotificationService.cancelReminder: canceled');
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
      log('NotificationService.cancelAll: ⚠️ WARNING - ${remaining.length} notifications still pending');
    }
  }

  Future<List<int>?> pendingNotificationIds() async {
    log('NotificationService.pendingNotificationIds: fetching pending ids');
    final pending = await _plugin.pendingNotificationRequests();
    final ids = pending.map((r) => r.id).toSet().toList()..sort();
    log('NotificationService.pendingNotificationIds: pending ids=$ids');
    return ids;
  }

  Future<void> testScheduledNotification() async {
    log('[TEST] Scheduling test notification for 30 seconds from now');
    final testTime = DateTime.now().add(const Duration(seconds: 30));
    final testReminder = ReminderModel(
      id: 'test_scheduled_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Test Scheduled Notification',
      description: 'If you see this, scheduled notifications are working!',
      dateTime: testTime,
    );
    await scheduleReminder(testReminder);
    log('[TEST] Scheduled test notification for $testTime');
  }

  Future<void> debugTestNotificationAtTime() async {
    log('[DEBUG] Testing notification scheduling');
    final testTime = DateTime.now().add(const Duration(minutes: 2));
    final testReminder = ReminderModel(
      id: 'debug_test_${DateTime.now().millisecondsSinceEpoch}',
      title: 'DEBUG: 2-Minute Test',
      description: 'This notification should appear at ${DateFormat('HH:mm:ss').format(testTime)}',
      dateTime: testTime,
    );
    await scheduleReminder(testReminder);

    final testTime2 = DateTime.now().add(const Duration(minutes: 5));
    final testReminder2 = ReminderModel(
      id: 'debug_test_2_${DateTime.now().millisecondsSinceEpoch}',
      title: 'DEBUG: 5-Minute Test',
      description: 'This notification should appear at ${DateFormat('HH:mm:ss').format(testTime2)}',
      dateTime: testTime2,
    );
    await scheduleReminder(testReminder2);
  }

  Future<void> testImmediateShow() async {
    log('[Test] Showing notification after 10 second delay');
    await Future.delayed(const Duration(seconds: 10));
    await _plugin.show(
      _stableId('test_show'),
      'Immediate Test',
      'This is an immediate notification',
      _platformDetails(),
      payload: 'test_show',
    );
    log('[Test] Immediate notification shown');
  }

  Future<void> welcomeImmediateShow() async {
    log('[Test] Showing immediate welcome notification');
    await _plugin.show(
      _stableId('welcome_show'),
      'Welcome!',
      'Welcome to the app',
      _platformDetails(),
      payload: 'welcome_show',
    );
  }

  Future<void> debugNotificationStatus() async {
    log('========== NOTIFICATION STATUS DEBUG ==========');
    await init();

    if (Platform.isAndroid) {
      final androidPlugin = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

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
    _ensureTimeZoneInitialized();
    log('TZ time: ${tz.TZDateTime.now(tz.local)}');
    log('Timezone: ${tz.local}');
    log('========== DEBUG COMPLETE ==========');
  }

  Future<void> testChannelWorking() async {
    log('[CHANNEL TEST] Testing if notification channel works...');
    await init();
    await _plugin.show(
      999999,
      '🔔 Channel Test',
      'If you see this, the channel is working!',
      _platformDetails(),
    );
    log('[CHANNEL TEST] Test notification sent');
  }
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {
  log('🔔 Background notification tapped. payload=${response.payload}');
}