import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:workorder_company_app/core/services/network/api_client.dart';
import 'package:workorder_company_app/core/services/network/endpoints.dart';
import 'package:workorder_company_app/features/submissions/data/datasources/file_upload_remote_datasource.dart';

// ── Mocks ─────────────────────────────────────────────────────────────────
class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient mockApiClient;
  late FileRemoteDataSourceImpl datasource;
  late File tempFile;

  setUpAll(() {
    registerFallbackValue(FormData());
  });

  setUp(() {
    mockApiClient = MockApiClient();
    datasource = FileRemoteDataSourceImpl(mockApiClient);
    tempFile = File('temp_upload_test.txt');
    tempFile.writeAsStringSync('dummy content');
  });

  tearDown(() {
    if (tempFile.existsSync()) {
      tempFile.deleteSync();
    }
  });

  // ═══════════════════════════════════════════════════════════════════════
  // uploadFile  │  Cyclomatic Complexity = 2
  //             │  Paths: try success vs catch exception
  // ═══════════════════════════════════════════════════════════════════════
  group('uploadFile —', () {
    test('R1: emits progress and success on happy path', () async {
      when(() => mockApiClient.postFormData(
            any(),
            data: any(named: 'data'),
            onSendProgress: any(named: 'onSendProgress'),
          )).thenAnswer((invocation) async {
        final onSendProgress =
            invocation.namedArguments[#onSendProgress] as void Function(int, int)?;
        if (onSendProgress != null) {
          onSendProgress(50, 100);
          onSendProgress(100, 100);
        }
        return {
          'message': 'success',
          'data': {'url': 'https://s3.example.com/file.png'}
        };
      });

      final stream = datasource.uploadFile(tempFile.path);

      final results = await stream.toList();

      expect(results.length, 3);
      // First is progress 0.5
      expect(results[0].progress, 0.5);
      expect(results[0].isDone, isFalse);
      // Second is progress 1.0
      expect(results[1].progress, 1.0);
      expect(results[1].isDone, isFalse);
      // Third is success with URL
      expect(results[2].progress, 1.0);
      expect(results[2].isDone, isTrue);
      expect(results[2].url, 'https://s3.example.com/file.png');
      expect(results[2].error, isNull);
    });

    test('R2: emits failure when ApiClient throws DioException', () async {
      final dioException = DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          requestOptions: RequestOptions(path: ''),
          data: {'message': 'Invalid file type'},
          statusCode: 400,
        ),
      );

      when(() => mockApiClient.postFormData(
            any(),
            data: any(named: 'data'),
            onSendProgress: any(named: 'onSendProgress'),
          )).thenThrow(dioException);

      final stream = datasource.uploadFile(tempFile.path);
      final results = await stream.toList();

      expect(results.length, 1);
      expect(results[0].isDone, isTrue);
      expect(results[0].error, 'Invalid file type');
    });

    test('R3: emits failure when ApiClient throws generic exception', () async {
      when(() => mockApiClient.postFormData(
            any(),
            data: any(named: 'data'),
            onSendProgress: any(named: 'onSendProgress'),
          )).thenThrow(Exception('Generic error'));

      final stream = datasource.uploadFile(tempFile.path);
      final results = await stream.toList();

      expect(results.length, 1);
      expect(results[0].isDone, isTrue);
      expect(results[0].error, 'Unexpected error');
    });

    test('R4: calls postFormData with correct endpoint', () async {
      when(() => mockApiClient.postFormData(
            any(),
            data: any(named: 'data'),
            onSendProgress: any(named: 'onSendProgress'),
          )).thenAnswer((_) async => {
            'message': 'success',
            'data': {'url': 'https://s3.example.com/file.png'}
          });

      final stream = datasource.uploadFile(tempFile.path);
      await stream.toList();

      verify(() => mockApiClient.postFormData(
            Endpoints.fileUpload,
            data: any(named: 'data'),
            onSendProgress: any(named: 'onSendProgress'),
          )).called(1);
    });
  });
}
