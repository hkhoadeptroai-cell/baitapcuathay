import 'package:flutter/material.dart';

import '../models/task.dart';
import '../screens/intro.dart';
import '../screens/main_shell.dart';
import '../screens/profile.dart';
import '../screens/task_detail.dart';
import '../screens/task_form.dart';

class AppRoutes {
  AppRoutes._();
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const home = '/home';
  static const form = '/task-form';
  static const detail = '/task-detail';
  static const profile = '/profile';

  static Route<dynamic> generate(RouteSettings s) {
    final Widget page = switch (s.name) {
      onboarding => const OnboardingScreen(),
      login => const LoginScreen(),
      home => const MainShell(),
      form => TaskFormScreen(task: s.arguments as Task?),
      detail => TaskDetailScreen(task: s.arguments as Task),
      profile => const ProfileScreen(),
      _ => const SplashScreen(),
    };
    return MaterialPageRoute(builder: (_) => page, settings: s);
  }
}
