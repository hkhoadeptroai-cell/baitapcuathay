import 'package:flutter/material.dart';

enum TaskGroup {
  study('Học tập', Color(0xFF2F5BEA), Color(0xFFE3EAFF), Icons.school_outlined),
  life('Cuộc sống', Color(0xFFE8731A), Color(0xFFFFEBD9), Icons.home_outlined);

  const TaskGroup(this.label, this.color, this.bg, this.icon);
  final String label;
  final Color color, bg;
  final IconData icon;
}

enum Priority {
  low('Thấp'),
  medium('Vừa'),
  high('Cao');

  const Priority(this.label);
  final String label;
}

abstract class Entity {
  Entity({String? id})
    : id = id ?? DateTime.now().microsecondsSinceEpoch.toString();
  final String id;
}

class SubTask extends Entity {
  SubTask(this.title, {this.done = false, super.id});
  final String title;
  bool done;
}

class Task extends Entity {
  Task({
    super.id,
    required this.title,
    required this.group,
    required this.due,
    this.note = '',
    this.priority = Priority.medium,
    this.remind = true,
    this.done = false,
    List<SubTask>? subTasks,
  }) : subTasks = subTasks ?? [];

  final String title, note;
  final TaskGroup group;
  final Priority priority;
  final DateTime due;
  final bool remind;
  final List<SubTask> subTasks;
  bool done;

  int get subDone => subTasks.where((s) => s.done).length;
  double get progress => subTasks.isEmpty ? 0 : subDone / subTasks.length;
}
