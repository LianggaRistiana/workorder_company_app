# Service Request Feature — Whitebox Test Documentation

**Layer**: Data (DataSource & Repository)  
**Framework**: `flutter_test` + `mocktail`  
**Testing Method**: Whitebox (branch/path coverage)  
**Date**: 2026-06-12

---

## File Structure

```
test/features/service_request/
└── data/
    ├── datasources/
    │   ├── provider_service_request_remote_datasource_test.dart  (12 tests)
    │   └── requester_service_request_remote_datasource_test.dart (27 tests)
    ├── repositories/
    │   ├── provider_service_request_repository_impl_test.dart    (13 tests)
    │   └── requester_service_request_repository_impl_test.dart   (23 tests)
    └── model/
        └── service_request_models_test.dart                     (5 tests)
```

---

## Cyclomatic Complexity Reference

> **Formula**: CC = Number of decision points + 1  
> Decision points: `if`, `else if`, `on`, `catch`, `case`, `&&`, `||`

| Class | Method | Decision Points | CC |
|---|---|---|---|
| `ProviderServiceRequestRemoteDatasourceImpl` | `approveServiceRequest` | 0 | 1 |
| `ProviderServiceRequestRemoteDatasourceImpl` | `getServiceRequestDetail` | 0 | 1 |
| `ProviderServiceRequestRemoteDatasourceImpl` | `getServiceRequests` | 0 | 1 |
| `ProviderServiceRequestRemoteDatasourceImpl` | `rejectServiceRequest` | 0 | 1 |
| `RequesterServiceRequestRemoteDatasourceImpl`| `cancelServiceRequest` | 0 | 1 |
| `RequesterServiceRequestRemoteDatasourceImpl`| `getServiceRequests` | 0 | 1 |
| `RequesterServiceRequestRemoteDatasourceImpl`| `getServiceRequestDetail` | 0 | 1 |
| `RequesterServiceRequestRemoteDatasourceImpl`| `submitIntakeForm` | 0 | 1 |
| `RequesterServiceRequestRemoteDatasourceImpl`| `submitReviewForm` | 0 | 1 |
| `RequesterServiceRequestRemoteDatasourceImpl`| `getIntakeFormForPublic` | 0 | 1 |
| `RequesterServiceRequestRemoteDatasourceImpl`| `getIntakeFormForInternal` | 0 | 1 |
| `RequesterServiceRequestRemoteDatasourceImpl`| `getReviewForm` | 0 | 1 |
| `RequesterServiceRequestRemoteDatasourceImpl`| `getServiceRequestReport` | 0 | 1 |
| `ProviderServiceRequestRepositoryImpl` | Constructor (event listener) | 1 | 2 |
| `ProviderServiceRequestRepositoryImpl` | `approveServiceRequest` | 0 | 1 |
| `ProviderServiceRequestRepositoryImpl` | `getServiceRequests` | 0 | 1 |
| `ProviderServiceRequestRepositoryImpl` | `getServiceRequestDetail` | 0 | 1 |
| `ProviderServiceRequestRepositoryImpl` | `rejectServiceRequest` | 0 | 1 |
| `RequesterServiceRequestRepositoryImpl` | Constructor (event listener) | 1 | 2 |
| `RequesterServiceRequestRepositoryImpl` | `cancelServiceRequest` | 0 | 1 |
| `RequesterServiceRequestRepositoryImpl` | `getServiceRequests` | 0 | 1 |
| `RequesterServiceRequestRepositoryImpl` | `getServiceRequestDetail` | 0 | 1 |
| `RequesterServiceRequestRepositoryImpl` | `getIntakeForm` | 1 | 2 |
| `RequesterServiceRequestRepositoryImpl` | `submitIntakeForm` | 0 | 1 |
| `RequesterServiceRequestRepositoryImpl` | `submitReviewForm` | 0 | 1 |
| `RequesterServiceRequestRepositoryImpl` | `getReviewForm` | 0 | 1 |
| `RequesterServiceRequestRepositoryImpl` | `getServiceRequestReport` | 0 | 1 |
| `ServiceRequestStatusDateModel` | `fromJson` | 0 | 1 |
| `ProviderServiceRequestModel` | `fromJson` | 2 | 3 |
| `RequesterServiceRequestModel` | `fromJson` | 2 | 3 |
| | | **Total CC** | **37** |

