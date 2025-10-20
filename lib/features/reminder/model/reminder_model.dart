import 'package:equatable/equatable.dart';
import 'package:eslam_s_application/features/reminder/enum/reminder_priority.dart';
import 'package:hive/hive.dart';

/// ==========
/// MODEL
/// ==========
@HiveType(typeId: 0)
class ReminderModel extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String? location;

  @HiveField(4)
  final String priority;

  @HiveField(5)
  final DateTime? dateTime;

  @HiveField(6)
  final bool isCompleted;

  @HiveField(7)
  final bool notificationsEnabled;

  const ReminderModel({
    required this.id,
    required this.title,
    this.description = '',
    this.location,
    this.priority = "Medium",
    this.dateTime,
    this.isCompleted = false,
    this.notificationsEnabled = true,
  });

  ReminderPriority get priorityEnum => ReminderPriorityText.fromText(priority);

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        location,
        priority,
        dateTime,
        isCompleted,
        notificationsEnabled,
      ];

  ReminderModel copyWith({
    String? id,
    String? title,
    String? description,
    String? location,
    String? priority,
    DateTime? dateTime,
    bool? isCompleted,
    bool? notificationsEnabled,
  }) {
    return ReminderModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      priority: priority ?? this.priority,
      dateTime: dateTime ?? this.dateTime,
      isCompleted: isCompleted ?? this.isCompleted,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}

/// ============
class ReminderModelAdapter extends TypeAdapter<ReminderModel> {
  @override
  final int typeId = 0;

  @override
  ReminderModel read(BinaryReader reader) {
    final id = reader.readString();
    final title = reader.readString();
    final description = reader.readString();
    final location = reader.read() as String?;
    final priority = reader.readString();
    final dateTime = reader.read() as DateTime?;
    final isCompleted = reader.readBool();
    final notificationsEnabled = reader.readBool();

    return ReminderModel(
      id: id,
      title: title,
      description: description,
      location: location,
      priority: priority,
      dateTime: dateTime,
      isCompleted: isCompleted,
      notificationsEnabled: notificationsEnabled,
    );
  }

  @override
  void write(BinaryWriter writer, ReminderModel obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.title);
    writer.writeString(obj.description);
    writer.write(obj.location);
    writer.writeString(obj.priority);
    writer.write(obj.dateTime);
    writer.writeBool(obj.isCompleted);
    writer.writeBool(obj.notificationsEnabled);
  }
}
