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

  Map<String, dynamic> toMap() => {'id': id, 'title': title, 'done': done};

  factory SubTask.fromMap(Map<String, dynamic> m) => SubTask(
    m['title'] as String? ?? '',
    done: m['done'] as bool? ?? false,
    id: m['id'] as String?,
  );
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

  Map<String, dynamic> toMap() => {
    'title': title,
    'note': note,
    'group': group.name,
    'priority': priority.name,
    'due': due.millisecondsSinceEpoch,
    'remind': remind,
    'done': done,
    'subTasks': subTasks.map((s) => s.toMap()).toList(),
  };

  factory Task.fromMap(String id, Map<String, dynamic> m) => Task(
    id: id,
    title: m['title'] as String? ?? '',
    note: m['note'] as String? ?? '',
    group: TaskGroup.values.byName(m['group'] as String? ?? 'study'),
    priority: Priority.values.byName(m['priority'] as String? ?? 'medium'),
    due: DateTime.fromMillisecondsSinceEpoch(m['due'] as int),
    remind: m['remind'] as bool? ?? true,
    done: m['done'] as bool? ?? false,
    subTasks: [
      for (final s in (m['subTasks'] as List? ?? []))
        SubTask.fromMap(Map<String, dynamic>.from(s as Map)),
    ],
  );
}
