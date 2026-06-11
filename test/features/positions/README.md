# Positions Feature — Whitebox Test Documentation

**Layer**: Data (DataSource & Repository)  
**Framework**: `flutter_test` + `mocktail`  
**Testing Method**: Whitebox (branch/path coverage)  
**Date**: 2026-06-12

---

## File Structure

```
test/features/positions/
├── README.md                                                 (test plan & result docs)
└── data/
    ├── datasources/
    │   └── positions_remote_datasource_test.dart            (15 tests)
    ├── repositories/
    │   └── positions_repository_impl_test.dart               (13 tests)
    └── model/
        └── positions_models_test.dart                        (4 tests)
```

---

## Cyclomatic Complexity Reference

> **Formula**: CC = Number of decision points + 1  
> Decision points: `if`, `else if`, `on`, `catch`, `case`, `&&`, `||`

| Class / Component | Method | Decision Points | CC |
|---|---|---|---|
| `PositionsRemoteDatasourceImpl` | `getPositions` | 0 | 1 |
| `PositionsRemoteDatasourceImpl` | `getPositionById` | 0 | 1 |
| `PositionsRemoteDatasourceImpl` | `createPosition` | 0 | 1 |
| `PositionsRemoteDatasourceImpl` | `updatePosition` | 0 | 1 |
| `PositionsRemoteDatasourceImpl` | `deletePosition` | 0 | 1 |
| `PositionsRepositoryImpl` | `getPositions` | 0 | 1 |
| `PositionsRepositoryImpl` | `createPostion` | 0 | 1 |
| `PositionsRepositoryImpl` | `updatePosition` | 0 | 1 |
| `PositionsRepositoryImpl` | `getPositionById` | 0 | 1 |
| `PositionsRepositoryImpl` | `deletePosition` | 0 | 1 |
| `PositionsRepositoryImpl` | `clearCache` | 0 | 1 |
| `PositionModel` | `fromJson` / `fromJsonTemplate` / `toJson` / `fromEntity` | 0 | 4 |
| | | **Total CC** | **15** |

> Minimum tests required for full branch coverage = **15**  
> Total tests written = **32** (includes full cache synchronization tests, stream triggers, and exception mocks)

---

---

## 1. Remote DataSource

**Source**: `lib/features/positions/data/datasources/positions_remote_datasource.dart`  
**Test File**: `test/features/positions/data/datasources/positions_remote_datasource_test.dart`  
**Mock**: `MockApiClient`

---

### Cyclomatic Complexity

All methods have **CC = 1**.

---

### Test Cases & Result

#### `getPositions()` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R1 | Successful fetch | Happy path | `apiClient.get` → list JSON | `ApiResponse<List<PositionModel>>` returned | ✅ PASS |
| R2 | API throws `ApiException` | Exception propagation | `apiClient.get` throws `ApiException(500)` | `ApiException` propagates | ✅ PASS |
| R3 | Correct endpoint called | Argument verification | Any | `get(Endpoints.positions, fromJson: any)` called | ✅ PASS |

#### `getPositionById(id)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R4 | Successful fetch | Happy path | `apiClient.get` → detail JSON | `ApiResponseWithMeta<PositionModel>` with meta returned | ✅ PASS |
| R5 | API throws | Exception propagation | `apiClient.get` throws `ApiException(404)` | `ApiException` propagates | ✅ PASS |
| R6 | Correct detail endpoint called | Argument verification | Any | `get(Endpoints.positions.byId(id))` called | ✅ PASS |

#### `createPosition(position)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R7 | Successful create | Happy path | `apiClient.post` → single JSON | `ApiResponse<PositionModel>` returned | ✅ PASS |
| R8 | API throws | Exception propagation | `apiClient.post` throws `ApiException(400)` | `ApiException` propagates | ✅ PASS |
| R9 | Correct endpoint & body | Argument verification | Any | `post(Endpoints.positions, data: position.toJson())` called | ✅ PASS |

#### `updatePosition(position)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R10 | Successful update | Happy path | `apiClient.put` → single JSON | `ApiResponse<PositionModel>` returned | ✅ PASS |
| R11 | API throws | Exception propagation | `apiClient.put` throws `ApiException(403)` | `ApiException` propagates | ✅ PASS |
| R12 | Correct endpoint & body | Argument verification | Any | `put(Endpoints.positions.byId(id), data: position.toJson())` called | ✅ PASS |

#### `deletePosition(id)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R13 | Successful delete | Happy path | `apiClient.delete` → delete JSON | `ApiResponse<Empty>` returned | ✅ PASS |
| R14 | API throws | Exception propagation | `apiClient.delete` throws `ApiException(400)` | `ApiException` propagates | ✅ PASS |
| R15 | Correct delete endpoint called | Argument verification | Any | `delete(Endpoints.positions.byId(id))` called | ✅ PASS |

**Section Total: 15 / 15 PASS**

---

---

## 2. Positions Repository

**Source**: `lib/features/positions/data/repositories/positions_repositories_impl.dart`  
**Test File**: `test/features/positions/data/repositories/positions_repository_impl_test.dart`  
**Mock**: `MockPositionsRemoteDatasource`

