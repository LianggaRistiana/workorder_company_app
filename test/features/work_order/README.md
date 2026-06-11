# Work Order Feature — Whitebox Test Documentation

**Layer**: Data (DataSource & Repository)  
**Framework**: `flutter_test` + `mocktail`  
**Testing Method**: Whitebox (branch/path coverage)  
**Date**: 2026-06-12

---

## File Structure

```
test/features/work_order/
└── data/
    ├── datasources/
    │   └── work_order_remote_datasource_test.dart  (39 tests)
    ├── repositories/
    │   └── work_order_repository_impl_test.dart    (29 tests)
    └── model/
        └── work_order_models_test.dart             (3 tests)
```

---

## Cyclomatic Complexity Reference

> **Formula**: CC = Number of decision points + 1  
> Decision points: `if`, `else if`, `on`, `catch`, `case`, `&&`, `||`

| Class | Method | Decision Points | CC |
|---|---|---|---|
| `WorkOrderRemoteDatasourceImpl` | `approveWorkOrder` | 0 | 1 |
| `WorkOrderRemoteDatasourceImpl` | `assignStaffs` | 0 | 1 |
| `WorkOrderRemoteDatasourceImpl` | `cancelWorkOrder` | 0 | 1 |
| `WorkOrderRemoteDatasourceImpl` | `completeWorkOrder` | 0 | 1 |
| `WorkOrderRemoteDatasourceImpl` | `createWorkOrder` | 0 | 1 |
| `WorkOrderRemoteDatasourceImpl` | `failWorkOrder` | 0 | 1 |
| `WorkOrderRemoteDatasourceImpl` | `getWorkOrderById` | 0 | 1 |
| `WorkOrderRemoteDatasourceImpl` | `getWorkOrders` | 0 | 1 |
| `WorkOrderRemoteDatasourceImpl` | `recreateWorkOrder` | 0 | 1 |
| `WorkOrderRemoteDatasourceImpl` | `rejectWorkOrder` | 0 | 1 |
| `WorkOrderRemoteDatasourceImpl` | `sendWorkOrder` | 0 | 1 |
| `WorkOrderRemoteDatasourceImpl` | `startWorkOrder` | 0 | 1 |
| `WorkOrderRemoteDatasourceImpl` | `submitWorkOrderSubmission` | 0 | 1 |
| `WorkOrderRepositoryImpl` | `_handleMetaCall` | 1 | 2 |
| `WorkOrderRepositoryImpl` | `getWorkOrders` | 0 | 1 |
| `WorkOrderRepositoryImpl` | `getWorkOrderById` | 0 | 1 |
| `WorkOrderRepositoryImpl` | `createWorkOrder` | 0 | 1 |
| `WorkOrderRepositoryImpl` | `approveWorkOrder` | 0 | 1 |
| `WorkOrderRepositoryImpl` | `rejectWorkOrder` | 0 | 1 |
| `WorkOrderRepositoryImpl` | `cancelWorkOrder` | 0 | 1 |
| `WorkOrderRepositoryImpl` | `recreateWorkOrder` | 0 | 1 |
| `WorkOrderRepositoryImpl` | `sendWorkOrder` | 0 | 1 |
| `WorkOrderRepositoryImpl` | `startWorkOrder` | 0 | 1 |
| `WorkOrderRepositoryImpl` | `completeWorkOrder` | 0 | 1 |
| `WorkOrderRepositoryImpl` | `failWorkOrder` | 0 | 1 |
| `WorkOrderRepositoryImpl` | `assignStaffs` | 0 | 1 |
| `WorkOrderRepositoryImpl` | `submitWorkOrderSubmission` | 0 | 1 |
| `WorkOrderStatusDateModel` | `fromJson` | 0 | 1 |
| `WorkOrderModel` | `fromJson` | 1 | 2 |
| | | **Total CC** | **31** |

> Minimum tests required for full branch coverage = **31**  
> Total tests written = **71** (includes argument verification and exception handling)

---

## 1. Work Order Remote DataSource

**Source**: `lib/features/work_order/data/datasources/work_order_remote_datasource.dart`  
**Test File**: `test/features/work_order/data/datasources/work_order_remote_datasource_test.dart`  
**Mock**: `MockApiClient`

### Cyclomatic Complexity

All methods have **CC = 1** — no local branching.

### Test Cases & Result

#### `getWorkOrders()` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R1 | Successful list fetch | Happy path | `apiClient.get` -> valid JSON list | `ApiResponse<List<WorkOrderModel>>` returned | ✅ PASS |
| R2 | API throws exception | Exception propagation | `apiClient.get` throws `ApiException` | `ApiException` propagates | ✅ PASS |
| R3 | Correct endpoint used | Argument verification | Any | `get` called with `Endpoints.workorders` | ✅ PASS |

