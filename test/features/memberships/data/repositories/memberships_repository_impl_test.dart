import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workorder_company_app/core/constants/app_enums/system_integration_enum.dart';
import 'package:workorder_company_app/core/constants/app_enums/user_enum.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/core/services/network/api_response.dart';
import 'package:workorder_company_app/features/memberships/data/datasources/memberships_remote_datasource.dart';
import 'package:workorder_company_app/features/memberships/data/model/member_model.dart';
import 'package:workorder_company_app/features/memberships/data/model/membership_code_model.dart';
import 'package:workorder_company_app/features/memberships/data/repositories/memberships_repository_impl.dart';
import 'package:workorder_company_app/features/system_integration/data/model/external_user_model.dart';
import 'package:workorder_company_app/features/company/data/models/company_model.dart';
import 'package:workorder_company_app/features/auth/data/model/user_model.dart';

// ── Mocks ─────────────────────────────────────────────────────────────────
class MockMembershipsRemoteDatasource extends Mock implements MembershipsRemoteDatasource {}

void main() {
  late MockMembershipsRemoteDatasource mockRemoteDatasource;
  late MembershipsRepositoryImpl repository;

  setUp(() {
    mockRemoteDatasource = MockMembershipsRemoteDatasource();
    repository = MembershipsRepositoryImpl(mockRemoteDatasource);
  });

  // ── fixtures ──────────────────────────────────────────────────────────
  CompanyModel makeCompany() => CompanyModel(
        id: 'comp-123',
        name: 'PT Jaya',
        address: 'Jl. Raya',
        isActive: true,
        isFaqActive: false,
      );

  UserModel makeUser() => const UserModel(
        userId: 'uid-123',
        name: 'Budi',
        email: 'budi@example.com',
        role: UserRole.client,
        position: null,
      );

  ExternalUserModel makeExternalUser() => ExternalUserModel(
        id: 'ext-user-123',
        integrationType: IntegrationType.externalSystem,
        externalEmail: 'ext@example.com',
        externalName: 'External User',
        company: makeCompany(),
        pairedAt: DateTime.parse('2026-06-12T03:37:03Z'),
      );

  MembershipCodeModel makeCodeModel({String id = 'code-123'}) => MembershipCodeModel(
        id: id,
        token: 'TOKEN123',
        externalCustomerEmail: 'cust@example.com',
        externalCustomerName: 'Customer Name',
      );

  MemberModel makeMemberModel() => MemberModel(
        externalUser: makeExternalUser(),
        client: makeUser(),
      );

  ApiResponse<ExternalUserModel> makeClaimResponse() => ApiResponse(
        message: 'success',
        data: makeExternalUser(),
      );

  ApiResponse<MembershipCodeModel> makeSingleCodeResponse({String id = 'code-123'}) => ApiResponse(
        message: 'success',
        data: makeCodeModel(id: id),
      );

  ApiResponse<List<MembershipCodeModel>> makeListCodeResponse(List<MembershipCodeModel> list) => ApiResponse(
        message: 'success',
        data: list,
      );

  ApiResponse<List<MemberModel>> makeListMembersResponse(List<MemberModel> list) => ApiResponse(
        message: 'success',
        data: list,
      );

  // ═══════════════════════════════════════════════════════════════════════
  // claimMembership  │  Cyclomatic Complexity = 1
  //                  │  Paths: success returns Right, failure returns Left
  // ═══════════════════════════════════════════════════════════════════════
  group('claimMembership —', () {
    /// I1: returns Right(ExternalUserEntity) on success.
    test('I1: returns Right(ExternalUserEntity) on success', () async {
      when(() => mockRemoteDatasource.claimMembership(any(), any()))
          .thenAnswer((_) async => makeClaimResponse());

      final result = await repository.claimMembership('TOKEN123', 'comp-123');

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Should be Right'),
        (r) {
          expect(r.id, 'ext-user-123');
          expect(r.externalEmail, 'ext@example.com');
        },
      );
      verify(() => mockRemoteDatasource.claimMembership('TOKEN123', 'comp-123')).called(1);
    });

    /// I2: returns Left(ServerFailure) when remote throws.
    test('I2: returns Left(ServerFailure) when remote throws', () async {
      when(() => mockRemoteDatasource.claimMembership(any(), any()))
          .thenThrow(ApiException(400, 'Invalid token'));

      final result = await repository.claimMembership('TOKEN123', 'comp-123');

      expect(result.isLeft(), isTrue);
      result.fold(
        (l) {
          expect(l, isA<ValidationFailure>());
          expect(l.message, 'Invalid token');
        },
        (r) => fail('Should be Left'),
      );
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // deleteMemberShipCode  │  Cyclomatic Complexity = 1
  //                       │  Paths: success returns Right, failure returns Left
  // ═══════════════════════════════════════════════════════════════════════
  group('deleteMemberShipCode —', () {
    /// I3: returns Right(MembershipCodeEntity) on success.
    test('I3: returns Right(MembershipCodeEntity) on success', () async {
      when(() => mockRemoteDatasource.deleteMemberShipCode(any()))
          .thenAnswer((_) async => makeSingleCodeResponse(id: 'code-123'));

      final result = await repository.deleteMemberShipCode('code-123');

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Should be Right'),
        (r) => expect(r.id, 'code-123'),
      );
      verify(() => mockRemoteDatasource.deleteMemberShipCode('code-123')).called(1);
    });

    /// I4: returns Left(ServerFailure) when remote throws.
    test('I4: returns Left(ServerFailure) when remote throws', () async {
      when(() => mockRemoteDatasource.deleteMemberShipCode(any()))
          .thenThrow(ApiException(404, 'Code not found'));

      final result = await repository.deleteMemberShipCode('code-123');

      expect(result.isLeft(), isTrue);
      result.fold(
        (l) {
          expect(l, isA<ServerFailure>());
          expect(l.message, 'Code not found');
        },
        (r) => fail('Should be Left'),
      );
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // getMembershipCodes  │  Cyclomatic Complexity = 1
  //                     │  Paths: success returns Right, failure returns Left
  // ═══════════════════════════════════════════════════════════════════════
  group('getMembershipCodes —', () {
    /// I5: returns Right(List<MembershipCodeEntity>) on success.
    test('I5: returns Right(List<MembershipCodeEntity>) on success', () async {
      final code = makeCodeModel();
      when(() => mockRemoteDatasource.getMembershipCodes())
          .thenAnswer((_) async => makeListCodeResponse([code]));

      final result = await repository.getMembershipCodes();

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Should be Right'),
        (r) {
          expect(r.length, 1);
          expect(r.first.id, 'code-123');
        },
      );
      verify(() => mockRemoteDatasource.getMembershipCodes()).called(1);
    });

    /// I6: returns Left(ServerFailure) when remote throws.
    test('I6: returns Left(ServerFailure) when remote throws', () async {
      when(() => mockRemoteDatasource.getMembershipCodes())
          .thenThrow(ApiException(500, 'Server Error'));

      final result = await repository.getMembershipCodes();

      expect(result.isLeft(), isTrue);
      result.fold(
        (l) {
          expect(l, isA<ServerFailure>());
          expect(l.message, 'Server Sedang Gangguan');
        },
        (r) => fail('Should be Left'),
      );
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // getMembers  │  Cyclomatic Complexity = 1
  //             │  Paths: success returns Right, failure returns Left
  // ═══════════════════════════════════════════════════════════════════════
  group('getMembers —', () {
    /// I7: returns Right(List<MemberEntity>) on success.
    test('I7: returns Right(List<MemberEntity>) on success', () async {
      final member = makeMemberModel();
      when(() => mockRemoteDatasource.getMembers())
          .thenAnswer((_) async => makeListMembersResponse([member]));

      final result = await repository.getMembers();

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Should be Right'),
        (r) {
          expect(r.length, 1);
          expect(r.first.client.userId, 'uid-123');
        },
      );
      verify(() => mockRemoteDatasource.getMembers()).called(1);
    });

    /// I8: returns Left(ServerFailure) when remote throws.
    test('I8: returns Left(ServerFailure) when remote throws', () async {
      when(() => mockRemoteDatasource.getMembers())
          .thenThrow(ApiException(500, 'Server Error'));

      final result = await repository.getMembers();

      expect(result.isLeft(), isTrue);
      result.fold(
        (l) {
          expect(l, isA<ServerFailure>());
          expect(l.message, 'Server Sedang Gangguan');
        },
        (r) => fail('Should be Left'),
      );
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // uploadMembershipCsvFile  │  Cyclomatic Complexity = 1
  //                          │  Paths: success returns Right, failure returns Left
  // ═══════════════════════════════════════════════════════════════════════
  group('uploadMembershipCsvFile —', () {
    /// I9: returns Right(List<MembershipCodeEntity>) on success.
    test('I9: returns Right(List<MembershipCodeEntity>) on success', () async {
      final code = makeCodeModel();
      when(() => mockRemoteDatasource.uploadMembershipCsvFile(any()))
          .thenAnswer((_) async => makeListCodeResponse([code]));

      final result = await repository.uploadMembershipCsvFile('path/to/csv.csv');

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Should be Right'),
        (r) {
          expect(r.length, 1);
          expect(r.first.id, 'code-123');
        },
      );
      verify(() => mockRemoteDatasource.uploadMembershipCsvFile('path/to/csv.csv')).called(1);
    });

    /// I10: returns Left(ServerFailure) when remote throws.
    test('I10: returns Left(ServerFailure) when remote throws', () async {
      when(() => mockRemoteDatasource.uploadMembershipCsvFile(any()))
          .thenThrow(ApiException(400, 'Invalid CSV'));

      final result = await repository.uploadMembershipCsvFile('path/to/csv.csv');

      expect(result.isLeft(), isTrue);
      result.fold(
        (l) {
          expect(l, isA<ValidationFailure>());
          expect(l.message, 'Invalid CSV');
        },
        (r) => fail('Should be Left'),
      );
    });
  });
}
