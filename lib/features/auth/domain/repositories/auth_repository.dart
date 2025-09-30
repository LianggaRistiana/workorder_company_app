
import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/auth/data/model/login_response.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  UserEntity? currentUser;
  Future<Either<Failure, LoginResponseModel>> login(String email, String password);
  Future<Either<Failure, UserEntity>> register(String name, String email, String password);
  Future<Either<Failure, UserEntity?>> getCurrentUser();
  Future<Either<Failure, void>> saveUser(UserEntity user);
}

