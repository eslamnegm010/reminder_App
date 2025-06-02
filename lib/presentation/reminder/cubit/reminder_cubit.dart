
// import 'package:bloc/bloc.dart';
// import 'package:eslam_s_application/presentation/reminder/cubit/reminder_state.dart';
// import 'package:eslam_s_application/presentation/reminder/model/reminder_model.dart';
// import 'package:uuid/uuid.dart';

// class ReminderCubit extends Cubit<ReminderState> {
//   ReminderCubit() : super(ReminderState());

//   void addReminder({required String text}) {
//      if (text.isNotEmpty){
//       final model =
//         ReminderModel(id: Uuid().v1(), title: text, isCompleted: false);
   
//       emit(state.copyWith(
//           status: ReminderStateStatus.loaded,
//           reminder: [model, ...state.reminder]));
//      }
    
//   }

//   void removeReminder(String id) {
//     final List<ReminderModel> reminder =
//         state.reminder.where((item) => item.id != id).toList();
//     emit(state.copyWith(reminder: reminder));
//   }

//   void toggleReminder(String id) {
//     final List<ReminderModel> reminder = state.reminder.map((item) {
//       return item.id == id
//           ? item.copyWith(isCompleted: !item.isCompleted)
//           : item;
//     }).toList();
//     emit(state.copyWith(reminder: reminder));
//   }
// }
import 'package:bloc/bloc.dart';
import 'package:eslam_s_application/presentation/reminder/model/reminder_model.dart';
import 'package:hive/hive.dart';
import 'reminder_state.dart';
import 'package:uuid/uuid.dart';

class ReminderCubit extends Cubit<ReminderState> {
  final Box<ReminderModel> _box;

  ReminderCubit(this._box) : super(ReminderState()) {
    _loadReminders();
  }

  void _loadReminders() {
    final reminders = _box.values.toList();
    emit(state.copyWith(reminder: reminders));
  }

  void addReminder({required String text}) {
    if (text.isNotEmpty) {
      final model = ReminderModel(id: Uuid().v1(), title: text, isCompleted: false);
      _box.put(model.id, model);
      _loadReminders();
    }
  }

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
}
