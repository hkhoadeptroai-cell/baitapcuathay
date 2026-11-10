import 'package:flutter/material.dart';

import '../core/routes.dart';
import '../data/auth_service.dart';
import '../data/realtime_stats.dart';
import '../data/task_repository.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  static const _week = [3, 5, 2, 4, 6, 3, 1];
  static const _days = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final auth = AuthService.instance;
    final all = TaskRepository.instance.all;
    final done = all.where((t) => t.done).length;
    final rate = all.isEmpty ? 0 : (done * 100 / all.length).round();

    // Ô thống kê (không bọc Expanded, để bọc ở chỗ dùng)
    Widget stat(String v, String label) => Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Column(
          children: [
            Text(
              v,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(label, style: const TextStyle(fontSize: 11)),
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Hồ sơ')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: CircleAvatar(
              radius: 36,
              backgroundImage: auth.photoUrl == null
                  ? null
                  : NetworkImage(auth.photoUrl!),
              child: auth.photoUrl == null
                  ? Text(auth.initials, style: const TextStyle(fontSize: 24))
                  : null,
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              auth.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Center(child: Text(auth.email)),
          if (!auth.isGuest)
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 6),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F6EA),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '✓ Đã liên kết tài khoản Google',
                  style: TextStyle(fontSize: 11, color: Color(0xFF1B9E5A)),
                ),
              ),
            ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: stat('$done', 'Việc đã xong')),
              Expanded(
                child: StreamBuilder<int>(
                  stream: RealtimeStats.opens(),
                  builder: (_, snap) =>
                      stat('${snap.data ?? 0}', 'Lượt mở app'),
                ),
              ),
              Expanded(child: stat('$rate%', 'Đúng hạn')),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Tuần này', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SizedBox(
            height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var i = 0; i < 7; i++)
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: _week[i] * 12.0,
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          decoration: BoxDecoration(
                            color: cs.primary.withValues(alpha: .6),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(_days[i], style: const TextStyle(fontSize: 11)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () async {
              TaskRepository.instance.stop();
              await AuthService.instance.signOut();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                  (_) => false,
                );
              }
            },
            icon: const Icon(Icons.logout, color: Colors.red),
            label: const Text('Đăng xuất', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
