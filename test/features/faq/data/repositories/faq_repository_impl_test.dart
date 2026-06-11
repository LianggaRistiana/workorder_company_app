import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/core/services/network/api_response.dart';
import 'package:workorder_company_app/core/model/multipart_result.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';
import 'package:workorder_company_app/features/company/data/models/company_model.dart';
import 'package:workorder_company_app/features/faq/data/datasources/faq_remote_datasource.dart';
import 'package:workorder_company_app/features/faq/data/datasources/faq_config_remote_datasource.dart';
import 'package:workorder_company_app/features/faq/data/model/faq_doc_model.dart';
import 'package:workorder_company_app/features/faq/data/model/faq_response_model.dart';
import 'package:workorder_company_app/features/faq/data/model/pdf_faq_doc_model.dart';
import 'package:workorder_company_app/features/faq/data/model/text_faq_doc_model.dart';
import 'package:workorder_company_app/features/faq/domain/entitties/chat_item_entity.dart';
import 'package:workorder_company_app/features/faq/domain/entitties/faq_doc_entity.dart';
import 'package:workorder_company_app/features/faq/domain/entitties/pdf_faq_doc_draft.dart';
import 'package:workorder_company_app/features/faq/domain/entitties/text_faq_doc_draft.dart';
import 'package:workorder_company_app/features/faq/data/repositories/faq_repository_impl.dart';
import 'package:workorder_company_app/features/faq/data/repositories/faq_config_repository_impl.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';

// ── Mocks ─────────────────────────────────────────────────────────────────
class MockFaqRemoteDatasource extends Mock implements FaqRemoteDatasource {}
class MockFaqConfigRemoteDatasource extends Mock implements FaqConfigRemoteDatasource {}

