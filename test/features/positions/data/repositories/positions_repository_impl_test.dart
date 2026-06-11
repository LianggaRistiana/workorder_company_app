import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/core/services/network/api_response.dart';
import 'package:workorder_company_app/features/positions/data/datasources/positions_remote_datasource.dart';
import 'package:workorder_company_app/features/positions/data/models/position_model.dart';
import 'package:workorder_company_app/features/positions/data/repositories/positions_repositories_impl.dart';
import 'package:workorder_company_app/features/positions/domain/meta/position_detail_meta.dart';

// ── Mocks ─────────────────────────────────────────────────────────────────
class MockPositionsRemoteDatasource extends Mock implements PositionsRemoteDatasource {}

void main() {
  late MockPositionsRemoteDatasource mockRemoteDatasource;
  late PositionsRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(const PositionModel(
      id: 'fallback-id',
      name: 'Fallback Position',
    ));
  });

  setUp(() {
    mockRemoteDatasource = MockPositionsRemoteDatasource();
    repository = PositionsRepositoryImpl(mockRemoteDatasource);
  });

  // ── fixtures ──────────────────────────────────────────────────────────
  PositionModel makePositionModel({String id = 'pos-123', String name = 'Technician'}) => PositionModel(
        id: id,
        name: name,
        description: 'Field Technician',
        isActive: true,
      );

  ApiResponse<List<PositionModel>> makeListResponse(List<PositionModel> list) => ApiResponse(
        message: 'success',
        data: list,
      );

  ApiResponse<PositionModel> makeSingleResponse(PositionModel data) => ApiResponse(
        message: 'success',
        data: data,
      );

  ApiResponseWithMeta<PositionModel> makeSingleResponseWithMeta(PositionModel data) => ApiResponseWithMeta(
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
  // getPositions  │  Cyclomatic Complexity = 1
  //               │  Paths: cache hit/miss, remote failure
  // ═══════════════════════════════════════════════════════════════════════
  group('getPositions —', () {
    /// I1: returns cached list without calling remote when cache is valid and refresh is false.
    test('I1: returns cached list without calling remote when cache is valid and refresh is false', () async {
      final pos = makePositionModel();
      when(() => mockRemoteDatasource.getPositions())
          .thenAnswer((_) async => makeListResponse([pos]));

      // Seed cache
      final firstResult = await repository.getPositions(refresh: false);
      expect(firstResult.isRight(), isTrue);
      verify(() => mockRemoteDatasource.getPositions()).called(1);
      clearInteractions(mockRemoteDatasource);

      // Hit cache
      final secondResult = await repository.getPositions(refresh: false);
      expect(secondResult.isRight(), isTrue);
      secondResult.fold(
        (l) => fail('Should be Right'),
        (r) => expect(r.first.id, 'pos-123'),
      );
      verifyNever(() => mockRemoteDatasource.getPositions());
    });

    /// I2: calls remote, returns Right(data), and updates cache when cache is empty.
    test('I2: calls remote, returns Right(data), and updates cache when cache is empty', () async {
      final pos = makePositionModel();
      when(() => mockRemoteDatasource.getPositions())
          .thenAnswer((_) async => makeListResponse([pos]));

      final result = await repository.getPositions(refresh: false);

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Should be Right'),
        (r) {
          expect(r.length, 1);
          expect(r.first.id, 'pos-123');
        },
      );
      verify(() => mockRemoteDatasource.getPositions()).called(1);
    });

    /// I3: calls remote even if cache is seeded when refresh is true.
    test('I3: calls remote even if cache is seeded when refresh is true', () async {
      final pos1 = makePositionModel(name: 'Old Name');
      final pos2 = makePositionModel(name: 'New Name');

      when(() => mockRemoteDatasource.getPositions())
          .thenAnswer((_) async => makeListResponse([pos1]));

      // Seed cache
      await repository.getPositions(refresh: false);
      verify(() => mockRemoteDatasource.getPositions()).called(1);
      clearInteractions(mockRemoteDatasource);

      // Force refresh
      when(() => mockRemoteDatasource.getPositions())
          .thenAnswer((_) async => makeListResponse([pos2]));

      final result = await repository.getPositions(refresh: true);

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Should be Right'),
        (r) => expect(r.first.name, 'New Name'),
      );
      verify(() => mockRemoteDatasource.getPositions()).called(1);
    });

    /// I4: returns Left(ServerFailure) when remote fails.
    test('I4: returns Left(ServerFailure) when remote fails', () async {
      when(() => mockRemoteDatasource.getPositions())
          .thenThrow(ApiException(500, 'Server Error'));

      final result = await repository.getPositions(refresh: false);

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
  // getPositionById  │  Cyclomatic Complexity = 1
  //                  │  Paths: success returns position with metadata, failure returns Failure
  // ═══════════════════════════════════════════════════════════════════════
  group('getPositionById —', () {
    /// I5: returns Right(PositionEntity) with detail metadata on remote success.
    test('I5: returns Right(PositionEntity) with detail metadata on remote success', () async {
      final pos = makePositionModel();
      when(() => mockRemoteDatasource.getPositionById('pos-123'))
          .thenAnswer((_) async => makeSingleResponseWithMeta(pos));

      final result = await repository.getPositionById('pos-123');

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Should be Right'),
        (r) {
          expect(r.data.id, 'pos-123');
          final detailMeta = r.getMeta<PositionDetailMeta>();
          expect(detailMeta, isNotNull);
          expect(detailMeta!.canDelete, isTrue);
        },
      );
    });

    /// I6: returns Left(ServerFailure) when remote fails.
    test('I6: returns Left(ServerFailure) when remote fails', () async {
      when(() => mockRemoteDatasource.getPositionById('pos-123'))
          .thenThrow(ApiException(404, 'Position not found'));

      final result = await repository.getPositionById('pos-123');

      expect(result.isLeft(), isTrue);
      result.fold(
        (l) {
          expect(l, isA<ServerFailure>());
          expect(l.message, 'Position not found');
        },
        (r) => fail('Should be Left'),
      );
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // createPostion  │  Cyclomatic Complexity = 1
  //                │  Paths: success merges item and notifies stream, failure skips
  // ═══════════════════════════════════════════════════════════════════════
  group('createPostion —', () {
    final posInput = makePositionModel(id: 'pos-new');
    final posOutput = makePositionModel(id: 'pos-new');

    /// I7: returns Right(PositionEntity), updates cache, and emits cacheChanged event on success.
    test('I7: returns Right(PositionEntity), updates cache, and emits cacheChanged event on success', () async {
      // Seed list cache first
      when(() => mockRemoteDatasource.getPositions())
          .thenAnswer((_) async => makeListResponse([makePositionModel(id: 'pos-existing')]));
      await repository.getPositions(refresh: false);

      when(() => mockRemoteDatasource.createPosition(any()))
          .thenAnswer((_) async => makeSingleResponse(posOutput));

      final expectation = expectLater(repository.cacheChanged, emits(null));

      final result = await repository.createPostion(posInput);

      expect(result.isRight(), isTrue);
      await expectation;

      verify(() => mockRemoteDatasource.createPosition(any())).called(1);

      // Verify merged cache
      clearInteractions(mockRemoteDatasource);
      final cacheCheck = await repository.getPositions(refresh: false);
      cacheCheck.fold(
        (l) => fail('Should be Right'),
        (r) {
          expect(r.length, 2);
          expect(r.any((e) => e.id == 'pos-new'), isTrue);
        },
      );
      verifyNever(() => mockRemoteDatasource.getPositions());
    });

    /// I8: returns Left(ServerFailure) when remote fails.
    test('I8: returns Left(ServerFailure) when remote fails', () async {
      when(() => mockRemoteDatasource.createPosition(any()))
          .thenThrow(ApiException(400, 'Bad request'));

      final changeEvents = [];
      final sub = repository.cacheChanged.listen((_) { changeEvents.add(null); });

      final result = await repository.createPostion(posInput);

      expect(result.isLeft(), isTrue);
      expect(changeEvents, isEmpty);
      sub.cancel();
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // updatePosition  │  Cyclomatic Complexity = 1
  //                 │  Paths: success updates item and notifies stream, failure skips
  // ═══════════════════════════════════════════════════════════════════════
  group('updatePosition —', () {
    final posInput = makePositionModel(id: 'pos-to-update', name: 'Old Name');
    final posOutput = makePositionModel(id: 'pos-to-update', name: 'New Name');

    /// I9: returns Right(PositionEntity), updates cache, and emits cacheChanged event.
    test('I9: returns Right(PositionEntity), updates cache, and emits cacheChanged event on success', () async {
      // Seed list cache
      when(() => mockRemoteDatasource.getPositions())
          .thenAnswer((_) async => makeListResponse([posInput]));
      await repository.getPositions(refresh: false);

      when(() => mockRemoteDatasource.updatePosition(any()))
          .thenAnswer((_) async => makeSingleResponse(posOutput));

      final expectation = expectLater(repository.cacheChanged, emits(null));

      final result = await repository.updatePosition(posInput);

      expect(result.isRight(), isTrue);
      await expectation;

      verify(() => mockRemoteDatasource.updatePosition(any())).called(1);

      // Verify updated cache
      clearInteractions(mockRemoteDatasource);
      final cacheCheck = await repository.getPositions(refresh: false);
      cacheCheck.fold(
        (l) => fail('Should be Right'),
        (r) {
          expect(r.length, 1);
          expect(r.first.name, 'New Name');
        },
      );
      verifyNever(() => mockRemoteDatasource.getPositions());
    });

    /// I10: returns Left(ServerFailure) when remote fails.
    test('I10: returns Left(ServerFailure) when remote fails', () async {
      when(() => mockRemoteDatasource.updatePosition(any()))
          .thenThrow(ApiException(403, 'Forbidden'));

      final changeEvents = [];
      final sub = repository.cacheChanged.listen((_) { changeEvents.add(null); });

      final result = await repository.updatePosition(posInput);

      expect(result.isLeft(), isTrue);
      expect(changeEvents, isEmpty);
      sub.cancel();
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // deletePosition  │  Cyclomatic Complexity = 1
  //                 │  Paths: success removes item and notifies stream, failure skips
  // ═══════════════════════════════════════════════════════════════════════
  group('deletePosition —', () {
    final posToDelete = makePositionModel(id: 'pos-to-delete');

    /// I11: returns Right(Empty), removes item from cache, and emits cacheChanged event.
    test('I11: returns Right(Empty), removes item from cache, and emits cacheChanged event on success', () async {
      // Seed list cache
      when(() => mockRemoteDatasource.getPositions())
          .thenAnswer((_) async => makeListResponse([posToDelete]));
      await repository.getPositions(refresh: false);

      when(() => mockRemoteDatasource.deletePosition(any()))
          .thenAnswer((_) async => makeEmptyResponse());

      final expectation = expectLater(repository.cacheChanged, emits(null));

      final result = await repository.deletePosition(posToDelete);

      expect(result.isRight(), isTrue);
      await expectation;

      verify(() => mockRemoteDatasource.deletePosition('pos-to-delete')).called(1);

      // Verify deleted from cache
      clearInteractions(mockRemoteDatasource);
      final cacheCheck = await repository.getPositions(refresh: false);
      cacheCheck.fold(
        (l) => fail('Should be Right'),
        (r) => expect(r, isEmpty),
      );
      verifyNever(() => mockRemoteDatasource.getPositions());
    });

    /// I12: returns Left(ServerFailure) when remote fails.
    test('I12: returns Left(ServerFailure) when remote fails', () async {
      when(() => mockRemoteDatasource.deletePosition(any()))
          .thenThrow(ApiException(409, 'Conflict'));

      final changeEvents = [];
      final sub = repository.cacheChanged.listen((_) { changeEvents.add(null); });

      final result = await repository.deletePosition(posToDelete);

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
    test('I13: invalidates cache causing subsequent getPositions to hit remote', () async {
      final pos = makePositionModel();
      when(() => mockRemoteDatasource.getPositions())
          .thenAnswer((_) async => makeListResponse([pos]));

      // Seed cache
      await repository.getPositions(refresh: false);
      verify(() => mockRemoteDatasource.getPositions()).called(1);
      clearInteractions(mockRemoteDatasource);

      // Clear cache
      repository.clearCache();

      // Subsequent call hits remote
      await repository.getPositions(refresh: false);
      verify(() => mockRemoteDatasource.getPositions()).called(1);
    });
  });
}
