import 'package:flutter/material.dart';

import '../core/routes.dart';
import '../core/utils.dart';
import '../data/app_settings.dart';
import '../data/task_repository.dart';
import '../models/task.dart';
import '../widgets/common.dart';

final _repo = TaskRepository.instance;

void _openDetail(BuildContext c, Task t) =>
    Navigator.pushNamed(c, AppRoutes.detail, arguments: t);

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  static const _items = [
    (Icons.home_outlined, 'Trang chủ'),
    (Icons.list_alt, 'Danh sách'),
    (Icons.notifications_none, 'Thông báo'),
    (Icons.tune, 'Cài đặt'),
  ];
  int _index = 0;

  void _go(int i) => setState(() => _index = i);

  Widget _navItem(int i) {
    final selected = i == _index;
    final color = selected
        ? Theme.of(context).colorScheme.primary
        : Colors.grey;
    return InkWell(
      onTap: () => _go(i),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_items[i].$1, color: color),
            Text(_items[i].$2, style: TextStyle(fontSize: 10, color: color)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: IndexedStack(
      index: _index,
      children: [
        HomeTab(onBell: () => _go(2), onSeeAll: () => _go(1)),
        const ListTab(),
        const NotificationTab(),
        const SettingsTab(),
      ],
    ),
    floatingActionButton: FloatingActionButton(
      shape: const CircleBorder(),
      onPressed: () => Navigator.pushNamed(context, AppRoutes.form),
      child: const Icon(Icons.add),
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    bottomNavigationBar: BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 6,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(0),
          _navItem(1),
          const SizedBox(width: 48),
          _navItem(2),
          _navItem(3),
        ],
      ),
    ),
  );
}

// ---------------- TRANG CHỦ ----------------
class HomeTab extends StatelessWidget {
  const HomeTab({super.key, required this.onBell, required this.onSeeAll});
  final VoidCallback onBell, onSeeAll;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListenableBuilder(
      listenable: _repo,
      builder: (_, __) {
        final today = _repo.today;
        final done = today.where((t) => t.done).length;
        final ratio = today.isEmpty ? 0.0 : done / today.length;
        return SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  const CircleAvatar(child: Text('MA')),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fmtLong(DateTime.now()),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          'Chào UTH!',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: onBell,
                    icon: const Icon(Icons.notifications_none),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cs.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tiến độ hôm nay',
                            style: TextStyle(color: Colors.white70),
                          ),
                          Text(
                            '$done/${today.length} việc',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'Bắt đầu từ việc khó nhất nhé.',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 64,
                      height: 64,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CircularProgressIndicator(
                            value: ratio,
                            strokeWidth: 6,
                            color: Colors.white,
                            backgroundColor: Colors.white24,
                          ),
                          Center(
                            child: Text(
                              '${(ratio * 100).round()}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  for (final g in TaskGroup.values) ...[
                    Expanded(child: _GroupCard(g)),
                    if (g != TaskGroup.values.last) const SizedBox(width: 12),
                  ],
                ],
              ),
              SectionTitle(
                'Việc hôm nay',
                trailing: TextButton(
                  onPressed: onSeeAll,
                  child: const Text('Xem tất cả'),
                ),
              ),
              for (final t in today)
                TaskTile(
                  task: t,
                  onTap: () => _openDetail(context, t),
                  onToggle: () => _repo.toggle(t),
                ),
              if (today.isEmpty)
                const Center(child: Text('Hôm nay chưa có việc nào 🎉')),
            ],
          ),
        );
      },
    );
  }
}

class _GroupCard extends StatelessWidget {
  const _GroupCard(this.group);
  final TaskGroup group;

  @override
  Widget build(BuildContext context) => Card(
    elevation: 0,
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: group.bg,
            child: Icon(group.icon, color: group.color),
          ),
          const SizedBox(height: 8),
          Text(
            group.label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            '${_repo.pendingOf(group)} việc còn lại',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    ),
  );
}

// ---------------- DANH SÁCH ----------------
class ListTab extends StatefulWidget {
  const ListTab({super.key});
  @override
  State<ListTab> createState() => _ListTabState();
}