---

### Cyclomatic Complexity

All repository methods have **CC = 1**.

---

### Test Cases & Result

#### `getPositions({refresh})` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup / State | Expected | Result |
|---|---|---|---|---|---|
| I1 | Cached list valid, `refresh=false` | Cache hit | Cache seeded; remote not called | Returns Right(cached list); remote is not called | ✅ PASS |
| I2 | Cache empty, `refresh=false` | Cache miss | Cache empty; remote returns success | Calls remote; returns Right(data); cache updated | ✅ PASS |
| I3 | Cache seeded, `refresh=true` | Cache bypass | Cache seeded; remote returns new data | Calls remote; returns Right(new data); cache updated | ✅ PASS |
| I4 | Remote fails | Error path | Remote throws `ApiException(500)` | Returns Left(ServerFailure "Server Sedang Gangguan") | ✅ PASS |

#### `getPositionById(id)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| I5 | Successful fetch | Happy path | Remote returns `ApiResponseWithMeta` | Returns Right(Result(data: PositionEntity, meta: PositionDetailMeta)) | ✅ PASS |
| I6 | Remote fails | Error path | Remote throws `ApiException(404)` | Returns Left(ServerFailure "Position not found") | ✅ PASS |

#### `createPostion(position)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup / State | Expected | Result |
|---|---|---|---|---|---|
| I7 | Successful creation | Happy path | Remote returns position; Cache contains existing | Returns Right(PositionEntity); new item merged; emits `cacheChanged` event | ✅ PASS |
| I8 | Remote fails | Error path | Remote throws `ApiException(400)` | Returns Left(ValidationFailure); cache unchanged; no notifications | ✅ PASS |

#### `updatePosition(position)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup / State | Expected | Result |
|---|---|---|---|---|---|
| I9 | Successful update | Happy path | Remote returns updated position; Cache has old | Returns Right(PositionEntity); item updated in cache; emits `cacheChanged` event | ✅ PASS |
| I10 | Remote fails | Error path | Remote throws `ApiException(403)` | Returns Left(AuthFailure); cache unchanged; no notifications | ✅ PASS |

#### `deletePosition(position)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup / State | Expected | Result |
|---|---|---|---|---|---|
| I11 | Successful deletion | Happy path | Remote returns Empty; Cache has item | Returns Right(Empty); item removed from cache; emits `cacheChanged` event | ✅ PASS |
| I12 | Remote fails | Error path | Remote throws `ApiException(409)` | Returns Left(ServerFailure); cache unchanged; no notifications | ✅ PASS |

#### `clearCache()` — CC = 1

| ID | Test Case | Branch / Path | State | Expected | Result |
|---|---|---|---|---|---|
| I13 | Cache clear | Happy path | Cache seeded | Cache invalidated; next `getPositions` invokes remote datasource | ✅ PASS |

**Section Total: 13 / 13 PASS**

---

---

## 3. Data Models

**Source**: `lib/features/positions/data/models/`  
**Test File**: `test/features/positions/data/model/positions_models_test.dart`  
**Mocks**: None (pure unit tests)

---

### Test Cases & Result

| ID | Test Case | Branch / Path | Input / Payload | Expected | Result |
|---|---|---|---|---|---|
| M1 | PositionModel.fromJson | Happy path | Valid JSON with description | Correct id, name, description, and isActive parsed | ✅ PASS |
| M2 | PositionModel.fromJsonTemplate | Happy path | JSON without ID and null isActive | Generates random ID; isActive defaults to true | ✅ PASS |
| M3 | PositionModel.toJson | Happy path | PositionModel instance | Returns JSON structure matching DB schema | ✅ PASS |
| M4 | PositionModel.fromEntity | Happy path | PositionEntity instance | Returns PositionModel copy | ✅ PASS |

**Section Total: 4 / 4 PASS**

---

---

## Overall Result

| File | Tests | Passed | Failed | Pass Rate |
|---|---|---|---|---|
| `positions_models_test.dart` | 4 | 4 | 0 | 100% |
| `positions_remote_datasource_test.dart` | 15 | 15 | 0 | 100% |
| `positions_repository_impl_test.dart` | 13 | 13 | 0 | 100% |
| **Total** | **32** | **32** | **0** | **100%** |

### Execution Command
```bash
flutter test test/features/positions/ --reporter expanded
```

### Execution Output
```
00:00 +0: loading D:/0002 - Source Code/workorder_company_app/test/features/positions/data/model/positions_models_test.dart
00:00 +1: loading D:/0002 - Source Code/workorder_company_app/test/features/positions/data/datasources/positions_remote_datasource_test.dart
00:00 +2: loading D:/0002 - Source Code/workorder_company_app/test/features/positions/data/repositories/positions_repository_impl_test.dart
...
00:00 +32: All tests passed!
```

---

## Notes

- expected log messages such as `⛔ ApiException` or `❌ ERROR in safeCall` from error path testing are normal logger outputs and do not signify a failure.
