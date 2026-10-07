import 'package:flutter/material.dart';

import 'bai1.dart';

// import 'bai2.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StudentList(), // đổi sang widget của bài muốn chạy
    );
  }
}