> Minimum tests required for full branch coverage = **37**  
> Total tests written = **80** (includes argument verification and exception handling)

---

## 1. Provider Service Request Remote DataSource

**Source**: `lib/features/service_request/data/datasources/provider_service_request_remote_datasource.dart`  
**Test File**: `test/features/service_request/data/datasources/provider_service_request_remote_datasource_test.dart`  
**Mock**: `MockApiClient`

### Cyclomatic Complexity

All methods have **CC = 1** — no local branching.

### Test Cases & Result

#### `approveServiceRequest(String id)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R1 | Successful approval | Happy path | `apiClient.patch` -> valid JSON | `ApiResponse<ProviderServiceRequestModel>` returned | ✅ PASS |
| R2 | API throws `ApiException` | Exception propagation | `apiClient.patch` throws `ApiException(400, 'Bad Request')` | `ApiException` propagates to caller | ✅ PASS |
| R3 | Correct endpoint used | Argument verification | Any | `patch` called with `Endpoints.serviceRequestApprove` filled | ✅ PASS |

#### `getServiceRequestDetail(String id)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R4 | Successful fetch | Happy path | `apiClient.get` -> valid JSON | `ApiResponse<ProviderServiceRequestModel>` returned | ✅ PASS |
| R5 | API throws `ApiException` | Exception propagation | `apiClient.get` throws `ApiException(404, 'Not Found')` | `ApiException` propagates to caller | ✅ PASS |
| R6 | Correct endpoint used | Argument verification | Any | `get` called with `Endpoints.serviceRequestDetail` filled | ✅ PASS |

#### `getServiceRequests()` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R7 | Successful fetch list | Happy path | `apiClient.get` -> list JSON | `ApiResponse<List<ProviderServiceRequestModel>>` returned | ✅ PASS |
| R8 | API throws `ApiException` | Exception propagation | `apiClient.get` throws `ApiException(500, 'Internal Server Error')` | `ApiException` propagates to caller | ✅ PASS |
| R9 | Correct endpoint used | Argument verification | Any | `get` called with `Endpoints.serviceRequestInbox` | ✅ PASS |

#### `rejectServiceRequest(String id)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R10 | Successful rejection | Happy path | `apiClient.patch` -> valid JSON | `ApiResponse<ProviderServiceRequestModel>` returned | ✅ PASS |
| R11 | API throws `ApiException` | Exception propagation | `apiClient.patch` throws `ApiException(400, 'Bad Request')` | `ApiException` propagates to caller | ✅ PASS |
| R12 | Correct endpoint used | Argument verification | Any | `patch` called with `Endpoints.serviceRequestReject` filled | ✅ PASS |

**Section Total: 12 / 12 PASS**

---

## 2. Requester Service Request Remote DataSource

**Source**: `lib/features/service_request/data/datasources/requester_service_request_remote_datasource.dart`  
**Test File**: `test/features/service_request/data/datasources/requester_service_request_remote_datasource_test.dart`  
**Mock**: `MockApiClient`

### Cyclomatic Complexity

All methods have **CC = 1** — no local branching.

### Test Cases & Result

#### `cancelServiceRequest(String id)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R13 | Successful cancel | Happy path | `apiClient.patch` -> valid JSON | `ApiResponse<RequesterServiceRequestModel>` returned | ✅ PASS |
| R14 | API throws `ApiException` | Exception propagation | `apiClient.patch` throws `ApiException(400)` | `ApiException` propagates | ✅ PASS |
| R15 | Correct endpoint used | Argument verification | Any | `patch` called with `Endpoints.serviceRequestCancel` filled | ✅ PASS |

