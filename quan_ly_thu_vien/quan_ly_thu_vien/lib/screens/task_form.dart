import 'package:flutter/material.dart';

import '../core/utils.dart';
import '../data/task_repository.dart';
import '../models/task.dart';

class TaskFormScreen extends StatefulWidget {
  const TaskFormScreen({super.key, this.task});
  final Task? task;
  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  late final _title = TextEditingController(text: widget.task?.title);
  late final _note = TextEditingController(text: widget.task?.note);
  late TaskGroup _group = widget.task?.group ?? TaskGroup.study;
  late Priority _priority = widget.task?.priority ?? Priority.medium;
  late DateTime _due =
      widget.task?.due ?? DateTime.now().add(const Duration(hours: 1));
  late bool _remind = widget.task?.remind ?? true;

  @override
  void dispose() {
    _title.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _due,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (d != null)
      setState(
        () => _due = DateTime(d.year, d.month, d.day, _due.hour, _due.minute),
      );
  }

  Future<void> _pickTime() async {
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_due),
    );
    if (t != null) {
      setState(
        () =>
            _due = DateTime(_due.year, _due.month, _due.day, t.hour, t.minute),
      );
    }
  }

  void _save() {
    if (_title.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập tên công việc')),
      );
      return;
    }
    final old = widget.task;
    TaskRepository.instance.save(
      Task(
        id: old?.id,
        title: _title.text.trim(),
        note: _note.text.trim(),
        group: _group,
        priority: _priority,
        due: _due,
        remind: _remind,
        done: old?.done ?? false,
        subTasks: old?.subTasks,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leadingWidth: 72,
      leading: TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Hủy'),
      ),
      title: Text(widget.task == null ? 'Việc mới' : 'Sửa việc'),
      centerTitle: true,
      actions: [TextButton(onPressed: _save, child: const Text('Lưu'))],
    ),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextField(
          controller: _title,
          decoration: const InputDecoration(
            labelText: 'Tên công việc',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _note,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Ghi chú (không bắt buộc)',
            border: OutlineInputBorder(),
          ),
        ),
        const SectionTitleLite('Nhóm'),
        SegmentedButton<TaskGroup>(
          segments: [
            for (final g in TaskGroup.values)
              ButtonSegment(value: g, label: Text(g.label)),
          ],
          selected: {_group},
          onSelectionChanged: (v) => setState(() => _group = v.first),
        ),
        const SizedBox(height: 8),
        ListTile(
          leading: const Icon(Icons.calendar_today_outlined),
          title: const Text('Ngày'),
          trailing: Text('${relDay(_due)} (${fmtDate(_due)})'),
          onTap: _pickDate,
        ),
        ListTile(
          leading: const Icon(Icons.access_time),
          title: const Text('Giờ'),
          trailing: Text(fmtTime(_due)),
          onTap: _pickTime,
        ),
        SwitchListTile(
          secondary: const Icon(Icons.notifications_none),
          title: const Text('Nhắc tôi'),
          subtitle: const Text('Trước 15 phút'),
          value: _remind,
          onChanged: (v) => setState(() => _remind = v),
        ),
        const SectionTitleLite('Mức ưu tiên'),
        SegmentedButton<Priority>(
          segments: [
            for (final p in Priority.values)
              ButtonSegment(value: p, label: Text(p.label)),
          ],
          selected: {_priority},
          onSelectionChanged: (v) => setState(() => _priority = v.first),
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 48,
          child: FilledButton(
            onPressed: _save,
            child: const Text('Lưu công việc'),
          ),
        ),
      ],
    ),
  );
}

class SectionTitleLite extends StatelessWidget {
  const SectionTitleLite(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 16, bottom: 8),
    child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
  );
}
