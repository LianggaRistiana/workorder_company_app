import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/core/services/network/api_response.dart';
import 'package:workorder_company_app/features/services/data/model/service_summary_model.dart';
import 'package:workorder_company_app/features/service_price/data/datasources/service_price_remote_datasource.dart';
import 'package:workorder_company_app/features/service_price/data/model/service_price_model.dart';
import 'package:workorder_company_app/features/service_price/data/repositories/service_price_repository_impl.dart';

// ── Mocks ─────────────────────────────────────────────────────────────────
class MockServicePriceRemoteDatasource extends Mock
    implements ServicePriceRemoteDatasource {}

void main() {
  late MockServicePriceRemoteDatasource mockRemote;
  late ServicePriceRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(const ServicePriceModel(
      id: 'fallback',
      service: ServiceSummaryModel(
        id: 'f-srv',
        title: 'f',
        accessType: ServiceAccessType.public,
        isActive: true,
      ),
      price: 0,
    ));
  });

  setUp(() {
    mockRemote = MockServicePriceRemoteDatasource();
    repository = ServicePriceRepositoryImpl(mockRemote);
  });

  // ── Helpers / Fixtures ──────────────────────────────────────────────────
  ServiceSummaryModel makeSummaryModel() => const ServiceSummaryModel(
        id: 'srv-123',
        title: 'AC Service',
        description: 'Regular maintenance',
        accessType: ServiceAccessType.public,
        isActive: true,
        price: 150000,
      );

  ServicePriceModel makeServicePriceModel({String id = 'sp-123', int price = 120000}) =>
      ServicePriceModel(
        id: id,
        service: makeSummaryModel(),
        price: price,
      );

  ApiResponse<ServicePriceModel> makeSingleResponse(ServicePriceModel data) =>
      ApiResponse(
        message: 'success',
        data: data,
      );

  ApiResponse<List<ServicePriceModel>> makeListResponse(
          List<ServicePriceModel> list) =>
      ApiResponse(
        message: 'success',
        data: list,
      );

  // ═══════════════════════════════════════════════════════════════════════
  // addServicePrice  │  Cyclomatic Complexity = 1
  //                  │  Paths: success returns Right(ServicePriceEntity), failure returns Left(Failure)
  // ═══════════════════════════════════════════════════════════════════════
  group('addServicePrice —', () {
    final entity = makeServicePriceModel();
    final model = makeServicePriceModel();

    /// I1: returns Right(ServicePriceEntity) on success.
    test('I1: returns Right(ServicePriceEntity) on success', () async {
      // arrange
      when(() => mockRemote.addServicePrice(any()))
          .thenAnswer((_) async => makeSingleResponse(model));

      // act
      final result = await repository.addServicePrice(entity);

      // assert
      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Should be Right'),
        (r) => expect(r.id, 'sp-123'),
      );
      verify(() => mockRemote.addServicePrice(any())).called(1);
    });

    /// I2: returns Left(ValidationFailure) when remote fails.
    test('I2: returns Left(ValidationFailure) when remote fails', () async {
      // arrange
      when(() => mockRemote.addServicePrice(any()))
          .thenThrow(ApiException(400, 'Bad Request'));

      // act
      final result = await repository.addServicePrice(entity);

      // assert
      expect(result.isLeft(), isTrue);
      result.fold(
        (l) {
          expect(l, isA<ValidationFailure>());
          expect(l.message, 'Bad Request');
        },
        (r) => fail('Should be Left'),
      );
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // deleteServicePrice  │  Cyclomatic Complexity = 1
  //                     │  Paths: success returns Right(ServicePriceEntity), failure returns Left(Failure)
  // ═══════════════════════════════════════════════════════════════════════
  group('deleteServicePrice —', () {
    const id = 'sp-123';
    final model = makeServicePriceModel(id: id);

    /// I3: returns Right(ServicePriceEntity) on success.
    test('I3: returns Right(ServicePriceEntity) on success', () async {
      // arrange
      when(() => mockRemote.deleteServicePrice(id))
          .thenAnswer((_) async => makeSingleResponse(model));

      // act
      final result = await repository.deleteServicePrice(id);

      // assert
      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Should be Right'),
        (r) => expect(r.id, id),
      );
      verify(() => mockRemote.deleteServicePrice(id)).called(1);
    });

    /// I4: returns Left(ServerFailure) when remote fails.
    test('I4: returns Left(ServerFailure) when remote fails', () async {
      // arrange
      when(() => mockRemote.deleteServicePrice(id))
          .thenThrow(ApiException(404, 'Not found'));

      // act
      final result = await repository.deleteServicePrice(id);

      // assert
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
  // getServicePrices  │  Cyclomatic Complexity = 1
  //                   │  Paths: success returns Right(List<ServicePriceEntity>), failure returns Left(Failure)
  // ═══════════════════════════════════════════════════════════════════════
  group('getServicePrices —', () {
    final model = makeServicePriceModel();

    /// I5: returns Right(List<ServicePriceEntity>) on success.
    test('I5: returns Right(List<ServicePriceEntity>) on success', () async {
      // arrange
      when(() => mockRemote.getServicePrices())
          .thenAnswer((_) async => makeListResponse([model]));

      // act
      final result = await repository.getServicePrices();

      // assert
      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Should be Right'),
        (r) {
          expect(r.length, 1);
          expect(r.first.id, 'sp-123');
        },
      );
      verify(() => mockRemote.getServicePrices()).called(1);
    });

    /// I6: returns Left(ServerFailure) when remote fails.
    test('I6: returns Left(ServerFailure) when remote fails', () async {
      // arrange
      when(() => mockRemote.getServicePrices())
          .thenThrow(ApiException(500, 'Server error'));

      // act
      final result = await repository.getServicePrices();

      // assert
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
  // updateServicePrice  │  Cyclomatic Complexity = 1
  //                     │  Paths: success returns Right(ServicePriceEntity), failure returns Left(Failure)
  // ═══════════════════════════════════════════════════════════════════════
  group('updateServicePrice —', () {
    final entity = makeServicePriceModel(price: 180000);
    final model = makeServicePriceModel(price: 180000);

    /// I7: returns Right(ServicePriceEntity) on success.
    test('I7: returns Right(ServicePriceEntity) on success', () async {
      // arrange
      when(() => mockRemote.updateServicePrice(any()))
          .thenAnswer((_) async => makeSingleResponse(model));

      // act
      final result = await repository.updateServicePrice(entity);

      // assert
      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Should be Right'),
        (r) => expect(r.price, 180000),
      );
      verify(() => mockRemote.updateServicePrice(any())).called(1);
    });

    /// I8: returns Left(AuthFailure) when remote fails.
    test('I8: returns Left(AuthFailure) when remote fails', () async {
      // arrange
      when(() => mockRemote.updateServicePrice(any()))
          .thenThrow(ApiException(403, 'Forbidden'));

      // act
      final result = await repository.updateServicePrice(entity);

      // assert
      expect(result.isLeft(), isTrue);
      result.fold(
        (l) {
          expect(l, isA<AuthFailure>());
          expect(l.message, 'Forbidden');
        },
        (r) => fail('Should be Left'),
      );
    });
  });
}
