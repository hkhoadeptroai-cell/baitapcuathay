import 'package:flutter/foundation.dart';

import '../core/utils.dart';
import '../models/task.dart';

class TaskRepository extends ChangeNotifier {
  TaskRepository._();
  static final instance = TaskRepository._();

  final List<Task> _tasks = _seed();

  List<Task> get all => List.unmodifiable(_tasks);

  List<Task> get today =>
      _tasks.where((t) => isSameDay(t.due, DateTime.now())).toList()
        ..sort((a, b) => a.due.compareTo(b.due));

  Task? byId(String id) {
    for (final t in _tasks) {
      if (t.id == id) return t;
    }
    return null;
  }

  int pendingOf(TaskGroup g) =>
      _tasks.where((t) => t.group == g && !t.done).length;

  void save(Task t) {
    final i = _tasks.indexWhere((e) => e.id == t.id);
    if (i < 0) {
      _tasks.insert(0, t);
    } else {
      _tasks[i] = t;
    }
    notifyListeners();
  }

  void remove(String id) {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void toggle(Task t) {
    t.done = !t.done;
    notifyListeners();
  }

  void toggleSub(SubTask s) {
    s.done = !s.done;
    notifyListeners();
  }

  void addSub(Task t, String title) {
    t.subTasks.add(SubTask(title));
    notifyListeners();
  }

  void removeSub(Task t, SubTask s) {
    t.subTasks.remove(s);
    notifyListeners();
  }

  static List<Task> _seed() {
    final n = DateTime.now();
    DateTime at(int h, int m, [int addDays = 0]) =>
        DateTime(n.year, n.month, n.day + addDays, h, m);
    return [
      Task(
        title: 'Nộp bài tập Lập trình di động',
        group: TaskGroup.study,
        due: at(9, 0),
        priority: Priority.high,
        note: 'Nộp file .zip lên hệ thống của trường.',
        subTasks: [
          SubTask('Hoàn thiện màn hình đăng nhập', done: true),
          SubTask('Chụp ảnh màn hình app', done: true),
          SubTask('Nén file và nộp bài'),
        ],
      ),
      Task(
        title: 'Ôn chương 3 – Cấu trúc dữ liệu',
        group: TaskGroup.study,
        due: at(14, 0),
      ),
      Task(
        title: 'Đi chợ mua đồ cho tuần',
        group: TaskGroup.life,
        due: at(17, 30),
      ),
      Task(
        title: 'Tập thể dục 30 phút',
        group: TaskGroup.life,
        due: at(6, 30),
        done: true,
      ),
      Task(title: 'Họp nhóm đồ án', group: TaskGroup.study, due: at(20, 0, 1)),
    ];
  }
}
