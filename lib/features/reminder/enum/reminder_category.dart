import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

enum ReminderCategory { work, personal, health, shopping, travel, others }

extension ReminderCategoryExtension on ReminderCategory {
  String get label {
    switch (this) {
      case ReminderCategory.work:
        return "work".tr();
      case ReminderCategory.personal:
        return "personal".tr();
      case ReminderCategory.health:
        return "health".tr();
      case ReminderCategory.shopping:
        return "shopping".tr();
      case ReminderCategory.travel:
        return "travel".tr();
      case ReminderCategory.others:
        return "others".tr();
    }
  }

  IconData get icon {
    switch (this) {
      case ReminderCategory.work:
        return Icons.work_outline_rounded;
      case ReminderCategory.personal:
        return Icons.person_outline_rounded;
      case ReminderCategory.health:
        return Icons.favorite_border_rounded;
      case ReminderCategory.shopping:
        return Icons.shopping_cart_outlined;
      case ReminderCategory.travel:
        return Icons.flight_takeoff_rounded;
      case ReminderCategory.others:
        return Icons.category_outlined;
    }
  }

  Color get color {
    switch (this) {
      case ReminderCategory.work:
        return Colors.blue;
      case ReminderCategory.personal:
        return Colors.purple;
      case ReminderCategory.health:
        return Colors.red;
      case ReminderCategory.shopping:
        return Colors.orange;
      case ReminderCategory.travel:
        return Colors.teal;
      case ReminderCategory.others:
        return Colors.blueGrey;
    }
  }

  static ReminderCategory fromText(String value) {
    switch (value.toLowerCase()) {
      case "work":
        return ReminderCategory.work;
      case "personal":
        return ReminderCategory.personal;
      case "health":
        return ReminderCategory.health;
      case "shopping":
        return ReminderCategory.shopping;
      case "travel":
        return ReminderCategory.travel;
      default:
        return ReminderCategory.others;
    }
  }

  String get toText => name;
}