#### `getWorkOrderById(String id)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R4 | Successful details fetch | Happy path | `apiClient.get` -> valid JSON | `ApiResponseWithMeta<WorkOrderModel>` returned | ✅ PASS |
| R5 | API throws exception | Exception propagation | `apiClient.get` throws `ApiException` | `ApiException` propagates | ✅ PASS |
| R6 | Correct endpoint used | Argument verification | Any | `get` called with `Endpoints.workorderDetail` filled | ✅ PASS |

#### `createWorkOrder(String serviceId)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R7 | Successful creation | Happy path | `apiClient.post` -> valid JSON | `ApiResponseWithMeta<WorkOrderModel>` returned | ✅ PASS |
| R8 | API throws exception | Exception propagation | `apiClient.post` throws `ApiException` | `ApiException` propagates | ✅ PASS |
| R9 | Correct endpoint used | Argument verification | Any | `post` called with `Endpoints.workorderCreate` filled | ✅ PASS |

#### `recreateWorkOrder(String id)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R10 | Successful recreation | Happy path | `apiClient.post` -> valid JSON | `ApiResponseWithMeta<WorkOrderModel>` returned | ✅ PASS |
| R11 | API throws exception | Exception propagation | `apiClient.post` throws `ApiException` | `ApiException` propagates | ✅ PASS |
| R12 | Correct endpoint used | Argument verification | Any | `post` called with `Endpoints.workorderRecreate` filled | ✅ PASS |

#### `submitWorkOrderSubmission(String id, SubmissionsModel submissions)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R13 | Successful submission | Happy path | `apiClient.put` -> valid JSON | `ApiResponseWithMeta<WorkOrderModel>` returned | ✅ PASS |
| R14 | API throws exception | Exception propagation | `apiClient.put` throws `ApiException` | `ApiException` propagates | ✅ PASS |
| R15 | Correct endpoint and payload | Argument verification | Any | `put` called with `Endpoints.workorderSetSubmissions` filled, payload matches | ✅ PASS |

#### `assignStaffs(String id, AssignedStaffsDraft draft)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R16 | Successful assignment | Happy path | `apiClient.put` -> valid JSON | `ApiResponseWithMeta<WorkOrderModel>` returned | ✅ PASS |
| R17 | API throws exception | Exception propagation | `apiClient.put` throws `ApiException` | `ApiException` propagates | ✅ PASS |
| R18 | Correct endpoint and payload | Argument verification | Any | `put` called with `Endpoints.workorderSetAssignedStaff` filled, payload matches | ✅ PASS |

#### `sendWorkOrder(String id)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R19 | Successful send | Happy path | `apiClient.patch` -> valid JSON | `ApiResponseWithMeta<WorkOrderModel>` returned | ✅ PASS |
| R20 | API throws exception | Exception propagation | `apiClient.patch` throws `ApiException` | `ApiException` propagates | ✅ PASS |
| R21 | Correct endpoint used | Argument verification | Any | `patch` called with `Endpoints.workorderSent` filled | ✅ PASS |

#### `cancelWorkOrder(String id)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R22 | Successful cancellation | Happy path | `apiClient.patch` -> valid JSON | `ApiResponseWithMeta<WorkOrderModel>` returned | ✅ PASS |
| R23 | API throws exception | Exception propagation | `apiClient.patch` throws `ApiException` | `ApiException` propagates | ✅ PASS |
| R24 | Correct endpoint used | Argument verification | Any | `patch` called with `Endpoints.workorderCancel` filled | ✅ PASS |

#### `approveWorkOrder(String id)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R25 | Successful approval | Happy path | `apiClient.patch` -> valid JSON | `ApiResponseWithMeta<WorkOrderModel>` returned | ✅ PASS |
| R26 | API throws exception | Exception propagation | `apiClient.patch` throws `ApiException` | `ApiException` propagates | ✅ PASS |
| R27 | Correct endpoint used | Argument verification | Any | `patch` called with `Endpoints.workorderApprove` filled | ✅ PASS |

#### `rejectWorkOrder(String id, String? issue)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R28 | Successful rejection | Happy path | `apiClient.patch` -> valid JSON | `ApiResponseWithMeta<WorkOrderModel>` returned | ✅ PASS |
| R29 | API throws exception | Exception propagation | `apiClient.patch` throws `ApiException` | `ApiException` propagates | ✅ PASS |
| R30 | Correct endpoint and payload | Argument verification | Any | `patch` called with `Endpoints.workorderReject` filled, payload contains `issue` | ✅ PASS |

