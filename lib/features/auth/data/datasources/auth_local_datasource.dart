import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:workorder_company_app/core/services/logger/app_logger.dart';
import 'package:workorder_company_app/features/auth/data/model/user_model.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'dart:convert';

abstract class AuthLocalDatasource {
  Future<void> saveUser(UserEntity user);
  Future<void> clearUser();
  Future<UserEntity?> getUser();
}

class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  final FlutterSecureStorage _secureStorage;

  static const _userKey = 'auth_user';

  AuthLocalDatasourceImpl({FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage ?? FlutterSecureStorage();

  @override
  Future<void> saveUser(UserEntity user) async {
    // Pastikan user yang disimpan adalah UserModel agar bisa toJson
    final jsonString = json.encode((user as UserModel).toJson());
    await _secureStorage.write(key: _userKey, value: jsonString);
  }

  @override
  Future<UserEntity?> getUser() async {
    final jsonString = await _secureStorage.read(key: _userKey);
    if (jsonString == null) return null;
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    return UserModel.fromJson(jsonMap);
  }

  @override
  Future<void> clearUser() async {
    appLogger.i("Delete user");
    await _secureStorage.delete(key: _userKey);
  }
}
