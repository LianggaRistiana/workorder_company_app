import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/constants/app_enums/notification_enum.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/core/services/network/api_response.dart';
import 'package:workorder_company_app/features/auth/data/model/user_model.dart';
import 'package:workorder_company_app/features/service_request/data/datasources/provider_service_request_remote_datasource.dart';
import 'package:workorder_company_app/features/service_request/data/model/provider_service_request_model.dart';
import 'package:workorder_company_app/features/service_request/data/repositories/provider_service_request_repository_impl.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/service_request_entity.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/service_request_status_date_entity.dart';
import 'package:workorder_company_app/features/services/data/model/service_summary_model.dart';

// ── Mocks ─────────────────────────────────────────────────────────────────
class MockProviderServiceRequestRemoteDatasource extends Mock
    implements ProviderServiceRequestRemoteDatasource {}

void main() {
  late MockProviderServiceRequestRemoteDatasource mockRemote;
  late StreamController<ResourceType> eventBusController;
  late ProviderServiceRequestRepositoryImpl repository;

  setUp(() {
    mockRemote = MockProviderServiceRequestRemoteDatasource();
    eventBusController = StreamController<ResourceType>.broadcast();
    repository = ProviderServiceRequestRepositoryImpl(
      mockRemote,
      eventBusController.stream,
    );
  });

  tearDown(() {
    eventBusController.close();
  });

  // ── Helpers / Fixtures ──────────────────────────────────────────────────
  Map<String, dynamic> userJson({String id = 'uid-123', String role = 'client'}) => {
        '_id': id,
        'name': 'John Doe',
        'email': 'john@example.com',
        'role': role,
        'position': null,
      };

  Map<String, dynamic> summaryJson() => {
        '_id': 'srv-123',
        'title': 'AC Service',
        'description': 'Regular maintenance',
        'accessType': 'public',
        'isActive': true,
        'price': 150000,
      };

  ProviderServiceRequestModel makeServiceRequestModel({
    String id = 'sr-123',
    ServiceRequestStatus status = ServiceRequestStatus.received,
  }) =>
      ProviderServiceRequestModel(
        id: id,
        code: 'SR-CODE-001',
        status: status,
        service: ServiceSummaryModel.fromJson(summaryJson()),
        requestedBy: UserModel.fromJson(userJson(role: 'client')),
        approvedBy: null,
        reviewNeed: true,
        approvalAccess: ServiceRequestApprovalAccess.manager,
        intakeForm: null,
        reviewForm: null,
        statusDate: const ServiceRequestStatusDateEntity(),
      );

  ApiResponse<ProviderServiceRequestModel> makeSingleResponse(
          ProviderServiceRequestModel data) =>
      ApiResponse(
        message: 'success',
        data: data,
      );

  ApiResponse<List<ProviderServiceRequestModel>> makeListResponse(
          List<ProviderServiceRequestModel> list) =>
      ApiResponse(
        message: 'success',
        data: list,
      );

  // ═══════════════════════════════════════════════════════════════════════
  // approveServiceRequest  │  Cyclomatic Complexity = 1
  //                        │  Paths: success merges into cache & notifies, failure returns Left(Failure)
  // ═══════════════════════════════════════════════════════════════════════
  group('approveServiceRequest —', () {
    const id = 'sr-123';
    final model = makeServiceRequestModel(id: id, status: ServiceRequestStatus.approved);

    /// I1: returns Right(ProviderServiceRequestEntity), updates cache, and emits cacheChanged event.
    test('I1: returns Right(ProviderServiceRequestEntity), updates cache, and emits cacheChanged event on success', () async {
      // Seed cache
      when(() => mockRemote.getServiceRequests())
          .thenAnswer((_) async => makeListResponse([makeServiceRequestModel(id: id)]));
      await repository.getServiceRequests(forceRefresh: false);

      when(() => mockRemote.approveServiceRequest(id))
          .thenAnswer((_) async => makeSingleResponse(model));

      final expectation = expectLater(repository.cacheChanged, emits(null));

      final result = await repository.approveServiceRequest(id);

      expect(result.isRight(), isTrue);
      await expectation;

      verify(() => mockRemote.approveServiceRequest(id)).called(1);

      // Verify updated cache
      clearInteractions(mockRemote);
      final cacheCheck = await repository.getServiceRequests(forceRefresh: false);
      cacheCheck.fold(
        (l) => fail('Should be Right'),
        (r) {
          expect(r.length, 1);
          expect(r.first.status, ServiceRequestStatus.approved);
        },
      );
      verifyNever(() => mockRemote.getServiceRequests());
    });

    /// I2: returns Left(ValidationFailure) when remote fails (400).
    test('I2: returns Left(ValidationFailure) when remote fails', () async {
      when(() => mockRemote.approveServiceRequest(id))
          .thenThrow(ApiException(400, 'Bad Request'));

      final result = await repository.approveServiceRequest(id);

      expect(result.isLeft(), isTrue);
      result.fold(
        (l) => expect(l, isA<ValidationFailure>()),
        (r) => fail('Should be Left'),
      );
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // rejectServiceRequest  │  Cyclomatic Complexity = 1
  //                       │  Paths: success merges into cache & notifies, failure returns Left(Failure)
  // ═══════════════════════════════════════════════════════════════════════
  group('rejectServiceRequest —', () {
    const id = 'sr-123';
    final model = makeServiceRequestModel(id: id, status: ServiceRequestStatus.rejected);

    /// I3: returns Right(ProviderServiceRequestEntity), updates cache, and emits cacheChanged event.
    test('I3: returns Right(ProviderServiceRequestEntity), updates cache, and emits cacheChanged event on success', () async {
      // Seed cache
      when(() => mockRemote.getServiceRequests())
          .thenAnswer((_) async => makeListResponse([makeServiceRequestModel(id: id)]));
      await repository.getServiceRequests(forceRefresh: false);

      when(() => mockRemote.rejectServiceRequest(id))
          .thenAnswer((_) async => makeSingleResponse(model));

      final expectation = expectLater(repository.cacheChanged, emits(null));

      final result = await repository.rejectServiceRequest(id);

      expect(result.isRight(), isTrue);
      await expectation;

      verify(() => mockRemote.rejectServiceRequest(id)).called(1);

      // Verify updated cache
      clearInteractions(mockRemote);
      final cacheCheck = await repository.getServiceRequests(forceRefresh: false);
      cacheCheck.fold(
        (l) => fail('Should be Right'),
        (r) {
          expect(r.length, 1);
          expect(r.first.status, ServiceRequestStatus.rejected);
        },
      );
      verifyNever(() => mockRemote.getServiceRequests());
    });

    /// I4: returns Left(AuthFailure) when remote fails (403).
    test('I4: returns Left(AuthFailure) when remote fails', () async {
      when(() => mockRemote.rejectServiceRequest(id))
          .thenThrow(ApiException(403, 'Forbidden'));

      final result = await repository.rejectServiceRequest(id);

      expect(result.isLeft(), isTrue);
      result.fold(
        (l) => expect(l, isA<AuthFailure>()),
        (r) => fail('Should be Left'),
      );
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // getServiceRequests  │  Cyclomatic Complexity = 1
  //                     │  Paths: cache hit, cache miss, cache bypass, remote failure
  // ═══════════════════════════════════════════════════════════════════════
  group('getServiceRequests —', () {
    final model = makeServiceRequestModel();

    /// I5: returns cached list without calling remote when cache is valid and forceRefresh is false.
    test('I5: returns cached list without calling remote when cache is valid and forceRefresh is false', () async {
      when(() => mockRemote.getServiceRequests())
          .thenAnswer((_) async => makeListResponse([model]));

      // Seed cache
      await repository.getServiceRequests(forceRefresh: false);
      verify(() => mockRemote.getServiceRequests()).called(1);
      clearInteractions(mockRemote);

      // Hit cache
      final result = await repository.getServiceRequests(forceRefresh: false);
      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Should be Right'),
        (r) => expect(r.first.id, 'sr-123'),
      );
      verifyNever(() => mockRemote.getServiceRequests());
    });

    /// I6: calls remote, returns Right(data), and updates cache when cache is empty.
    test('I6: calls remote, returns Right(data), and updates cache when cache is empty', () async {
      when(() => mockRemote.getServiceRequests())
          .thenAnswer((_) async => makeListResponse([model]));

      final result = await repository.getServiceRequests(forceRefresh: false);

      expect(result.isRight(), isTrue);
      verify(() => mockRemote.getServiceRequests()).called(1);
    });

    /// I7: calls remote even if cache is seeded when forceRefresh is true.
    test('I7: calls remote even if cache is seeded when forceRefresh is true', () async {
      final m1 = makeServiceRequestModel(id: 'sr-1');
      final m2 = makeServiceRequestModel(id: 'sr-2');

      when(() => mockRemote.getServiceRequests())
          .thenAnswer((_) async => makeListResponse([m1]));

      // Seed cache
      await repository.getServiceRequests(forceRefresh: false);
      verify(() => mockRemote.getServiceRequests()).called(1);
      clearInteractions(mockRemote);

      // Force refresh
      when(() => mockRemote.getServiceRequests())
          .thenAnswer((_) async => makeListResponse([m2]));

      final result = await repository.getServiceRequests(forceRefresh: true);

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Should be Right'),
        (r) => expect(r.first.id, 'sr-2'),
      );
      verify(() => mockRemote.getServiceRequests()).called(1);
    });

    /// I8: returns Left(ServerFailure) when remote fails (500).
    test('I8: returns Left(ServerFailure) when remote fails', () async {
      when(() => mockRemote.getServiceRequests())
          .thenThrow(ApiException(500, 'Server Error'));

      final result = await repository.getServiceRequests(forceRefresh: false);

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
  // getServiceRequestDetail  │  Cyclomatic Complexity = 1
  //                          │  Paths: success returns Right(ProviderServiceRequestEntity), failure returns Left(Failure)
  // ═══════════════════════════════════════════════════════════════════════
  group('getServiceRequestDetail —', () {
    const id = 'sr-123';
    final model = makeServiceRequestModel(id: id);

    /// I9: returns Right(ProviderServiceRequestEntity) on success.
    test('I9: returns Right(ProviderServiceRequestEntity) on success', () async {
      when(() => mockRemote.getServiceRequestDetail(id))
          .thenAnswer((_) async => makeSingleResponse(model));

      final result = await repository.getServiceRequestDetail(id);

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Should be Right'),
        (r) => expect(r.id, id),
      );
      verify(() => mockRemote.getServiceRequestDetail(id)).called(1);
    });

    /// I10: returns Left(ServerFailure) when remote fails (404).
    test('I10: returns Left(ServerFailure) when remote fails', () async {
      when(() => mockRemote.getServiceRequestDetail(id))
          .thenThrow(ApiException(404, 'Not Found'));

      final result = await repository.getServiceRequestDetail(id);

      expect(result.isLeft(), isTrue);
      result.fold(
        (l) {
          expect(l, isA<ServerFailure>());
          expect(l.message, 'Not Found');
        },
        (r) => fail('Should be Left'),
      );
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // clearCache  │  Cyclomatic Complexity = 1
  //             │  Paths: clear cache causes subsequent getServiceRequests to hit remote
  // ═══════════════════════════════════════════════════════════════════════
  group('clearCache —', () {
    /// I11: clears cache causing subsequent call to hit remote.
    test('I11: clears cache causing subsequent getServiceRequests to hit remote', () async {
      final model = makeServiceRequestModel();
      when(() => mockRemote.getServiceRequests())
          .thenAnswer((_) async => makeListResponse([model]));

      // Seed cache
      await repository.getServiceRequests(forceRefresh: false);
      verify(() => mockRemote.getServiceRequests()).called(1);
      clearInteractions(mockRemote);

      // Clear cache
      repository.clearCache();

      // Subsequent call hits remote
      await repository.getServiceRequests(forceRefresh: false);
      verify(() => mockRemote.getServiceRequests()).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // eventBus Trigger  │  Cyclomatic Complexity = 1 (if check is the path under test)
  //                   │  Paths: ResourceType.serviceRequest clears cache & notifies, other events skip
  // ═══════════════════════════════════════════════════════════════════════
  group('eventBus Trigger —', () {
    /// I12: clears cache and emits cacheChanged when event is ResourceType.serviceRequest.
    test('I12: clears cache and emits cacheChanged when event is ResourceType.serviceRequest', () async {
      final model = makeServiceRequestModel();
      when(() => mockRemote.getServiceRequests())
          .thenAnswer((_) async => makeListResponse([model]));

      // Seed cache
      await repository.getServiceRequests(forceRefresh: false);
      verify(() => mockRemote.getServiceRequests()).called(1);
      clearInteractions(mockRemote);

      final expectation = expectLater(repository.cacheChanged, emits(null));

      // Trigger event
      eventBusController.add(ResourceType.serviceRequest);

      await expectation;

      // Verify cache cleared by checking that the next get hits remote
      await repository.getServiceRequests(forceRefresh: false);
      verify(() => mockRemote.getServiceRequests()).called(1);
    });

    /// I13: does not clear cache when event is not ResourceType.serviceRequest.
    test('I13: does not clear cache when event is not ResourceType.serviceRequest', () async {
      final model = makeServiceRequestModel();
      when(() => mockRemote.getServiceRequests())
          .thenAnswer((_) async => makeListResponse([model]));

      // Seed cache
      await repository.getServiceRequests(forceRefresh: false);
      verify(() => mockRemote.getServiceRequests()).called(1);
      clearInteractions(mockRemote);

      // Trigger other event
      eventBusController.add(ResourceType.invitation);

      // Wait a short time to allow stream processing
      await Future<void>.delayed(const Duration(milliseconds: 10));

      // Verify cache not cleared (subsequent call does NOT hit remote)
      await repository.getServiceRequests(forceRefresh: false);
      verifyNever(() => mockRemote.getServiceRequests());
    });
  });
}
