import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

class RemoteSettings {
  RemoteSettings._();
  static final instance = RemoteSettings._();

  final _rc = FirebaseRemoteConfig.instance;

  String get homeTip => _rc.getString('home_tip');

  Future<void> init() async {
    try {
      await _rc.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: Duration.zero, // để demo thấy đổi ngay
        ),
      );
      await _rc.setDefaults({'home_tip': 'Bắt đầu từ việc khó nhất nhé.'});
      await _rc.fetchAndActivate();
    } catch (e) {
      debugPrint('Remote Config lỗi: $e');
    }
  }
}