#### `startWorkOrder(String id)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R31 | Successful start | Happy path | `apiClient.patch` -> valid JSON | `ApiResponseWithMeta<WorkOrderModel>` returned | ✅ PASS |
| R32 | API throws exception | Exception propagation | `apiClient.patch` throws `ApiException` | `ApiException` propagates | ✅ PASS |
| R33 | Correct endpoint used | Argument verification | Any | `patch` called with `Endpoints.workorderStart` filled | ✅ PASS |

#### `completeWorkOrder(String id, String? issue)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R34 | Successful completion | Happy path | `apiClient.patch` -> valid JSON | `ApiResponseWithMeta<WorkOrderModel>` returned | ✅ PASS |
| R35 | API throws exception | Exception propagation | `apiClient.patch` throws `ApiException` | `ApiException` propagates | ✅ PASS |
| R36 | Correct endpoint and payload | Argument verification | Any | `patch` called with `Endpoints.workorderComplete` filled, payload contains `issue` | ✅ PASS |

#### `failWorkOrder(String id, String issue)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R37 | Successful fail marking | Happy path | `apiClient.patch` -> valid JSON | `ApiResponseWithMeta<WorkOrderModel>` returned | ✅ PASS |
| R38 | API throws exception | Exception propagation | `apiClient.patch` throws `ApiException` | `ApiException` propagates | ✅ PASS |
| R39 | Correct endpoint and payload | Argument verification | Any | `patch` called with `Endpoints.workorderFail` filled, payload contains `issue` | ✅ PASS |

**Section Total: 39 / 39 PASS**

---

## 2. Work Order Repository

**Source**: `lib/features/work_order/data/repositories/work_order_repository_impl.dart`  
**Test File**: `test/features/work_order/data/repositories/work_order_repository_impl_test.dart`  
**Mock**: `MockWorkOrderRemoteDatasource`

### Cyclomatic Complexity

| Method | CC | Decision Points |
|---|---|---|
| `_handleMetaCall` | 2 | `if (clearCache) ... else ...` |
| `getWorkOrders` | 1 | None (delegated to cache helper) |
| Other operations | 1 | None (delegated directly to `_handleMetaCall`) |

### Test Cases & Result

#### `getWorkOrders({bool forceRefresh})` — CC = 1

| ID | Test Case | Branch / Path | Cache State | Expected | Result |
|---|---|---|---|---|---|
| I1 | Cache valid, no force refresh | Cache hit | Cache seeded, `forceRefresh = false` | Returns cached list without calling remote | ✅ PASS |
| I2 | Cache empty, no force refresh | Cache miss | Cache empty, remote returns list | Calls remote, updates cache, returns list | ✅ PASS |
| I3 | Cache seeded, force refresh | Cache bypass | Cache seeded, `forceRefresh = true` | Calls remote, updates cache, returns list | ✅ PASS |
| I4 | Remote fails | Error path | Remote throws `ApiException` | Returns `Left(ServerFailure)` | ✅ PASS |

#### `getWorkOrderById(String id)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| I5 | Successful fetch with meta | Happy path | Remote returns single response with metadata | Returns `Right(Result<WorkOrderEntity>)` with parsed capability metadata | ✅ PASS |
| I6 | Remote fails | Error path | Remote throws `ApiException` | Returns `Left(ServerFailure)` | ✅ PASS |

#### `createWorkOrder(String serviceId)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| I7 | Successful creation | Happy path (clearCache = true) | Remote returns model | Returns `Right(Result<WorkOrderEntity>)`, clears cache, triggers cacheChanged | ✅ PASS |
| I8 | Remote fails | Error path | Remote throws `ApiException` | Returns `Left(ServerFailure)` | ✅ PASS |

#### `approveWorkOrder(String id)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| I9 | Successful approval | Happy path (clearCache = false) | Remote returns model | Returns `Right(Result<WorkOrderEntity>)`, merges cache, triggers cacheChanged | ✅ PASS |
| I10 | Remote fails | Error path | Remote throws `ApiException` | Returns `Left(ServerFailure)` | ✅ PASS |

#### `rejectWorkOrder(String id, String? issue)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| I11 | Successful rejection | Happy path | Remote returns model | Returns `Right(Result<WorkOrderEntity>)` | ✅ PASS |
| I12 | Remote fails | Error path | Remote throws `ApiException` | Returns `Left(ServerFailure)` | ✅ PASS |

#### `cancelWorkOrder(String id)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| I13 | Successful cancellation | Happy path (clearCache = true) | Remote returns model | Returns `Right(Result<WorkOrderEntity>)`, clears cache | ✅ PASS |
| I14 | Remote fails | Error path | Remote throws `ApiException` | Returns `Left(ServerFailure)` | ✅ PASS |

