# Invitations Feature — Whitebox Test Documentation

**Layer**: Data (DataSource & Repository)  
**Framework**: `flutter_test` + `mocktail`  
**Testing Method**: Whitebox (branch/path coverage)  
**Date**: 2026-06-12

---

## File Structure

```
test/features/invitations/
├── README.md                                                 (test plan & result docs)
└── data/
    ├── datasources/
    │   ├── receiver_invitations_remote_datasource_test.dart (9 tests)
    │   └── sender_invitations_remote_datasource_test.dart   (9 tests)
    ├── repositories/
    │   └── invitations_repository_impl_test.dart            (12 tests)
    └── model/
        └── invitations_models_test.dart                     (5 tests)
```

---

## Cyclomatic Complexity Reference

> **Formula**: CC = Number of decision points + 1  
> Decision points: `if`, `else if`, `on`, `catch`, `case`, `&&`, `||`

| Class / Component | Method | Decision Points | CC |
|---|---|---|---|
| `ReceiverInvitationsRemoteDatasourceImpl` | `acceptInvitation` | 0 | 1 |
| `ReceiverInvitationsRemoteDatasourceImpl` | `rejectInvitation` | 0 | 1 |
| `ReceiverInvitationsRemoteDatasourceImpl` | `getPendingInvitations` | 0 | 1 |
| `SenderInvitationsRemoteDatasourceImpl` | `cancelInvitation` | 0 | 1 |
| `SenderInvitationsRemoteDatasourceImpl` | `getInvitationsHistory` | 0 | 1 |
| `SenderInvitationsRemoteDatasourceImpl` | `inviteEmployees` | 0 | 1 |
| `InvitationsRepositoryImpl` | `acceptInvitation` | 0 | 1 |
| `InvitationsRepositoryImpl` | `rejectInvitation` | 0 | 1 |
| `InvitationsRepositoryImpl` | `cancelInvitation` | 0 | 1 |
| `InvitationsRepositoryImpl` | `inviteEmployees` | 0 | 1 |
| `InvitationsRepositoryImpl` | `getInvitationsHistory` | 0 | 1 |
| `InvitationsRepositoryImpl` | `getPendingInvitations` | 0 | 1 |
| Models | various `fromJson`/`toJson` | 0 | 4 |
| | | **Total CC** | **16** |

> Minimum tests required for full branch coverage = **16**  
> Total tests written = **35** (includes full exception mapping coverage and argument checks)

---

---

## 1. Receiver Remote DataSource

**Source**: `lib/features/invitations/data/datasources/receiver_invitations_remote_datasource.dart`  
**Test File**: `test/features/invitations/data/datasources/receiver_invitations_remote_datasource_test.dart`  
**Mock**: `MockApiClient`

---

### Cyclomatic Complexity

All methods have **CC = 1** (delegating to `_apiClient`).

---

### Test Cases & Result

#### `acceptInvitation(id)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R1 | Successful accept | Happy path | `apiClient.put` → accepted JSON | `ApiResponse<InvitationModel>` with status=accepted | ✅ PASS |
| R2 | API throws `ApiException` | Exception propagation | `apiClient.put` throws `ApiException(400)` | `ApiException` propagates | ✅ PASS |
| R3 | Correct endpoint called | Argument verification | Any | `put(Endpoints.acceptInvitations.fillId(id))` called | ✅ PASS |

#### `getPendingInvitations()` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R4 | Successful fetch | Happy path | `apiClient.get` → list JSON | `ApiResponse<List<InvitationModel>>` returned | ✅ PASS |
| R5 | API throws | Exception propagation | `apiClient.get` throws `ApiException(500)` | `ApiException` propagates | ✅ PASS |
| R6 | Correct endpoint called | Argument verification | Any | `get(Endpoints.pendingInvitations)` called | ✅ PASS |

#### `rejectInvitation(id)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R7 | Successful reject | Happy path | `apiClient.put` → rejected JSON | `ApiResponse<InvitationModel>` with status=rejected | ✅ PASS |
| R8 | API throws | Exception propagation | `apiClient.put` throws `ApiException(400)` | `ApiException` propagates | ✅ PASS |
| R9 | Correct endpoint called | Argument verification | Any | `put(Endpoints.rejectInvitations.fillId(id))` called | ✅ PASS |

**Section Total: 9 / 9 PASS**

---

---

## 2. Sender Remote DataSource

**Source**: `lib/features/invitations/data/datasources/sender_invitations_remote_datasource.dart`  
**Test File**: `test/features/invitations/data/datasources/sender_invitations_remote_datasource_test.dart`  
**Mock**: `MockApiClient`

---

### Cyclomatic Complexity

All methods have **CC = 1**.

---

### Test Cases & Result

#### `cancelInvitation(id)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R10 | Successful cancellation | Happy path | `apiClient.delete` → cancelled JSON | `ApiResponse<InvitationModel>` with status=cancelled | ✅ PASS |
| R11 | API throws | Exception propagation | `apiClient.delete` throws `ApiException(400)` | `ApiException` propagates | ✅ PASS |
| R12 | Correct endpoint called | Argument verification | Any | `delete(Endpoints.cancelInvitations.fillId(id))` called | ✅ PASS |

#### `getInvitationsHistory()` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R13 | Successful history fetch | Happy path | `apiClient.get` → list JSON | `ApiResponse<List<InvitationModel>>` returned | ✅ PASS |
| R14 | API throws | Exception propagation | `apiClient.get` throws `ApiException(500)` | `ApiException` propagates | ✅ PASS |
| R15 | Correct endpoint called | Argument verification | Any | `get(Endpoints.historyInvitations)` called | ✅ PASS |

