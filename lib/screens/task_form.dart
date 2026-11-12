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
  bool _saving = false;
  String? _titleError;

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
    if (d != null) {
      setState(
        () => _due = DateTime(d.year, d.month, d.day, _due.hour, _due.minute),
      );
    }
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

  Future<void> _save() async {
    final title = _title.text.trim();
    if (title.isEmpty) {
      setState(() => _titleError = 'Vui lòng nhập tên công việc');
      return;
    }
    setState(() {
      _titleError = null;
      _saving = true;
    });
    final old = widget.task;
    final err = await TaskRepository.instance.save(
      Task(
        id: old?.id,
        title: title,
        note: _note.text.trim(),
        group: _group,
        priority: _priority,
        due: _due,
        remind: _remind,
        done: old?.done ?? false,
        subTasks: old?.subTasks,
      ),
    );
    if (!mounted) return;
    if (err == null) {
      toast(old == null ? 'Đã thêm công việc' : 'Đã lưu thay đổi');
      Navigator.pop(context);
    } else {
      setState(() => _saving = false);
      toast('Lưu thất bại: $err', error: true);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leadingWidth: 72,
      leading: TextButton(
        onPressed: _saving ? null : () => Navigator.pop(context),
        child: const Text('Hủy'),
      ),
      title: Text(widget.task == null ? 'Việc mới' : 'Sửa việc'),
      centerTitle: true,
      actions: [
        TextButton(onPressed: _saving ? null : _save, child: const Text('Lưu')),
      ],
    ),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextField(
          controller: _title,
          enabled: !_saving,
          decoration: InputDecoration(
            labelText: 'Tên công việc',
            errorText: _titleError,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _note,
          enabled: !_saving,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Ghi chú (không bắt buộc)',
            border: OutlineInputBorder(),
          ),
        ),
        const _Label('Nhóm'),
        SegmentedButton<TaskGroup>(
          segments: [
            for (final g in TaskGroup.values)
              ButtonSegment(value: g, label: Text(g.label)),
          ],
          selected: {_group},
          onSelectionChanged: _saving
              ? null
              : (v) => setState(() => _group = v.first),
        ),
        const SizedBox(height: 8),
        ListTile(
          leading: const Icon(Icons.calendar_today_outlined),
          title: const Text('Ngày'),
          trailing: Text('${relDay(_due)} (${fmtDate(_due)})'),
          onTap: _saving ? null : _pickDate,
        ),
        ListTile(
          leading: const Icon(Icons.access_time),
          title: const Text('Giờ'),
          trailing: Text(fmtTime(_due)),
          onTap: _saving ? null : _pickTime,
        ),
        SwitchListTile(
          secondary: const Icon(Icons.notifications_none),
          title: const Text('Nhắc tôi'),
          subtitle: const Text('Trước 15 phút'),
          value: _remind,
          onChanged: _saving ? null : (v) => setState(() => _remind = v),
        ),
        const _Label('Mức ưu tiên'),
        SegmentedButton<Priority>(
          segments: [
            for (final p in Priority.values)
              ButtonSegment(value: p, label: Text(p.label)),
          ],
          selected: {_priority},
          onSelectionChanged: _saving
              ? null
              : (v) => setState(() => _priority = v.first),
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 48,
          child: FilledButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Lưu công việc'),
          ),
        ),
      ],
    ),
  );
}

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 16, bottom: 8),
    child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
  );
}
