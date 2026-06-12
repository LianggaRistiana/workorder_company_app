import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workorder_company_app/features/submissions/data/datasources/file_upload_remote_datasource.dart';
import 'package:workorder_company_app/features/submissions/data/repositories/file_upload_repository_impl.dart';
import 'package:workorder_company_app/features/submissions/domain/entities/upload_result.dart';

// ── Mocks ─────────────────────────────────────────────────────────────────
class MockFileRemoteDataSource extends Mock implements FileRemoteDataSource {}

void main() {
  late MockFileRemoteDataSource mockRemote;
  late FileRepositoryImpl repository;

  setUp(() {
    mockRemote = MockFileRemoteDataSource();
    repository = FileRepositoryImpl(mockRemote);
  });

  // ═══════════════════════════════════════════════════════════════════════
  // uploadFile  │  Cyclomatic Complexity = 1
  //             │  Paths: direct stream delegation
  // ═══════════════════════════════════════════════════════════════════════
  group('uploadFile —', () {
    const filePath = 'some/path/file.png';

    test('I1: delegates directly to remote datasource stream', () async {
      final expectedEvents = [
        UploadResult.progress(0.5),
        UploadResult.success('https://s3.example.com/file.png'),
      ];

      when(() => mockRemote.uploadFile(filePath))
          .thenAnswer((_) => Stream.fromIterable(expectedEvents));

      final stream = repository.uploadFile(filePath);
      final results = await stream.toList();

      expect(results.length, 2);
      expect(results[0].progress, 0.5);
      expect(results[0].url, isNull);
      expect(results[1].progress, 1.0);
      expect(results[1].url, 'https://s3.example.com/file.png');

      verify(() => mockRemote.uploadFile(filePath)).called(1);
    });
  });
}
