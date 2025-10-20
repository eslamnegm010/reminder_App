import 'package:eslam_s_application/features/reminder/enum/filter_type.dart';
import 'package:flutter/foundation.dart';
import 'package:eslam_s_application/features/reminder/model/reminder_model.dart';

enum ReminderStateStatus { initial, loading, loaded }

@immutable
class ReminderState {
  final ReminderStateStatus status;
  final List<ReminderModel> reminder;
  final FilterType filter;
  final String search;
  final bool notificationsEnabled;

  const ReminderState({
    this.status = ReminderStateStatus.initial,
    this.reminder = const [],
    this.filter = FilterType.all,
    this.search = '',
    this.notificationsEnabled = true,
  });

  ReminderState copyWith({
    ReminderStateStatus? status,
    List<ReminderModel>? reminder,
    FilterType? filter,
    String? search,
    bool? notificationsEnabled,
  }) {
    return ReminderState(
      status: status ?? this.status,
      reminder: reminder ?? this.reminder,
      filter: filter ?? this.filter,
      search: search ?? this.search,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }

  @override
  bool operator ==(covariant ReminderState other) {
    if (identical(this, other)) return true;
    return other.status == status &&
        listEquals(other.reminder, reminder) &&
        other.filter == filter &&
        other.notificationsEnabled == notificationsEnabled &&
        other.search == search;
  }

  @override
  int get hashCode =>
      status.hashCode ^ reminder.hashCode ^ filter.hashCode ^ notificationsEnabled.hashCode ^ search.hashCode;
}
