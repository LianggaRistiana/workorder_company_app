# Forms Feature — Whitebox Test Documentation

**Layer**: Data (DataSource & Repository)  
**Framework**: `flutter_test` + `mocktail`  
**Testing Method**: Whitebox (branch/path coverage)  
**Date**: 2026-06-12

---

## File Structure

```
test/features/forms/
├── README.md                                 (test plan & result docs)
└── data/
    ├── datasources/
    │   └── forms_remote_datasource_test.dart (15 tests)
    ├── repositories/
    │   └── forms_repository_impl_test.dart   (13 tests)
    └── model/
        └── forms_models_test.dart            (20 tests)
```

---

## Cyclomatic Complexity Reference

> **Formula**: CC = Number of decision points + 1  
> Decision points: `if`, `else if`, `on`, `catch`, `case`, `&&`, `||`, and conditional execution operators (`?.`, `?..`)

| Class / Component | Method | Decision Points | CC |
|---|---|---|---|
| `FormsRemoteDatasourceImpl` | `getForms` | 0 | 1 |
| `FormsRemoteDatasourceImpl` | `getFormById` | 0 | 1 |
| `FormsRemoteDatasourceImpl` | `createForm` | 0 | 1 |
| `FormsRemoteDatasourceImpl` | `updateForm` | 0 | 1 |
| `FormsRemoteDatasourceImpl` | `deleteForm` | 0 | 1 |
| `FormsRepositoryImpl` | `getForms` | 0 | 1 |
| `FormsRepositoryImpl` | `getForm` | 0 | 1 |
| `FormsRepositoryImpl` | `createForm` | 0 | 1 |
| `FormsRepositoryImpl` | `updateForm` | 0 | 1 |
| `FormsRepositoryImpl` | `deleteForm` | 0 | 1 |
| `FormsRepositoryImpl` | `clearCache` | 0 | 1 |
| `OptionModel` | `fromJson` / `toJson` / `fromEntity` | 0 | 3 |
| `FieldModel` | `fromJson` | 2 | 3 |
| `FieldModel` | `toJson` / `fromEntity` | 0 | 2 |
| `FormModel` | `fromJson` / `fromJsonTemplate` / `toJson` / `fromEntity` | 0 | 4 |
| `FilledFormModel` | `fromJson` | 1 | 2 |
| `FilledFormWithHistoryModel` | `fromJson` | 4 | 5 |
| `WorkReportsFilledFormModel` | `fromJson` | 2 | 3 |
| | | **Total CC** | **33** |

> Minimum tests required for full branch coverage = **33**  
> Total tests written = **48** (includes caching updates, stream events, argument verification, and exceptions coverage)

---

---

## 1. Remote DataSource

**Source**: `lib/features/forms/data/datasources/forms_remote_datasource.dart`  
**Test File**: `test/features/forms/data/datasources/forms_remote_datasource_test.dart`  
**Mock**: `MockApiClient`

---

### Cyclomatic Complexity

All methods have **CC = 1** (no internal branching logic, delegating directly to `_apiClient`).

---

### Test Cases & Result

#### `getForms()` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R1 | Successful getForms | Happy path | `apiClient.get` → list JSON | `ApiResponse<List<FormModel>>` returned | ✅ PASS |
| R2 | API throws `ApiException` | Exception propagation | `apiClient.get` throws `ApiException(500)` | `ApiException` propagates | ✅ PASS |
| R3 | Correct endpoint called | Argument verification | Any | `get(Endpoints.forms)` called exactly once | ✅ PASS |

#### `getFormById(id)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R4 | Successful getFormById | Happy path | `apiClient.get` → detail JSON | `ApiResponseWithMeta<FormModel>` returned | ✅ PASS |
| R5 | API throws | Exception propagation | `apiClient.get` throws `ApiException(404)` | `ApiException` propagates | ✅ PASS |
| R6 | Correct detail endpoint called | Argument verification | Any | `get(Endpoints.forms.byId(id))` called once | ✅ PASS |

#### `createForm(form)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R7 | Successful createForm | Happy path | `apiClient.post` → single JSON | `ApiResponse<FormModel>` returned | ✅ PASS |
| R8 | API throws | Exception propagation | `apiClient.post` throws `ApiException(400)` | `ApiException` propagates | ✅ PASS |
| R9 | Correct endpoint & payload sent | Argument verification | Any | `post(Endpoints.forms, data: form.toJson())` called once | ✅ PASS |

#### `updateForm(form)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R10 | Successful updateForm | Happy path | `apiClient.put` → single JSON | `ApiResponse<FormModel>` returned | ✅ PASS |
| R11 | API throws | Exception propagation | `apiClient.put` throws `ApiException(403)` | `ApiException` propagates | ✅ PASS |
| R12 | Correct endpoint & payload sent | Argument verification | Any | `put(Endpoints.forms.byId(form.id), data: form.toJson())` called once | ✅ PASS |

