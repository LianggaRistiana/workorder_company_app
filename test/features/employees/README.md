# Employees Feature — Whitebox Test Plan & Result

**Layer**: Data (DataSource & Repository)  
**Framework**: `flutter_test` + `mocktail`  
**Testing Method**: Whitebox (branch/path coverage)  
**Date**: 2026-06-12  

---

## 1. File Structure

```
test/features/employees/
├── README.md                          ← Test plan & result documentation
└── data/
    ├── datasources/
    │   └── employees_remote_datasource_test.dart
    ├── repositories/
    │   └── employees_repository_impl_test.dart
    └── model/
        └── employees_models_test.dart
```

---

## 2. Cyclomatic Complexity Reference Table

| Class | Method | Decision Points | CC | Min Tests |
|---|---|---|---|---|
| **EmployeeDetailMeta** | `fromJson` | None (`??` counts as 0) | 1 | 1 |
| **EmployeesRemoteDatasourceImpl** | `getEmployees` | None | 1 | 1 |
| | `getEmployeeByDetail` | None | 1 | 1 |
| | `kickEmployee` | None | 1 | 1 |
| **EmployeesRepositoryImpl** | `getEmployees` | `if (params == null)` (+1), filter matchSearch logic (+2), filter matchPosition logic (+2) | 5 | 5 |
| | `clearCache` | None | 1 | 1 |
| | `getEmployeeByDetail` | None (delegated to `safeCall`) | 1 | 1 |
| | `kickEmployee` | None (delegated to `safeCall`) | 1 | 1 |

---

## 3. Data Models / Metadata

### 3.1 Cyclomatic Complexity
| Method | CC | Reason |
|---|---|---|
| `EmployeeDetailMeta.fromJson` | 1 | Direct parsing, null coalescing operator (`??`) counts as 0. |

### 3.2 Test Cases
| ID | Test Case | Branch/Path | Input/Setup | Expected |
|---|---|---|---|---|
| **M1** | fromJson with canKick populated | Happy path | JSON with `canKick: false` | Returns `EmployeeDetailMeta` with `canKick = false` |
| **M2** | fromJson with null/absent canKick | Null guard | JSON with `canKick` null or absent | Returns `EmployeeDetailMeta` with `canKick` as `true` (default) |
| **M3** | fromJson with explicitly true canKick | Happy path | JSON with `canKick: true` | Returns `EmployeeDetailMeta` with `canKick = true` |

### 3.3 Test Result
| ID | Description | Result | Note |
|---|---|---|---|
| **M1** | fromJson parses canKick correctly when populated in JSON | ✅ PASS | |
| **M2** | fromJson uses true default when canKick is null or absent | ✅ PASS | |
| **M3** | fromJson parses canKick correctly when explicitly true | ✅ PASS | |

**Section Total: 3 / 3 PASS**

---

## 4. Remote DataSources

### 4.1 Cyclomatic Complexity
| Method | CC | Reason |
|---|---|---|
| `getEmployees` | 1 | Direct call to ApiClient. |
| `getEmployeeByDetail` | 1 | Direct call to ApiClient. |
| `kickEmployee` | 1 | Direct call to ApiClient. |

### 4.2 Test Cases
| ID | Test Case | Branch/Path | Input/Setup | Expected |
|---|---|---|---|---|
| **R1** | getEmployees success | Happy path | API returns 200 + employees JSON list | Returns `ApiResponse<List<UserModel>>` |
| **R2** | getEmployees error | Exception path | ApiClient throws `ApiException` | Propagates `ApiException` |
| **R3** | getEmployeeByDetail success | Happy path | API returns 200 + detail JSON | Returns `ApiResponseWithMeta<Empty>` |
| **R4** | getEmployeeByDetail endpoint check | Verification | Call with specific ID | ApiClient.get called with `/company/employees/{id}` |
| **R5** | getEmployeeByDetail error | Exception path | ApiClient throws `ApiException` | Propagates `ApiException` |
| **R6** | kickEmployee success | Happy path | API returns 200 + response JSON | Returns `ApiResponse<Empty>` |
| **R7** | kickEmployee payload check | Verification | Call with email | ApiClient.delete called with correct endpoint and email body |
| **R8** | kickEmployee error | Exception path | ApiClient throws `ApiException` | Propagates `ApiException` |

### 4.3 Test Result
| ID | Description | Result | Note |
|---|---|---|---|
| **R1** | getEmployees returns ApiResponse<List<UserModel>> on success | ✅ PASS | |
| **R2** | getEmployees propagates ApiException on error | ✅ PASS | |
| **R3** | getEmployeeByDetail returns ApiResponseWithMeta<Empty> on success | ✅ PASS | |
| **R4** | getEmployeeByDetail calls API get with correct ID-based endpoint path | ✅ PASS | |
| **R5** | getEmployeeByDetail propagates ApiException on error | ✅ PASS | |
| **R6** | kickEmployee returns ApiResponse<Empty> on success | ✅ PASS | |
| **R7** | kickEmployee calls API delete with correct endpoint and body payload | ✅ PASS | |
| **R8** | kickEmployee propagates ApiException on error | ✅ PASS | |

