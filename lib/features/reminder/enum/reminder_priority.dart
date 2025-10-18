enum ReminderPriority { low, medium, high }

extension ReminderPriorityText on ReminderPriority {
  String get toText {
    switch (this) {
      case ReminderPriority.low:
        return "Low";
      case ReminderPriority.medium:
        return "Medium";
      case ReminderPriority.high:
        return "High";
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