#### `deleteForm(form)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R13 | Successful deleteForm | Happy path | `apiClient.delete` → delete JSON | `ApiResponse<Empty>` returned | ✅ PASS |
| R14 | API throws | Exception propagation | `apiClient.delete` throws `ApiException(400)` | `ApiException` propagates | ✅ PASS |
| R15 | Correct delete endpoint called | Argument verification | Any | `delete(Endpoints.forms.byId(form.id))` called once | ✅ PASS |

**Section Total: 15 / 15 PASS**

---

---

## 2. Forms Repository

**Source**: `lib/features/forms/data/repositories/forms_repository_impl.dart`  
**Test File**: `test/features/forms/data/repositories/forms_repository_impl_test.dart`  
**Mock**: `MockFormsRemoteDatasource`

---

### Cyclomatic Complexity

All methods have **CC = 1** since branching and exception handling are delegated to `ListCacheHelper` and `safeCall`.

---

### Test Cases & Result

#### `getForms({forceRefresh})` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup / State | Expected | Result |
|---|---|---|---|---|---|
| I1 | Cached list valid, `forceRefresh=false` | Cache hit | Cache seeded; remote return not set | Returns Right(cached list); remote is not called | ✅ PASS |
| I2 | Cache empty, `forceRefresh=false` | Cache miss | Cache empty; remote returns success | Calls remote; returns Right(data); cache is updated | ✅ PASS |
| I3 | Cache seeded, `forceRefresh=true` | Cache bypass | Cache seeded; remote returns new data | Calls remote; returns Right(new data); cache updated | ✅ PASS |
| I4 | Remote fails | Error path | Remote throws `ApiException(500)` | Returns Left(ServerFailure "Server Sedang Gangguan") | ✅ PASS |

#### `getForm(id)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| I5 | Successful detail fetch | Happy path | Remote returns `ApiResponseWithMeta` | Returns Right(Result(data: FormEntity, meta: FormDetailMeta)) | ✅ PASS |
| I6 | Remote fails | Error path | Remote throws `ApiException(404)` | Returns Left(ServerFailure "Form not found") | ✅ PASS |

#### `createForm(form)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup / State | Expected | Result |
|---|---|---|---|---|---|
| I7 | Successful creation | Happy path | Remote returns form; Cache contains existing items | Returns Right(void); new form merged in cache; emits `cacheChanged` event | ✅ PASS |
| I8 | Remote fails | Error path | Remote throws `ApiException(400)` | Returns Left(ValidationFailure); cache is unchanged; no stream notifications | ✅ PASS |

#### `updateForm(form)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup / State | Expected | Result |
|---|---|---|---|---|---|
| I9 | Successful update | Happy path | Remote returns updated form; Cache has old item | Returns Right(FormEntity); item updated in cache; emits `cacheChanged` event | ✅ PASS |
| I10 | Remote fails | Error path | Remote throws `ApiException(403)` | Returns Left(AuthFailure); cache unchanged; no notifications | ✅ PASS |

#### `deleteForm(form)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup / State | Expected | Result |
|---|---|---|---|---|---|
| I11 | Successful deletion | Happy path | Remote returns Empty; Cache has old item | Returns Right(Empty); item removed from cache; emits `cacheChanged` event | ✅ PASS |
| I12 | Remote fails | Error path | Remote throws `ApiException(409)` | Returns Left(ServerFailure); cache unchanged; no notifications | ✅ PASS |

#### `clearCache()` — CC = 1

| ID | Test Case | Branch / Path | State | Expected | Result |
|---|---|---|---|---|---|
| I13 | Cache clear | Happy path | Cache seeded | Cache is invalidated; next `getForms` invokes remote datasource | ✅ PASS |

**Section Total: 13 / 13 PASS**

---

---

## 3. Data Models

**Source**: `lib/features/forms/data/model/`  
**Test File**: `test/features/forms/data/model/forms_models_test.dart`  
**Mocks**: None (pure unit tests)

---

### Cyclomatic Complexity

| Model Method | CC | Decision Points / Branching Detail |
|---|---|---|
| `OptionModel.fromJson` / `toJson` / `fromEntity` | 1 | Straight-line parsing / serialization |
| `FieldModel.fromJson` | 3 | `json["options"] != null` (yes/no), item `e is String` (yes/no) |
| `FilledFormModel.fromJson` | 2 | `submissionJson == null` (yes/no) |
| `FilledFormWithHistoryModel.fromJson` | 5 | 1. `formJson is! Map`<br>2. `submissionsJson != null`<br>3. `submissionsJson is! List`<br>4. Loop item `e is! Map` |
| `WorkReportsFilledFormModel.fromJson` | 3 | 1. Null-aware cascade (`?..sort`) on submissions list<br>2. Null-aware navigation (`?.where`) on submissions filter |

```
FilledFormWithHistoryModel.fromJson Branch Tree:
               [formJson is! Map?]
               /                 \
            (true)             (false)
            /                       \
   [ParsingException]     [submissionsJson != null?]
                           /                       \
                        (true)                   (false)
                         /                             \
             [submissionsJson is! List?]       [Return Model]
               /                     \
            (true)                 (false)
            /                           \
   [ParsingException]           [Loop e is! Map?]
                                 /             \
                              (true)         (false)
                              /                   \
                     [ParsingException]       [Sort & Return]
```

