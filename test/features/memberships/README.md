# Memberships Feature — Whitebox Test Documentation

**Layer**: Data (DataSource & Repository)  
**Framework**: `flutter_test` + `mocktail`  
**Testing Method**: Whitebox (branch/path coverage)  
**Date**: 2026-06-12

---

## File Structure

```
test/features/memberships/
├── README.md                                                 (test plan & result docs)
└── data/
    ├── datasources/
    │   └── memberships_remote_datasource_test.dart          (15 tests)
    ├── repositories/
    │   └── memberships_repository_impl_test.dart            (10 tests)
    └── model/
        └── memberships_models_test.dart                     (5 tests)
```

---

## Cyclomatic Complexity Reference

> **Formula**: CC = Number of decision points + 1  
> Decision points: `if`, `else if`, `on`, `catch`, `case`, `&&`, `||`

| Class / Component | Method | Decision Points | CC |
|---|---|---|---|
| `MembershipsRemoteDatasourceImpl` | `claimMembership` | 0 | 1 |
| `MembershipsRemoteDatasourceImpl` | `deleteMemberShipCode` | 0 | 1 |
| `MembershipsRemoteDatasourceImpl` | `getMembershipCodes` | 0 | 1 |
| `MembershipsRemoteDatasourceImpl` | `getMembers` | 0 | 1 |
| `MembershipsRemoteDatasourceImpl` | `uploadMembershipCsvFile` | 0 | 1 |
| `MembershipsRepositoryImpl` | `claimMembership` | 0 | 1 |
| `MembershipsRepositoryImpl` | `deleteMemberShipCode` | 0 | 1 |
| `MembershipsRepositoryImpl` | `getMembershipCodes` | 0 | 1 |
| `MembershipsRepositoryImpl` | `getMembers` | 0 | 1 |
| `MembershipsRepositoryImpl` | `uploadMembershipCsvFile` | 0 | 1 |
| Models | various `fromJson`/`toJson` | 0 | 4 |
| | | **Total CC** | **14** |

> Minimum tests required for full branch coverage = **14**  
> Total tests written = **30** (includes upload setups and exception checks)

---

---

## 1. Remote DataSource

**Source**: `lib/features/memberships/data/datasources/memberships_remote_datasource.dart`  
**Test File**: `test/features/memberships/data/datasources/memberships_remote_datasource_test.dart`  
**Mock**: `MockApiClient`

---

### Cyclomatic Complexity

All methods have **CC = 1**.

---

### Test Cases & Result

#### `claimMembership(token, companyId)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R1 | Successful claim | Happy path | `apiClient.post` → external user JSON | `ApiResponse<ExternalUserModel>` returned | ✅ PASS |
| R2 | API throws `ApiException` | Exception propagation | `apiClient.post` throws `ApiException(400)` | `ApiException` propagates | ✅ PASS |
| R3 | Correct endpoint called | Argument verification | Any | `post(Endpoints.claimMembership, data: {code, companyId})` called | ✅ PASS |

#### `deleteMemberShipCode(id)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R4 | Successful delete | Happy path | `apiClient.delete` → code JSON | `ApiResponse<MembershipCodeModel>` returned | ✅ PASS |
| R5 | API throws | Exception propagation | `apiClient.delete` throws `ApiException(404)` | `ApiException` propagates | ✅ PASS |
| R6 | Correct endpoint called | Argument verification | Any | `delete(Endpoints.membershipCodes.byId(id))` called | ✅ PASS |

#### `getMembershipCodes()` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R7 | Successful fetch | Happy path | `apiClient.get` → list JSON | `ApiResponse<List<MembershipCodeModel>>` returned | ✅ PASS |
| R8 | API throws | Exception propagation | `apiClient.get` throws `ApiException(500)` | `ApiException` propagates | ✅ PASS |
| R9 | Correct endpoint called | Argument verification | Any | `get(Endpoints.membershipCodes)` called | ✅ PASS |

#### `getMembers()` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R10 | Successful fetch | Happy path | `apiClient.get` → list JSON | `ApiResponse<List<MemberModel>>` returned | ✅ PASS |
| R11 | API throws | Exception propagation | `apiClient.get` throws `ApiException(500)` | `ApiException` propagates | ✅ PASS |
| R12 | Correct endpoint called | Argument verification | Any | `get(Endpoints.memberships)` called | ✅ PASS |

#### `uploadMembershipCsvFile(filePath)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R13 | Successful upload | Happy path | `apiClient.postFormData` → list JSON | `ApiResponse<List<MembershipCodeModel>>` returned | ✅ PASS |
| R14 | API throws | Exception propagation | `apiClient.postFormData` throws `ApiException(400)` | `ApiException` propagates | ✅ PASS |
| R15 | Correct endpoint called | Argument verification | Any | `postFormData(Endpoints.membershipCodes, data: any)` called | ✅ PASS |

