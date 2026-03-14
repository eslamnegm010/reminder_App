import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:reminder_app/core/local_storage/hive.dart';
import 'package:reminder_app/core/notifications/notification_service.dart';
import 'package:reminder_app/features/reminder/enum/filter_type.dart';
import 'package:reminder_app/features/reminder/model/reminder_model.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'reminder_state.dart';

class ReminderCubit extends Cubit<ReminderState> {
  final Box<ReminderModel> _box;


  ReminderCubit(this._box) : super(const ReminderState()) {
    _loadReminders();
    _loadSettings();
  }


  final notificationService = NotificationService.instance;

  FilterType get filter => state.filter;
  String get search => state.search;

  List<ReminderModel> visibleReminders() {
    final reminders = state.reminder;
    final currentFilter = state.filter;
    final q = state.search.trim().toLowerCase();

    return reminders.where((r) {
      if (currentFilter == FilterType.active && r.isCompleted) return false;
      if (currentFilter == FilterType.completed && !r.isCompleted) return false;
      if (q.isNotEmpty) {
        final title = r.title.toLowerCase();
        final desc = r.description.toLowerCase();
        return title.contains(q) || desc.contains(q);
      }
      return true;
    }).toList();
  }

  void _loadReminders() {
    final reminders = _box.values.toList();
    emit(state.copyWith(reminder: reminders, status: ReminderStateStatus.loaded));
  }

  Future<void> addReminder({
    required String title,
    String? description,
    String? location,
    String? priority,
    DateTime? dateTime,
    String? id,
    bool? notificationsEnabled,
    double? latitude,
    double? longitude,
  }) async {
    if (title.trim().isEmpty) return;

    final reminder = ReminderModel(
      id: id ?? const Uuid().v1(),
      title: title.trim(),
      description: description?.trim() ?? '',
      location: location?.trim(),
      priority: priority ?? "Medium",
      dateTime: dateTime,
      notificationsEnabled: notificationsEnabled ?? true,
      isCompleted: false,
      latitude: latitude,
      longitude: longitude,
    );
    log(
      ' added reminder id=${reminder.id} title=${reminder.title} description=${reminder.description}  dateTime=${reminder.dateTime}',
    );

    _box.put(reminder.id, reminder);
    if (reminder.dateTime != null &&
        state.notificationsEnabled &&
        reminder.notificationsEnabled) {
      await notificationService.scheduleReminder(reminder);
    }
    _loadReminders();
  }

  void removeReminder(String id) async {
    final reminder = _box.get(id);
    if (reminder != null && reminder.dateTime != null) {
      await notificationService.cancelReminder(id);
    }
    _box.delete(id);

    _loadReminders();
  }

  void toggleReminder(String id) {
    final reminder = _box.get(id);
    if (reminder != null) {
      final updated = reminder.copyWith(isCompleted: !reminder.isCompleted);
      _box.put(id, updated);
      _loadReminders();
    }
  }

  /// ===== Edit Reminder =====
  void editReminder(ReminderModel updated) {
    if (_box.containsKey(updated.id)) {
      _box.put(updated.id, updated);

      NotificationService.instance.cancelReminder(updated.id);
      if (updated.dateTime != null) {
        NotificationService.instance.scheduleReminder(updated);
      }

      _loadReminders();
    }
  }

  Future<void> clearAll() async {
    await _box.clear();
    _loadReminders();
  }

  void setFilter(FilterType f) {
    if (state.filter == f) return;
    emit(state.copyWith(filter: f));
  }

  // reminder_cubit.dart

  void toggleNotifications(bool value) async {
    final settings = HiveService.settingsBox;

    try {
      await settings.put('notificationsEnabled', value);

      if (!value) {
        await notificationService.cancelAll();
      } else {
        log(' Notifications re-enabled');
      }
      emit(state.copyWith(notificationsEnabled: value));
    } catch (e, s) {
      log(' Error toggling notifications: $e', stackTrace: s);
    }
  }

  void NotificationsEnabledForReminder(bool value) async {
    emit(state.copyWith(notificationsEnabled: value));
  }

  void _loadSettings() {
    final settings = HiveService.settingsBox;
    final enabled = settings.get('notificationsEnabled', defaultValue: true);
    emit(state.copyWith(notificationsEnabled: enabled));
  }


}