---

### Test Cases & Result

| ID | Test Case | Branch / Path | Input / Payload | Expected | Result |
|---|---|---|---|---|---|
| M1 | OptionModel.fromJson | Happy path | `{"key": "k1", "value": "v1"}` | Returns OptionModel with key and value | ✅ PASS |
| M2 | OptionModel.toJson | Happy path | OptionModel instance | Returns Map matching original schema | ✅ PASS |
| M3 | OptionModel.fromEntity | Happy path | OptionEntity instance | Returns OptionModel with same fields | ✅ PASS |
| M4 | FieldModel.fromJson string list | `options` = `List<String>` | JSON options contains `["opt1", "opt2"]` | OptionModel keys and values set to the string values | ✅ PASS |
| M5 | FieldModel.fromJson map list | `options` = `List<Map>` | JSON options contains maps | Parses OptionModel using `fromJson` | ✅ PASS |
| M6 | FieldModel.fromJson null | `options` = `null` | JSON options missing | FieldModel created with `options = null` | ✅ PASS |
| M7 | FieldModel.toJson | Happy path | FieldModel instance with options | Returns correct JSON with matching type string | ✅ PASS |
| M8 | FieldModel.fromEntity | Happy path | FieldEntity instance | FieldModel correctly created | ✅ PASS |
| M9 | FormModel.fromJson | Happy path | JSON with position and fields list | Correct properties parsed, position & fields parsed | ✅ PASS |
| M10 | FormModel.fromJsonTemplate | Happy path (Key Gotcha) | JSON with double-quoted key `'"position"'` | Generates random ID; successfully extracts position | ✅ PASS |
| M11 | FormModel.toJson | Happy path | FormModel instance | Returns JSON structure matching backend schema | ✅ PASS |
| M12 | FormModel.fromEntity | Happy path | FormEntity instance | Returns FormModel copy | ✅ PASS |
| M13 | FilledFormModel.fromJson | Submission != null | Valid form and submission JSONs | returns model with both form and submission | ✅ PASS |
| M14 | FilledFormModel.fromJson null | Submission = null | Valid form JSON, null submission | returns model with null submission field | ✅ PASS |
| M15 | FilledFormWithHistoryModel.fromJson | Happy path & Sorting | Valid form, list of 3 submissions | Submissions parsed and sorted by `createdAt` descending | ✅ PASS |
| M16 | FilledFormWithHistoryModel.fromJson | formJson is not Map | String input | Throws ParsingException ("Field 'form' expected Map...") | ✅ PASS |
| M17 | FilledFormWithHistoryModel.fromJson | submissionsJson not List | String input | Throws ParsingException ("Field 'submissions' expected List...") | ✅ PASS |
| M18 | FilledFormWithHistoryModel.fromJson | submission item not Map | List containing String | Throws ParsingException ("Each submission must be Map...") | ✅ PASS |
| M19 | WorkReportsFilledFormModel.fromJson | Happy path & Filter | 2 forms, 2 submissions matching form-1 | filledForms created; form-1 gets newest submission; form-2 gets null | ✅ PASS |
| M20 | WorkReportsFilledFormModel.fromJson | Submissions is null | Form list, null submissions | filledForms mapped with null submission fields | ✅ PASS |

**Section Total: 20 / 20 PASS**

---

---

## Overall Result

| File | Tests | Passed | Failed | Pass Rate |
|---|---|---|---|---|
| `forms_models_test.dart` | 20 | 20 | 0 | 100% |
| `forms_remote_datasource_test.dart` | 15 | 15 | 0 | 100% |
| `forms_repository_impl_test.dart` | 13 | 13 | 0 | 100% |
| **Total** | **48** | **48** | **0** | **100%** |

### Execution Command
```bash
flutter test test/features/forms/ --reporter expanded
```

### Execution Output
```
00:00 +0: loading D:/0002 - Source Code/workorder_company_app/test/features/forms/data/model/forms_models_test.dart
00:00 +1: loading D:/0002 - Source Code/workorder_company_app/test/features/forms/data/datasources/forms_remote_datasource_test.dart
00:00 +2: loading D:/0002 - Source Code/workorder_company_app/test/features/forms/data/repositories/forms_repository_impl_test.dart
...
00:00 +48: All tests passed!
```

---

## Notes

- **ApiException log noise**: During error path testing, expected output messages such as `⛔ ApiException` or `❌ ERROR in safeCall` will appear in the output console from the app Logger. This is expected behavior and does not represent failed tests.
- **Mocktail generic API calls**: Stubbing of generic `ApiClient` methods `post`, `get`, `put`, and `delete` must explicitly specify the generic type parameter `<dynamic>` (e.g. `mockApiClient.get<dynamic>(...)`) to avoid runtime type errors.