void main() {
  late MockFaqRemoteDatasource mockFaqRemote;
  late MockFaqConfigRemoteDatasource mockFaqConfigRemote;
  late FaqRepositoryImpl faqRepo;
  late FaqConfigRepositoryImpl faqConfigRepo;

  setUpAll(() {
    registerFallbackValue(const TextFaqDocModel(title: 'T', content: 'C'));
    registerFallbackValue(PdfFaqDocModel(title: 'T', filePath: 'P'));
    registerFallbackValue(FaqDocEntity(
      id: '101',
      title: 'T',
      content: 'C',
      type: FaqDocsType.text,
      createdAt: DateTime.now(),
    ));
  });

  setUp(() {
    mockFaqRemote = MockFaqRemoteDatasource();
    mockFaqConfigRemote = MockFaqConfigRemoteDatasource();
    faqRepo = FaqRepositoryImpl(mockFaqRemote);
    faqConfigRepo = FaqConfigRepositoryImpl(mockFaqConfigRemote);
  });

  // ── fixtures ──────────────────────────────────────────────────────────
  CompanyEntity makeCompany() => CompanyEntity(
        id: 'co-123',
        name: 'PT Maju Bersama',
        isActive: true,
        isFaqActive: true,
      );

  CompanyModel makeCompanyModel() => CompanyModel(
        id: 'co-123',
        name: 'PT Maju Bersama',
        isActive: true,
        isFaqActive: true,
      );

  ChatItemEntity makeChatItem() => ChatItemEntity(
        id: 'chat-1',
        userQuery: 'How to pay?',
      );

  FaqDocModel makeFaqDoc() => FaqDocModel(
        id: '101',
        title: 'How to pay',
        content: 'You can pay using credit card',
        type: FaqDocsType.text,
        createdAt: DateTime.parse('2026-06-12T03:00:00.000Z'),
      );

  // ═══════════════════════════════════════════════════════════════════════
  // FaqRepositoryImpl.askQuestion  │  Cyclomatic Complexity = 2
  //                                │  Paths: success -> success chat state | remote throws -> error chat state
  // ═══════════════════════════════════════════════════════════════════════
  group('FaqRepositoryImpl.askQuestion —', () {
    /// I1 | Branch: remote success
    /// Expected: returns RoomChatEntity with a success chat item
    test('I1: returns RoomChatEntity containing success chat state on success', () async {
      when(() => mockFaqRemote.askQuestion(any(), any()))
          .thenAnswer((_) async => ApiResponse(message: 'OK', data: const FaqResponseModel(answer: 'Credit Card')));

      final room = await faqRepo.askQuestion(makeCompany(), makeChatItem());

      expect(room.chatItems.length, 1);
      expect(room.chatItems[0].state, ChatState.success);
      expect(room.chatItems[0].botResponse, 'Credit Card');
      verify(() => mockFaqRemote.askQuestion('co-123', 'How to pay?')).called(1);
    });

    /// I2 | Branch: remote throws
    /// Expected: returns RoomChatEntity with an error chat item (Server Sedang Gangguan for 500 error status)
    test('I2: returns RoomChatEntity containing error chat state when remote fails', () async {
      when(() => mockFaqRemote.askQuestion(any(), any()))
          .thenThrow(ApiException(500, 'Server offline'));

      final room = await faqRepo.askQuestion(makeCompany(), makeChatItem());

      expect(room.chatItems.length, 1);
      expect(room.chatItems[0].state, ChatState.error);
      expect(room.chatItems[0].botResponse, 'Server Sedang Gangguan');
    });

    /// I3 | Branch: append to existing room
    /// Expected: adds to existing RoomChatEntity if one already exists in cache
    test('I3: appends chatItem to existing room in cache if company room already exists', () async {
      when(() => mockFaqRemote.askQuestion(any(), any()))
          .thenAnswer((_) async => ApiResponse(message: 'OK', data: const FaqResponseModel(answer: 'Ok')));

      // First chat
      await faqRepo.askQuestion(makeCompany(), makeChatItem());
      // Second chat
      final room = await faqRepo.askQuestion(makeCompany(), ChatItemEntity(id: 'chat-2', userQuery: 'Another?'));

      expect(room.chatItems.length, 2);
      expect(room.chatItems[0].id, 'chat-1');
      expect(room.chatItems[1].id, 'chat-2');
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // FaqRepositoryImpl.retry  │  Cyclomatic Complexity = 2
  //                          │  Paths: success -> success chat state | remote throws -> error chat state
  // ═══════════════════════════════════════════════════════════════════════
  group('FaqRepositoryImpl.retry —', () {
    /// I4 | Branch: success
    /// Expected: transitions chat item to success state
    test('I4: updates retry chat item to success state on remote success', () async {
      // Seed an error chat item
      when(() => mockFaqRemote.askQuestion(any(), any()))
          .thenThrow(ApiException(500, 'Offline'));
      var room = await faqRepo.askQuestion(makeCompany(), makeChatItem());
      expect(room.chatItems[0].state, ChatState.error);
      clearInteractions(mockFaqRemote);

      // Retry
      when(() => mockFaqRemote.askQuestion(any(), any()))
          .thenAnswer((_) async => ApiResponse(message: 'OK', data: const FaqResponseModel(answer: 'Recovered')));

      room = await faqRepo.retry(makeCompany(), room.chatItems[0]);

      expect(room.chatItems.length, 1);
      expect(room.chatItems[0].state, ChatState.success);
      expect(room.chatItems[0].botResponse, 'Recovered');
      verify(() => mockFaqRemote.askQuestion('co-123', 'How to pay?')).called(1);
    });

    /// I5 | Branch: remote throws
    /// Expected: keeps/transitions chat item in error state (Server Sedang Gangguan for 500 error status)
    test('I5: updates retry chat item to error state when remote fails', () async {
      when(() => mockFaqRemote.askQuestion(any(), any()))
          .thenThrow(ApiException(500, 'Offline'));
      var room = await faqRepo.askQuestion(makeCompany(), makeChatItem());
      expect(room.chatItems[0].state, ChatState.error);
      clearInteractions(mockFaqRemote);

      // Retry fails again
      when(() => mockFaqRemote.askQuestion(any(), any()))
          .thenThrow(ApiException(500, 'Still offline'));

      room = await faqRepo.retry(makeCompany(), room.chatItems[0]);

      expect(room.chatItems[0].state, ChatState.error);
      expect(room.chatItems[0].botResponse, 'Server Sedang Gangguan');
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // FaqRepositoryImpl.getRoomChat & clearCache  │  Cyclomatic Complexity = 2
  //                                             │  Paths: get or add room chat | clear cache
  // ═══════════════════════════════════════════════════════════════════════
  group('FaqRepositoryImpl.getRoomChat & clearCache —', () {
    /// I6 | Branch: cached room retrieval
    /// Expected: returns the same room instance if already cached
    test('I6: getRoomChat returns cached room chat if company room already exists', () async {
      final room1 = await faqRepo.getRoomChat(makeCompany());
      final room2 = await faqRepo.getRoomChat(makeCompany());

      expect(room1, room2);
    });

    /// I7 | Branch: create new room chat
    /// Expected: returns new room chat if cache is empty
    test('I7: getRoomChat returns new empty room chat when no cache exists', () async {
      final room = await faqRepo.getRoomChat(makeCompany());

      expect(room.companyRoomChat.id, 'co-123');
      expect(room.chatItems, isEmpty);
    });

    /// I8 | Branch: clear cache side effects
    /// Expected: after clearCache, getRoomChat returns a fresh room
    test('I8: clearCache causes subsequent getRoomChat to return a fresh room chat', () async {
      final room1 = await faqRepo.getRoomChat(makeCompany());
      faqRepo.clearCache();
      final room2 = await faqRepo.getRoomChat(makeCompany());

      expect(room1, isNot(room2));
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // FaqConfigRepositoryImpl.deleteFaqDoc  │  Cyclomatic Complexity = 1
  //                                       │  Paths: success | remote throws
  // ═══════════════════════════════════════════════════════════════════════
  group('FaqConfigRepositoryImpl.deleteFaqDoc —', () {
    final docToDelete = makeFaqDoc();

    /// I9 | Branch: success cache invalidation
    /// Expected: returns Right(Empty) and removes doc from cache list
    test('I9: returns Right(Empty) and removes doc from cache on success', () async {
      // Seed getFaqDocs cache
      when(() => mockFaqConfigRemote.getFaqDocs())
          .thenAnswer((_) async => ApiResponse(message: 'OK', data: [docToDelete]));
      await faqConfigRepo.getFaqDocs();
      clearInteractions(mockFaqConfigRemote);

      // Mock delete
      when(() => mockFaqConfigRemote.deleteFaqDoc(any()))
          .thenAnswer((_) async => ApiResponse(message: 'OK', data: Empty()));

      final result = await faqConfigRepo.deleteFaqDoc(docToDelete);

      expect(result.isRight(), isTrue);
      verify(() => mockFaqConfigRemote.deleteFaqDoc('101')).called(1);

      // Verify removed from cache
      final getCached = await faqConfigRepo.getFaqDocs();
      expect(getCached.isRight(), isTrue);
      getCached.fold((l) => fail('Right expected'), (r) => expect(r, isEmpty));
      verifyNever(() => mockFaqConfigRemote.getFaqDocs());
    });

    /// I10 | Branch: remote throws
    /// Expected: returns Left(ServerFailure)
    test('I10: returns Left(ServerFailure) when remote delete fails', () async {
      when(() => mockFaqConfigRemote.deleteFaqDoc(any()))
          .thenThrow(ApiException(404, 'Not found'));

      final result = await faqConfigRepo.deleteFaqDoc(docToDelete);

      expect(result.isLeft(), isTrue);
      result.fold(
        (l) => expect(l, isA<ServerFailure>()),
        (r) => fail('Left expected'),
      );
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // FaqConfigRepositoryImpl.getFaqDocs  │  Cyclomatic Complexity = 1
  //                                     │  Paths: cache hit | cache miss | remote failure
  // ═══════════════════════════════════════════════════════════════════════
  group('FaqConfigRepositoryImpl.getFaqDocs —', () {
    /// I11 | Branch: cache hit
    /// Expected: returns cached list directly
    test('I11: returns Right(cached) from cache when forceRefresh is false', () async {
      when(() => mockFaqConfigRemote.getFaqDocs())
          .thenAnswer((_) async => ApiResponse(message: 'OK', data: [makeFaqDoc()]));

      await faqConfigRepo.getFaqDocs();
      verify(() => mockFaqConfigRemote.getFaqDocs()).called(1);
      clearInteractions(mockFaqConfigRemote);

      final result = await faqConfigRepo.getFaqDocs(forceRefresh: false);

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Right expected'),
        (r) => expect(r[0].id, '101'),
      );
      verifyNever(() => mockFaqConfigRemote.getFaqDocs());
    });

    /// I12 | Branch: cache miss
    /// Expected: calls remote, returns list
    test('I12: calls remote and returns Right(data) when cache is empty', () async {
      when(() => mockFaqConfigRemote.getFaqDocs())
          .thenAnswer((_) async => ApiResponse(message: 'OK', data: [makeFaqDoc()]));

      final result = await faqConfigRepo.getFaqDocs();

      expect(result.isRight(), isTrue);
      verify(() => mockFaqConfigRemote.getFaqDocs()).called(1);
    });

    /// I13 | Branch: remote failure
    /// Expected: returns Left(ServerFailure)
    test('I13: returns Left(ServerFailure) when remote getFaqDocs fails', () async {
      when(() => mockFaqConfigRemote.getFaqDocs())
          .thenThrow(ApiException(500, 'Server error'));

      final result = await faqConfigRepo.getFaqDocs();

      expect(result.isLeft(), isTrue);
      result.fold(
        (l) => expect(l, isA<ServerFailure>()),
        (r) => fail('Left expected'),
      );
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // FaqConfigRepositoryImpl.toggleFaqFeature  │  Cyclomatic Complexity = 1
  //                                           │  Paths: success | remote throws
  // ═══════════════════════════════════════════════════════════════════════
  group('FaqConfigRepositoryImpl.toggleFaqFeature —', () {
    /// I14 | Branch: success
    /// Expected: returns Right(CompanyEntity)
    test('I14: returns Right(CompanyEntity) on remote toggle success', () async {
      when(() => mockFaqConfigRemote.toggleFaqFeature(any()))
          .thenAnswer((_) async => ApiResponse(message: 'OK', data: makeCompanyModel()));

      final result = await faqConfigRepo.toggleFaqFeature(true);

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Right expected'),
        (r) => expect(r.id, 'co-123'),
      );
      verify(() => mockFaqConfigRemote.toggleFaqFeature(true)).called(1);
    });

    /// I15 | Branch: remote failure
    /// Expected: returns Left(ServerFailure)
    test('I15: returns Left(ServerFailure) when remote toggle fails', () async {
      when(() => mockFaqConfigRemote.toggleFaqFeature(any()))
          .thenThrow(ApiException(400, 'Bad Request'));

      final result = await faqConfigRepo.toggleFaqFeature(false);

      expect(result.isLeft(), isTrue);
      result.fold(
        (l) => expect(l, isA<ValidationFailure>()),
        (r) => fail('Left expected'),
      );
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // FaqConfigRepositoryImpl.uploadTextDocs  │  Cyclomatic Complexity = 1
  //                                         │  Paths: success | remote throws
  // ═══════════════════════════════════════════════════════════════════════
  group('FaqConfigRepositoryImpl.uploadTextDocs —', () {
    const draft = TextFaqDocDraft(title: 'T', content: 'C');
    final docResult = makeFaqDoc();

    /// I16 | Branch: success cache merge
    /// Expected: returns Right(FaqDocEntity) and merges into cache list
    test('I16: returns Right(FaqDocEntity) and merges text doc into cache list on success', () async {
      // Seed cache first
      when(() => mockFaqConfigRemote.getFaqDocs())
          .thenAnswer((_) async => ApiResponse(message: 'OK', data: <FaqDocModel>[]));
      await faqConfigRepo.getFaqDocs();
      clearInteractions(mockFaqConfigRemote);

      when(() => mockFaqConfigRemote.uploadTextDocs(any()))
          .thenAnswer((_) async => ApiResponse(message: 'OK', data: docResult));

      final result = await faqConfigRepo.uploadTextDocs(draft);

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Right expected'),
        (r) => expect(r.id, '101'),
      );
      verify(() => mockFaqConfigRemote.uploadTextDocs(any())).called(1);

      // Verify merged into cache without remote call
      final getCached = await faqConfigRepo.getFaqDocs(forceRefresh: false);
      expect(getCached.isRight(), isTrue);
      getCached.fold((l) => fail('Right expected'), (r) => expect(r.length, 1));
      verifyNever(() => mockFaqConfigRemote.getFaqDocs());
    });

    /// I17 | Branch: remote failure
    /// Expected: returns Left(ServerFailure)
    test('I17: returns Left(ServerFailure) when remote uploadTextDocs fails', () async {
      when(() => mockFaqConfigRemote.uploadTextDocs(any()))
          .thenThrow(ApiException(500, 'Upload offline'));

      final result = await faqConfigRepo.uploadTextDocs(draft);

      expect(result.isLeft(), isTrue);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // FaqConfigRepositoryImpl.uploadPdfDoc  │  Cyclomatic Complexity = 1
  //                                       │  Paths: stream success | stream progress
  // ═══════════════════════════════════════════════════════════════════════
  group('FaqConfigRepositoryImpl.uploadPdfDoc —', () {
    final draft = PdfFaqDocDraft(title: 'T', filePath: 'P');
    final docResult = makeFaqDoc();

    /// I18 | Branch: stream success cache merge
    /// Expected: maps stream events and merges doc into cache upon Done success
    test('I18: maps remote stream events and merges pdf doc into cache when done', () async {
      // Seed cache first
      when(() => mockFaqConfigRemote.getFaqDocs())
          .thenAnswer((_) async => ApiResponse(message: 'OK', data: <FaqDocModel>[]));
      await faqConfigRepo.getFaqDocs();
      clearInteractions(mockFaqConfigRemote);

      when(() => mockFaqConfigRemote.uploadPdfDoc(any()))
          .thenAnswer((_) => Stream.fromIterable([
                MultipartResult<FaqDocModel>.progress(0.5),
                MultipartResult<FaqDocModel>.success(docResult),
              ]));

      final stream = faqConfigRepo.uploadPdfDoc(draft);

      final results = await stream.toList();

      expect(results.length, 2);
      expect(results[0].progress, 0.5);
      expect(results[1].isDone, isTrue);
      expect(results[1].data, isNotNull);

      // Verify merged into cache without remote call
      final getCached = await faqConfigRepo.getFaqDocs(forceRefresh: false);
      expect(getCached.isRight(), isTrue);
      getCached.fold((l) => fail('Right expected'), (r) => expect(r.length, 1));
      verifyNever(() => mockFaqConfigRemote.getFaqDocs());
    });

    /// I19 | Branch: stream failure
    /// Expected: maps failure results unchanged
    test('I19: maps failure stream event directly to caller', () async {
      when(() => mockFaqConfigRemote.uploadPdfDoc(any()))
          .thenAnswer((_) => Stream.fromIterable([
                MultipartResult<FaqDocModel>.failure('Upload failed'),
              ]));

      final stream = faqConfigRepo.uploadPdfDoc(draft);

      final results = await stream.toList();

      expect(results.length, 1);
      expect(results[0].error, 'Upload failed');
    });
  });
}
