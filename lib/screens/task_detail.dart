import 'package:flutter/material.dart';

import '../core/routes.dart';
import '../core/utils.dart';
import '../data/task_repository.dart';
import '../models/task.dart';
import '../widgets/common.dart';

class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({super.key, required this.task});
  final Task task;

  Future<void> _addSub(BuildContext context, Task t) async {
    final c = TextEditingController();
    final text = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Thêm việc nhỏ'),
        content: TextField(controller: c, autofocus: true),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, c.text.trim()),
            child: const Text('Thêm'),
          ),
        ],
      ),
    );
    if (text != null && text.isNotEmpty)
      TaskRepository.instance.addSub(t, text);
  }

  @override
  Widget build(BuildContext context) {
    final repo = TaskRepository.instance;
    return ListenableBuilder(
      listenable: repo,
      builder: (_, __) {
        final t = repo.byId(task.id) ?? task;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Danh sách'),
            actions: [
              TextButton(
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.form, arguments: t),
                child: const Text('Sửa'),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  GroupChip(t.group),
                  const SizedBox(width: 8),
                  Text(
                    'Ưu tiên ${t.priority.label.toLowerCase()}',
                    style: const TextStyle(color: Colors.red, fontSize: 12),
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
              if (t.note.isNotEmpty) ...[
                const SectionTitle('Ghi chú'),
                Text(t.note),
              ],
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
                    onChanged: (_) => repo.toggleSub(s),
                  ),
                  title: Text(
                    s.title,
                    style: s.done
                        ? const TextStyle(
                            decoration: TextDecoration.lineThrough,
                          )
                        : null,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () => repo.removeSub(t, s),
                  ),
                ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.add),
                title: const Text('Thêm việc nhỏ'),
                onTap: () => _addSub(context, t),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 48,
                child: FilledButton(
                  onPressed: () => repo.toggle(t),
                  child: Text(
                    t.done ? 'Bỏ đánh dấu hoàn thành' : 'Đánh dấu hoàn thành',
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  repo.remove(t.id);
                  Navigator.pop(context);
                },
                child: const Text(
                  'Xóa công việc',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
