import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/core/services/network/api_response.dart';
import 'package:workorder_company_app/features/forms/data/model/form_model.dart';
import 'package:workorder_company_app/features/positions/data/models/position_model.dart';
import 'package:workorder_company_app/features/services/data/datasources/internal_services_management_remote_datasource.dart';
import 'package:workorder_company_app/features/services/data/datasources/public_services_remote_datasource.dart';
import 'package:workorder_company_app/features/services/data/model/service_model.dart';
import 'package:workorder_company_app/features/services/data/model/service_request_config_model.dart';
import 'package:workorder_company_app/features/services/data/model/service_summary_model.dart';
import 'package:workorder_company_app/features/services/data/model/work_order_config_model.dart';
import 'package:workorder_company_app/features/services/data/repositories/services_repository_impl.dart';

// ── Mocks ─────────────────────────────────────────────────────────────────
class MockInternalServicesRemoteDatasource extends Mock
    implements InternalServicesManagementRemoteDatasource {}

class MockPublicServicesRemoteDatasource extends Mock
    implements PublicServicesRemoteDatasource {}

void main() {
  late MockInternalServicesRemoteDatasource mockInternalRemote;
  late MockPublicServicesRemoteDatasource mockPublicRemote;
  late ServicesRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(ServiceModel(
      id: 'fallback',
      title: 'Fallback',
      isActive: true,
      accessType: ServiceAccessType.public,
      serviceRequestConfig: ServiceRequestConfigModel(
        intakeForm: FormModel(
            id: 'f', title: 't', formType: FormType.workOrder, description: 'desc', fields: const []),
        reviewForm: FormModel(
            id: 'f', title: 't', formType: FormType.workOrder, description: 'desc', fields: const []),
        serviceRequestApprovalAccessType: ServiceRequestApprovalAccess.manager,
        reviewNeed: true,
      ),
      workOrdersConfig: const [],
      workOrderDraftingType: WorkOrderDraftingType.manual,
    ));
  });

  setUp(() {
    mockInternalRemote = MockInternalServicesRemoteDatasource();
    mockPublicRemote = MockPublicServicesRemoteDatasource();
    repository = ServicesRepositoryImpl(mockInternalRemote, mockPublicRemote);
  });

  // ── Helpers / Fixtures ──────────────────────────────────────────────────
  FormModel makeFormModel({String id = 'form-123'}) {
    return FormModel(
      id: id,
      title: 'Form Title',
      formType: FormType.workOrder,
      description: 'Test description',
      position: null,
      fields: const [],
    );
  }

  PositionModel makePositionModel() {
    return const PositionModel(
      id: 'pos-123',
      name: 'Tech',
      description: 'Test position',
      isActive: true,
    );
  }

  ServiceModel makeServiceModel({String id = 'srv-123', bool isActive = true}) {
    return ServiceModel(
      id: id,
      title: 'Plumbing',
      description: 'Plumbing service',
      accessType: ServiceAccessType.public,
      isActive: isActive,
      serviceRequestConfig: ServiceRequestConfigModel(
        intakeForm: makeFormModel(id: 'f-intake'),
        reviewForm: makeFormModel(id: 'f-review'),
        serviceRequestApprovalAccessType: ServiceRequestApprovalAccess.manager,
        reviewNeed: true,
      ),
      workOrdersConfig: [
        WorkOrderConfigModel(
          workOrderForm: makeFormModel(id: 'f-wo'),
          workReportForm: makeFormModel(id: 'f-wr'),
          positionOnDuty: makePositionModel(),
          workOrderAprrovalAccessType: WorkOrderAprrovalAccess.staffPic,
          workReportApprovalAccessType: WorkReportApprovalAccess.manager,
          minStaff: 1,
          maxStaff: 3,
          showReportToRequester: true,
        ),
      ],
      workOrderDraftingType: WorkOrderDraftingType.manual,
      price: 200000,
    );
  }

  ServiceSummaryModel makeServiceSummaryModel({String id = 'srv-123'}) {
    return ServiceSummaryModel(
      id: id,
      title: 'Plumbing',
      description: 'Plumbing service',
      accessType: ServiceAccessType.public,
      isActive: true,
      price: 200000,
    );
  }

  ApiResponse<ServiceModel> makeSingleResponse(ServiceModel data) => ApiResponse(
        message: 'success',
        data: data,
      );

  ApiResponse<List<ServiceSummaryModel>> makeListResponse(
          List<ServiceSummaryModel> list) =>
      ApiResponse(
        message: 'success',
        data: list,
      );

  // ═══════════════════════════════════════════════════════════════════════
  // createService  │  Cyclomatic Complexity = 1
  //                │  Paths: success merges into cache & notifies, failure returns Failure
  // ═══════════════════════════════════════════════════════════════════════
  group('createService —', () {
    final srvInput = makeServiceModel(id: 'srv-new');
    final srvOutput = makeServiceModel(id: 'srv-new');

    /// I1: returns Right(ServiceEntity), updates cache, and emits cacheChanged event.
    test('I1: returns Right(ServiceEntity), updates cache, and emits cacheChanged event on success', () async {
      // Seed cache first
      when(() => mockInternalRemote.getServices())
          .thenAnswer((_) async => makeListResponse([makeServiceSummaryModel(id: 'srv-existing')]));
      await repository.getServices(forceRefresh: false);

      when(() => mockInternalRemote.createService(any()))
          .thenAnswer((_) async => makeSingleResponse(srvOutput));

      final expectation = expectLater(repository.cacheChanged, emits(null));

      final result = await repository.createService(srvInput);

      expect(result.isRight(), isTrue);
      await expectation;

      verify(() => mockInternalRemote.createService(any())).called(1);

      // Verify merged cache
      clearInteractions(mockInternalRemote);
      final cacheCheck = await repository.getServices(forceRefresh: false);
      cacheCheck.fold(
        (l) => fail('Should be Right'),
        (r) {
          expect(r.length, 2);
          expect(r.any((e) => e.id == 'srv-new'), isTrue);
        },
      );
      verifyNever(() => mockInternalRemote.getServices());
    });

    /// I2: returns Left(ServerFailure) when remote fails.
    test('I2: returns Left(ServerFailure) when remote fails', () async {
      when(() => mockInternalRemote.createService(any()))
          .thenThrow(ApiException(400, 'Bad request'));

      final changeEvents = [];
      final sub = repository.cacheChanged.listen((_) {
        changeEvents.add(null);
      });

      final result = await repository.createService(srvInput);

      expect(result.isLeft(), isTrue);
      expect(changeEvents, isEmpty);
      sub.cancel();
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // getPublicServices  │  Cyclomatic Complexity = 1
  //                    │  Paths: success returns Right(List), failure returns Left(Failure)
  // ═══════════════════════════════════════════════════════════════════════
  group('getPublicServices —', () {
    const companyId = 'company-123';
    final summary = makeServiceSummaryModel();

    /// I3: returns Right(List<ServiceSummaryEntity>) on success.
    test('I3: returns Right(List<ServiceSummaryEntity>) on success', () async {
      when(() => mockPublicRemote.getPublicServices(companyId))
          .thenAnswer((_) async => makeListResponse([summary]));

      final result = await repository.getPublicServices(companyId);

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Should be Right'),
        (r) {
          expect(r.length, 1);
          expect(r.first.id, 'srv-123');
        },
      );
      verify(() => mockPublicRemote.getPublicServices(companyId)).called(1);
    });

    /// I4: returns Left(ServerFailure) when remote fails.
    test('I4: returns Left(ServerFailure) when remote fails', () async {
      when(() => mockPublicRemote.getPublicServices(companyId))
          .thenThrow(ApiException(500, 'Server error'));

      final result = await repository.getPublicServices(companyId);

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
  // getServiceById  │  Cyclomatic Complexity = 1
  //                 │  Paths: success returns Right(ServiceEntity), failure returns Left(Failure)
  // ═══════════════════════════════════════════════════════════════════════
  group('getServiceById —', () {
    const id = 'srv-123';
    final service = makeServiceModel(id: id);

    /// I5: returns Right(ServiceEntity) on success.
    test('I5: returns Right(ServiceEntity) on success', () async {
      when(() => mockInternalRemote.getServiceById(id))
          .thenAnswer((_) async => makeSingleResponse(service));

      final result = await repository.getServiceById(id);

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Should be Right'),
        (r) => expect(r.id, id),
      );
      verify(() => mockInternalRemote.getServiceById(id)).called(1);
    });

    /// I6: returns Left(ServerFailure) when remote fails.
    test('I6: returns Left(ServerFailure) when remote fails', () async {
      when(() => mockInternalRemote.getServiceById(id))
          .thenThrow(ApiException(404, 'Not found'));

      final result = await repository.getServiceById(id);

      expect(result.isLeft(), isTrue);
      result.fold(
        (l) {
          expect(l, isA<ServerFailure>());
          expect(l.message, 'Not found');
        },
        (r) => fail('Should be Left'),
      );
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // getServices  │  Cyclomatic Complexity = 1
  //              │  Paths: cache hit, cache miss, cache bypass, remote failure
  // ═══════════════════════════════════════════════════════════════════════
  group('getServices —', () {
    final summary = makeServiceSummaryModel();

    /// I7: returns cached list without calling remote when cache is valid and forceRefresh is false.
    test('I7: returns cached list without calling remote when cache is valid and forceRefresh is false', () async {
      when(() => mockInternalRemote.getServices())
          .thenAnswer((_) async => makeListResponse([summary]));

      // Seed cache
      final firstResult = await repository.getServices(forceRefresh: false);
      expect(firstResult.isRight(), isTrue);
      verify(() => mockInternalRemote.getServices()).called(1);
      clearInteractions(mockInternalRemote);

      // Hit cache
      final secondResult = await repository.getServices(forceRefresh: false);
      expect(secondResult.isRight(), isTrue);
      secondResult.fold(
        (l) => fail('Should be Right'),
        (r) => expect(r.first.id, 'srv-123'),
      );
      verifyNever(() => mockInternalRemote.getServices());
    });

    /// I8: calls remote, returns Right(data), and updates cache when cache is empty.
    test('I8: calls remote, returns Right(data), and updates cache when cache is empty', () async {
      when(() => mockInternalRemote.getServices())
          .thenAnswer((_) async => makeListResponse([summary]));

      final result = await repository.getServices(forceRefresh: false);

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Should be Right'),
        (r) {
          expect(r.length, 1);
          expect(r.first.id, 'srv-123');
        },
      );
      verify(() => mockInternalRemote.getServices()).called(1);
    });

    /// I9: calls remote even if cache is seeded when forceRefresh is true.
    test('I9: calls remote even if cache is seeded when forceRefresh is true', () async {
      final srv1 = makeServiceSummaryModel(id: 'srv-1');
      final srv2 = makeServiceSummaryModel(id: 'srv-2');

      when(() => mockInternalRemote.getServices())
          .thenAnswer((_) async => makeListResponse([srv1]));

      // Seed cache
      await repository.getServices(forceRefresh: false);
      verify(() => mockInternalRemote.getServices()).called(1);
      clearInteractions(mockInternalRemote);

      // Force refresh
      when(() => mockInternalRemote.getServices())
          .thenAnswer((_) async => makeListResponse([srv2]));

      final result = await repository.getServices(forceRefresh: true);

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Should be Right'),
        (r) => expect(r.first.id, 'srv-2'),
      );
      verify(() => mockInternalRemote.getServices()).called(1);
    });

    /// I10: returns Left(ServerFailure) when remote fails.
    test('I10: returns Left(ServerFailure) when remote fails', () async {
      when(() => mockInternalRemote.getServices())
          .thenThrow(ApiException(500, 'Server Error'));

      final result = await repository.getServices(forceRefresh: false);

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
  // updateService  │  Cyclomatic Complexity = 1
  //                │  Paths: success updates cache & notifies, failure returns Failure
  // ═══════════════════════════════════════════════════════════════════════
  group('updateService —', () {
    final oldSrv = makeServiceModel(id: 'srv-update', isActive: true);
    final updatedSrv = makeServiceModel(id: 'srv-update', isActive: false);

    /// I11: returns Right(ServiceEntity), updates cache, and emits cacheChanged event.
    test('I11: returns Right(ServiceEntity), updates cache, and emits cacheChanged event on success', () async {
      // Seed cache
      when(() => mockInternalRemote.getServices())
          .thenAnswer((_) async => makeListResponse([makeServiceSummaryModel(id: 'srv-update')]));
      await repository.getServices(forceRefresh: false);

      when(() => mockInternalRemote.updateService(any()))
          .thenAnswer((_) async => makeSingleResponse(updatedSrv));

      final expectation = expectLater(repository.cacheChanged, emits(null));

      final result = await repository.updateService(oldSrv);

      expect(result.isRight(), isTrue);
      await expectation;

      verify(() => mockInternalRemote.updateService(any())).called(1);

      // Verify updated cache
      clearInteractions(mockInternalRemote);
      final cacheCheck = await repository.getServices(forceRefresh: false);
      cacheCheck.fold(
        (l) => fail('Should be Right'),
        (r) {
          expect(r.length, 1);
          expect(r.first.isActive, isFalse);
        },
      );
      verifyNever(() => mockInternalRemote.getServices());
    });

    /// I12: returns Left(ServerFailure) when remote fails.
    test('I12: returns Left(ServerFailure) when remote fails', () async {
      when(() => mockInternalRemote.updateService(any()))
          .thenThrow(ApiException(403, 'Forbidden'));

      final changeEvents = [];
      final sub = repository.cacheChanged.listen((_) {
        changeEvents.add(null);
      });

      final result = await repository.updateService(oldSrv);

      expect(result.isLeft(), isTrue);
      expect(changeEvents, isEmpty);
      sub.cancel();
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // removeService  │  Cyclomatic Complexity = 1
  //                │  Paths: success removes from cache & notifies, failure returns Failure
  // ═══════════════════════════════════════════════════════════════════════
  group('removeService —', () {
    const id = 'srv-remove';
    final srvOutput = makeServiceModel(id: id);

    /// I13: returns Right(ServiceEntity), removes from cache, and emits cacheChanged event.
    test('I13: returns Right(ServiceEntity), removes from cache, and emits cacheChanged event on success', () async {
      // Seed cache
      when(() => mockInternalRemote.getServices())
          .thenAnswer((_) async => makeListResponse([makeServiceSummaryModel(id: id)]));
      await repository.getServices(forceRefresh: false);

      when(() => mockInternalRemote.removeService(id))
          .thenAnswer((_) async => makeSingleResponse(srvOutput));

      final expectation = expectLater(repository.cacheChanged, emits(null));

      final result = await repository.removeService(id);

      expect(result.isRight(), isTrue);
      await expectation;

      verify(() => mockInternalRemote.removeService(id)).called(1);

      // Verify removed from cache
      clearInteractions(mockInternalRemote);
      final cacheCheck = await repository.getServices(forceRefresh: false);
      cacheCheck.fold(
        (l) => fail('Should be Right'),
        (r) => expect(r, isEmpty),
      );
      verifyNever(() => mockInternalRemote.getServices());
    });

    /// I14: returns Left(ServerFailure) when remote fails.
    test('I14: returns Left(ServerFailure) when remote fails', () async {
      when(() => mockInternalRemote.removeService(id))
          .thenThrow(ApiException(400, 'Bad request'));

      final changeEvents = [];
      final sub = repository.cacheChanged.listen((_) {
        changeEvents.add(null);
      });

      final result = await repository.removeService(id);

      expect(result.isLeft(), isTrue);
      expect(changeEvents, isEmpty);
      sub.cancel();
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // toggleActiveStatus  │  Cyclomatic Complexity = 1
  //                      │  Paths: success updates cache & notifies, failure returns Failure
  // ═══════════════════════════════════════════════════════════════════════
  group('toggleActiveStatus —', () {
    final oldSrv = makeServiceModel(id: 'srv-toggle', isActive: true);
    final updatedSrv = makeServiceModel(id: 'srv-toggle', isActive: false);

    /// I15: returns Right(ServiceEntity), merges into cache, and emits cacheChanged event.
    test('I15: returns Right(ServiceEntity), merges into cache, and emits cacheChanged event on success', () async {
      // Seed cache
      when(() => mockInternalRemote.getServices())
          .thenAnswer((_) async => makeListResponse([makeServiceSummaryModel(id: 'srv-toggle')]));
      await repository.getServices(forceRefresh: false);

      when(() => mockInternalRemote.toggleActive(any()))
          .thenAnswer((_) async => makeSingleResponse(updatedSrv));

      final expectation = expectLater(repository.cacheChanged, emits(null));

      final result = await repository.toggleActiveStatus(oldSrv);

      expect(result.isRight(), isTrue);
      await expectation;

      verify(() => mockInternalRemote.toggleActive(any())).called(1);

      // Verify updated cache
      clearInteractions(mockInternalRemote);
      final cacheCheck = await repository.getServices(forceRefresh: false);
      cacheCheck.fold(
        (l) => fail('Should be Right'),
        (r) {
          expect(r.length, 1);
          expect(r.first.isActive, isFalse);
        },
      );
      verifyNever(() => mockInternalRemote.getServices());
    });

    /// I16: returns Left(ServerFailure) when remote fails.
    test('I16: returns Left(ServerFailure) when remote fails', () async {
      when(() => mockInternalRemote.toggleActive(any()))
          .thenThrow(ApiException(403, 'Forbidden'));

      final changeEvents = [];
      final sub = repository.cacheChanged.listen((_) {
        changeEvents.add(null);
      });

      final result = await repository.toggleActiveStatus(oldSrv);

      expect(result.isLeft(), isTrue);
      expect(changeEvents, isEmpty);
      sub.cancel();
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // clearCache  │  Cyclomatic Complexity = 1
  //             │  Paths: clear cache causes subsequent getServices to hit remote
  // ═══════════════════════════════════════════════════════════════════════
  group('clearCache —', () {
    /// I17: clears cache causing subsequent call to hit remote.
    test('I17: clears cache causing subsequent getServices to hit remote', () async {
      final summary = makeServiceSummaryModel();
      when(() => mockInternalRemote.getServices())
          .thenAnswer((_) async => makeListResponse([summary]));

      // Seed cache
      await repository.getServices(forceRefresh: false);
      verify(() => mockInternalRemote.getServices()).called(1);
      clearInteractions(mockInternalRemote);

      // Clear cache
      repository.clearCache();

      // Subsequent call hits remote
      await repository.getServices(forceRefresh: false);
      verify(() => mockInternalRemote.getServices()).called(1);
    });
  });
}
