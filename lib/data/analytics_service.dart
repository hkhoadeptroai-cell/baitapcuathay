import 'package:firebase_analytics/firebase_analytics.dart';

class Analytics {
  Analytics._();
  static final _fa = FirebaseAnalytics.instance;

  static Future<void> login(String method) => _fa.logLogin(loginMethod: method);

  static Future<void> addTask(String group) =>
      _fa.logEvent(name: 'add_task', parameters: {'group': group});

  static Future<void> completeTask() => _fa.logEvent(name: 'complete_task');
}
