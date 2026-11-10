import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'data/remote_settings.dart';
import 'core/routes.dart';
import 'data/app_settings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      measurementId: 'G-V64D73ZWHE',
      databaseURL: 'https://console.firebase.google.com/u/0/project/uth-todo-43070/overview',
      apiKey: 'AIzaSyDSOOYqeitoOPcgkVMFmAQjHmgKaob_6-U',
      authDomain: 'uth-todo-43070.firebaseapp.com',
      projectId: 'uth-todo-43070',
      storageBucket: 'uth-todo-43070.firebasestorage.app',
      messagingSenderId: '212819653430',
      appId: '1:212819653430:web:c52d53bea2ede82886f997',
    ),
  );
  await RemoteSettings.instance.init();
  runApp(const UthTodoApp());
}

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
