// lib/core/notifications/timezone_util.dart
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:flutter/services.dart';
import 'dart:developer';

class TimezoneUtil {
  static Future<void> configureLocalTimeZone() async {
    try {
      // Initialize timezone database
      tz_data.initializeTimeZones();
      
      // Get the local timezone
      final String timeZoneName = await _getLocalTimeZoneName();
      log('TimezoneUtil: Device timezone: $timeZoneName');
      
      // Set local location
      try {
        tz.setLocalLocation(tz.getLocation(timeZoneName));
        log('TimezoneUtil: Successfully set local location to: $timeZoneName');
      } catch (e) {
        log('TimezoneUtil: Failed to set location $timeZoneName, falling back to local: $e');
        // Fallback - use the local timezone as detected by DateTime
        final local = tz.getLocation('UTC'); // Start with UTC
        tz.setLocalLocation(local);
      }
      
      // Verify
      final nowLocal = tz.TZDateTime.now(tz.local);
      log('TimezoneUtil: Verified - TZ local: ${tz.local.name}');
      log('TimezoneUtil: Verified - Current TZ time: $nowLocal');
      log('TimezoneUtil: Verified - System time: ${DateTime.now()}');
      
    } catch (e, stack) {
      log('TimezoneUtil: Error configuring timezone: $e');
      log('TimezoneUtil: Stack trace: $stack');
    }
  }

  static Future<String> _getLocalTimeZoneName() async {
    try {
      // Platform channel to get exact timezone from Android
      const platform = MethodChannel('com.reminder/timezone');
      final String timeZoneName = await platform.invokeMethod('getTimeZone');
      return timeZoneName;
    } catch (e) {
      log('TimezoneUtil: Failed to get timezone from platform, using fallback: $e');
      // Fallback: use DateTime to get timezone name
      return DateTime.now().timeZoneName;
    }
  }
}