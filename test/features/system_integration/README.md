# System Integration Feature — Whitebox Test Documentation

**Layer**: Data (DataSource & Repository)  
**Framework**: `flutter_test` + `mocktail`  
**Testing Method**: Whitebox (branch/path coverage)  
**Date**: 2026-06-12

---

## File Structure

```
test/features/system_integration/
└── data/
    ├── datasources/
    │   ├── customer_account_integration_remote_datasource_test.dart  (15 tests)
    │   └── provider_integration_remote_datasource_test.dart          (6 tests)
    ├── repositories/
    │   ├── customer_account_integration_repository_impl_test.dart    (10 tests)
    │   └── provider_integration_repository_impl_test.dart            (4 tests)
    └── model/
        └── system_integration_models_test.dart                       (6 tests)
```

---

## Cyclomatic Complexity Reference

> **Formula**: CC = Number of decision points + 1  
> Decision points: `if`, `else if`, `on`, `catch`, `case`, `&&`, `||`

| Class | Method | Decision Points | CC |
|---|---|---|---|
| `CustomerAccountIntegrationRemoteDatasourceImpl` | `startPairing` | 0 | 1 |
| `CustomerAccountIntegrationRemoteDatasourceImpl` | `completePairing` | 0 | 1 |
| `CustomerAccountIntegrationRemoteDatasourceImpl` | `getAccountPairingStatus` | 0 | 1 |
| `CustomerAccountIntegrationRemoteDatasourceImpl` | `detachAccountPairing` | 0 | 1 |
| `CustomerAccountIntegrationRemoteDatasourceImpl` | `getAllAccountsPairingStatus` | 0 | 1 |
| `ProviderIntegrationRemoteDatasourceImpl` | `getProviderIntegrationData` | 0 | 1 |
| `ProviderIntegrationRemoteDatasourceImpl` | `updateProviderIntegrationData` | 0 | 1 |
| `CustomerAccountIntegrationRepositoryImpl` | `startPairing` | 0 | 1 |
| `CustomerAccountIntegrationRepositoryImpl` | `completePairing` | 0 | 1 |
| `CustomerAccountIntegrationRepositoryImpl` | `getAccountPairingStatus` | 0 | 1 |
| `CustomerAccountIntegrationRepositoryImpl` | `detachAccountPairing` | 0 | 1 |
| `CustomerAccountIntegrationRepositoryImpl` | `getAllAccountsPairingStatus` | 0 | 1 |
| `ProviderIntegrationRepositoryImpl` | `getProviderIntegrationData` | 0 | 1 |
| `ProviderIntegrationRepositoryImpl` | `updateProviderIntegrationData` | 0 | 1 |
| Models (`fromJson` / `toJson` / `fromEntity`) | various | 0 | 1 |
| | | **Total CC** | **19** |

> Minimum tests required for full branch coverage = **19**  
> Total tests written = **41** (includes argument verification and edge cases)

---

## 1. Local Datasource

Not applicable. The System Integration feature does not have a local datasource.

---

## 2. Remote Datasources

### 2.1 Customer Account Integration Remote Datasource
**Source**: `lib/features/system_integration/data/datasources/customer_account_integration_remote_datasource.dart`  
**Test File**: `test/features/system_integration/data/datasources/customer_account_integration_remote_datasource_test.dart`  
**Mock**: `MockApiClient`

#### Cyclomatic Complexity
All methods have **CC = 1** — no local branching.

| Method | CC |
|---|---|
| `startPairing` | 1 |
| `completePairing` | 1 |
| `getAccountPairingStatus` | 1 |
| `detachAccountPairing` | 1 |
| `getAllAccountsPairingStatus` | 1 |

