import 'package:flutter/material.dart';

import 'screens/home_page.dart';

void main() => runApp(const LibraryApp());

class LibraryApp extends StatelessWidget {
  const LibraryApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Quản lý Thư viện',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2755B8)),
    ),
    home: const HomePage(),
  );
}