#### `getServiceRequests()` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R16 | Successful fetch | Happy path | `apiClient.get` -> valid JSON | `ApiResponse<List<RequesterServiceRequestModel>>` returned | ✅ PASS |
| R17 | API throws `ApiException` | Exception propagation | `apiClient.get` throws `ApiException(500)` | `ApiException` propagates | ✅ PASS |
| R18 | Correct endpoint used | Argument verification | Any | `get` called with `Endpoints.serviceRequestSent` | ✅ PASS |

#### `getServiceRequestDetail(String id)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R19 | Successful fetch | Happy path | `apiClient.get` -> valid JSON | `ApiResponse<RequesterServiceRequestModel>` returned | ✅ PASS |
| R20 | API throws `ApiException` | Exception propagation | `apiClient.get` throws `ApiException(404)` | `ApiException` propagates | ✅ PASS |
| R21 | Correct endpoint used | Argument verification | Any | `get` called with `Endpoints.serviceRequestDetail` filled | ✅ PASS |

#### `submitIntakeForm(String serviceId, SubmissionsModel submission)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R22 | Successful submit | Happy path | `apiClient.post` -> valid JSON | `ApiResponse<RequesterServiceRequestModel>` returned | ✅ PASS |
| R23 | API throws `ApiException` | Exception propagation | `apiClient.post` throws `ApiException(422)` | `ApiException` propagates | ✅ PASS |
| R24 | Correct endpoint & payload | Argument verification | Any | `post` called with `Endpoints.serviceRequestCreate` filled, payload contains `submission` | ✅ PASS |

#### `submitReviewForm(String serviceRequestId, SubmissionsModel submission)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R25 | Successful submit | Happy path | `apiClient.post` -> valid JSON | `ApiResponse<RequesterServiceRequestModel>` returned | ✅ PASS |
| R26 | API throws `ApiException` | Exception propagation | `apiClient.post` throws `ApiException(422)` | `ApiException` propagates | ✅ PASS |
| R27 | Correct endpoint & payload | Argument verification | Any | `post` called with `Endpoints.serviceRequestReview` filled, payload contains `submission` | ✅ PASS |

#### `getIntakeFormForPublic(String serviceId)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R28 | Successful fetch | Happy path | `apiClient.get` -> valid Form JSON | `ApiResponse<FormModel>` returned | ✅ PASS |
| R29 | API throws `ApiException` | Exception propagation | `apiClient.get` throws `ApiException(404)` | `ApiException` propagates | ✅ PASS |
| R30 | Correct endpoint used | Argument verification | Any | `get` called with `Endpoints.serviceRequestIntakePublic` filled | ✅ PASS |

#### `getIntakeFormForInternal(String serviceId)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R31 | Successful fetch | Happy path | `apiClient.get` -> valid Form JSON | `ApiResponse<FormModel>` returned | ✅ PASS |
| R32 | API throws `ApiException` | Exception propagation | `apiClient.get` throws `ApiException(404)` | `ApiException` propagates | ✅ PASS |
| R33 | Correct endpoint used | Argument verification | Any | `get` called with `Endpoints.serviceRequestIntakeInternal` filled | ✅ PASS |

#### `getReviewForm(String serviceRequestId)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R34 | Successful fetch | Happy path | `apiClient.get` -> valid Form JSON | `ApiResponse<FormModel>` returned | ✅ PASS |
| R35 | API throws `ApiException` | Exception propagation | `apiClient.get` throws `ApiException(404)` | `ApiException` propagates | ✅ PASS |
| R36 | Correct endpoint used | Argument verification | Any | `get` called with `Endpoints.serviceRequestReview` filled | ✅ PASS |

#### `getServiceRequestReport(String id)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R37 | Successful fetch | Happy path | `apiClient.get` -> valid JSON | `ApiResponse<WorkReportsFilledFormModel>` returned | ✅ PASS |
| R38 | API throws `ApiException` | Exception propagation | `apiClient.get` throws `ApiException(500)` | `ApiException` propagates | ✅ PASS |
| R39 | Correct endpoint used | Argument verification | Any | `get` called with `Endpoints.serviceRequestReport` filled | ✅ PASS |

**Section Total: 27 / 27 PASS**

---

## 3. Provider Service Request Repository