#### Test Cases & Result

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R1 | Successful `startPairing` | Happy path | `apiClient.post` → valid JSON | `ApiResponse<StartPairingDataModel>` with redirectUrl | ✅ PASS |
| R2 | `startPairing` API throws | Exception propagation | `apiClient.post` throws `ApiException(400)` | `ApiException` propagates | ✅ PASS |
| R3 | Correct endpoint & payload | Argument verification | Any | `post(Endpoints.startPairing)` called with company_id | ✅ PASS |
| R4 | Successful `completePairing` | Happy path | `apiClient.post` → valid JSON | `ApiResponse<ExternalUserModel>` | ✅ PASS |
| R5 | `completePairing` API throws | Exception propagation | `apiClient.post` throws `ApiException(400)` | `ApiException` propagates | ✅ PASS |
| R6 | Correct endpoint & payload | Argument verification | Any | `post(Endpoints.completePairing)` called with code, state | ✅ PASS |
| R7 | Successful `getAccountPairingStatus` | Happy path | `apiClient.get` → valid JSON | `ApiResponse<ExternalUserModel>` | ✅ PASS |
| R8 | `getAccountPairingStatus` API throws | Exception propagation | `apiClient.get` throws `ApiException(404)` | `ApiException` propagates | ✅ PASS |
| R9 | Correct endpoint used | Argument verification | Any | `get(Endpoints.accountPairing)` with companyId called | ✅ PASS |
| R10 | Successful `detachAccountPairing` | Happy path | `apiClient.delete` → valid JSON | `ApiResponse<ExternalUserModel>` | ✅ PASS |
| R11 | `detachAccountPairing` API throws | Exception propagation | `apiClient.delete` throws `ApiException(400)` | `ApiException` propagates | ✅ PASS |
| R12 | Correct endpoint used | Argument verification | Any | `delete(Endpoints.detachAccountPairing)` with companyId | ✅ PASS |
| R13 | Successful `getAllAccountsPairingStatus` | Happy path | `apiClient.get` → valid JSON list | `ApiResponse<List<ExternalUserModel>>` | ✅ PASS |
| R14 | `getAllAccountsPairingStatus` API throws | Exception propagation | `apiClient.get` throws `ApiException(500)` | `ApiException` propagates | ✅ PASS |
| R15 | Correct endpoint used | Argument verification | Any | `get(Endpoints.allAccountPairing)` called once | ✅ PASS |

**Section Total: 15 / 15 PASS**

---

### 2.2 Provider Integration Remote Datasource
**Source**: `lib/features/system_integration/data/datasources/provider_integration_remote_datasource.dart`  
**Test File**: `test/features/system_integration/data/datasources/provider_integration_remote_datasource_test.dart`  
**Mock**: `MockApiClient`

#### Cyclomatic Complexity
All methods have **CC = 1** — no local branching.

| Method | CC |
|---|---|
| `getProviderIntegrationData` | 1 |
| `updateProviderIntegrationData` | 1 |

#### Test Cases & Result

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R16 | Successful `getProviderIntegration` | Happy path | `apiClient.get` → valid JSON | `ApiResponse<ProviderIntegrationDataModel>` | ✅ PASS |
| R17 | `getProviderIntegration` API throws | Exception propagation | `apiClient.get` throws `ApiException(404)` | `ApiException` propagates | ✅ PASS |
| R18 | Correct endpoint used | Argument verification | Any | `get(Endpoints.systemIntegration)` called once | ✅ PASS |
| R19 | Successful `updateProviderIntegration` | Happy path | `apiClient.put` → valid JSON | `ApiResponse<ProviderIntegrationDataModel>` | ✅ PASS |
| R20 | `updateProviderIntegration` API throws | Exception propagation | `apiClient.put` throws `ApiException(400)` | `ApiException` propagates | ✅ PASS |
| R21 | Correct endpoint & payload | Argument verification | Any | `put(Endpoints.systemIntegration)` with payload called | ✅ PASS |

**Section Total: 6 / 6 PASS**

---

## 3. Repositories

### 3.1 Customer Account Integration Repository Impl
**Source**: `lib/features/system_integration/data/repositories/customer_account_integration_repository_impl.dart`  
**Test File**: `test/features/system_integration/data/repositories/customer_account_integration_repository_impl_test.dart`  
**Mock**: `MockCustomerAccountIntegrationRemoteDatasource`

#### Cyclomatic Complexity
All methods delegate to the remote datasource inside a `safeCall` closure, resulting in **CC = 1**.

| Method | CC |
|---|---|
| `startPairing` | 1 |
| `completePairing` | 1 |
| `getAccountPairingStatus` | 1 |
| `detachAccountPairing` | 1 |
| `getAllAccountsPairingStatus` | 1 |

#### Test Cases & Result

| ID | Test Case | Branch / Path | Setup | Expected | Result |
|---|---|---|---|---|---|
| I1 | Successful startPairing | `safeCall` success | Remote returns `ApiResponse<StartPairingDataModel>` | `Right(StartPairingDataEntity)` | ✅ PASS |
| I2 | startPairing remote fails | `safeCall` catch -> `ServerFailure` | Remote throws `ApiException(500)` | `Left(ServerFailure)` | ✅ PASS |
| I3 | Successful completePairing | `safeCall` success | Remote returns `ApiResponse<ExternalUserModel>` | `Right(ExternalUserEntity)` | ✅ PASS |
| I4 | completePairing remote fails | `safeCall` catch -> `ValidationFailure` | Remote throws `ApiException(400)` | `Left(ValidationFailure)` (asserts `isLeft()`) | ✅ PASS |
| I5 | Successful getAccountPairingStatus | `safeCall` success | Remote returns `ApiResponse<ExternalUserModel>` | `Right(ExternalUserEntity)` | ✅ PASS |
| I6 | getAccountPairingStatus remote fails | `safeCall` catch -> `ServerFailure` | Remote throws `ApiException(404)` | `Left(ServerFailure)` | ✅ PASS |
| I7 | Successful detachAccountPairing | `safeCall` success | Remote returns `ApiResponse<ExternalUserModel>` | `Right(ExternalUserEntity)` | ✅ PASS |
| I8 | detachAccountPairing remote fails | `safeCall` catch -> `ValidationFailure` | Remote throws `ApiException(400)` | `Left(ValidationFailure)` | ✅ PASS |
| I9 | Successful getAllAccountsPairingStatus | `safeCall` success | Remote returns `ApiResponse<List<ExternalUserModel>>` | `Right(List<ExternalUserEntity>)` | ✅ PASS |
| I10 | getAllAccountsPairingStatus remote fails | `safeCall` catch -> `ServerFailure` | Remote throws `ApiException(500)` | `Left(ServerFailure)` | ✅ PASS |

