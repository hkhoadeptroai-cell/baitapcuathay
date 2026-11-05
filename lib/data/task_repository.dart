import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'analytics_service.dart';
import '../core/utils.dart';
import '../models/task.dart';

class TaskRepository extends ChangeNotifier {
  TaskRepository._();
  static final instance = TaskRepository._();

  List<Task> _tasks = [];
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _sub;
  CollectionReference<Map<String, dynamic>>? _col;

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

  /// Gọi sau khi đăng nhập: lắng nghe việc của user hiện tại trên Firestore.
  void start() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    _sub?.cancel();
    _col = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tasks');
    var first = true;
    _sub = _col!.snapshots().listen((snap) {
      if (first && snap.docs.isEmpty && !snap.metadata.isFromCache) {
        _seed();
      }
      first = false;
      _tasks = snap.docs.map((d) => Task.fromMap(d.id, d.data())).toList();
      notifyListeners();
    }, onError: (e) => debugPrint('Firestore lỗi: $e'));
  }

  /// Gọi khi đăng xuất.
  void stop() {
    _sub?.cancel();
    _sub = null;
    _col = null;
    _tasks = [];
    notifyListeners();
  }

  void _write(Task t) => _col?.doc(t.id).set(t.toMap());

  void save(Task t) {
    final i = _tasks.indexWhere((e) => e.id == t.id);
    if (i < 0) {
      _tasks.insert(0, t);
      Analytics.addTask(t.group.name);
    } else {
      _tasks[i] = t;
    }
    _write(t);
    notifyListeners();
  }

  void remove(String id) {
    _tasks.removeWhere((t) => t.id == id);
    _col?.doc(id).delete();
    notifyListeners();
  }

  void toggle(Task t) {
    t.done = !t.done;
    if (t.done) Analytics.completeTask();
    _write(t);
    notifyListeners();
  }

  void toggleSub(SubTask s) {
    s.done = !s.done;
    for (final t in _tasks) {
      if (t.subTasks.contains(s)) _write(t);
    }
    notifyListeners();
  }

  void addSub(Task t, String title) {
    t.subTasks.add(SubTask(title));
    _write(t);
    notifyListeners();
  }

  void removeSub(Task t, SubTask s) {
    t.subTasks.remove(s);
    _write(t);
    notifyListeners();
  }

  /// Tạo vài việc mẫu cho tài khoản mới (chỉ chạy khi chưa có việc nào).
  void _seed() {
    final n = DateTime.now();
    DateTime at(int h, int m, [int d = 0]) =>
        DateTime(n.year, n.month, n.day + d, h, m);
    final list = [
      Task(
        id: 'seed1',
        title: 'Nộp bài tập Lập trình di động',
        group: TaskGroup.study,
        due: at(9, 0),
        priority: Priority.high,
        note: 'Nộp file .zip lên hệ thống của trường.',
        subTasks: [
          SubTask('Hoàn thiện màn hình đăng nhập', done: true, id: 'a1'),
          SubTask('Chụp ảnh màn hình app', done: true, id: 'a2'),
          SubTask('Nén file và nộp bài', id: 'a3'),
        ],
      ),
      Task(
        id: 'seed2',
        title: 'Ôn chương 3 – Cấu trúc dữ liệu',
        group: TaskGroup.study,
        due: at(14, 0),
      ),
      Task(
        id: 'seed3',
        title: 'Đi chợ mua đồ cho tuần',
        group: TaskGroup.life,
        due: at(17, 30),
      ),
      Task(
        id: 'seed4',
        title: 'Tập thể dục 30 phút',
        group: TaskGroup.life,
        due: at(6, 30),
        done: true,
      ),
      Task(
        id: 'seed5',
        title: 'Họp nhóm đồ án',
        group: TaskGroup.study,
        due: at(20, 0, 1),
      ),
    ];
    final batch = FirebaseFirestore.instance.batch();
    for (final t in list) {
      batch.set(_col!.doc(t.id), t.toMap());
    }
    batch.commit();
  }
}