class _ListTabState extends State<ListTab> {
  String _query = '';
  TaskGroup? _filter;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _repo,
    builder: (_, __) {
      bool match(Task t) =>
          (_filter == null || t.group == _filter) &&
          t.title.toLowerCase().contains(_query.toLowerCase());
      final todo = _repo.all.where((t) => !t.done && match(t)).toList()
        ..sort((a, b) => a.due.compareTo(b.due));
      final finished = _repo.all.where((t) => t.done && match(t)).toList();

      return SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Danh sách',
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'Tìm công việc',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                for (final g in <TaskGroup?>[null, ...TaskGroup.values])
                  ChoiceChip(
                    label: Text(g?.label ?? 'Tất cả'),
                    selected: _filter == g,
                    onSelected: (_) => setState(() => _filter = g),
                  ),
              ],
            ),
            const SectionTitle('CẦN LÀM'),
            for (final t in todo)
              TaskTile(
                task: t,
                onTap: () => _openDetail(context, t),
                onToggle: () => _repo.toggle(t),
              ),
            if (finished.isNotEmpty) const SectionTitle('ĐÃ XONG'),
            for (final t in finished)
              TaskTile(
                task: t,
                onTap: () => _openDetail(context, t),
                onToggle: () => _repo.toggle(t),
              ),
          ],
        ),
      );
    },
  );
}

// ---------------- THÔNG BÁO ----------------
class NotificationTab extends StatelessWidget {
  const NotificationTab({super.key});

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _repo,
    builder: (_, __) {
      final list = _repo.all.where((t) => t.remind && !t.done).toList()
        ..sort((a, b) => a.due.compareTo(b.due));
      return SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Thông báo',
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (list.isEmpty) const Text('Chưa có nhắc nhở nào.'),
            for (final t in list)
              Card(
                elevation: 0,
                child: ListTile(
                  leading: const Icon(Icons.alarm),
                  title: Text(t.title),
                  subtitle: Text(
                    'Nhắc lúc ${fmtTime(t.due)} – ${relDay(t.due)}',
                  ),
                  onTap: () => _openDetail(context, t),
                ),
              ),
          ],
        ),
      );
    },
  );
}

// ---------------- CÀI ĐẶT ----------------
class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});
  static const _accents = [
    Color(0xFF2F5BEA),
    Color(0xFF1B9E5A),
    Color(0xFFD9480F),
    Color(0xFF7C3AED),
  ];

  @override
  Widget build(BuildContext context) {
    final s = AppSettings.instance;
    return ListenableBuilder(
      listenable: s,
      builder: (_, __) => SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Cài đặt',
                    style: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
                  child: const CircleAvatar(child: Text('MA')),
                ),
              ],
            ),
            const SectionTitle('GIAO DIỆN'),
            SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(value: ThemeMode.light, label: Text('Sáng')),
                ButtonSegment(value: ThemeMode.dark, label: Text('Tối')),
                ButtonSegment(value: ThemeMode.system, label: Text('Tự động')),
              ],
              selected: {s.themeMode},
              onSelectionChanged: (v) => s.update(() => s.themeMode = v.first),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Expanded(child: Text('Màu chủ đạo')),
                for (final c in _accents)
                  GestureDetector(
                    onTap: () => s.update(() => s.accent = c),
                    child: Container(
                      margin: const EdgeInsets.only(left: 10),
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: c,
                        shape: BoxShape.circle,
                        border: s.accent == c
                            ? Border.all(width: 3, color: Colors.black26)
                            : null,
                      ),
                    ),
                  ),
              ],
            ),
            Row(
              children: [
                const Text('Cỡ chữ'),
                Expanded(
                  child: Slider(
                    value: s.fontScale,
                    min: .85,
                    max: 1.3,
                    onChanged: (v) => s.update(() => s.fontScale = v),
                  ),
                ),
              ],
            ),
            const SectionTitle('THÔNG BÁO'),
            SwitchListTile(
              title: const Text('Nhắc việc'),
              subtitle: const Text('Báo trước hạn chót 15 phút'),
              value: s.remind,
              onChanged: (v) => s.update(() => s.remind = v),
            ),
            SwitchListTile(
              title: const Text('Âm thanh'),
              value: s.sound,
              onChanged: (v) => s.update(() => s.sound = v),
            ),
            SwitchListTile(
              title: const Text('Tổng kết cuối ngày'),
              subtitle: const Text('Gửi lúc 21:00 mỗi tối'),
              value: s.dailySummary,
              onChanged: (v) => s.update(() => s.dailySummary = v),
            ),
            const SectionTitle('CHUNG'),
            const ListTile(
              title: Text('Ngôn ngữ'),
              trailing: Text('Tiếng Việt'),
            ),
          ],
        ),
      ),
    );
  }
}
