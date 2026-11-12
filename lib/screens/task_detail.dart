import 'package:flutter/material.dart';

import '../core/routes.dart';
import '../core/utils.dart';
import '../data/task_repository.dart';
import '../models/task.dart';
import '../widgets/common.dart';

class TaskDetailScreen extends StatefulWidget {
  const TaskDetailScreen({super.key, required this.task});
  final Task task;
  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  final _repo = TaskRepository.instance;
  bool _loading = true;
  bool _deleting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final err = await _repo.loadDetail(widget.task.id);
    if (!mounted) return;
    setState(() {
      _loading = false;
      _error = err;
    });
  }

  Future<String?> _ask(String title, {String initial = ''}) {
    final c = TextEditingController(text: initial);
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: TextField(controller: c, autofocus: true),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, c.text.trim()),
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  Future<void> _delete(Task t) async {
    setState(() => _deleting = true);
    final ok = await _repo.remove(t.id);
    if (!mounted) return;
    if (ok) {
      toast('Đã xóa công việc');
      Navigator.pop(context);
    } else {
      setState(() => _deleting = false);
    }
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _repo,
    builder: (_, _) {
      final t = _repo.byId(widget.task.id);
      return Scaffold(
        appBar: AppBar(
          title: const Text('Chi tiết'),
          actions: [
            if (t != null && !_loading && _error == null)
              TextButton(
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.form, arguments: t),
                child: const Text('Sửa'),
              ),
          ],
        ),
        body: _body(context, t),
      );
    },
  );

  Widget _body(BuildContext context, Task? t) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) return ErrorView(message: _error!, onRetry: _load);
    if (t == null) return const Center(child: Text('Không tìm thấy công việc'));

    final high = t.priority == Priority.high;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            GroupChip(t.group),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: high ? const Color(0xFFFFE3E3) : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Ưu tiên ${t.priority.label.toLowerCase()}',
                style: TextStyle(
                  fontSize: 11,
                  color: high ? const Color(0xFFD92D20) : Colors.black54,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          t.title,
          style: Theme.of(context).textTheme.headlineSmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 0,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.calendar_today_outlined),
                title: const Text('Hạn chót'),
                trailing: Text('${relDay(t.due)}, ${fmtTime(t.due)}'),
              ),
              ListTile(
                leading: const Icon(Icons.notifications_none),
                title: const Text('Nhắc nhở'),
                trailing: Text(t.remind ? 'Trước 15 phút' : 'Không'),
              ),
            ],
          ),
        ),
        if (t.note.isNotEmpty) ...[const SectionTitle('Ghi chú'), Text(t.note)],
        SectionTitle(
          'Việc nhỏ',
          trailing: Text('${t.subDone}/${t.subTasks.length}'),
        ),
        LinearProgressIndicator(value: t.progress),
        for (final s in t.subTasks)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Checkbox(
              value: s.done,
              onChanged: (_) => _repo.toggleSub(t, s),
            ),
            title: Text(
              s.title,
              style: s.done
                  ? const TextStyle(decoration: TextDecoration.lineThrough)
                  : null,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  onPressed: () async {
                    final text = await _ask('Sửa việc nhỏ', initial: s.title);
                    if (text != null && text.isNotEmpty)
                      _repo.editSub(t, s, text);
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                    size: 20,
                  ),
                  onPressed: () => _repo.removeSub(t, s),
                ),
              ],
            ),
          ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.add),
          title: const Text('Thêm việc nhỏ'),
          onTap: () async {
            final text = await _ask('Thêm việc nhỏ');
            if (text != null && text.isNotEmpty) _repo.addSub(t, text);
          },
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 48,
          child: FilledButton(
            onPressed: () => _repo.toggle(t),
            child: Text(
              t.done ? 'Bỏ đánh dấu hoàn thành' : 'Đánh dấu hoàn thành',
            ),
          ),
        ),
        TextButton(
          onPressed: _deleting ? null : () => _delete(t),
          child: _deleting
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text(
                  'Xóa công việc',
                  style: TextStyle(color: Colors.red),
                ),
        ),
      ],
    );
  }
}
