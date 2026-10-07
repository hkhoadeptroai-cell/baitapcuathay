import 'package:flutter/material.dart';

import 'bai1.dart';
import 'bai2.dart';
import 'bai3.dart' as b3;
import 'thuchanh.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(debugShowCheckedModeBanner: false, home: Menu());
  }
}

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bài tập tuần 2')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StudentList()),
              ),
              child: const Text('Bài 1: Danh sách sinh viên'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const Bai2Screen()),
              ),
              child: const Text('Bài 2: Xếp loại học lực'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const b3.Bai3Screen()),
              ),
              child: const Text('Bài 3: Bảng điểm lớp'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const Home()),
              ),
              child: const Text('Thực hành: Number, Email, Calc'),
            ),
          ],
        ),
      ),
    );
  }
}