**Section Total: 10 / 10 PASS**

---

### 3.2 Provider Integration Repository Impl
**Source**: `lib/features/system_integration/data/repositories/provider_integration_repository_impl.dart`  
**Test File**: `test/features/system_integration/data/repositories/provider_integration_repository_impl_test.dart`  
**Mock**: `MockProviderIntegrationRemoteDatasource`

#### Cyclomatic Complexity
All methods delegate to the remote datasource inside a `safeCall` closure, resulting in **CC = 1**.

| Method | CC |
|---|---|
| `getProviderIntegrationData` | 1 |
| `updateProviderIntegrationData` | 1 |

#### Test Cases & Result

| ID | Test Case | Branch / Path | Setup | Expected | Result |
|---|---|---|---|---|---|
| I11 | Successful getProviderIntegrationData | `safeCall` success | Remote returns `ApiResponse<ProviderIntegrationDataModel>` | `Right(ProviderIntegrationDataEntity)` | ✅ PASS |
| I12 | getProviderIntegrationData remote fails | `safeCall` catch -> `ServerFailure` | Remote throws `ApiException(500)` | `Left(ServerFailure)` | ✅ PASS |
| I13 | Successful updateProviderIntegrationData | `safeCall` success | Remote returns `ApiResponse<ProviderIntegrationDataModel>` | `Right(ProviderIntegrationDataEntity)` | ✅ PASS |
| I14 | updateProviderIntegrationData remote fails | `safeCall` catch -> `ServerFailure` | Remote throws `ApiException(500)` | `Left(ServerFailure)` | ✅ PASS |

**Section Total: 4 / 4 PASS**

---

## 4. Models
**Source**: `lib/features/system_integration/data/model/`  
**Test File**: `test/features/system_integration/data/model/system_integration_models_test.dart`

#### Cyclomatic Complexity
Model deserialization methods (`fromJson`) have straight-line execution mappings with no complex local branching. **CC = 1**.

#### Test Cases & Result

| ID | Test Case | Branch / Path | Input | Expected | Result |
|---|---|---|---|---|---|
| M1 | `ExternalUserModel.fromJson` happy path | Happy path | JSON with CompanyModel & date | Model fields mapped correctly | ✅ PASS |
| M2 | `ProviderIntegrationDataModel.fromJson` happy path | Happy path | JSON with complete parameters | Model fields mapped correctly | ✅ PASS |
| M3 | `ProviderIntegrationDataModel.fromJson` missing integration_type | Default value path | JSON with missing integration_type | Model defaults to `externalSystem` | ✅ PASS |
| M4 | `ProviderIntegrationDataModel.fromEntity` happy path | Happy path | Valid `ProviderIntegrationDataEntity` | Correct model fields | ✅ PASS |
| M5 | `ProviderIntegrationDataModel.toJson` happy path | Happy path | Valid model | Map has snake_case keys and enum values | ✅ PASS |
| M6 | `StartPairingDataModel.fromJson` happy path | Happy path | JSON with redirectUrl | Model parsed correctly | ✅ PASS |

**Section Total: 6 / 6 PASS**

---

## Overall Result

| Section | Total Test Cases | Passed | Failed | Pass Rate |
|---|---|---|---|---|
| 1. Local Datasource | 0 | 0 | 0 | N/A |
| 2. Remote Datasources | 21 | 21 | 0 | 100% |
| 3. Repository Impl | 14 | 14 | 0 | 100% |
| 4. Models | 6 | 6 | 0 | 100% |
| **Total** | **41** | **41** | **0** | **100%** |

### Execution Command and Output
```bash
flutter test test/features/system_integration/data/ --reporter expanded
```
```
00:01 +41: All tests passed!
```

---

## Notes
- During error-path testing of the Repository layer, expected `ApiException` exceptions are logged via the `safeCall` exception handler:
  - `⛔ ❌ ERROR in safeCall`
  This is expected console noise from production logging code and does not represent test failures. All test assertions succeeded.