**Source**: `lib/features/service_request/data/repositories/provider_service_request_repository_impl.dart`  
**Test File**: `test/features/service_request/data/repositories/provider_service_request_repository_impl_test.dart`  
**Mock**: `MockProviderServiceRequestRemoteDatasource`

### Cyclomatic Complexity

| Method | CC | Decision Points |
|---|---|---|
| Constructor (event listener) | 2 | `if (event == ResourceType.serviceRequest)` |
| `approveServiceRequest` | 1 | None (delegated to `safeCall`) |
| `getServiceRequests` | 1 | None (delegated to `_cache.fetchList`) |
| `getServiceRequestDetail` | 1 | None (delegated to `safeCall`) |
| `rejectServiceRequest` | 1 | None (delegated to `safeCall`) |

### Test Cases & Result

#### `approveServiceRequest(String id)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| I1 | Successful approval | Happy path | Remote returns model | Returns `Right(ProviderServiceRequestEntity)`, merges cache, emits cacheChanged | ✅ PASS |
| I2 | Remote throws exception | Exception path | Remote throws `ApiException(422)` | Returns `Left(ValidationFailure)` | ✅ PASS |

#### `rejectServiceRequest(String id)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| I3 | Successful rejection | Happy path | Remote returns model | Returns `Right(ProviderServiceRequestEntity)`, merges cache, emits cacheChanged | ✅ PASS |
| I4 | Remote throws exception | Exception path | Remote throws `ApiException(401)` | Returns `Left(AuthFailure)` | ✅ PASS |

#### `getServiceRequests({bool forceRefresh})` — CC = 1

| ID | Test Case | Branch / Path | Cache State / Setup | Expected | Result |
|---|---|---|---|---|---|
| I5 | Cache valid, no force refresh | Cache hit | Cache seeded, `forceRefresh = false` | Returns cached list without calling remote | ✅ PASS |
| I6 | Cache empty, no force refresh | Cache miss | Cache empty, remote returns list | Calls remote, updates cache, returns list | ✅ PASS |
| I7 | Cache seeded, force refresh | Cache bypass | Cache seeded, `forceRefresh = true` | Calls remote, updates cache, returns list | ✅ PASS |
| I8 | Remote fails | Error path | Remote throws `ApiException(500)` | Returns `Left(ServerFailure)` | ✅ PASS |

#### `getServiceRequestDetail(String id)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| I9 | Successful detail fetch | Happy path | Remote returns model | Returns `Right(ProviderServiceRequestEntity)` | ✅ PASS |
| I10 | Remote fails | Error path | Remote throws `ApiException(404)` | Returns `Left(ServerFailure)` | ✅ PASS |

#### `clearCache()` — CC = 1

| ID | Test Case | Branch / Path | Expected | Result |
|---|---|---|---|---|
| I11 | Normal cache clear | Straight-line | Cache is cleared, next fetch hits remote | ✅ PASS |

#### Constructor Event Listener — CC = 2

| ID | Test Case | Branch / Path | Input Event | Expected | Result |
|---|---|---|---|---|---|
| I12 | Matches ResourceType.serviceRequest | `event == ResourceType.serviceRequest` | `ResourceType.serviceRequest` | Cache is cleared, cacheChanged emits | ✅ PASS |
| I13 | Matches other ResourceType | `event != ResourceType.serviceRequest` | `ResourceType.invitation` | Cache is NOT cleared, no event emitted | ✅ PASS |

**Section Total: 13 / 13 PASS**

---

## 4. Requester Service Request Repository

**Source**: `lib/features/service_request/data/repositories/requester_service_request_repository_impl.dart`  
**Test File**: `test/features/service_request/data/repositories/requester_service_request_repository_impl_test.dart`  
**Mock**: `MockRequesterServiceRequestRemoteDatasource`

### Cyclomatic Complexity

