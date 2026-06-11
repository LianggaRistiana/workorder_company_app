import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/core/services/network/api_response.dart';
import 'package:workorder_company_app/features/invitations/data/datasources/receiver_invitations_remote_datasource.dart';
import 'package:workorder_company_app/features/invitations/data/datasources/sender_invitations_remote_datasource.dart';
import 'package:workorder_company_app/features/invitations/data/model/invitation_draft_model.dart';
import 'package:workorder_company_app/features/invitations/data/model/invitation_model.dart';
import 'package:workorder_company_app/features/invitations/data/repositories/invitations_repository_impl.dart';
import 'package:workorder_company_app/features/invitations/domain/entities/invitation_draft_entity.dart';

// ── Mocks ─────────────────────────────────────────────────────────────────
class MockReceiverRemoteDatasource extends Mock implements ReceiverInvitationsRemoteDatasource {}
class MockSenderRemoteDatasource extends Mock implements SenderInvitationsRemoteDatasource {}

void main() {
  late MockReceiverRemoteDatasource mockReceiverRemote;
  late MockSenderRemoteDatasource mockSenderRemote;
  late InvitationsRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(InvitationDraftModel(
      email: 'fallback@example.com',
      role: UserRole.staffCompany,
    ));
    registerFallbackValue(<InvitationDraftModel>[]);
  });

  setUp(() {
    mockReceiverRemote = MockReceiverRemoteDatasource();
    mockSenderRemote = MockSenderRemoteDatasource();
    repository = InvitationsRepositoryImpl(mockReceiverRemote, mockSenderRemote);
  });

  // ── fixtures ──────────────────────────────────────────────────────────
  InvitationModel makeInvitationModel({String id = 'inv-123', String status = 'pending'}) => InvitationModel(
        id: id,
        role: UserRole.staffCompany,
        status: InvitationStatus.fromString(status),
      );

  ApiResponse<InvitationModel> makeSingleResponse(InvitationModel data) => ApiResponse(
        message: 'success',
        data: data,
      );

  ApiResponse<List<InvitationModel>> makeListResponse(List<InvitationModel> data) => ApiResponse(
        message: 'success',
        data: data,
      );

  // ═══════════════════════════════════════════════════════════════════════
  // acceptInvitation  │  Cyclomatic Complexity = 1
  //                   │  Paths: success returns Right, failure returns Left
  // ═══════════════════════════════════════════════════════════════════════
  group('acceptInvitation —', () {
    /// I1: returns Right(InvitationEntity) on remote success.
    test('I1: returns Right(InvitationEntity) on success', () async {
      final model = makeInvitationModel(status: 'accepted');
      when(() => mockReceiverRemote.acceptInvitation(any()))
          .thenAnswer((_) async => makeSingleResponse(model));

      final result = await repository.acceptInvitation('inv-123');

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Should be Right'),
        (r) => expect(r.status, InvitationStatus.accepted),
      );
      verify(() => mockReceiverRemote.acceptInvitation('inv-123')).called(1);
    });

    /// I2: returns Left(ServerFailure) when remote throws.
    test('I2: returns Left(ServerFailure) on failure', () async {
      when(() => mockReceiverRemote.acceptInvitation(any()))
          .thenThrow(ApiException(404, 'Invitation not found'));

      final result = await repository.acceptInvitation('inv-123');

      expect(result.isLeft(), isTrue);
      result.fold(
        (l) {
          expect(l, isA<ServerFailure>());
          expect(l.message, 'Invitation not found');
        },
        (r) => fail('Should be Left'),
      );
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // cancelInvitation  │  Cyclomatic Complexity = 1
  //                   │  Paths: success returns Right, failure returns Left
  // ═══════════════════════════════════════════════════════════════════════
  group('cancelInvitation —', () {
    /// I3: returns Right(InvitationEntity) on success.
    test('I3: returns Right(InvitationEntity) on success', () async {
      final model = makeInvitationModel(status: 'cancelled');
      when(() => mockSenderRemote.cancelInvitation(any()))
          .thenAnswer((_) async => makeSingleResponse(model));

      final result = await repository.cancelInvitation('inv-123');

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Should be Right'),
        (r) => expect(r.status, InvitationStatus.cancelled),
      );
      verify(() => mockSenderRemote.cancelInvitation('inv-123')).called(1);
    });

    /// I4: returns Left(ServerFailure) when remote throws.
    test('I4: returns Left(ServerFailure) when remote throws', () async {
      when(() => mockSenderRemote.cancelInvitation(any()))
          .thenThrow(ApiException(400, 'Cannot cancel accepted invitation'));

      final result = await repository.cancelInvitation('inv-123');

      expect(result.isLeft(), isTrue);
      result.fold(
        (l) {
          expect(l, isA<ValidationFailure>());
          expect(l.message, 'Cannot cancel accepted invitation');
        },
        (r) => fail('Should be Left'),
      );
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // getInvitationsHistory  │  Cyclomatic Complexity = 1
  //                        │  Paths: success returns Right, failure returns Left
  // ═══════════════════════════════════════════════════════════════════════
  group('getInvitationsHistory —', () {
    /// I5: returns Right(List<InvitationEntity>) on success.
    test('I5: returns Right(List<InvitationEntity>) on success', () async {
      final model = makeInvitationModel();
      when(() => mockSenderRemote.getInvitationsHistory())
          .thenAnswer((_) async => makeListResponse([model]));

      final result = await repository.getInvitationsHistory();

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Should be Right'),
        (r) {
          expect(r.length, 1);
          expect(r.first.id, 'inv-123');
        },
      );
      verify(() => mockSenderRemote.getInvitationsHistory()).called(1);
    });

    /// I6: returns Left(ServerFailure) when remote throws.
    test('I6: returns Left(ServerFailure) when remote throws', () async {
      when(() => mockSenderRemote.getInvitationsHistory())
          .thenThrow(ApiException(500, 'Server Error'));

      final result = await repository.getInvitationsHistory();

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
  // inviteEmployees  │  Cyclomatic Complexity = 1
  //                  │  Paths: success returns Right, failure returns Left
  // ═══════════════════════════════════════════════════════════════════════
  group('inviteEmployees —', () {
    final drafts = [
      InvitationDraftEntity(email: 'staff@example.com', role: UserRole.staffCompany)
    ];

    /// I7: returns Right(List<InvitationEntity>) on success.
    test('I7: returns Right(List<InvitationEntity>) on success', () async {
      final model = makeInvitationModel();
      when(() => mockSenderRemote.inviteEmployees(any()))
          .thenAnswer((_) async => makeListResponse([model]));

      final result = await repository.inviteEmployees(drafts);

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Should be Right'),
        (r) {
          expect(r.length, 1);
          expect(r.first.id, 'inv-123');
        },
      );
      verify(() => mockSenderRemote.inviteEmployees(any())).called(1);
    });

    /// I8: returns Left(ServerFailure) when remote throws.
    test('I8: returns Left(ServerFailure) when remote throws', () async {
      when(() => mockSenderRemote.inviteEmployees(any()))
          .thenThrow(ApiException(400, 'Invalid email list'));

      final result = await repository.inviteEmployees(drafts);

      expect(result.isLeft(), isTrue);
      result.fold(
        (l) {
          expect(l, isA<ValidationFailure>());
          expect(l.message, 'Invalid email list');
        },
        (r) => fail('Should be Left'),
      );
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // rejectInvitation  │  Cyclomatic Complexity = 1
  //                   │  Paths: success returns Right, failure returns Left
  // ═══════════════════════════════════════════════════════════════════════
  group('rejectInvitation —', () {
    /// I9: returns Right(InvitationEntity) on success.
    test('I9: returns Right(InvitationEntity) on success', () async {
      final model = makeInvitationModel(status: 'rejected');
      when(() => mockReceiverRemote.rejectInvitation(any()))
          .thenAnswer((_) async => makeSingleResponse(model));

      final result = await repository.rejectInvitation('inv-123');

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Should be Right'),
        (r) => expect(r.status, InvitationStatus.rejected),
      );
      verify(() => mockReceiverRemote.rejectInvitation('inv-123')).called(1);
    });

    /// I10: returns Left(ServerFailure) when remote throws.
    test('I10: returns Left(ServerFailure) when remote throws', () async {
      when(() => mockReceiverRemote.rejectInvitation(any()))
          .thenThrow(ApiException(404, 'Invitation not found'));

      final result = await repository.rejectInvitation('inv-123');

      expect(result.isLeft(), isTrue);
      result.fold(
        (l) {
          expect(l, isA<ServerFailure>());
          expect(l.message, 'Invitation not found');
        },
        (r) => fail('Should be Left'),
      );
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // getPendingInvitations  │  Cyclomatic Complexity = 1
  //                        │  Paths: success returns Right, failure returns Left
  // ═══════════════════════════════════════════════════════════════════════
  group('getPendingInvitations —', () {
    /// I11: returns Right(List<InvitationEntity>) on success.
    test('I11: returns Right(List<InvitationEntity>) on success', () async {
      final model = makeInvitationModel();
      when(() => mockReceiverRemote.getPendingInvitations())
          .thenAnswer((_) async => makeListResponse([model]));

      final result = await repository.getPendingInvitations();

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Should be Right'),
        (r) {
          expect(r.length, 1);
          expect(r.first.id, 'inv-123');
        },
      );
      verify(() => mockReceiverRemote.getPendingInvitations()).called(1);
    });

    /// I12: returns Left(ServerFailure) when remote throws.
    test('I12: returns Left(ServerFailure) when remote throws', () async {
      when(() => mockReceiverRemote.getPendingInvitations())
          .thenThrow(ApiException(500, 'Server Error'));

      final result = await repository.getPendingInvitations();

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
}
