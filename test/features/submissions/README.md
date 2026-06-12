# Submissions Feature — Whitebox Test Documentation

**Layer**: Data (DataSource & Repository)  
**Framework**: `flutter_test` + `mocktail`  
**Testing Method**: Whitebox (branch/path coverage)  
**Date**: 2026-06-12

---

## File Structure

```
test/features/submissions/
└── data/
    ├── datasources/
    │   └── file_upload_remote_datasource_test.dart  (4 tests)
    ├── repositories/
    │   └── file_upload_repository_impl_test.dart    (1 test)
    └── model/
        └── submissions_models_test.dart             (6 tests)
```

---

## Cyclomatic Complexity Reference

> **Formula**: CC = Number of decision points + 1  
> Decision points: `if`, `else if`, `on`, `catch`, `case`, `&&`, `||`

| Class | Method | Decision Points | CC |
|---|---|---|---|
| `FileRemoteDataSourceImpl` | `uploadFile` | 2 (`if (total <= 0)` & `catch (e)`) | 3 |
| `FileRemoteDataSourceImpl` | `_mapError` | 1 (`if (e is DioException)`) | 2 |
| `FileRepositoryImpl` | `uploadFile` | 0 | 1 |
| `FieldDataModel` | `toJson` | 1 (`value is DateTime`) | 2 |
| Models (others) | various | 0 | 1 |
| | | **Total CC** | **10** |

> Minimum tests required for full branch coverage = **10**  
> Total tests written = **11**

---

## 1. Local Datasource

Not applicable. The Submissions feature does not have a local datasource.

---

## 2. Remote Datasource

**Source**: `lib/features/submissions/data/datasources/file_upload_remote_datasource.dart`  
**Test File**: `test/features/submissions/data/datasources/file_upload_remote_datasource_test.dart`  
**Mock**: `MockApiClient`

### Cyclomatic Complexity
The `uploadFile` method initiates file reading, registers an upload progress callback, and handles API errors via a try-catch, resulting in **CC = 3** for the core flow. The error mapping helper has **CC = 2**.

---

### Test Cases & Result

#### `uploadFile(filePath)` — CC = 3

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R1 | Success upload | Happy path | `apiClient.postFormData` triggers progress & succeeds | Emits progress and success results on stream | ✅ PASS |
| R2 | API throws `DioException` | `catch` -> `_mapError` (Dio) | `apiClient.postFormData` throws `DioException` | Emits failure result with backend error message | ✅ PASS |
| R3 | API throws generic exception | `catch` -> `_mapError` (generic) | `apiClient.postFormData` throws `Exception` | Emits failure result with "Unexpected error" | ✅ PASS |
| R4 | Correct endpoint called | Argument verification | Any | `postFormData(Endpoints.fileUpload)` called once | ✅ PASS |

**Section Total: 4 / 4 PASS**

---

## 3. Repository Impl

**Source**: `lib/features/submissions/data/repositories/file_upload_repository_impl.dart`  
**Test File**: `test/features/submissions/data/repositories/file_upload_repository_impl_test.dart`  
**Mock**: `MockFileRemoteDataSource`

### Cyclomatic Complexity
Delegates directly to `FileRemoteDataSource.uploadFile`, yielding **CC = 1**.

---

### Test Cases & Result

#### `uploadFile(filePath)` — CC = 1

| ID | Test Case | Branch / Path | Setup | Expected | Result |
|---|---|---|---|---|---|
| I1 | Direct delegation | Straight-line delegation | Remote datasource returns `Stream<UploadResult>` | Yields identical stream events | ✅ PASS |

**Section Total: 1 / 1 PASS**

---

## 4. Models

**Source**: `lib/features/submissions/data/model/`  
**Test File**: `test/features/submissions/data/model/submissions_models_test.dart`

### Cyclomatic Complexity
Model helpers have straight-line mappings, except `FieldDataModel.toJson` which has a dynamic type check for `value is DateTime` (**CC = 2**).

---

### Test Cases & Result

#### `FieldDataModel` — CC = 3 (across fromJson & toJson)

| ID | Test Case | Branch / Path | Input | Expected | Result |
|---|---|---|---|---|---|
| M1 | `fromJson` parses order & value | Happy path | JSON with int/string order | Correctly parses order to string | ✅ PASS |
| M2 | `toJson` parses datetime & order | `value is DateTime` path | DateTime value / normal value | Formats DateTime to ISO 8601 string, order to int | ✅ PASS |

#### `SubmissionsModel` — CC = 2 (across fromJson & toJson)

| ID | Test Case | Branch / Path | Input | Expected | Result |
|---|---|---|---|---|---|
| M3 | `fromJson` parses successfully | Happy path | JSON with multiple list objects | Parses fieldsData and createdAt correctly | ✅ PASS |
| M4 | `toJson` parses successfully | Happy path | Valid SubmissionsModel | Correct map keys and list conversion | ✅ PASS |
| M5 | `fromEntity` parses successfully | Happy path | Valid SubmissionEntity | Converts entity to model correctly | ✅ PASS |

#### `UploadPayload` — CC = 1

| ID | Test Case | Branch / Path | Input | Expected | Result |
|---|---|---|---|---|---|
| M6 | `fromMap` parses successfully | Happy path | Map with url field | Parses payload URL correctly | ✅ PASS |

**Section Total: 6 / 6 PASS**

---

## Overall Result

| Section | Total Test Cases | Passed | Failed | Pass Rate |
|---|---|---|---|---|
| 1. Local Datasource | 0 | 0 | 0 | N/A |
| 2. Remote Datasource | 4 | 4 | 0 | 100% |
| 3. Repository Impl | 1 | 1 | 0 | 100% |
| 4. Models | 6 | 6 | 0 | 100% |
| **Total** | **11** | **11** | **0** | **100%** |

### Execution Command and Output
```bash
flutter test test/features/submissions/data/ --reporter expanded
```
```
00:00 +11: All tests passed!
```

---

## Notes
- Production logger outputs information messages (e.g. `💡 Upload started`) and handled error exceptions during failure test execution. These represent expected telemetry log lines and are not test assertion failures. All test expectations passed.
