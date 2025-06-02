// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:eslam_s_application/presentation/reminder/model/reminder_model.dart';

enum ReminderStateStatus {initial,loaded}
 @immutable
class ReminderState {
  final ReminderStateStatus status;
  final List<ReminderModel> reminder;

  ReminderState({
    this.status = ReminderStateStatus.initial,
   reminder
  }) : reminder = reminder ?? const [];


  ReminderState copyWith({
    ReminderStateStatus? status,
    List<ReminderModel>? reminder,
  }) {
    return ReminderState(
      status: status ?? this.status,
      reminder: reminder ?? this.reminder,
    );
  }

  @override
  bool operator ==(covariant ReminderState other) {
    if (identical(this, other)) return true;
  
    return 
      other.status == status &&
      listEquals(other.reminder, reminder);
  }

  @override
  int get hashCode => status.hashCode ^ reminder.hashCode;
}

