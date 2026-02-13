import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/core/network/api_response.dart';
import 'package:workorder_company_app/core/storage/token_storage.dart';
import 'package:workorder_company_app/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:workorder_company_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:workorder_company_app/features/auth/data/model/login_response.dart';
import 'package:workorder_company_app/features/auth/data/model/user_model.dart';
import 'package:workorder_company_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';

class MockRemoteDatasource extends Mock implements AuthRemoteDatasource {}

class MockLocalDatasource extends Mock implements AuthLocalDatasource {}

class MockTokenStorage extends Mock implements TokenStorage {}

void main() {
  late AuthRepositoryImpl repository;
  late MockRemoteDatasource mockRemote;
  late MockLocalDatasource mockLocal;
  late MockTokenStorage mockToken;

  setUp(() {
    mockRemote = MockRemoteDatasource();
    mockLocal = MockLocalDatasource();
    mockToken = MockTokenStorage();

    repository = AuthRepositoryImpl(
      mockRemote,
      mockLocal,
      mockToken,
    );
  });

  const email = "test@mail.com";
  const password = "123456";

  final userModel = UserModel(
    name: "Test User",
    email: email,
    role: UserRole.ownerCompany,
    position: null,
  );

  final loginResponse = LoginResponseModel(
    user: userModel,
    token: "abc123",
  );

  // ================= LOGIN =================

  group("LOGIN", () {
    test("Should return Right(LoginResponseModel) when success", () async {
      when(() => mockRemote.login(email, password))
          .thenAnswer((_) async => ApiResponse(
                message: "Success",
                data: loginResponse,
              ));

      final result = await repository.login(email, password);

      expect(result, Right(loginResponse));
      verify(() => mockRemote.login(email, password)).called(1);
    });

    test("Should return ServerFailure when data is null", () async {
      when(() => mockRemote.login(email, password))
          .thenAnswer((_) async => ApiResponse<LoginResponseModel>(
                message: "Invalid credentials",
                data: null,
              ));

      final result = await repository.login(email, password);

      expect(result, Left(ServerFailure(message: "Invalid credentials")));
    });

    test("Should return ServerFailure when ApiException thrown", () async {
      when(() => mockRemote.login(email, password))
          .thenThrow(ApiException(500, "Server Error"));

      final result = await repository.login(email, password);

      expect(result, Left(ServerFailure(message: "Server Error")));
    });

    test("Should return UnexpectedFailure when unknown exception thrown",
        () async {
      when(() => mockRemote.login(email, password))
          .thenThrow(Exception("Unknown"));

      final result = await repository.login(email, password);

      expect(result.isLeft(), true);
      expect(result.fold((l) => l is UnexpectedFailure, (_) => false), true);
    });
  });

  // ================= REGISTER =================

  group("REGISTER", () {
    test("Should return Right(UserEntity) when success", () async {
      when(() => mockRemote.register(any(), any(), any()))
          .thenAnswer((_) async => ApiResponse<UserModel>(
                message: "Success",
                data: userModel,
              ));

      final result = await repository.register("Test", email, password);

      expect(result, Right(userModel));
    });

    test("Should return ServerFailure when data null", () async {
      when(() => mockRemote.register(any(), any(), any()))
          .thenAnswer((_) async => ApiResponse<UserModel>(
                message: "Email already used",
                data: null,
              ));

      final result = await repository.register("Test", email, password);

      expect(result, Left(ServerFailure(message: "Email already used")));
    });

    test("Should return ServerFailure when ApiException thrown", () async {
      when(() => mockRemote.register(any(), any(), any()))
          .thenThrow(ApiException(400, "Bad Request"));

      final result = await repository.register("Test", email, password);

      expect(result, Left(ServerFailure(message: "Bad Request")));
    });
  });

  // ================= GET CURRENT USER =================

  group("GET CURRENT USER", () {
    test("Should return Right(UserEntity) when cache exists", () async {
      when(() => mockLocal.getUser()).thenAnswer((_) async => userModel);

      final result = await repository.getCurrentUser();

      expect(result, Right(userModel));
      verify(() => mockLocal.getUser()).called(1);
    });

    test("Should return CacheFailure when exception thrown", () async {
      when(() => mockLocal.getUser()).thenThrow(Exception("Cache error"));

      final result = await repository.getCurrentUser();

      expect(result.isLeft(), true);
      expect(result.fold((l) => l is CacheFailure, (_) => false), true);
    });
  });

  // ================= SAVE USER =================

  group("SAVE USER", () {
    test("Should call saveUser and return Right(null)", () async {
      when(() => mockLocal.saveUser(userModel)).thenAnswer((_) async {});

      final result = await repository.saveUser(userModel);

      expect(result, const Right(null));
      verify(() => mockLocal.saveUser(userModel)).called(1);
    });

    test("Should return CacheFailure when exception thrown", () async {
      when(() => mockLocal.saveUser(userModel))
          .thenThrow(Exception("Cache error"));

      final result = await repository.saveUser(userModel);

      expect(result.isLeft(), true);
      expect(result.fold((l) => l is CacheFailure, (_) => false), true);
    });
  });

  // ================= LOGOUT =================

  group("LOGOUT", () {
    test("Should clear remote, local, and token when success", () async {
      when(() => mockRemote.logout())
          .thenAnswer((_) async => ApiResponse(message: "OK"));

      when(() => mockLocal.clearUser()).thenAnswer((_) async {});

      when(() => mockToken.clearToken()).thenAnswer((_) async {});

      final result = await repository.logOut();

      expect(result, const Right(null));

      verify(() => mockRemote.logout()).called(1);
      verify(() => mockLocal.clearUser()).called(1);
      verify(() => mockToken.clearToken()).called(1);
    });

    test("Should return ServerFailure when ApiException thrown", () async {
      when(() => mockRemote.logout())
          .thenThrow(ApiException(401, "Unauthorized"));

      final result = await repository.logOut();

      expect(result, Left(ServerFailure(message: "Unauthorized")));
    });

    test("Should return CacheFailure when local clearUser fails", () async {
      when(() => mockRemote.logout())
          .thenAnswer((_) async => ApiResponse(message: "OK"));

      when(() => mockLocal.clearUser()).thenThrow(Exception("Local error"));

      final result = await repository.logOut();

      expect(result.isLeft(), true);
      expect(result.fold((l) => l is CacheFailure, (_) => false), true);
    });

    test("Should return CacheFailure when unknown exception thrown", () async {
      when(() => mockRemote.logout())
          .thenAnswer((_) async => throw Exception("Unknown"));

      final result = await repository.logOut();

      expect(result.isLeft(), true);
      expect(result.fold((l) => l is CacheFailure, (_) => false), true);
    });
  });
}
