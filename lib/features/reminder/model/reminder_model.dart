// ignore_for_file: public_member_api_docs, sort_constructors_first
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

  const ReminderModel({
    required this.id,
    required this.title,
    this.description = '',
    this.location,
    this.priority = "Medium",
    this.dateTime,
    this.isCompleted = false,
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
      ];

  ReminderModel copyWith({
    String? id,
    String? title,
    String? description,
    String? location,
    String? priority,
    DateTime? dateTime,
    bool? isCompleted,
  }) {
    return ReminderModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      priority: priority ?? this.priority,
      dateTime: dateTime ?? this.dateTime,
      isCompleted: isCompleted ?? this.isCompleted,
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

    return ReminderModel(
      id: id,
      title: title,
      description: description,
      location: location,
      priority: priority,
      dateTime: dateTime,
      isCompleted: isCompleted,
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
  }
}