**Section Total: 15 / 15 PASS**

---

---

## 2. Memberships Repository

**Source**: `lib/features/memberships/data/repositories/memberships_repository_impl.dart`  
**Test File**: `test/features/memberships/data/repositories/memberships_repository_impl_test.dart`  
**Mock**: `MockMembershipsRemoteDatasource`

---

### Cyclomatic Complexity

All repository methods have **CC = 1**.

---

### Test Cases & Result

#### `claimMembership(token, companyId)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| I1 | Successful claim | Happy path | Remote returns external user | Returns Right(ExternalUserEntity) | ✅ PASS |
| I2 | Remote fails | Error path | Remote throws `ApiException(400)` | Returns Left(ValidationFailure "Invalid token") | ✅ PASS |

#### `deleteMemberShipCode(id)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| I3 | Successful delete | Happy path | Remote returns code | Returns Right(MembershipCodeEntity) | ✅ PASS |
| I4 | Remote fails | Error path | Remote throws `ApiException(404)` | Returns Left(ServerFailure "Code not found") | ✅ PASS |

#### `getMembershipCodes()` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| I5 | Successful fetch | Happy path | Remote returns list | Returns Right(List<MembershipCodeEntity>) | ✅ PASS |
| I6 | Remote fails | Error path | Remote throws `ApiException(500)` | Returns Left(ServerFailure "Server Sedang Gangguan") | ✅ PASS |

#### `getMembers()` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| I7 | Successful fetch | Happy path | Remote returns list | Returns Right(List<MemberEntity>) | ✅ PASS |
| I8 | Remote fails | Error path | Remote throws `ApiException(500)` | Returns Left(ServerFailure "Server Sedang Gangguan") | ✅ PASS |

#### `uploadMembershipCsvFile(filePath)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| I9 | Successful upload | Happy path | Remote returns list | Returns Right(List<MembershipCodeEntity>) | ✅ PASS |
| I10 | Remote fails | Error path | Remote throws `ApiException(400)` | Returns Left(ValidationFailure "Invalid CSV") | ✅ PASS |

**Section Total: 10 / 10 PASS**

---

---

## 3. Data Models

**Source**: `lib/features/memberships/data/model/`  
**Test File**: `test/features/memberships/data/model/memberships_models_test.dart`  
**Mocks**: None (pure unit tests)

---

### Test Cases & Result

| ID | Test Case | Branch / Path | Input / Payload | Expected | Result |
|---|---|---|---|---|---|
| M1 | MemberModel.fromJson | Happy path | JSON with externalAccount and user | Correctly parses ExternalUserModel & UserModel | ✅ PASS |
| M2 | MembershipCodeModel.fromJson | Happy path | JSON with claimedAt populated | Parses id, token, emails, and claimedAt Date | ✅ PASS |
| M3 | MembershipCodeModel.fromJson | Null claimedAt | JSON with claimedAt null | Parses claimedAt as null | ✅ PASS |
| M4 | MembershipCodesGenerateDraftModel.toJson | Deprecated | Draft model instance | Returns correct amount & prefix JSON map | ✅ PASS |
| M5 | MembershipCodesGenerateDraftModel.fromEntity | Deprecated | Draft entity instance | Returns model with matching properties | ✅ PASS |

**Section Total: 5 / 5 PASS**

---

---

## Overall Result

| File | Tests | Passed | Failed | Pass Rate |
|---|---|---|---|---|
| `memberships_models_test.dart` | 5 | 5 | 0 | 100% |
| `memberships_remote_datasource_test.dart` | 15 | 15 | 0 | 100% |
| `memberships_repository_impl_test.dart` | 10 | 10 | 0 | 100% |
| **Total** | **30** | **30** | **0** | **100%** |

### Execution Command
```bash
flutter test test/features/memberships/ --reporter expanded
```

### Execution Output
```
00:00 +0: loading D:/0002 - Source Code/workorder_company_app/test/features/memberships/data/model/memberships_models_test.dart
00:00 +1: loading D:/0002 - Source Code/workorder_company_app/test/features/memberships/data/datasources/memberships_remote_datasource_test.dart
00:00 +2: loading D:/0002 - Source Code/workorder_company_app/test/features/memberships/data/repositories/memberships_repository_impl_test.dart
...
00:00 +30: All tests passed!
```

---

## Notes

- expected log messages such as `⛔ ApiException` or `❌ ERROR in safeCall` from error path testing are normal logger outputs and do not signify a failure.
