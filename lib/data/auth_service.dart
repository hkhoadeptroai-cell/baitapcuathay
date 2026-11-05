import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'analytics_service.dart';

class AuthService {
  AuthService._();
  static final instance = AuthService._();

  final _auth = FirebaseAuth.instance;

  User? get user => _auth.currentUser;
  bool get isGuest => user == null || user!.isAnonymous;

  String get name =>
      isGuest ? 'Khách' : (user!.displayName ?? user!.email ?? 'Người dùng');
  String get email => isGuest ? 'Chưa liên kết tài khoản' : (user!.email ?? '');
  String? get photoUrl => user?.photoURL;

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  Future<void> signInWithGoogle() async {
    final provider = GoogleAuthProvider();
    if (kIsWeb) {
      await _auth.signInWithPopup(provider);
    } else {
      await _auth.signInWithProvider(provider);
    }
    await Analytics.login('google');
  }

  Future<void> signInGuest() async {
    await _auth.signInAnonymously();
    await Analytics.login('anonymous');
  }

  Future<void> signOut() => _auth.signOut();
}
