// lib/core/notifications/boot_channel.dart
import 'package:flutter/services.dart';

typedef BootHandler = Future<void> Function();

class BootChannel {
  static const MethodChannel _channel = MethodChannel('reminder_boot');

  /// Set a handler that will be invoked when native side calls "rescheduleReminders".
  /// Call this early in main(), after you initialize hive/timezone/notifications.
  static void setBootHandler(BootHandler handler) {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'rescheduleReminders') {
        await handler();
      }
      return null;
    });
  }

  /// Optional: invoke from Dart to native (not needed normally).
  static Future<dynamic> invoke(String method, [dynamic args]) {
    return _channel.invokeMethod(method, args);
  }
}
