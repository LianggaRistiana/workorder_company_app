import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/auth/data/model/login_response.dart';
import 'package:workorder_company_app/features/auth/domain/entities/company_registration_entity.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_registration_entity.dart';

abstract class AuthRepository {
  UserEntity? get currentUser;
  Future<Either<Failure, LoginResponseModel>> login(
      String email, String password);
  Future<Either<Failure, UserEntity?>> getCurrentUser({bool refresh = false});
  Future<Either<Failure, void>> saveUser(UserEntity user);
  Future<Either<Failure, void>> logOut();
  Future<Either<Failure, void>> userRegistration(
      UserRegistrationEntity registrationData);
  Future<Either<Failure, void>> companyRegistration(
      CompanyRegistrationEntity registrationData);
}
