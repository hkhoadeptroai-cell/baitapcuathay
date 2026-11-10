import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

/// Đếm số lần mở app của từng tài khoản bằng Realtime Database.
class RealtimeStats {
  RealtimeStats._();

  static DatabaseReference? get _ref {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;
    return FirebaseDatabase.instance.ref('users/$uid/stats');
  }

  static Future<void> recordOpen() async {
    await _ref?.update({
      'lastOpen': ServerValue.timestamp,
      'opens': ServerValue.increment(1),
    });
  }

  static Stream<int> opens() {
    final r = _ref;
    if (r == null) return const Stream.empty();
    return r.child('opens').onValue.map((e) => (e.snapshot.value as int?) ?? 0);
  }
}