#### `inviteEmployees(drafts)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R16 | Successful invite | Happy path | `apiClient.post` → list JSON | `ApiResponse<List<InvitationModel>>` returned | ✅ PASS |
| R17 | API throws | Exception propagation | `apiClient.post` throws `ApiException(400)` | `ApiException` propagates | ✅ PASS |
| R18 | Correct endpoint & body | Argument verification | Any | `post(Endpoints.inviteEmployees, data: {invites})` called | ✅ PASS |

**Section Total: 9 / 9 PASS**

---

---

## 3. Invitations Repository

**Source**: `lib/features/invitations/data/repositories/invitations_repository_impl.dart`  
**Test File**: `test/features/invitations/data/repositories/invitations_repository_impl_test.dart`  
**Mocks**: `MockReceiverRemoteDatasource`, `MockSenderRemoteDatasource`

---

### Cyclomatic Complexity

All repository methods have **CC = 1** since exception handling is delegated directly to `safeCall`.

---

### Test Cases & Result

#### `acceptInvitation(id)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| I1 | Successful acceptance | Happy path | Receiver returns model | Returns Right(InvitationEntity) | ✅ PASS |
| I2 | Remote fails | Error path | Receiver throws `ApiException(404)` | Returns Left(ServerFailure "Invitation not found") | ✅ PASS |

#### `cancelInvitation(id)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| I3 | Successful cancellation | Happy path | Sender returns model | Returns Right(InvitationEntity) | ✅ PASS |
| I4 | Remote fails | Error path | Sender throws `ApiException(400)` | Returns Left(ValidationFailure) | ✅ PASS |

#### `getInvitationsHistory()` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| I5 | Successful fetch | Happy path | Sender returns list | Returns Right(List<InvitationEntity>) | ✅ PASS |
| I6 | Remote fails | Error path | Sender throws `ApiException(500)` | Returns Left(ServerFailure "Server Sedang Gangguan") | ✅ PASS |

#### `inviteEmployees(drafts)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| I7 | Successful invites | Happy path | Sender returns list | Returns Right(List<InvitationEntity>) | ✅ PASS |
| I8 | Remote fails | Error path | Sender throws `ApiException(400)` | Returns Left(ValidationFailure "Invalid email list") | ✅ PASS |

#### `rejectInvitation(id)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| I9 | Successful rejection | Happy path | Receiver returns model | Returns Right(InvitationEntity) | ✅ PASS |
| I10 | Remote fails | Error path | Receiver throws `ApiException(404)` | Returns Left(ServerFailure "Invitation not found") | ✅ PASS |

#### `getPendingInvitations()` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| I11 | Successful fetch | Happy path | Receiver returns list | Returns Right(List<InvitationEntity>) | ✅ PASS |
| I12 | Remote fails | Error path | Receiver throws `ApiException(500)` | Returns Left(ServerFailure "Server Sedang Gangguan") | ✅ PASS |

**Section Total: 12 / 12 PASS**

---

---

## 4. Data Models

**Source**: `lib/features/invitations/data/model/`  
**Test File**: `test/features/invitations/data/model/invitations_models_test.dart`  
**Mocks**: None (pure unit tests)

---

### Test Cases & Result

| ID | Test Case | Branch / Path | Input / Payload | Expected | Result |
|---|---|---|---|---|---|
| M1 | InvitationDraftModel.fromJson | Happy path | Valid JSON with position | Correct email, role, and position ID parsed | ✅ PASS |
| M2 | InvitationDraftModel.toJson | Happy path | Model with position | Returns JSON mapping role snake_case and positionId | ✅ PASS |
| M3 | InvitationDraftModel.fromEntity | Happy path | Entity instance | Returns model mapping all fields correctly | ✅ PASS |
| M4 | InvitationModel.fromJson | Populated JSON | Fully loaded JSON payload | Correct ID, status, user, company, and position parsed | ✅ PASS |
| M5 | InvitationModel.fromJson | Optional missing | Min minimal JSON payload | Optional fields parse safely to null | ✅ PASS |

**Section Total: 5 / 5 PASS**

---

---

## Overall Result

| File | Tests | Passed | Failed | Pass Rate |
|---|---|---|---|---|
| `invitations_models_test.dart` | 5 | 5 | 0 | 100% |
| `receiver_invitations_remote_datasource_test.dart` | 9 | 9 | 0 | 100% |
| `sender_invitations_remote_datasource_test.dart` | 9 | 9 | 0 | 100% |
| `invitations_repository_impl_test.dart` | 12 | 12 | 0 | 100% |
| **Total** | **35** | **35** | **0** | **100%** |

### Execution Command
```bash
flutter test test/features/invitations/ --reporter expanded
```

### Execution Output
```
00:00 +0: loading D:/0002 - Source Code/workorder_company_app/test/features/invitations/data/model/invitations_models_test.dart
00:00 +1: loading D:/0002 - Source Code/workorder_company_app/test/features/invitations/data/datasources/receiver_invitations_remote_datasource_test.dart
00:00 +2: loading D:/0002 - Source Code/workorder_company_app/test/features/invitations/data/datasources/sender_invitations_remote_datasource_test.dart
00:00 +3: loading D:/0002 - Source Code/workorder_company_app/test/features/invitations/data/repositories/invitations_repository_impl_test.dart
...
00:01 +35: All tests passed!
```

---

## Notes

- Expected `appLogger.e` console outputs or `❌ ERROR in safeCall` logs from remote exception testing are normal behavior and do not constitute test failures.
