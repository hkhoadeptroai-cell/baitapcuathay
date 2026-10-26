import 'package:flutter/material.dart';

import 'screens/forget_password_screen.dart';

void main() => runApp(const SmartTasksApp());

class SmartTasksApp extends StatelessWidget {
  const SmartTasksApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'SmartTasks',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4795EB)),
    ),
    home: const ForgetPasswordScreen(),
  );
}