#### `recreateWorkOrder(String id)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| I15 | Successful recreation | Happy path | Remote returns model | Returns `Right(Result<WorkOrderEntity>)` | ✅ PASS |
| I16 | Remote fails | Error path | Remote throws `ApiException` | Returns `Left(ServerFailure)` | ✅ PASS |

#### `sendWorkOrder(String id)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| I17 | Successful send | Happy path | Remote returns model | Returns `Right(Result<WorkOrderEntity>)` | ✅ PASS |
| I18 | Remote fails | Error path | Remote throws `ApiException` | Returns `Left(ServerFailure)` | ✅ PASS |

#### `startWorkOrder(String id)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| I19 | Successful start | Happy path | Remote returns model | Returns `Right(Result<WorkOrderEntity>)` | ✅ PASS |
| I20 | Remote fails | Error path | Remote throws `ApiException` | Returns `Left(ServerFailure)` | ✅ PASS |

#### `completeWorkOrder(String id, String? issue)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| I21 | Successful completion | Happy path | Remote returns model | Returns `Right(Result<WorkOrderEntity>)` | ✅ PASS |
| I22 | Remote fails | Error path | Remote throws `ApiException` | Returns `Left(ServerFailure)` | ✅ PASS |

#### `failWorkOrder(String id, String issue)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| I23 | Successful failure marking | Happy path | Remote returns model | Returns `Right(Result<WorkOrderEntity>)` | ✅ PASS |
| I24 | Remote fails | Error path | Remote throws `ApiException` | Returns `Left(ServerFailure)` | ✅ PASS |

#### `assignStaffs(String id, AssignedStaffsDraft draft)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| I25 | Successful assignment | Happy path | Remote returns model | Returns `Right(Result<WorkOrderEntity>)` | ✅ PASS |
| I26 | Remote fails | Error path | Remote throws `ApiException` | Returns `Left(ServerFailure)` | ✅ PASS |

#### `submitWorkOrderSubmission(String id, SubmissionEntity sub)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| I27 | Successful submission | Happy path | Remote returns model | Returns `Right(Result<WorkOrderEntity>)` | ✅ PASS |
| I28 | Remote fails | Error path | Remote throws `ApiException` | Returns `Left(ServerFailure)` | ✅ PASS |

#### `clearCache()` — CC = 1

| ID | Test Case | Branch / Path | Expected | Result |
|---|---|---|---|---|
| I29 | Normal clear | Straight-line | Cache helper clears; subsequent fetch calls remote | ✅ PASS |

**Section Total: 29 / 29 PASS**

---

## 3. Data Models

**Source**: `lib/features/work_order/data/model/`  
**Test File**: `test/features/work_order/data/model/work_order_models_test.dart`  
**Mock**: None

### Cyclomatic Complexity

| Model | Method | CC | Decision Points |
|---|---|---|---|
| `WorkOrderStatusDateModel` | `fromJson` | 1 | None |
| `WorkOrderModel` | `fromJson` | 2 | 1× ternary operator for `workOrderForm` |

### Test Cases & Result

#### `WorkOrderStatusDateModel` — CC = 1

| ID | Test Case | Branch / Path | Input | Expected | Result |
|---|---|---|---|---|---|
| M1 | fromJson parses all dates | Happy path | JSON containing optional dates | Mapped to correct non-null `DateTime` fields | ✅ PASS |

#### `WorkOrderModel` — CC = 2

| ID | Test Case | Branch / Path | Input | Expected | Result |
|---|---|---|---|---|---|
| M2 | fromJson with forms & submissions | Ternary = true path | JSON containing non-null `workOrderForm` & `submissions` | `workOrderForm` parsed with nested history submissions | ✅ PASS |
| M3 | fromJson with null forms | Ternary = false path | JSON containing null `workOrderForm` | `workOrderForm` is null | ✅ PASS |

**Section Total: 3 / 3 PASS**

---

## Overall Result

```
flutter test test/features/work_order/data/ --reporter expanded

00:01 +71: All tests passed!
```

| Test File | Tests | Pass | Fail |
|---|---|---|---|
| `work_order_remote_datasource_test.dart` | 39 | 39 | 0 |
| `work_order_repository_impl_test.dart` | 29 | 29 | 0 |
| `work_order_models_test.dart` | 3 | 3 | 0 |
| **Total** | **71** | **71** | **0** |

**✅ All 71 tests passed.**

---

## Notes

- Production logs showing `⛔ ❌ ERROR in safeCall` in the test runner output are expected log trace outputs from repository error-path testing using the `safeCall` utility. These logs do not indicate test failures.
