import 'package:bloc/bloc.dart';
import 'package:eslam_s_application/features/reminder/enum/filter_type.dart';
import 'package:eslam_s_application/features/reminder/model/reminder_model.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'reminder_state.dart';

class ReminderCubit extends Cubit<ReminderState> {
  final Box<ReminderModel> _box;

  ReminderCubit(this._box) : super(const ReminderState()) {
    _loadReminders();
  }

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

  /// ===== Load All Reminders from Hive =====
  void _loadReminders() {
    final reminders = _box.values.toList();
    emit(state.copyWith(reminder: reminders, status: ReminderStateStatus.loaded));
  }

  /// ===== Add New Reminder =====
  void addReminder({
    required String title,
    String? description,
    String? location,
    String? priority,
    DateTime? dateTime,
    String? id,
  }) {
    if (title.trim().isEmpty) return;

    final reminder = ReminderModel(
      id: id ?? const Uuid().v1(),
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

// void updateReminder({
//   required String id,
//   required String title,
//   required String description,
//   required String priority,
//   DateTime? dateTime,
// }) {
//   final updatedList = state.reminder.map((r) {
//     if (r.id == id) {
//       return r.copyWith(
//         title: title,
//         description: description,
//         priority: priority,
//         dateTime: dateTime,
//         time: dateTime != null
//             ? TimeOfDay.fromDateTime(dateTime)
//             : r.time,
//       );
//     }
//     return r;
//   }).toList();

//   emit(state.copyWith(reminders: updatedList));
//   saveToHive(updatedList);
// }

  void removeReminder(String id) {
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
      _loadReminders();
    }
  }

  void clearAll() {
    _box.clear();
    _loadReminders();
  }

  void setFilter(FilterType f) {
    if (state.filter == f) return;
    emit(state.copyWith(filter: f));
  }

  void setSearch(String q) {
    if (state.search == q) return;
    emit(state.copyWith(search: q));
  }
}
