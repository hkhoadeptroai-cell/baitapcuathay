import 'package:flutter/material.dart';

import '../core/utils.dart';

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

  /// Chuyển JSON của API thành Task. [shiftDays] dùng để dời ngày mẫu về hôm nay.
  factory Task.fromApi(Map<String, dynamic> m, {int shiftDays = 0}) {
    final d = DateTime.tryParse('${m['date']}') ?? DateTime.now();
    final p = '${m['time'] ?? '00:00'}'.split(':');
    final h = int.tryParse(p.first) ?? 0;
    final mi = p.length > 1 ? (int.tryParse(p[1]) ?? 0) : 0;
    return Task(
      id: '${m['id']}',
      title: m['title'] as String? ?? '',
      note: m['note'] as String? ?? '',
      group: m['category'] == 'life' ? TaskGroup.life : TaskGroup.study,
      priority: Priority.values.firstWhere(
        (p) => p.name == m['priority'],
        orElse: () => Priority.medium,
      ),
      due: DateTime(d.year, d.month, d.day + shiftDays, h, mi),
      remind: m['remind'] as bool? ?? true,
      done: m['done'] as bool? ?? false,
      subTasks: [
        for (final s in (m['subtasks'] as List? ?? []))
          SubTask(
            (s as Map)['title'] as String? ?? '',
            done: s['done'] as bool? ?? false,
          ),
      ],
    );
  }

  /// Chuyển Task thành JSON để gửi lên API.
  Map<String, dynamic> toApi() => {
    'title': title,
    'note': note,
    'category': group == TaskGroup.life ? 'life' : 'study',
    'date': '${due.year}-${two(due.month)}-${two(due.day)}',
    'time': '${two(due.hour)}:${two(due.minute)}',
    'priority': priority.name,
    'remind': remind,
    'done': done,
    'subtasks': [
      for (final s in subTasks) {'title': s.title, 'done': s.done},
    ],
  };
}
