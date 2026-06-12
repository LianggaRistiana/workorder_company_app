# Work Report Feature — Whitebox Test Documentation

**Layer**: Data (DataSource & Repository)  
**Framework**: `flutter_test` + `mocktail`  
**Testing Method**: Whitebox (branch/path coverage)  
**Date**: 2026-06-12

---

## File Structure

```
test/features/work_report/
└── data/
    ├── datasources/
    │   └── work_report_remote_datasource_test.dart  (15 tests)
    ├── repositories/
    │   └── work_report_repository_impl_test.dart    (10 tests)
    └── model/
        └── work_report_models_test.dart             (3 tests)
```

---

## Cyclomatic Complexity Reference

> **Formula**: CC = Number of decision points + 1  
> Decision points: `if`, `else if`, `on`, `catch`, `case`, `&&`, `||`

| Class | Method | Decision Points | CC |
|---|---|---|---|
| `WorkReportRemoteDatasourceImpl` | `getWorkReport` | 0 | 1 |
| `WorkReportRemoteDatasourceImpl` | `submitWorkReportSubmission` | 0 | 1 |
| `WorkReportRemoteDatasourceImpl` | `sendWorkReport` | 0 | 1 |
| `WorkReportRemoteDatasourceImpl` | `approveWorkReport` | 0 | 1 |
| `WorkReportRemoteDatasourceImpl` | `rejectWorkReport` | 0 | 1 |
| `WorkReportRepositoryImpl` | `getWorkReport` | 0 | 1 |
| `WorkReportRepositoryImpl` | `submitWorkReportSubmission` | 0 | 1 |
| `WorkReportRepositoryImpl` | `sendWorkReport` | 0 | 1 |
| `WorkReportRepositoryImpl` | `approveWorkReport` | 0 | 1 |
| `WorkReportRepositoryImpl` | `rejectWorkReport` | 0 | 1 |
| Models (`fromJson` / `toJson`) | various | 0 | 1 |
| | | **Total CC** | **13** |

> Minimum tests required for full branch coverage = **13**  
> Total tests written = **28** (includes argument verification and edge cases)

---

## 1. Local Datasource

Not applicable. The Work Report feature does not have a local datasource.

---

## 2. WorkReportRemoteDatasource

**Source**: `lib/features/work_report/data/datasources/work_report_remote_datasource.dart`  
**Test File**: `test/features/work_report/data/datasources/work_report_remote_datasource_test.dart`  
**Mock**: `MockApiClient`

### Cyclomatic Complexity

All methods have **CC = 1** — no local branching. Each method delegates directly to `_apiClient` and wraps the result in `ApiResponse.fromJson`.

| Method | CC |
|---|---|
| `getWorkReport` | 1 |
| `submitWorkReportSubmission` | 1 |
| `sendWorkReport` | 1 |
| `approveWorkReport` | 1 |
| `rejectWorkReport` | 1 |

---

### Test Cases & Result

#### `getWorkReport(workOrderId)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R1 | Successful getWorkReport | Happy path | `apiClient.get` → valid JSON | `ApiResponse<WorkReportModel>` with correct ID | ✅ PASS |
| R2 | API throws `ApiException` | Exception propagation | `apiClient.get` throws `ApiException(404)` | `ApiException` propagates to caller | ✅ PASS |
| R3 | Correct endpoint used | Argument verification | Any | `get(Endpoints.workReportDetail.fillId(workOrderId))` called once | ✅ PASS |

#### `submitWorkReportSubmission(workReportId, submission)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R4 | Successful submission | Happy path | `apiClient.post` → valid JSON | `ApiResponse<WorkReportModel>` with correct ID | ✅ PASS |
| R5 | API throws `ApiException` | Exception propagation | `apiClient.post` throws `ApiException(422)` | `ApiException` propagates to caller | ✅ PASS |
| R6 | Correct endpoint & payload | Argument verification | Any | `post(Endpoints.workReportSetSubmissions.fillId(workReportId), data: submission.toJson())` called once | ✅ PASS |

#### `sendWorkReport(workReportId)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R7 | Successful sendWorkReport | Happy path | `apiClient.patch` → valid JSON | `ApiResponse<WorkReportModel>` with status `sent` | ✅ PASS |
| R8 | API throws `ApiException` | Exception propagation | `apiClient.patch` throws `ApiException(400)` | `ApiException` propagates to caller | ✅ PASS |
| R9 | Correct endpoint used | Argument verification | Any | `patch(Endpoints.workReportSent.fillId(workReportId))` called once | ✅ PASS |

#### `approveWorkReport(workReportId)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R10 | Successful approveWorkReport | Happy path | `apiClient.patch` → valid JSON | `ApiResponse<WorkReportModel>` with status `approved` | ✅ PASS |
| R11 | API throws `ApiException` | Exception propagation | `apiClient.patch` throws `ApiException(400)` | `ApiException` propagates to caller | ✅ PASS |
| R12 | Correct endpoint used | Argument verification | Any | `patch(Endpoints.workReportApprove.fillId(workReportId))` called once | ✅ PASS |

#### `rejectWorkReport(workReportId)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R13 | Successful rejectWorkReport | Happy path | `apiClient.patch` → valid JSON | `ApiResponse<WorkReportModel>` with status `rejected` | ✅ PASS |
| R14 | API throws `ApiException` | Exception propagation | `apiClient.patch` throws `ApiException(400)` | `ApiException` propagates to caller | ✅ PASS |
| R15 | Correct endpoint used | Argument verification | Any | `patch(Endpoints.workReportReject.fillId(workReportId))` called once | ✅ PASS |

