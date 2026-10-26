import 'package:flutter/material.dart';

import '../core/utils.dart';
import '../models/task.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 40, this.inverted = false});
  final double size;
  final bool inverted;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: inverted ? Colors.white : const Color(0xFF2F5BEA),
      borderRadius: BorderRadius.circular(size * .28),
    ),
    child: Icon(
      Icons.checklist_rounded,
      size: size * .6,
      color: inverted ? const Color(0xFF2F5BEA) : Colors.white,
    ),
  );
}

class GroupChip extends StatelessWidget {
  const GroupChip(this.group, {super.key});
  final TaskGroup group;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    decoration: BoxDecoration(
      color: group.bg,
      borderRadius: BorderRadius.circular(6),
    ),
    child: Text(
      group.label,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: group.color,
      ),
    ),
  );
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key, this.trailing});
  final String text;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 16, bottom: 8),
    child: Row(
      children: [
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        if (trailing != null) trailing!,
      ],
    ),
  );
}

class TaskTile extends StatelessWidget {
  const TaskTile({
    super.key,
    required this.task,
    required this.onTap,
    required this.onToggle,
  });
  final Task task;
  final VoidCallback onTap, onToggle;

  @override
  Widget build(BuildContext context) => Card(
    elevation: 0,
    margin: const EdgeInsets.only(bottom: 8),
    child: ListTile(
      onTap: onTap,
      leading: Checkbox(
        shape: const CircleBorder(),
        value: task.done,
        onChanged: (_) => onToggle(),
      ),
      title: Text(
        task.title,
        style: task.done
            ? const TextStyle(
                decoration: TextDecoration.lineThrough,
                color: Colors.grey,
              )
            : null,
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Row(
          children: [
            GroupChip(task.group),
            const SizedBox(width: 8),
            Text(
              '${relDay(task.due)}, ${fmtTime(task.due)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
    ),
  );
}
