// lib/core/notifications/timezone_util.dart
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:flutter/services.dart';
import 'dart:developer';

class TimezoneUtil {
  static const MethodChannel _channel = MethodChannel('com.reminder/timezone');

  static Future<void> configureLocalTimeZone() async {
    try {
      tz_data.initializeTimeZones();

      // 1) Get timezone name (IANA preferred) from platform or fallback
      final String timeZoneName = await _getLocalTimeZoneName();

      try {
        tz.setLocalLocation(tz.getLocation(timeZoneName));
      } catch (e) {
        log('TimezoneUtil: tzdb does not recognize "$timeZoneName": $e');
        final mapped = _mapCommonShortNameToIana(timeZoneName);
        if (mapped != null) {
          try {
            tz.setLocalLocation(tz.getLocation(mapped));
            return;
          } catch (e2) {
            log('TimezoneUtil: Mapping "$mapped" failed: $e2');
          }
        }
        tz.setLocalLocation(tz.getLocation('UTC'));
      }
      final nowLocal = tz.TZDateTime.now(tz.local);
      log('TimezoneUtil: Verified - TZ local: ${tz.local.name}');
      log('TimezoneUtil: Verified - Current TZ time: $nowLocal');
      log('TimezoneUtil: Verified - System time: ${DateTime.now()}');
    } catch (e, stack) {
      log('TimezoneUtil: Error configuring timezone: $e');
      log('TimezoneUtil: Stack trace: $stack');
      try {
        tz_data.initializeTimeZones();
        tz.setLocalLocation(tz.getLocation('UTC'));
      } catch (_) {}
    }
  }

  /// Returns a best-effort IANA timezone name string (never null).
  static Future<String> _getLocalTimeZoneName() async {
    try {
      final String? platformTz = await _channel.invokeMethod<String>('getTimeZone');
      if (platformTz != null && platformTz.trim().isNotEmpty) {
        return platformTz.trim();
      }
    } catch (e) {
      log('TimezoneUtil: Error getting timezone from platform: $e');
    }

    // Fallback 1: use DateTime.timeZoneName and try map common abbreviations
    final String dtName = DateTime.now().timeZoneName;
    log('TimezoneUtil: DateTime.timeZoneName = $dtName');

    if (dtName.contains('/')) {
      return dtName;
    }
    // Try map
    final mapped = _mapCommonShortNameToIana(dtName);
    if (mapped != null) {
      return mapped;
    }
    return 'UTC';
  }

  static String? _mapCommonShortNameToIana(String shortName) {
    final key = shortName.trim().toUpperCase();
    const Map<String, String> map = {
      'EET': 'Africa/Cairo',
      'EEST': 'Europe/Athens',
      'CET': 'Europe/Paris',
      'BST': 'Europe/London',
      'GMT': 'Etc/GMT',
      'UTC': 'UTC',
      'MSK': 'Europe/Moscow',
      'IST': 'Asia/Kolkata',
    };

    return map[key];
  }
}