**Section Total: 15 / 15 PASS**

---

## 3. WorkReportRepositoryImpl

**Source**: `lib/features/work_report/data/repositories/work_report_repository_impl.dart`  
**Test File**: `test/features/work_report/data/repositories/work_report_repository_impl_test.dart`  
**Mock**: `MockWorkReportRemoteDatasource`

### Cyclomatic Complexity

All methods delegate to the remote datasource inside a `safeCall` closure, resulting in **CC = 1** for each method under test (as decision branches are delegated to the core helper).

| Method | CC |
|---|---|
| `approveWorkReport` | 1 |
| `getWorkReport` | 1 |
| `rejectWorkReport` | 1 |
| `sendWorkReport` | 1 |
| `submitWorkReportSubmission` | 1 |

---

### Test Cases & Result

#### `approveWorkReport(workReportId)` — CC = 1

| ID | Test Case | Branch / Path | Setup | Expected | Result |
|---|---|---|---|---|---|
| I1 | Successful approval | `safeCall` success | Remote returns `ApiResponse<WorkReportModel>` | `Right(WorkReportEntity)` with correct ID | ✅ PASS |
| I2 | Remote throws `ApiException` | `safeCall` catch -> `ServerFailure` | Remote throws `ApiException(400)` | `Left(ServerFailure)` | ✅ PASS |

#### `getWorkReport(workOrderId)` — CC = 1

| ID | Test Case | Branch / Path | Setup | Expected | Result |
|---|---|---|---|---|---|
| I3 | Successful getWorkReport | `safeCall` success | Remote returns `ApiResponse<WorkReportModel>` | `Right(WorkReportEntity)` | ✅ PASS |
| I4 | Remote throws `ApiException` | `safeCall` catch -> `ServerFailure` | Remote throws `ApiException(404)` | `Left(ServerFailure)` | ✅ PASS |

#### `rejectWorkReport(workReportId)` — CC = 1

| ID | Test Case | Branch / Path | Setup | Expected | Result |
|---|---|---|---|---|---|
| I5 | Successful rejection | `safeCall` success | Remote returns `ApiResponse<WorkReportModel>` | `Right(WorkReportEntity)` | ✅ PASS |
| I6 | Remote throws `ApiException` | `safeCall` catch -> `ServerFailure` | Remote throws `ApiException(400)` | `Left(ServerFailure)` | ✅ PASS |

#### `sendWorkReport(workReportId)` — CC = 1

| ID | Test Case | Branch / Path | Setup | Expected | Result |
|---|---|---|---|---|---|
| I7 | Successful send | `safeCall` success | Remote returns `ApiResponse<WorkReportModel>` | `Right(WorkReportEntity)` | ✅ PASS |
| I8 | Remote throws `ApiException` | `safeCall` catch -> `ServerFailure` | Remote throws `ApiException(400)` | `Left(ServerFailure)` | ✅ PASS |

#### `submitWorkReportSubmission(workReportId, submission)` — CC = 1

| ID | Test Case | Branch / Path | Setup | Expected | Result |
|---|---|---|---|---|---|
| I9 | Successful submission | `safeCall` success | Remote returns `ApiResponse<WorkReportModel>` | `Right(WorkReportEntity)` | ✅ PASS |
| I10 | Remote throws `ApiException` | `safeCall` catch -> `ServerFailure` | Remote throws `ApiException(422)` | `Left(ServerFailure)` | ✅ PASS |

**Section Total: 10 / 10 PASS**

---

## 4. Models

**Source**: `lib/features/work_report/data/model/`  
**Test File**: `test/features/work_report/data/model/work_report_models_test.dart`

### Cyclomatic Complexity

The model serialization methods (`fromJson`) have straight-line execution mappings with no complex local branching. **CC = 1**.

---

### Test Cases & Result

#### `WorkReportStatusDateModel.fromJson` — CC = 1

| ID | Test Case | Branch / Path | Input | Expected | Result |
|---|---|---|---|---|---|
| M1 | fromJson parses all dates correctly | Happy path | JSON with multiple ISO 8601 strings | Model fields mapped to correct `DateTime` | ✅ PASS |

#### `WorkReportModel.fromJson` — CC = 1

| ID | Test Case | Branch / Path | Input | Expected | Result |
|---|---|---|---|---|---|
| M2 | fromJson parses all fields with approvedBy | Happy path | JSON with approvedBy user | Model parsed with non-null `approvedBy` | ✅ PASS |
| M3 | fromJson parses correctly when approvedBy is null | Null approvedBy path | JSON with approvedBy as null | Model parsed with null `approvedBy` | ✅ PASS |

**Section Total: 3 / 3 PASS**

---

## Overall Result

| Section | Total Test Cases | Passed | Failed | Pass Rate |
|---|---|---|---|---|
| 1. Local Datasource | 0 | 0 | 0 | N/A |
| 2. Remote Datasource | 15 | 15 | 0 | 100% |
| 3. Repository Impl | 10 | 10 | 0 | 100% |
| 4. Models | 3 | 3 | 0 | 100% |
| **Total** | **28** | **28** | **0** | **100%** |

### Execution Command and Output
```bash
flutter test test/features/work_report/data/ --reporter expanded
```
```
00:02 +28: All tests passed!
```

---

## Notes
- During error-path testing of the Repository layer, expected `ApiException` exceptions are logged via the `safeCall` exception handler:
  - `⛔ ❌ ERROR in safeCall`
  This is expected console noise from production logging code and does not represent test failures. All test assertions succeeded.
