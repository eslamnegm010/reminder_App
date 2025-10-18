import 'package:bloc/bloc.dart';
import 'package:eslam_s_application/features/reminder/model/reminder_model.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'reminder_state.dart';

class ReminderCubit extends Cubit<ReminderState> {
  final Box<ReminderModel> _box;

  ReminderCubit(this._box) : super(ReminderState()) {
    _loadReminders();
  }

  /// ===== Load All Reminders from Hive =====
  void _loadReminders() {
    final reminders = _box.values.toList();
    emit(state.copyWith(reminder: reminders));
  }

  /// ===== Add New Reminder =====
  void addReminder({
    required String title,
    String? description,
    String? location,
    String? priority,
    DateTime? dateTime,
  }) {
    if (title.trim().isEmpty) return;

    final reminder = ReminderModel(
      id: const Uuid().v1(),
      title: title.trim(),
      description: description?.trim() ?? '',
      location: location?.trim(),
      priority: priority ?? "Medium",
      dateTime: dateTime,
      isCompleted: false,
    );

    _box.put(reminder.id, reminder);
    _loadReminders();
  }

  /// ===== Remove Reminder by ID =====
  void removeReminder(String id) {
    _box.delete(id);
    _loadReminders();
  }

  /// ===== Toggle Completion =====
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
      _loadReminders();
    }
  }

  /// ===== Clear All Reminders =====
  void clearAll() {
    _box.clear();
    _loadReminders();
  }
}
