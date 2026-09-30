import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Widget _iconButton(IconData icon, Color color) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Icon(icon, size: 20, color: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Stack(
          children: [
            // Nút quay lại (góc trái trên)
            Positioned(
              top: 16,
              left: 16,
              child: InkWell(
                onTap: () => Navigator.maybePop(context),
                child: _iconButton(Icons.arrow_back, Colors.black87),
              ),
            ),
            // Nút chỉnh sửa (góc phải trên)
            Positioned(
              top: 16,
              right: 16,
              child: InkWell(
                onTap: () {},
                child: _iconButton(Icons.edit_outlined, Colors.teal),
              ),
            ),
            // Ảnh + tên + MSSV ở giữa
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage('assets/avatar.jpg'),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Nguyễn Hoàng Huy Khoa',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'MSSV: 058206001568',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
