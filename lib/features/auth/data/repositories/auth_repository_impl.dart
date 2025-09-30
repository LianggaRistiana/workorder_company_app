import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:workorder_company_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:workorder_company_app/features/auth/data/model/login_response.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _remoteDatasource;
  final AuthLocalDatasource _localDatasource;
  UserEntity? currentUser;

  AuthRepositoryImpl(this._remoteDatasource, this._localDatasource);

  @override
  Future<Either<Failure, LoginResponseModel>> login(
      String email, String password) async {
    try {
      final response = await _remoteDatasource.login(email, password);
      if (response.data == null) {
        return Left(ServerFailure(message: response.message));
      }
      return Right(response.data!);
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register(
      String name, String email, String password) async {
    try {
      final response = await _remoteDatasource.register(name, email, password);

      if (response.data == null) {
        return Left(ServerFailure(message: response.message));
      }

      return Right(response.data!);
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final result = await _localDatasource.getUser();

      // if (result == null) {
      //   return Left(CacheFailure(message: "Belum Login"));
      // }

      currentUser = result;
      Logger().i(currentUser);
      return Right(result);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveUser(UserEntity user) async {
    try {
      await _localDatasource.saveUser(user);
      currentUser = user;
      Logger().i(currentUser);
      return Right(null);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }
}
