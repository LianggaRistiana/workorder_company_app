import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/core/services/logger/app_logger.dart';
import 'package:workorder_company_app/core/services/storage/token_storage.dart';
import 'package:workorder_company_app/core/utils/safe_call.dart';
import 'package:workorder_company_app/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:workorder_company_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:workorder_company_app/features/auth/data/model/company_registration_model.dart';
import 'package:workorder_company_app/features/auth/data/model/login_response.dart';
import 'package:workorder_company_app/features/auth/data/model/user_registration_model.dart';
import 'package:workorder_company_app/features/auth/domain/entities/company_registration_entity.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_registration_entity.dart';
import 'package:workorder_company_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _remoteDatasource;
  final AuthLocalDatasource _localDatasource;
  final TokenStorage _tokenStorage;

  UserEntity? _cache;

  @override
  UserEntity? get currentUser => _cache;

  AuthRepositoryImpl(
      this._remoteDatasource, this._localDatasource, this._tokenStorage);

  @override
  Future<Either<Failure, LoginResponseModel>> login(
      String email, String password) async {
    try {
      final response = await _remoteDatasource.login(email, password);
      return Right(response.data);
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser({
    bool refresh = false,
  }) async {
    try {
      // =====================================================
      // 1️⃣ FORCE REFRESH → ALWAYS HIT REMOTE
      // =====================================================
      if (refresh) {
        try {
          final remoteUser = await _remoteDatasource.getUser();

          // update memory cache
          _cache = remoteUser.data;

          // update local storage
          await _localDatasource.saveUser(remoteUser.data);

          return Right(remoteUser.data);
        } catch (e) {
          // fallback ke cache kalau ada
          if (_cache != null) {
            return Right(_cache!);
          }

          // fallback ke local storage
          final localUser = await _localDatasource.getUser();
          if (localUser != null) {
            _cache = localUser;
            return Right(localUser);
          }

          return Left(ServerFailure(message: e.toString()));
        }
      }

      // =====================================================
      // 2️⃣ MEMORY CACHE HIT
      // =====================================================
      if (_cache != null) {
        return Right(_cache!);
      }

      // =====================================================
      // 3️⃣ LOAD FROM LOCAL STORAGE
      // =====================================================
      final localUser = await _localDatasource.getUser();

      if (localUser != null) {
        _cache = localUser;
        return Right(localUser);
      }
      return Left(AuthFailure());
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveUser(UserEntity user) async {
    try {
      await _localDatasource.saveUser(user);
      _cache = user;
      appLogger.i(user);
      return Right(null);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logOut() async {
    try {
      await _remoteDatasource.logout();
      await _localDatasource.clearUser();
      await _tokenStorage.clearToken();
      _cache = null;

      return Right(null);
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e, st) {
      appLogger.e("$e\n $st");
      return Left(CacheFailure(message: "Gagal Menghapus Data Local"));
    }
  }

  @override
  Future<Either<Failure, void>> companyRegistration(
      CompanyRegistrationEntity registrationData) {
    return safeCall(() async {
      return _remoteDatasource.companyRegistration(
          CompanyRegistrationModel.fromEntity(registrationData));
    });
  }

  @override
  Future<Either<Failure, void>> userRegistration(
      UserRegistrationEntity registrationData) async {
    return safeCall(() async {
      return _remoteDatasource
          .userRegistration(UserRegistrationModel.fromEntity(registrationData));
    });
  }
}
