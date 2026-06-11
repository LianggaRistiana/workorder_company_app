import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/constants/app_enums/notification_enum.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/core/services/network/api_response.dart';
import 'package:workorder_company_app/features/auth/data/model/user_model.dart';
import 'package:workorder_company_app/features/company/data/models/company_model.dart';
import 'package:workorder_company_app/features/forms/data/model/form_model.dart';
import 'package:workorder_company_app/features/forms/data/model/work_reports_filled_form_model.dart';
import 'package:workorder_company_app/features/service_request/data/datasources/requester_service_request_remote_datasource.dart';
import 'package:workorder_company_app/features/service_request/data/model/requester_service_request_model.dart';
import 'package:workorder_company_app/features/service_request/data/repositories/requester_service_request_repository_impl.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/service_request_entity.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/service_request_status_date_entity.dart';
import 'package:workorder_company_app/features/services/data/model/service_summary_model.dart';
import 'package:workorder_company_app/features/submissions/data/model/submissions_model.dart';
import 'package:workorder_company_app/features/submissions/domain/entities/submission_entity.dart';

// ── Mocks ─────────────────────────────────────────────────────────────────
class MockRequesterServiceRequestRemoteDatasource extends Mock
    implements RequesterServiceRequestRemoteDatasource {}

void main() {
  late MockRequesterServiceRequestRemoteDatasource mockRemote;
  late StreamController<ResourceType> eventBusController;
  late RequesterServiceRequestRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(SubmissionsModel(
      id: 'fallback',
      formId: 'form',
      submissionType: FormType.workOrder,
      createdAt: DateTime.now(),
      fieldsData: const [],
    ));
  });

  setUp(() {
    mockRemote = MockRequesterServiceRequestRemoteDatasource();
    eventBusController = StreamController<ResourceType>.broadcast();
    repository = RequesterServiceRequestRepositoryImpl(
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

  Map<String, dynamic> companyJson() => {
        '_id': 'co-123',
        'name': 'PT Maju Bersama',
        'address': 'Jl. Sudirman No.1',
        'description': 'Perusahaan logistik',
        'isActive': true,
        'isFaqActive': true,
      };

  Map<String, dynamic> summaryJson() => {
        '_id': 'srv-123',
        'title': 'AC Service',
        'description': 'Regular maintenance',
        'accessType': 'public',
        'isActive': true,
        'price': 150000,
      };

  RequesterServiceRequestModel makeServiceRequestModel({
    String id = 'sr-123',
    ServiceRequestStatus status = ServiceRequestStatus.received,
  }) =>
      RequesterServiceRequestModel(
        id: id,
        code: 'SR-CODE-001',
        status: status,
        service: ServiceSummaryModel.fromJson(summaryJson()),
        requestedBy: UserModel.fromJson(userJson(role: 'client')),
        approvedBy: null,
        company: CompanyModel.fromJson(companyJson()),
        intakeForm: null,
        reviewForm: null,
        statusDate: const ServiceRequestStatusDateEntity(),
      );

  FormModel makeFormModel({String id = 'form-123'}) => FormModel(
        id: id,
        title: 'Form Title',
        formType: FormType.workOrder,
        description: 'Test description',
        position: null,
        fields: const [],
      );

  WorkReportsFilledFormModel makeWorkReportsFilledFormModel() =>
      const WorkReportsFilledFormModel(
        filledForms: [],
      );

  SubmissionEntity makeSubmissionEntity() => SubmissionEntity(
        id: 'sub-123',
        formId: 'form-123',
        submissionType: FormType.workOrder,
        createdAt: DateTime.parse('2026-06-12T03:37:03Z'),
        fieldsData: const [],
      );

  ApiResponse<RequesterServiceRequestModel> makeSingleResponse(
          RequesterServiceRequestModel data) =>
      ApiResponse(
        message: 'success',
        data: data,
      );

  ApiResponse<List<RequesterServiceRequestModel>> makeListResponse(
          List<RequesterServiceRequestModel> list) =>
      ApiResponse(
        message: 'success',
        data: list,
      );

  ApiResponse<FormModel> makeFormResponse(FormModel data) => ApiResponse(
        message: 'success',
        data: data,
      );

  ApiResponse<WorkReportsFilledFormModel> makeReportResponse(
          WorkReportsFilledFormModel data) =>
      ApiResponse(
        message: 'success',
        data: data,
      );

  // ═══════════════════════════════════════════════════════════════════════
  // cancelServiceRequest  │  Cyclomatic Complexity = 1
  //                       │  Paths: success merges into cache & notifies, failure returns Left(Failure)
  // ═══════════════════════════════════════════════════════════════════════
  group('cancelServiceRequest —', () {
    const id = 'sr-123';
    final model = makeServiceRequestModel(id: id, status: ServiceRequestStatus.cancelled);

    /// I14: returns Right(RequesterServiceRequestEntity), updates cache, and emits cacheChanged event.
    test('I14: returns Right(RequesterServiceRequestEntity), updates cache, and emits cacheChanged event on success', () async {
      // Seed cache
      when(() => mockRemote.getServiceRequests())
          .thenAnswer((_) async => makeListResponse([makeServiceRequestModel(id: id)]));
      await repository.getServiceRequests(forceRefresh: false);

      when(() => mockRemote.cancelServiceRequest(id))
          .thenAnswer((_) async => makeSingleResponse(model));

      final expectation = expectLater(repository.cacheChanged, emits(null));

      final result = await repository.cancelServiceRequest(id);

      expect(result.isRight(), isTrue);
      await expectation;

      verify(() => mockRemote.cancelServiceRequest(id)).called(1);

      // Verify updated cache
      clearInteractions(mockRemote);
      final cacheCheck = await repository.getServiceRequests(forceRefresh: false);
      cacheCheck.fold(
        (l) => fail('Should be Right'),
        (r) {
          expect(r.length, 1);
          expect(r.first.status, ServiceRequestStatus.cancelled);
        },
      );
      verifyNever(() => mockRemote.getServiceRequests());
    });

    /// I15: returns Left(ValidationFailure) when remote fails (400).
    test('I15: returns Left(ValidationFailure) when remote fails', () async {
      when(() => mockRemote.cancelServiceRequest(id))
          .thenThrow(ApiException(400, 'Bad Request'));

      final result = await repository.cancelServiceRequest(id);

      expect(result.isLeft(), isTrue);
      result.fold(
        (l) => expect(l, isA<ValidationFailure>()),
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

    /// I16: returns cached list without calling remote when cache is valid and forceRefresh is false.
    test('I16: returns cached list without calling remote when cache is valid and forceRefresh is false', () async {
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

    /// I17: calls remote, returns Right(data), and updates cache when cache is empty.
    test('I17: calls remote, returns Right(data), and updates cache when cache is empty', () async {
      when(() => mockRemote.getServiceRequests())
          .thenAnswer((_) async => makeListResponse([model]));

      final result = await repository.getServiceRequests(forceRefresh: false);

      expect(result.isRight(), isTrue);
      verify(() => mockRemote.getServiceRequests()).called(1);
    });

    /// I18: calls remote even if cache is seeded when forceRefresh is true.
    test('I18: calls remote even if cache is seeded when forceRefresh is true', () async {
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

    /// I19: returns Left(ServerFailure) when remote fails (500).
    test('I19: returns Left(ServerFailure) when remote fails', () async {
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
  //                          │  Paths: success returns Right(RequesterServiceRequestEntity), failure returns Left(Failure)
  // ═══════════════════════════════════════════════════════════════════════
  group('getServiceRequestDetail —', () {
    const id = 'sr-123';
    final model = makeServiceRequestModel(id: id);

    /// I20: returns Right(RequesterServiceRequestEntity) on success.
    test('I20: returns Right(RequesterServiceRequestEntity) on success', () async {
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

    /// I21: returns Left(ServerFailure) when remote fails (404).
    test('I21: returns Left(ServerFailure) when remote fails', () async {
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
  // getIntakeForm  │  Cyclomatic Complexity = 2
  //                │  Paths: client role -> getIntakeFormForPublic, other role -> getIntakeFormForInternal
  // ═══════════════════════════════════════════════════════════════════════
  group('getIntakeForm —', () {
    const serviceId = 'srv-123';
    final form = makeFormModel();

    /// I22: client role -> returns Right(FormEntity) calling public intake form.
    test('I22: client role -> returns Right(FormEntity) calling public intake form', () async {
      when(() => mockRemote.getIntakeFormForPublic(serviceId))
          .thenAnswer((_) async => makeFormResponse(form));

      final result = await repository.getIntakeForm(serviceId, UserRole.client);

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Should be Right'),
        (r) => expect(r.id, 'form-123'),
      );
      verify(() => mockRemote.getIntakeFormForPublic(serviceId)).called(1);
      verifyNever(() => mockRemote.getIntakeFormForInternal(any()));
    });

    /// I23: client role -> returns Left(ServerFailure) when public fails.
    test('I23: client role -> returns Left(ServerFailure) when public fails', () async {
      when(() => mockRemote.getIntakeFormForPublic(serviceId))
          .thenThrow(ApiException(404, 'Not Found'));

      final result = await repository.getIntakeForm(serviceId, UserRole.client);

      expect(result.isLeft(), isTrue);
      verify(() => mockRemote.getIntakeFormForPublic(serviceId)).called(1);
    });

    /// I24: owner/staff role -> returns Right(FormEntity) calling internal intake form.
    test('I24: owner/staff role -> returns Right(FormEntity) calling internal intake form', () async {
      when(() => mockRemote.getIntakeFormForInternal(serviceId))
          .thenAnswer((_) async => makeFormResponse(form));

      final result = await repository.getIntakeForm(serviceId, UserRole.ownerCompany);

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Should be Right'),
        (r) => expect(r.id, 'form-123'),
      );
      verify(() => mockRemote.getIntakeFormForInternal(serviceId)).called(1);
      verifyNever(() => mockRemote.getIntakeFormForPublic(any()));
    });

    /// I25: owner/staff role -> returns Left(ServerFailure) when internal fails.
    test('I25: owner/staff role -> returns Left(ServerFailure) when internal fails', () async {
      when(() => mockRemote.getIntakeFormForInternal(serviceId))
          .thenThrow(ApiException(404, 'Not Found'));

      final result = await repository.getIntakeForm(serviceId, UserRole.ownerCompany);

      expect(result.isLeft(), isTrue);
      verify(() => mockRemote.getIntakeFormForInternal(serviceId)).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // submitIntakeForm  │  Cyclomatic Complexity = 1
  //                   │  Paths: success merges into cache & notifies, failure returns Left(Failure)
  // ═══════════════════════════════════════════════════════════════════════
  group('submitIntakeForm —', () {
    const serviceId = 'srv-123';
    final submission = makeSubmissionEntity();
    final model = makeServiceRequestModel(id: 'sr-new');

    /// I26: returns Right(RequesterServiceRequestEntity), updates cache, and emits cacheChanged event.
    test('I26: returns Right(RequesterServiceRequestEntity), updates cache, and emits cacheChanged event on success', () async {
      when(() => mockRemote.submitIntakeForm(serviceId, any()))
          .thenAnswer((_) async => makeSingleResponse(model));

      final expectation = expectLater(repository.cacheChanged, emits(null));

      final result = await repository.submitIntakeForm(serviceId, submission);

      expect(result.isRight(), isTrue);
      await expectation;

      verify(() => mockRemote.submitIntakeForm(serviceId, any())).called(1);
    });

    /// I27: returns Left(ValidationFailure) when remote fails (400).
    test('I27: returns Left(ValidationFailure) when remote fails', () async {
      when(() => mockRemote.submitIntakeForm(serviceId, any()))
          .thenThrow(ApiException(400, 'Bad Request'));

      final result = await repository.submitIntakeForm(serviceId, submission);

      expect(result.isLeft(), isTrue);
      result.fold(
        (l) => expect(l, isA<ValidationFailure>()),
        (r) => fail('Should be Left'),
      );
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // submitReviewForm  │  Cyclomatic Complexity = 1
  //                   │  Paths: success merges into cache & notifies, failure returns Left(Failure)
  // ═══════════════════════════════════════════════════════════════════════
  group('submitReviewForm —', () {
    const serviceRequestId = 'sr-123';
    final submission = makeSubmissionEntity();
    final model = makeServiceRequestModel(id: serviceRequestId);

    /// I28: returns Right(RequesterServiceRequestEntity), updates cache, and emits cacheChanged event.
    test('I28: returns Right(RequesterServiceRequestEntity), updates cache, and emits cacheChanged event on success', () async {
      when(() => mockRemote.submitReviewForm(serviceRequestId, any()))
          .thenAnswer((_) async => makeSingleResponse(model));

      final expectation = expectLater(repository.cacheChanged, emits(null));

      final result = await repository.submitReviewForm(serviceRequestId, submission);

      expect(result.isRight(), isTrue);
      await expectation;

      verify(() => mockRemote.submitReviewForm(serviceRequestId, any())).called(1);
    });

    /// I29: returns Left(ValidationFailure) when remote fails (400).
    test('I29: returns Left(ValidationFailure) when remote fails', () async {
      when(() => mockRemote.submitReviewForm(serviceRequestId, any()))
          .thenThrow(ApiException(400, 'Bad Request'));

      final result = await repository.submitReviewForm(serviceRequestId, submission);

      expect(result.isLeft(), isTrue);
      result.fold(
        (l) => expect(l, isA<ValidationFailure>()),
        (r) => fail('Should be Left'),
      );
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // getReviewForm  │  Cyclomatic Complexity = 1
  //                │  Paths: success returns Right(FormEntity), failure returns Left(Failure)
  // ═══════════════════════════════════════════════════════════════════════
  group('getReviewForm —', () {
    const serviceRequestId = 'sr-123';
    final form = makeFormModel();

    /// I30: returns Right(FormEntity) on success.
    test('I30: returns Right(FormEntity) on success', () async {
      when(() => mockRemote.getReviewForm(serviceRequestId))
          .thenAnswer((_) async => makeFormResponse(form));

      final result = await repository.getReviewForm(serviceRequestId);

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Should be Right'),
        (r) => expect(r.id, 'form-123'),
      );
      verify(() => mockRemote.getReviewForm(serviceRequestId)).called(1);
    });

    /// I31: returns Left(ServerFailure) when remote fails (404).
    test('I31: returns Left(ServerFailure) when remote fails', () async {
      when(() => mockRemote.getReviewForm(serviceRequestId))
          .thenThrow(ApiException(404, 'Not Found'));

      final result = await repository.getReviewForm(serviceRequestId);

      expect(result.isLeft(), isTrue);
      result.fold(
        (l) => expect(l, isA<ServerFailure>()),
        (r) => fail('Should be Left'),
      );
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // getServiceRequestReport  │  Cyclomatic Complexity = 1
  //                          │  Paths: success returns Right(WorkReportsFilledFormEntity), failure returns Left(Failure)
  // ═══════════════════════════════════════════════════════════════════════
  group('getServiceRequestReport —', () {
    const id = 'sr-123';
    final report = makeWorkReportsFilledFormModel();

    /// I32: returns Right(WorkReportsFilledFormEntity) on success.
    test('I32: returns Right(WorkReportsFilledFormEntity) on success', () async {
      when(() => mockRemote.getServiceRequestReport(id))
          .thenAnswer((_) async => makeReportResponse(report));

      final result = await repository.getServiceRequestReport(id);

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Should be Right'),
        (r) => expect(r.filledForms, isEmpty),
      );
      verify(() => mockRemote.getServiceRequestReport(id)).called(1);
    });

    /// I33: returns Left(ServerFailure) when remote fails (404).
    test('I33: returns Left(ServerFailure) when remote fails', () async {
      when(() => mockRemote.getServiceRequestReport(id))
          .thenThrow(ApiException(404, 'Not Found'));

      final result = await repository.getServiceRequestReport(id);

      expect(result.isLeft(), isTrue);
      result.fold(
        (l) => expect(l, isA<ServerFailure>()),
        (r) => fail('Should be Left'),
      );
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // clearCache  │  Cyclomatic Complexity = 1
  //             │  Paths: clear cache causes subsequent getServiceRequests to hit remote
  // ═══════════════════════════════════════════════════════════════════════
  group('clearCache —', () {
    /// I34: clears cache causing subsequent call to hit remote.
    test('I34: clears cache causing subsequent getServiceRequests to hit remote', () async {
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
  // eventBus Trigger  │  Cyclomatic Complexity = 1
  //                   │  Paths: ResourceType.serviceRequest clears cache & notifies, other events skip
  // ═══════════════════════════════════════════════════════════════════════
  group('eventBus Trigger —', () {
    /// I35: clears cache and emits cacheChanged when event is ResourceType.serviceRequest.
    test('I35: clears cache and emits cacheChanged when event is ResourceType.serviceRequest', () async {
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

    /// I36: does not clear cache when event is not ResourceType.serviceRequest.
    test('I36: does not clear cache when event is not ResourceType.serviceRequest', () async {
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
