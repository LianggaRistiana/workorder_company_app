import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/core/services/network/api_client.dart';
import 'package:workorder_company_app/core/services/network/endpoints.dart';
import 'package:workorder_company_app/shared/utils/string_route_utils.dart';
import 'package:workorder_company_app/features/invitations/data/datasources/sender_invitations_remote_datasource.dart';
import 'package:workorder_company_app/features/invitations/data/model/invitation_draft_model.dart';
import 'package:workorder_company_app/features/invitations/data/model/invitation_model.dart';

// ── Mocks ─────────────────────────────────────────────────────────────────
class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient mockApiClient;
  late SenderInvitationsRemoteDatasourceImpl datasource;

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    mockApiClient = MockApiClient();
    datasource = SenderInvitationsRemoteDatasourceImpl(mockApiClient);
  });

  // ── fixtures ──────────────────────────────────────────────────────────
  InvitationDraftModel makeDraft() => InvitationDraftModel(
        email: 'staff@example.com',
        role: UserRole.staffCompany,
      );

  Map<String, dynamic> invitationJson({String id = 'inv-123', String status = 'pending'}) => {
        '_id': id,
        'role': 'staff_company',
        'status': status,
      };

  Map<String, dynamic> singleResponseJson({String id = 'inv-123', String status = 'pending'}) => {
        'message': 'success',
        'data': invitationJson(id: id, status: status),
      };

  Map<String, dynamic> listResponseJson() => {
        'message': 'success',
        'data': [invitationJson(id: 'inv-123', status: 'pending')],
      };

  // ═══════════════════════════════════════════════════════════════════════
  // cancelInvitation  │  Cyclomatic Complexity = 1
  //                   │  Paths: success returns response, failure propagates
  // ═══════════════════════════════════════════════════════════════════════
  group('cancelInvitation —', () {
    /// R10: returns ApiResponse<InvitationModel> on success.
    test('R10: returns ApiResponse<InvitationModel> on success', () async {
      when(() => mockApiClient.delete<dynamic>(any()))
          .thenAnswer((_) async => singleResponseJson(status: 'cancelled'));

      final result = await datasource.cancelInvitation('inv-123');

      expect(result.data, isA<InvitationModel>());
      expect(result.data.id, 'inv-123');
      expect(result.data.status, InvitationStatus.cancelled);
    });

    /// R11: propagates ApiException when API call fails.
    test('R11: propagates ApiException when API call fails', () async {
      when(() => mockApiClient.delete<dynamic>(any()))
          .thenThrow(ApiException(400, 'Bad Request'));

      await expectLater(
        () async => datasource.cancelInvitation('inv-123'),
        throwsA(isA<ApiException>()),
      );
    });

    /// R12: calls delete with correct filled endpoint.
    test('R12: calls delete with correct filled endpoint', () async {
      when(() => mockApiClient.delete<dynamic>(any()))
          .thenAnswer((_) async => singleResponseJson(status: 'cancelled'));

      await datasource.cancelInvitation('inv-123');

      verify(() => mockApiClient.delete<dynamic>(
            Endpoints.cancelInvitations.fillId('inv-123'),
          )).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // getInvitationsHistory  │  Cyclomatic Complexity = 1
  //                        │  Paths: success maps list, failure propagates
  // ═══════════════════════════════════════════════════════════════════════
  group('getInvitationsHistory —', () {
    /// R13: returns ApiResponse<List<InvitationModel>> on success.
    test('R13: returns ApiResponse<List<InvitationModel>> on success', () async {
      when(() => mockApiClient.get<dynamic>(any()))
          .thenAnswer((_) async => listResponseJson());

      final result = await datasource.getInvitationsHistory();

      expect(result.data, isA<List<InvitationModel>>());
      expect(result.data.length, 1);
      expect(result.data.first.id, 'inv-123');
    });

    /// R14: propagates ApiException when API call fails.
    test('R14: propagates ApiException when API call fails', () async {
      when(() => mockApiClient.get<dynamic>(any()))
          .thenThrow(ApiException(500, 'Internal Server Error'));

      await expectLater(
        () async => datasource.getInvitationsHistory(),
        throwsA(isA<ApiException>()),
      );
    });

    /// R15: calls get with correct endpoint.
    test('R15: calls get with correct endpoint', () async {
      when(() => mockApiClient.get<dynamic>(any()))
          .thenAnswer((_) async => listResponseJson());

      await datasource.getInvitationsHistory();

      verify(() => mockApiClient.get<dynamic>(Endpoints.historyInvitations)).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // inviteEmployees  │  Cyclomatic Complexity = 1
  //                  │  Paths: success maps list, failure propagates
  // ═══════════════════════════════════════════════════════════════════════
  group('inviteEmployees —', () {
    final drafts = [makeDraft()];

    /// R16: returns ApiResponse<List<InvitationModel>> on success.
    test('R16: returns ApiResponse<List<InvitationModel>> on success', () async {
      when(() => mockApiClient.post<dynamic>(any(), data: any(named: 'data')))
          .thenAnswer((_) async => listResponseJson());

      final result = await datasource.inviteEmployees(drafts);

      expect(result.data, isA<List<InvitationModel>>());
      expect(result.data.length, 1);
      expect(result.data.first.id, 'inv-123');
    });

    /// R17: propagates ApiException when API call fails.
    test('R17: propagates ApiException when API call fails', () async {
      when(() => mockApiClient.post<dynamic>(any(), data: any(named: 'data')))
          .thenThrow(ApiException(400, 'Invalid parameters'));

      await expectLater(
        () async => datasource.inviteEmployees(drafts),
        throwsA(isA<ApiException>()),
      );
    });

    /// R18: calls post with correct endpoint and serialized invites payload.
    test('R18: calls post with correct endpoint and serialized payload', () async {
      when(() => mockApiClient.post<dynamic>(any(), data: any(named: 'data')))
          .thenAnswer((_) async => listResponseJson());

      await datasource.inviteEmployees(drafts);

      verify(() => mockApiClient.post<dynamic>(
            Endpoints.inviteEmployees,
            data: {
              'invites': drafts.map((e) => e.toJson()).toList(),
            },
          )).called(1);
    });
  });
}
