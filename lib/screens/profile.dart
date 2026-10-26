import 'package:flutter/material.dart';

import '../core/routes.dart';
import '../data/task_repository.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  static const _week = [3, 5, 2, 4, 6, 3, 1];
  static const _days = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final all = TaskRepository.instance.all;
    final done = all.where((t) => t.done).length;
    final rate = all.isEmpty ? 0 : (done * 100 / all.length).round();

    Widget stat(String v, String label) => Expanded(
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Column(
            children: [
              Text(
                v,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(label, style: const TextStyle(fontSize: 11)),
            ],
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Hồ sơ')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Center(
            child: CircleAvatar(
              radius: 36,
              child: Text('MA', style: TextStyle(fontSize: 24)),
            ),
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text(
              'Minh Anh',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const Center(child: Text('minhanh@gmail.com')),
          const SizedBox(height: 16),
          Row(
            children: [
              stat('$done', 'Việc đã xong'),
              stat('12 ngày', 'Chuỗi liên tiếp'),
              stat('$rate%', 'Đúng hạn'),
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
                            color: cs.primary.withOpacity(.6),
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
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.login,
              (_) => false,
            ),
            icon: const Icon(Icons.logout, color: Colors.red),
            label: const Text('Đăng xuất', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
