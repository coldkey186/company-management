// lib/domain/entities/task_entity.dart
class TaskEntity {
  final String id;
  final String description;
  final String status;
  final String assignedTo;
  final DateTime dueDate;

  TaskEntity({
    required this.id,
    required this.description,
    required this.status,
    required this.assignedTo,
    required this.dueDate,
  });
}