| Method | CC | Decision Points |
|---|---|---|
| Constructor (event listener) | 2 | `if (event == ResourceType.serviceRequest)` |
| `cancelServiceRequest` | 1 | None (delegated to `safeCall`) |
| `getServiceRequests` | 1 | None (delegated to `_cache.fetchList`) |
| `getServiceRequestDetail` | 1 | None (delegated to `safeCall`) |
| `getIntakeForm` | 2 | `if (role == UserRole.client)` |
| `submitIntakeForm` | 1 | None (delegated to `safeCall`) |
| `submitReviewForm` | 1 | None (delegated to `safeCall`) |
| `getReviewForm` | 1 | None (delegated to `safeCall`) |
| `getServiceRequestReport` | 1 | None (delegated to `safeCall`) |

### Test Cases & Result

#### `cancelServiceRequest(String id)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| I14 | Successful cancel | Happy path | Remote returns model | Returns `Right(RequesterServiceRequestEntity)`, merges cache, emits cacheChanged | ✅ PASS |
| I15 | Remote throws exception | Exception path | Remote throws `ApiException(422)` | Returns `Left(ValidationFailure)` | ✅ PASS |

#### `getServiceRequests({bool forceRefresh})` — CC = 1

| ID | Test Case | Branch / Path | Cache State / Setup | Expected | Result |
|---|---|---|---|---|---|
| I16 | Cache valid, no force refresh | Cache hit | Cache seeded, `forceRefresh = false` | Returns cached list without calling remote | ✅ PASS |
| I17 | Cache empty, no force refresh | Cache miss | Cache empty, remote returns list | Calls remote, updates cache, returns list | ✅ PASS |
| I18 | Cache seeded, force refresh | Cache bypass | Cache seeded, `forceRefresh = true` | Calls remote, updates cache, returns list | ✅ PASS |
| I19 | Remote fails | Error path | Remote throws `ApiException(500)` | Returns `Left(ServerFailure)` | ✅ PASS |

#### `getServiceRequestDetail(String id)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| I20 | Successful detail fetch | Happy path | Remote returns model | Returns `Right(RequesterServiceRequestEntity)` | ✅ PASS |
| I21 | Remote fails | Error path | Remote throws `ApiException(404)` | Returns `Left(ServerFailure)` | ✅ PASS |

#### `getIntakeForm(String serviceId, UserRole role)` — CC = 2

```
getIntakeForm()
 ├── [A] role == UserRole.client   → Calls getIntakeFormForPublic()
 └── [B] role != UserRole.client   → Calls getIntakeFormForInternal()
```

| ID | Test Case | Branch | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| I22 | Client role - success | [A] | Remote public intake returns Form | Returns `Right(FormEntity)` | ✅ PASS |
| I23 | Client role - fails | [A] | Remote public intake throws `ApiException(404)` | Returns `Left(ServerFailure)` | ✅ PASS |
| I24 | Internal role - success | [B] | Remote internal intake returns Form | Returns `Right(FormEntity)` | ✅ PASS |
| I25 | Internal role - fails | [B] | Remote internal intake throws `ApiException(404)` | Returns `Left(ServerFailure)` | ✅ PASS |

#### `submitIntakeForm(String serviceId, SubmissionEntity submission)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| I26 | Successful submit | Happy path | Remote returns model | Returns `Right(RequesterServiceRequestEntity)`, merges cache, emits cacheChanged | ✅ PASS |
| I27 | Remote fails | Error path | Remote throws `ApiException(422)` | Returns `Left(ValidationFailure)` | ✅ PASS |

#### `submitReviewForm(String serviceRequestId, SubmissionEntity submission)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| I28 | Successful submit | Happy path | Remote returns model | Returns `Right(RequesterServiceRequestEntity)`, merges cache, emits cacheChanged | ✅ PASS |
| I29 | Remote fails | Error path | Remote throws `ApiException(422)` | Returns `Left(ValidationFailure)` | ✅ PASS |

#### `getReviewForm(String serviceRequestId)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| I30 | Successful fetch | Happy path | Remote returns Form | Returns `Right(FormEntity)` | ✅ PASS |
| I31 | Remote fails | Error path | Remote throws `ApiException(404)` | Returns `Left(ServerFailure)` | ✅ PASS |

