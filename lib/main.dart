import 'package:flutter/material.dart';

import 'core/routes.dart';
import 'data/app_settings.dart';

void main() => runApp(const UthTodoApp());

class UthTodoApp extends StatelessWidget {
  const UthTodoApp({super.key});

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: AppSettings.instance,
    builder: (_, __) {
      final s = AppSettings.instance;
      ThemeData theme(Brightness b) => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: s.accent,
          brightness: b,
        ).copyWith(primary: s.accent),
      );
      return MaterialApp(
        title: 'UTH Todo',
        debugShowCheckedModeBanner: false,
        theme: theme(Brightness.light),
        darkTheme: theme(Brightness.dark),
        themeMode: s.themeMode,
        builder: (c, child) => MediaQuery(
          data: MediaQuery.of(c)
              .copyWith(textScaler: TextScaler.linear(s.fontScale)),
          child: child!,
        ),
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRoutes.generate,
      );
    },
  );
}
