import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const String _key = 'auth_token';
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  TokenStorage();

  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: _key, value: token);
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: _key);
  }

  Future<void> clearToken() async {
    await _secureStorage.delete(key: _key);
  }

  Future<bool> hasToken() async {
    final token = await _secureStorage.read(key: _key);
    return token != null;
  }
}