**Section Total: 8 / 8 PASS**

---

## 5. Repository Implementations

### 5.1 Cyclomatic Complexity
| Method | CC | Reason |
|---|---|---|
| `getEmployees` | 5 | Checks `params == null` (+1). Under filtering checks: `params.search == null` (+1) or name check (+1); `params.positionId == null` (+1) or position check (+1). |
| `clearCache` | 1 | Direct clearing of private cached resource helper. |
| `getEmployeeByDetail` | 1 | Fully delegated to `safeCall`. |
| `kickEmployee` | 1 | Fully delegated to `safeCall`. |

### 5.2 Test Cases
| ID | Test Case | Branch/Path | Input/Setup | Expected |
|---|---|---|---|---|
| **I1** | forceRefresh=false, cache valid | Happy path (cache hit) | Pre-seed cache, forceRefresh=false | Returns `Right(cachedEmployees)`, no remote call |
| **I2** | forceRefresh=false, cache empty | Happy path (cache miss) | Empty cache, remote success | Returns `Right(employees)`, cache updated |
| **I3** | forceRefresh=true, cache seeded | Happy path (forced refresh) | Seeded cache, remote success | Returns `Right(freshEmployees)` via remote call |
| **I4** | remote getEmployees fails | Exception path | Empty cache, remote exception | Returns `Left(ServerFailure)` |
| **I5** | params == null | Filtering path | Call with `params: null` | Returns all employees unfiltered |
| **I6** | params.search match | Filtering path | Call with matching search | Returns employees containing search term |
| **I7** | params.search no match | Filtering path | Call with unmatched search | Returns empty list |
| **I8** | params.positionId match | Filtering path | Call with matching positionId | Returns employees with matching positionId |
| **I9** | params.search & positionId combined | Filtering path | Call with search & positionId | Returns matching employees |
| **I10**| Cache validation sequence | Verification | Consecutive fetch calls | Second fetch hits cached list |
| **I11**| clearCache side-effects | Invalidation | Call clearCache, then fetch | Invalidation forces remote API fetch |
| **I12**| getEmployeeByDetail success | Happy path | Remote detail success | Returns `Right(Result<Empty>)` with meta |
| **I13**| getEmployeeByDetail fails | Exception path | Remote detail throws | Returns `Left(ServerFailure)` |
| **I14**| kickEmployee success cache update | Happy path | Remote success, pre-seeded cache | Returns `Right(Empty)`, kicked user is removed from cache |
| **I15**| kickEmployee fails | Exception path | Remote kick throws `ApiException` | Returns `Left(AuthFailure)` for 403 status |
| **I16**| kickEmployee stream check | Verification | Kick success | Emits null event on `cacheChanged` stream |

### 5.3 Test Result
| ID | Description | Result | Note |
|---|---|---|---|
| **I1** | returns Right(cached) and does not call remote when cache is valid and forceRefresh is false | ✅ PASS | |
| **I2** | calls remote and returns Right(data) when cache is empty | ✅ PASS | |
| **I3** | calls remote even if cache is valid when forceRefresh is true | ✅ PASS | |
| **I4** | returns Left(ServerFailure) when remote getEmployees fails | ✅ PASS | |
| **I5** | returns unfiltered list when params is null | ✅ PASS | |
| **I6** | returns filtered list matching the search term case-insensitively | ✅ PASS | |
| **I7** | returns empty list when search term does not match any name | ✅ PASS | |
| **I8** | returns filtered list matching the positionId | ✅ PASS | |
| **I9** | returns filtered list matching both search term and positionId | ✅ PASS | |
| **I10**| consecutive calls fetch list from cache after initial Remote success | ✅ PASS | |
| **I11**| clearCache causes subsequent getEmployees to hit remote datasource | ✅ PASS | |
| **I12**| returns Right(Result<Empty>) on remote success | ✅ PASS | |
| **I13**| returns Left(ServerFailure) when remote getEmployeeByDetail fails | ✅ PASS | |
| **I14**| returns Right(Empty) and removes kicked user from cached employees list | ✅ PASS | |
| **I15**| returns Left(ServerFailure) when remote kick fails | ✅ PASS | |
| **I16**| emits event on cacheChanged stream when employee is successfully kicked | ✅ PASS | |

**Section Total: 16 / 16 PASS**

---

## 6. Overall Result

| Component | Total Tests | Passed | Failed | Pass Rate |
|---|---|---|---|---|
| **Models & Meta** | 3 | 3 | 0 | 100% |
| **Remote DataSources** | 8 | 8 | 0 | 100% |
| **Repository Implementations** | 16 | 16 | 0 | 100% |
| **TOTAL** | **27** | **27** | **0** | **100%** |

```bash
flutter test test/features/employees/ --reporter expanded
# Output: All tests passed!
```

---

## 7. Notes

* **Console Logging Output**: During execution of repository tests, error messages like `⛔ ❌ ERROR in safeCall` and ApiException tracebacks will print to the console. These are expected logs from production error handlers called during testing of error-handling branches. They are not test failures unless accompanied by `[E]`.