#### `getServiceRequestReport(String id)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| I32 | Successful fetch | Happy path | Remote returns report model | Returns `Right(WorkReportsFilledFormEntity)` | ✅ PASS |
| I33 | Remote fails | Error path | Remote throws `ApiException(404)` | Returns `Left(ServerFailure)` | ✅ PASS |

#### `clearCache()` — CC = 1

| ID | Test Case | Branch / Path | Expected | Result |
|---|---|---|---|---|
| I34 | Normal cache clear | Straight-line | Cache is cleared, next fetch hits remote | ✅ PASS |

#### Constructor Event Listener — CC = 2

| ID | Test Case | Branch / Path | Input Event | Expected | Result |
|---|---|---|---|---|---|
| I35 | Matches ResourceType.serviceRequest | `event == ResourceType.serviceRequest` | `ResourceType.serviceRequest` | Cache is cleared, cacheChanged emits | ✅ PASS |
| I36 | Matches other ResourceType | `event != ResourceType.serviceRequest` | `ResourceType.invitation` | Cache is NOT cleared, no event emitted | ✅ PASS |

**Section Total: 23 / 23 PASS**

---

## 5. Data Models

**Source**: `lib/features/service_request/data/model/`  
**Test File**: `test/features/service_request/data/model/service_request_models_test.dart`  
**Mock**: None

### Cyclomatic Complexity

| Model | Method | CC | Decision Points |
|---|---|---|---|
| `ServiceRequestStatusDateModel` | `fromJson` | 1 | None |
| `ProviderServiceRequestModel` | `fromJson` | 3 | 2× ternary operators for `intakeForm` and `reviewForm` |
| `RequesterServiceRequestModel` | `fromJson` | 3 | 2× ternary operators for `intakeForm` and `reviewForm` |

### Test Cases & Result

#### `ServiceRequestStatusDateModel` — CC = 1

| ID | Test Case | Branch / Path | Input | Expected | Result |
|---|---|---|---|---|---|
| M1 | fromJson parses all dates | Straight-line | JSON with non-null `createdAt` & `approvedAt`, others null | Correct `DateTime` mapping and null fields | ✅ PASS |

#### `ProviderServiceRequestModel` — CC = 3

| ID | Test Case | Branch / Path | Input | Expected | Result |
|---|---|---|---|---|---|
| M2 | fromJson with all nested forms | Ternary = true paths | JSON containing non-null intake/review forms/submissions | Mapped to `FilledFormModel` for both fields | ✅ PASS |
| M3 | fromJson with null forms | Ternary = false paths | JSON containing null intake/review forms/submissions | `intakeForm` and `reviewForm` are null | ✅ PASS |

#### `RequesterServiceRequestModel` — CC = 3

| ID | Test Case | Branch / Path | Input | Expected | Result |
|---|---|---|---|---|---|
| M4 | fromJson with all nested forms | Ternary = true paths | JSON containing non-null intake/review forms/submissions | Mapped to `FilledFormModel` for both fields | ✅ PASS |
| M5 | fromJson with null forms | Ternary = false paths | JSON containing null intake/review forms/submissions | `intakeForm` and `reviewForm` are null | ✅ PASS |

**Section Total: 5 / 5 PASS**

---

## Overall Result

```
flutter test test/features/service_request/data/ --reporter expanded

00:02 +80: All tests passed!
```

| Test File | Tests | Pass | Fail |
|---|---|---|---|
| `provider_service_request_remote_datasource_test.dart` | 12 | 12 | 0 |
| `requester_service_request_remote_datasource_test.dart` | 27 | 27 | 0 |
| `provider_service_request_repository_impl_test.dart` | 13 | 13 | 0 |
| `requester_service_request_repository_impl_test.dart` | 23 | 23 | 0 |
| `service_request_models_test.dart` | 5 | 5 | 0 |
| **Total** | **80** | **80** | **0** |

**✅ All 80 tests passed.**

---

## Notes

- Production logs showing `⛔ ❌ ERROR in safeCall` in the test runner output are expected log trace outputs from repository error-path testing using the `safeCall` utility. These logs do not indicate test failures.
