import 'package:flutter/foundation.dart';

import '../core/utils.dart';
import '../models/task.dart';
import 'analytics_service.dart';
import 'api_service.dart';

enum LoadState { idle, loading, ready, error }

class TaskRepository extends ChangeNotifier {
  TaskRepository._();
  static final instance = TaskRepository._();

  // Dữ liệu mẫu ghi ngày 20/10/2026 -> dời ngày sớm nhất thành hôm nay cho giống slide.
  static const _alignSampleToToday = true;

  final _api = ApiService.instance;
  final _dirty = <String>{}; // việc đã sửa trong máy (mock không lưu thật)
  List<Task> _tasks = [];
  int _shiftDays = 0;

  LoadState state = LoadState.idle;
  String? error;

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

  // ---------------- TẢI DỮ LIỆU ----------------
  void start() => Future.microtask(load);

  void stop() {
    _tasks = [];
    _dirty.clear();
    _shiftDays = 0;
    state = LoadState.idle;
    error = null;
    notifyListeners();
  }

  int _computeShift(List<dynamic> raw) {
    DateTime? min;
    for (final m in raw) {
      final d = DateTime.tryParse('${(m as Map)['date']}');
      if (d != null && (min == null || d.isBefore(min))) min = d;
    }
    if (min == null) return 0;
    final now = DateTime.now();
    return DateTime(
      now.year,
      now.month,
      now.day,
    ).difference(DateTime(min.year, min.month, min.day)).inDays;
  }

  /// GET /tasks (Trang chủ, Danh sách)
  Future<void> load() async {
    state = LoadState.loading;
    error = null;
    notifyListeners();
    try {
      final raw = await _api.getTasks();
      _shiftDays = _alignSampleToToday ? _computeShift(raw) : 0;
      _tasks = [
        for (final m in raw)
          Task.fromApi(
            Map<String, dynamic>.from(m as Map),
            shiftDays: _shiftDays,
          ),
      ];
      _dirty.clear();
      state = LoadState.ready;
    } on ApiException catch (e) {
      error = e.message;
      state = LoadState.error;
    } catch (_) {
      error = 'Dữ liệu trả về không đúng định dạng';
      state = LoadState.error;
    }
    notifyListeners();
  }

  /// GET /tasks/{id} (mở Chi tiết). Trả về null nếu thành công, ngược lại là thông báo lỗi.
  Future<String?> loadDetail(String id) async {
    try {
      final m = await _api.getTask(id);
      final t = Task.fromApi(
        Map<String, dynamic>.from(m as Map),
        shiftDays: _shiftDays,
      );
      // Mock trả cùng một mẫu cho mọi id và không lưu thay đổi -> chỉ nhận khi đúng id và chưa sửa.
      if (t.id == id && !_dirty.contains(id)) {
        final i = _tasks.indexWhere((e) => e.id == id);
        if (i >= 0) _tasks[i] = t;
      }
      notifyListeners();
      return null;
    } on ApiException catch (e) {
      return e.message;
    } catch (_) {
      return 'Dữ liệu trả về không đúng định dạng';
    }
  }

  // ---------------- SỬA / XÓA (PATCH, DELETE) ----------------
  Future<void> _patch(
    Task t,
    Map<String, dynamic> body,
    VoidCallback revert,
  ) async {
    try {
      await _api.patchTask(t.id, body);
      _dirty.add(t.id);
    } on ApiException catch (e) {
      revert();
      notifyListeners();
      toast('Cập nhật thất bại: ${e.message}', error: true);
    }
  }

  List<Map<String, dynamic>> _subs(Task t) => [
    for (final s in t.subTasks) {'title': s.title, 'done': s.done},
  ];

  void toggle(Task t) {
    final v = !t.done;
    t.done = v;
    if (v) Analytics.completeTask();
    notifyListeners();
    _patch(t, {'done': v}, () => t.done = !v);
  }

  void toggleSub(Task t, SubTask s) {
    s.done = !s.done;
    notifyListeners();
    _patch(t, {'subtasks': _subs(t)}, () => s.done = !s.done);
  }

  void addSub(Task t, String title) {
    final s = SubTask(title);
    t.subTasks.add(s);
    notifyListeners();
    _patch(t, {'subtasks': _subs(t)}, () => t.subTasks.remove(s));
  }

  void editSub(Task t, SubTask s, String title) {
    final i = t.subTasks.indexOf(s);
    if (i < 0) return;
    t.subTasks[i] = SubTask(title, done: s.done, id: s.id);
    notifyListeners();
    _patch(t, {'subtasks': _subs(t)}, () => t.subTasks[i] = s);
  }

  void removeSub(Task t, SubTask s) {
    final i = t.subTasks.indexOf(s);
    if (i < 0) return;
    t.subTasks.removeAt(i);
    notifyListeners();
    _patch(t, {'subtasks': _subs(t)}, () => t.subTasks.insert(i, s));
  }

  /// Thêm mới (POST) hoặc sửa (PATCH). Trả về null nếu thành công, ngược lại là thông báo lỗi.
  Future<String?> save(Task t) async {
    final i = _tasks.indexWhere((e) => e.id == t.id);
    try {
      if (i < 0) {
        await _api.createTask(t.toApi());
        _tasks.insert(
          0,
          t,
        ); // mock không lưu thật nên tự thêm vào danh sách trong máy
        Analytics.addTask(t.group.name);
      } else {
        final body = t.toApi();
        final d = DateTime(t.due.year, t.due.month, t.due.day - _shiftDays);
        body['date'] = '${d.year}-${two(d.month)}-${two(d.day)}'; // trả về ngày gốc của API
        await _api.patchTask(t.id, body);
        _tasks[i] = t;
        _dirty.add(t.id);
      }
      notifyListeners();
      return null;
    } on ApiException catch (e) {
      return e.message;
    }
  }

  /// DELETE /tasks/{id}. Trả về true nếu xóa thành công.
  Future<bool> remove(String id) async {
    try {
      await _api.deleteTask(id);
      _tasks.removeWhere((t) => t.id == id);
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      toast('Xóa thất bại: ${e.message}', error: true);
      return false;
    }
  }
}
