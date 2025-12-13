import 'package:equatable/equatable.dart';
import 'package:reminder_app/features/reminder/enum/reminder_priority.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'reminder_model.g.dart';

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

  @HiveField(8)
  final double? latitude;

  @HiveField(9)
  final double? longitude;

  const ReminderModel({
    required this.id,
    required this.title,
    this.description = '',
    this.location,
    this.priority = "Medium",
    this.dateTime,
    this.isCompleted = false,
    this.notificationsEnabled = true,
    this.latitude,
    this.longitude,
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
    latitude,
    longitude,
  ];

  ReminderModel copyWith({
    String? id,
    String? title,
    String? description,
    ValueGetter<String?>? location,
    String? priority,
    DateTime? dateTime,
    bool? isCompleted,
    bool? notificationsEnabled,
    double? latitude,
    double? longitude,
  }) {
    return ReminderModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location != null ? location() : this.location,
      priority: priority ?? this.priority,
      dateTime: dateTime ?? this.dateTime,
      isCompleted: isCompleted ?? this.isCompleted,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}

/// ============
