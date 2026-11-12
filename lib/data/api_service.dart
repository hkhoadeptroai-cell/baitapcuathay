import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiException implements Exception {
  ApiException(this.message);
  final String message;
  @override
  String toString() => message;
}

class ApiService {
  ApiService._();
  static final instance = ApiService._();

  static const _base = 'https://share.tryapps.store/mock/teach';
  static const _token = 'TuanTruong-uth-student'; // token thầy cấp
  static const _timeout = Duration(seconds: 15);

  Map<String, String> get _auth => {'Authorization': 'Bearer $_token'};

  Future<dynamic> _run(Future<http.Response> Function() call) async {
    try {
      final res = await call().timeout(_timeout);
      if (res.statusCode < 200 || res.statusCode >= 300) {
        throw ApiException('Máy chủ báo lỗi (${res.statusCode})');
      }
      if (res.body.trim().isEmpty) return null;
      return jsonDecode(utf8.decode(res.bodyBytes));
    } on ApiException {
      rethrow;
    } on TimeoutException {
      throw ApiException('Quá thời gian chờ, hãy thử lại');
    } on FormatException {
      throw ApiException('Dữ liệu trả về không hợp lệ');
    } catch (_) {
      throw ApiException('Không kết nối được máy chủ');
    }
  }
  // POST /mock/teach/tasks
  Future<dynamic> createTask(Map<String, dynamic> body) => _run(
        () => http.post(
          Uri.parse('$_base/tasks'),
          headers: {..._auth, 'Content-Type': 'application/json'},
          body: jsonEncode(body),
        ),
      );
  // GET /mock/teach/tasks
  Future<List<dynamic>> getTasks() async {
    final data = await _run(
      () => http.get(Uri.parse('$_base/tasks'), headers: _auth),
    );
    return data as List<dynamic>;
  }

  // GET /mock/teach/tasks/{id}
  Future<dynamic> getTask(String id) =>
      _run(() => http.get(Uri.parse('$_base/tasks/$id'), headers: _auth));

  // PATCH /mock/teach/tasks/{id}
  Future<dynamic> patchTask(String id, Map<String, dynamic> body) => _run(
    () => http.patch(
      Uri.parse('$_base/tasks/$id'),
      headers: {..._auth, 'Content-Type': 'application/json'},
      body: jsonEncode(body),
    ),
  );

  // DELETE /mock/teach/tasks/{id}
  Future<dynamic> deleteTask(String id) =>
      _run(() => http.delete(Uri.parse('$_base/tasks/$id'), headers: _auth));
}
