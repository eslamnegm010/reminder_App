import 'package:easy_localization/easy_localization.dart';

enum ReminderPriority { low, medium, high }

extension ReminderPriorityText on ReminderPriority {
  String get toText {
    switch (this) {
      case ReminderPriority.low:
        return "low".tr();
      case ReminderPriority.medium:
        return "medium".tr();
      case ReminderPriority.high:
        return "high".tr();
    }
  }

  static ReminderPriority fromText(String value) {
    switch (value.toLowerCase()) {
      case "low":
        return ReminderPriority.low;
      case "high":
        return ReminderPriority.high;
      default:
        return ReminderPriority.medium;
    }
  }
}
