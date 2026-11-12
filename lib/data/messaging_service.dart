import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

const _vapidKey = 'DÁN_VAPID_KEY';

class MessagingService {
  MessagingService._();
  static final instance = MessagingService._();

  final _fm = FirebaseMessaging.instance;
  final lastMessage = ValueNotifier<RemoteMessage?>(null);
  bool _listening = false;

  /// Lắng nghe thông báo khi app đang mở (gọi 1 lần).
  void listen() {
    if (_listening) return;
    _listening = true;
    FirebaseMessaging.onMessage.listen((m) => lastMessage.value = m);
  }

  /// Xin quyền, lấy token, lưu lên Realtime Database. Trả về token (null nếu bị từ chối).
  Future<String?> enable() async {
    try {
      final s = await _fm.requestPermission();
      final ok =
          s.authorizationStatus == AuthorizationStatus.authorized ||
          s.authorizationStatus == AuthorizationStatus.provisional;
      if (!ok) return null;

      final token = await _fm.getToken(vapidKey: kIsWeb ? _vapidKey : null);
      debugPrint('FCM token: $token');

      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null && token != null) {
        await FirebaseDatabase.instance.ref('users/$uid/stats').update({
          'fcmToken': token,
        });
      }
      return token;
    } catch (e) {
      debugPrint('Messaging lỗi: $e');
      return null;
    }
  }
}
