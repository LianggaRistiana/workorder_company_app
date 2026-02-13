import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/core/error/failures.dart';
import 'package:workorder_company_app/core/network/api_response.dart';
import 'package:workorder_company_app/features/company/data/datasources/company_remote_datasource.dart';
import 'package:workorder_company_app/features/company/data/models/company_model.dart';
import 'package:workorder_company_app/features/company/data/repositories/company_repository_impl.dart';
import 'package:workorder_company_app/features/services/data/models/service_model.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';

class MockCompanyRemoteDatasource extends Mock
    implements CompanyRemoteDatasource {}

void main() {
  late CompanyRepositoryImpl repository;
  late MockCompanyRemoteDatasource mockRemote;

  setUp(() {
    mockRemote = MockCompanyRemoteDatasource();
    repository = CompanyRepositoryImpl(mockRemote);
  });

  final tCompany = CompanyModel(
    id: "1",
    name: "Test Company",
    address: "Test Address",
    description: "Test Description",
    isActive: true,
  );

  final tService = ServiceModel(
    id: "1",
    title: "Test Service",
    description: "Desc",
    requiredStaff: [],
    clientIntakeForms: [],
    workOrderForms: [],
    reportForms: [],
    accessType: ServiceAccessType.public,
    isActive: true,
  );

  // =====================================================
  // ================= GET COMPANIES =====================
  // =====================================================

  group("GET COMPANIES", () {
    test("Success - return list", () async {
      when(() => mockRemote.getCompanies()).thenAnswer(
        (_) async => ApiResponse(message: "OK", data: [tCompany]),
      );

      final result = await repository.getCompanies();

      expect(result.isRight(), true);
      result.fold(
        (_) => fail("Should be Right"),
        (r) {
          expect(r.length, 1);
          expect(r.first.id, "1");
        },
      );
    });

    test("Success - data null return empty list", () async {
      when(() => mockRemote.getCompanies())
          .thenAnswer((_) async => ApiResponse(message: "OK", data: null));

      final result = await repository.getCompanies();

      expect(result.isRight(), true);
      result.fold(
        (_) => fail("Should be Right"),
        (r) => expect(r.isEmpty, true),
      );
    });

    test("400 -> ServerFailure", () async {
      when(() => mockRemote.getCompanies())
          .thenThrow(ApiException(400, "Bad Request"));

      final result = await repository.getCompanies();

      expect(result,
          const Left(ServerFailure(message: "Bad Request")));
    });

    test("401 -> AuthFailure", () async {
      when(() => mockRemote.getCompanies())
          .thenThrow(ApiException(401, "Unauthorized"));

      final result = await repository.getCompanies();

      expect(result,
          const Left(AuthFailure(message: "Unauthorized")));
    });

    test("403 -> AuthFailure", () async {
      when(() => mockRemote.getCompanies())
          .thenThrow(ApiException(403, "Forbidden"));

      final result = await repository.getCompanies();

      expect(result,
          const Left(AuthFailure(message: "Forbidden")));
    });

    test("404 -> ServerFailure", () async {
      when(() => mockRemote.getCompanies())
          .thenThrow(ApiException(404, "Not Found"));

      final result = await repository.getCompanies();

      expect(result,
          const Left(ServerFailure(message: "Not Found")));
    });

    test("500 -> ServerFailure default message", () async {
      when(() => mockRemote.getCompanies())
          .thenThrow(ApiException(500, "Server Error"));

      final result = await repository.getCompanies();

      expect(result,
          const Left(ServerFailure(message: "Server Sedang Gangguan")));
    });

    test("NetworkException -> NetworkFailure", () async {
      when(() => mockRemote.getCompanies())
          .thenThrow(NetworkException("No internet"));

      final result = await repository.getCompanies();

      expect(result,
          const Left(NetworkFailure(message: "No internet")));
    });

    test("CacheException -> CacheFailure", () async {
      when(() => mockRemote.getCompanies())
          .thenThrow(CacheException("Cache error"));

      final result = await repository.getCompanies();

      expect(result,
          const Left(CacheFailure(message: "Cache error")));
    });

    test("ParsingException -> ParsingFailure", () async {
      when(() => mockRemote.getCompanies())
          .thenThrow(ParsingException("Invalid"));

      final result = await repository.getCompanies();

      expect(result,
          const Left(ParsingFailure(message: "Invalid data format")));
    });

    test("FormatException -> ParsingFailure", () async {
      when(() => mockRemote.getCompanies())
          .thenThrow(FormatException());

      final result = await repository.getCompanies();

      expect(result,
          const Left(ParsingFailure(message: "Invalid data format")));
    });

    test("Generic Exception -> UnexpectedFailure", () async {
      when(() => mockRemote.getCompanies())
          .thenThrow(Exception("Unknown"));

      final result = await repository.getCompanies();

      expect(result.fold((l) => l, (_) => null),
          isA<UnexpectedFailure>());
    });

    
  });

  // =====================================================
  // ================= GET COMPANY BY ID =================
  // =====================================================

  group("GET COMPANY BY ID", () {
    const id = "1";

    test("Success", () async {
      when(() => mockRemote.getCompanyById(id)).thenAnswer(
        (_) async => ApiResponse(message: "OK", data: tCompany),
      );

      final result = await repository.getCompanyById(id);

      expect(result.isRight(), true);
    });
  });

  // =====================================================
  // ================= GET COMPANY SERVICE ===============
  // =====================================================

  group("GET COMPANY SERVICE", () {
    const id = "1";

    test("Success", () async {
      when(() => mockRemote.getCompanyService(id)).thenAnswer(
        (_) async => ApiResponse(message: "OK", data: [tService]),
      );

      final result = await repository.getCompanyService(id);

      expect(result.isRight(), true);
    });

    test("Success - null return empty list", () async {
      when(() => mockRemote.getCompanyService(id))
          .thenAnswer((_) async => ApiResponse(message: "OK", data: null));

      final result = await repository.getCompanyService(id);

      result.fold(
        (_) => fail("Should be Right"),
        (r) => expect(r.isEmpty, true),
      );
    });
  });
}
