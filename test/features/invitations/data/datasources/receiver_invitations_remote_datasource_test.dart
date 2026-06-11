import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/core/services/network/api_client.dart';
import 'package:workorder_company_app/core/services/network/endpoints.dart';
import 'package:workorder_company_app/shared/utils/string_route_utils.dart';
import 'package:workorder_company_app/features/invitations/data/datasources/receiver_invitations_remote_datasource.dart';
import 'package:workorder_company_app/features/invitations/data/model/invitation_model.dart';

// ── Mocks ─────────────────────────────────────────────────────────────────
class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient mockApiClient;
  late ReceiverInvitationsRemoteDatasourceImpl datasource;

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    mockApiClient = MockApiClient();
    datasource = ReceiverInvitationsRemoteDatasourceImpl(mockApiClient);
  });

  // ── fixtures ──────────────────────────────────────────────────────────
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
  // acceptInvitation  │  Cyclomatic Complexity = 1
  //                   │  Paths: success returns response, failure propagates
  // ═══════════════════════════════════════════════════════════════════════
  group('acceptInvitation —', () {
    /// R1: returns ApiResponse<InvitationModel> on success.
    test('R1: returns ApiResponse<InvitationModel> on success', () async {
      when(() => mockApiClient.put<dynamic>(any(), data: any(named: 'data')))
          .thenAnswer((_) async => singleResponseJson(status: 'accepted'));

      final result = await datasource.acceptInvitation('inv-123');

      expect(result.data, isA<InvitationModel>());
      expect(result.data.id, 'inv-123');
      expect(result.data.status, InvitationStatus.accepted);
    });

    /// R2: propagates ApiException when API call fails.
    test('R2: propagates ApiException when API call fails', () async {
      when(() => mockApiClient.put<dynamic>(any(), data: any(named: 'data')))
          .thenThrow(ApiException(400, 'Bad Request'));

      await expectLater(
        () async => datasource.acceptInvitation('inv-123'),
        throwsA(isA<ApiException>()),
      );
    });

    /// R3: calls put with correct filled endpoint.
    test('R3: calls put with correct filled endpoint', () async {
      when(() => mockApiClient.put<dynamic>(any(), data: any(named: 'data')))
          .thenAnswer((_) async => singleResponseJson(status: 'accepted'));

      await datasource.acceptInvitation('inv-123');

      verify(() => mockApiClient.put<dynamic>(
            Endpoints.acceptInvitations.fillId('inv-123'),
          )).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // getPendingInvitations  │  Cyclomatic Complexity = 1
  //                        │  Paths: success maps list, failure propagates
  // ═══════════════════════════════════════════════════════════════════════
  group('getPendingInvitations —', () {
    /// R4: returns ApiResponse<List<InvitationModel>> on success.
    test('R4: returns ApiResponse<List<InvitationModel>> on success', () async {
      when(() => mockApiClient.get<dynamic>(any()))
          .thenAnswer((_) async => listResponseJson());

      final result = await datasource.getPendingInvitations();

      expect(result.data, isA<List<InvitationModel>>());
      expect(result.data.length, 1);
      expect(result.data.first.id, 'inv-123');
    });

    /// R5: propagates ApiException when API call fails.
    test('R5: propagates ApiException when API call fails', () async {
      when(() => mockApiClient.get<dynamic>(any()))
          .thenThrow(ApiException(500, 'Internal Server Error'));

      await expectLater(
        () async => datasource.getPendingInvitations(),
        throwsA(isA<ApiException>()),
      );
    });

    /// R6: calls get with correct endpoint.
    test('R6: calls get with correct endpoint', () async {
      when(() => mockApiClient.get<dynamic>(any()))
          .thenAnswer((_) async => listResponseJson());

      await datasource.getPendingInvitations();

      verify(() => mockApiClient.get<dynamic>(Endpoints.pendingInvitations)).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // rejectInvitation  │  Cyclomatic Complexity = 1
  //                   │  Paths: success returns response, failure propagates
  // ═══════════════════════════════════════════════════════════════════════
  group('rejectInvitation —', () {
    /// R7: returns ApiResponse<InvitationModel> on success.
    test('R7: returns ApiResponse<InvitationModel> on success', () async {
      when(() => mockApiClient.put<dynamic>(any(), data: any(named: 'data')))
          .thenAnswer((_) async => singleResponseJson(status: 'rejected'));

      final result = await datasource.rejectInvitation('inv-123');

      expect(result.data, isA<InvitationModel>());
      expect(result.data.id, 'inv-123');
      expect(result.data.status, InvitationStatus.rejected);
    });

    /// R8: propagates ApiException.
    test('R8: propagates ApiException when API call fails', () async {
      when(() => mockApiClient.put<dynamic>(any(), data: any(named: 'data')))
          .thenThrow(ApiException(400, 'Bad Request'));

      await expectLater(
        () async => datasource.rejectInvitation('inv-123'),
        throwsA(isA<ApiException>()),
      );
    });

    /// R9: calls put with correct filled endpoint.
    test('R9: calls put with correct filled endpoint', () async {
      when(() => mockApiClient.put<dynamic>(any(), data: any(named: 'data')))
          .thenAnswer((_) async => singleResponseJson(status: 'rejected'));

      await datasource.rejectInvitation('inv-123');

      verify(() => mockApiClient.put<dynamic>(
            Endpoints.rejectInvitations.fillId('inv-123'),
          )).called(1);
    });
  });
}
