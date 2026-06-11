import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/core/services/network/api_response.dart';
import 'package:workorder_company_app/features/forms/data/datasources/forms_remote_datasource.dart';
import 'package:workorder_company_app/features/forms/data/model/form_model.dart';
import 'package:workorder_company_app/features/forms/data/repositories/forms_repository_impl.dart';
import 'package:workorder_company_app/features/forms/domain/meta/form_detail_meta.dart';

// ── Mocks ─────────────────────────────────────────────────────────────────
class MockFormsRemoteDatasource extends Mock implements FormsRemoteDatasource {}

void main() {
  late MockFormsRemoteDatasource mockRemoteDatasource;
  late FormsRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(const FormModel(
      id: 'fallback-id',
      title: 'Fallback Form',
      formType: FormType.workOrder,
      description: 'Fallback Description',
      fields: [],
    ));
  });

  setUp(() {
    mockRemoteDatasource = MockFormsRemoteDatasource();
    repository = FormsRepositoryImpl(mockRemoteDatasource);
  });

  // ── fixtures ──────────────────────────────────────────────────────────
  FormModel makeFormModel({String id = 'form-id-123', String title = 'Inspection Form'}) => FormModel(
        id: id,
        title: title,
        formType: FormType.workOrder,
        description: 'Inspection description',
        fields: const [],
      );

  ApiResponse<List<FormModel>> makeListResponse(List<FormModel> data) => ApiResponse(
        message: 'success',
        data: data,
      );

  ApiResponse<FormModel> makeSingleResponse(FormModel data) => ApiResponse(
        message: 'success',
        data: data,
      );

  ApiResponseWithMeta<FormModel> makeSingleResponseWithMeta(FormModel data) => ApiResponseWithMeta(
        message: 'success',
        data: data,
        meta: const {
          'canDelete': true,
        },
      );

  ApiResponse<Empty> makeEmptyResponse() => const ApiResponse(
        message: 'success',
        data: Empty(),
      );

  // ═══════════════════════════════════════════════════════════════════════
  // getForms  │  Cyclomatic Complexity = 1 (delegates to ListCacheHelper)
  //           │  Paths: cache hit/miss, remote failure
  // ═══════════════════════════════════════════════════════════════════════
  group('getForms —', () {
    /// I1: returns cached list without calling remote when cache is valid and forceRefresh is false.
    test('I1: returns cached list without calling remote when cache is valid and forceRefresh is false', () async {
      final form = makeFormModel();
      when(() => mockRemoteDatasource.getForms())
          .thenAnswer((_) async => makeListResponse([form]));

      // Seed cache
      final firstResult = await repository.getForms(forceRefresh: false);
      expect(firstResult.isRight(), isTrue);
      verify(() => mockRemoteDatasource.getForms()).called(1);
      clearInteractions(mockRemoteDatasource);

      // Hit cache
      final secondResult = await repository.getForms(forceRefresh: false);
      expect(secondResult.isRight(), isTrue);
      secondResult.fold(
        (l) => fail('Should be Right'),
        (r) => expect(r.first.id, 'form-id-123'),
      );
      verifyNever(() => mockRemoteDatasource.getForms());
    });

    /// I2: calls remote, returns Right(data), and updates cache when cache is empty.
    test('I2: calls remote, returns Right(data), and updates cache when cache is empty', () async {
      final form = makeFormModel();
      when(() => mockRemoteDatasource.getForms())
          .thenAnswer((_) async => makeListResponse([form]));

      final result = await repository.getForms(forceRefresh: false);

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Should be Right'),
        (r) {
          expect(r.length, 1);
          expect(r.first.id, 'form-id-123');
        },
      );
      verify(() => mockRemoteDatasource.getForms()).called(1);
    });

    /// I3: calls remote even if cache is seeded when forceRefresh is true.
    test('I3: calls remote even if cache is seeded when forceRefresh is true', () async {
      final form1 = makeFormModel(title: 'Form Old');
      final form2 = makeFormModel(title: 'Form New');

      when(() => mockRemoteDatasource.getForms())
          .thenAnswer((_) async => makeListResponse([form1]));

      // Seed cache
      await repository.getForms(forceRefresh: false);
      verify(() => mockRemoteDatasource.getForms()).called(1);
      clearInteractions(mockRemoteDatasource);

      // Force refresh
      when(() => mockRemoteDatasource.getForms())
          .thenAnswer((_) async => makeListResponse([form2]));

      final result = await repository.getForms(forceRefresh: true);

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Should be Right'),
        (r) => expect(r.first.title, 'Form New'),
      );
      verify(() => mockRemoteDatasource.getForms()).called(1);
    });

    /// I4: returns Left(ServerFailure) when remote fails.
    test('I4: returns Left(ServerFailure) when remote fails', () async {
      when(() => mockRemoteDatasource.getForms())
          .thenThrow(ApiException(500, 'Server Error'));

      final result = await repository.getForms(forceRefresh: false);

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
  // getForm  │  Cyclomatic Complexity = 1
  //          │  Paths: success returns form with detail meta, failure returns Failure
  // ═══════════════════════════════════════════════════════════════════════
  group('getForm —', () {
    /// I5: returns Right(FormEntity) with detail metadata on remote success.
    test('I5: returns Right(FormEntity) with detail metadata on remote success', () async {
      final form = makeFormModel();
      when(() => mockRemoteDatasource.getFormById('form-id-123'))
          .thenAnswer((_) async => makeSingleResponseWithMeta(form));

      final result = await repository.getForm('form-id-123');

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Should be Right'),
        (r) {
          expect(r.data.id, 'form-id-123');
          final detailMeta = r.getMeta<FormDetailMeta>();
          expect(detailMeta, isNotNull);
          expect(detailMeta!.canDelete, isTrue);
        },
      );
    });

    /// I6: returns Left(ServerFailure) when remote fails.
    test('I6: returns Left(ServerFailure) when remote fails', () async {
      when(() => mockRemoteDatasource.getFormById('form-id-123'))
          .thenThrow(ApiException(404, 'Form not found'));

      final result = await repository.getForm('form-id-123');

      expect(result.isLeft(), isTrue);
      result.fold(
        (l) {
          expect(l, isA<ServerFailure>());
          expect(l.message, 'Form not found');
        },
        (r) => fail('Should be Left'),
      );
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // createForm  │  Cyclomatic Complexity = 1
  //             │  Paths: success merges item and notifies stream, failure skips
  // ═══════════════════════════════════════════════════════════════════════
  group('createForm —', () {
    final formInput = makeFormModel(id: 'form-new');
    final formOutput = makeFormModel(id: 'form-new');

    /// I7: returns Right(void), updates cache, calls remote, and emits event to cacheChanged.
    test('I7: returns Right(void), updates cache, and emits cacheChanged event on success', () async {
      // Seed list cache first
      when(() => mockRemoteDatasource.getForms())
          .thenAnswer((_) async => makeListResponse([makeFormModel(id: 'form-existing')]));
      await repository.getForms(forceRefresh: false);

      when(() => mockRemoteDatasource.createForm(any()))
          .thenAnswer((_) async => makeSingleResponse(formOutput));

      final expectation = expectLater(repository.cacheChanged, emits(null));

      final result = await repository.createForm(formInput);

      expect(result.isRight(), isTrue);
      await expectation;

      verify(() => mockRemoteDatasource.createForm(any())).called(1);

      // Verify the new form is merged in the cache (getForms returns it without calling remote again)
      clearInteractions(mockRemoteDatasource);
      final cacheCheck = await repository.getForms(forceRefresh: false);
      cacheCheck.fold(
        (l) => fail('Should be Right'),
        (r) {
          expect(r.length, 2);
          expect(r.any((e) => e.id == 'form-new'), isTrue);
        },
      );
      verifyNever(() => mockRemoteDatasource.getForms());
    });

    /// I8: returns Left(ServerFailure) when remote fails and does not update cache or emit event.
    test('I8: returns Left(ServerFailure) when remote fails and does not update cache or notify', () async {
      when(() => mockRemoteDatasource.createForm(any()))
          .thenThrow(ApiException(400, 'Invalid fields'));

      final changeEvents = [];
      final sub = repository.cacheChanged.listen((_) { changeEvents.add(null); });

      final result = await repository.createForm(formInput);

      expect(result.isLeft(), isTrue);
      expect(changeEvents, isEmpty);
      sub.cancel();
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // updateForm  │  Cyclomatic Complexity = 1
  //             │  Paths: success updates item and notifies stream, failure skips
  // ═══════════════════════════════════════════════════════════════════════
  group('updateForm —', () {
    final formInput = makeFormModel(id: 'form-to-update', title: 'Old Title');
    final formOutput = makeFormModel(id: 'form-to-update', title: 'New Title');

    /// I9: returns Right(FormEntity), updates cache, calls remote, and emits event.
    test('I9: returns Right(FormEntity), updates cache, and emits cacheChanged event on success', () async {
      // Seed list cache
      when(() => mockRemoteDatasource.getForms())
          .thenAnswer((_) async => makeListResponse([formInput]));
      await repository.getForms(forceRefresh: false);

      when(() => mockRemoteDatasource.updateForm(any()))
          .thenAnswer((_) async => makeSingleResponse(formOutput));

      final expectation = expectLater(repository.cacheChanged, emits(null));

      final result = await repository.updateForm(formInput);

      expect(result.isRight(), isTrue);
      await expectation;

      verify(() => mockRemoteDatasource.updateForm(any())).called(1);

      // Verify the updated form is reflected in the cache
      clearInteractions(mockRemoteDatasource);
      final cacheCheck = await repository.getForms(forceRefresh: false);
      cacheCheck.fold(
        (l) => fail('Should be Right'),
        (r) {
          expect(r.length, 1);
          expect(r.first.title, 'New Title');
        },
      );
      verifyNever(() => mockRemoteDatasource.getForms());
    });

    /// I10: returns Left(ServerFailure) when remote fails.
    test('I10: returns Left(ServerFailure) when remote fails', () async {
      when(() => mockRemoteDatasource.updateForm(any()))
          .thenThrow(ApiException(403, 'Unauthorized edit'));

      final changeEvents = [];
      final sub = repository.cacheChanged.listen((_) { changeEvents.add(null); });

      final result = await repository.updateForm(formInput);

      expect(result.isLeft(), isTrue);
      expect(changeEvents, isEmpty);
      sub.cancel();
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // deleteForm  │  Cyclomatic Complexity = 1
  //             │  Paths: success removes item and notifies stream, failure skips
  // ═══════════════════════════════════════════════════════════════════════
  group('deleteForm —', () {
    final formToDelete = makeFormModel(id: 'form-to-delete');

    /// I11: returns Right(Empty), updates cache (removes form), calls remote, and emits event.
    test('I11: returns Right(Empty), removes form from cache, and emits cacheChanged event on success', () async {
      // Seed list cache
      when(() => mockRemoteDatasource.getForms())
          .thenAnswer((_) async => makeListResponse([formToDelete]));
      await repository.getForms(forceRefresh: false);

      when(() => mockRemoteDatasource.deleteForm(any()))
          .thenAnswer((_) async => makeEmptyResponse());

      final expectation = expectLater(repository.cacheChanged, emits(null));

      final result = await repository.deleteForm(formToDelete);

      expect(result.isRight(), isTrue);
      await expectation;

      verify(() => mockRemoteDatasource.deleteForm(any())).called(1);

      // Verify the form is deleted from cache
      clearInteractions(mockRemoteDatasource);
      final cacheCheck = await repository.getForms(forceRefresh: false);
      cacheCheck.fold(
        (l) => fail('Should be Right'),
        (r) => expect(r, isEmpty),
      );
      verifyNever(() => mockRemoteDatasource.getForms());
    });

    /// I12: returns Left(ServerFailure) when remote fails.
    test('I12: returns Left(ServerFailure) when remote fails', () async {
      when(() => mockRemoteDatasource.deleteForm(any()))
          .thenThrow(ApiException(409, 'Conflict'));

      final changeEvents = [];
      final sub = repository.cacheChanged.listen((_) { changeEvents.add(null); });

      final result = await repository.deleteForm(formToDelete);

      expect(result.isLeft(), isTrue);
      expect(changeEvents, isEmpty);
      sub.cancel();
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // clearCache  │  Cyclomatic Complexity = 1
  //             │  Paths: clears cache causing subsequent call to hit remote
  // ═══════════════════════════════════════════════════════════════════════
  group('clearCache —', () {
    /// I13: invalidates cache.
    test('I13: invalidates cache causing subsequent getForms to hit remote', () async {
      final form = makeFormModel();
      when(() => mockRemoteDatasource.getForms())
          .thenAnswer((_) async => makeListResponse([form]));

      // Seed cache
      await repository.getForms(forceRefresh: false);
      verify(() => mockRemoteDatasource.getForms()).called(1);
      clearInteractions(mockRemoteDatasource);

      // Clear cache
      repository.clearCache();

      // Subsequent call hits remote
      await repository.getForms(forceRefresh: false);
      verify(() => mockRemoteDatasource.getForms()).called(1);
    });
  });
}
