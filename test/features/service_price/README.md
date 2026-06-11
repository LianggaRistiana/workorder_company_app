# Service Price Feature — Whitebox Test Documentation

**Layer**: Data (DataSource & Repository)  
**Framework**: `flutter_test` + `mocktail`  
**Testing Method**: Whitebox (branch/path coverage)  
**Date**: 2026-06-12

---

## File Structure

```
test/features/service_price/
├── README.md                                                 (test plan & result docs)
└── data/
    ├── datasources/
    │   └── service_price_remote_datasource_test.dart        (12 tests)
    ├── repositories/
    │   └── service_price_repository_impl_test.dart           (8 tests)
    └── model/
        └── service_price_models_test.dart                    (3 tests)
```

---

## Cyclomatic Complexity Reference

> **Formula**: CC = Number of decision points + 1  
> Decision points: `if`, `else if`, `on`, `catch`, `case`, `&&`, `||`

| Class / Component | Method | Decision Points | CC |
|---|---|---|---|
| `ServicePriceRemoteDatasourceImpl` | `addServicePrice` | 0 | 1 |
| `ServicePriceRemoteDatasourceImpl` | `deleteServicePrice` | 0 | 1 |
| `ServicePriceRemoteDatasourceImpl` | `getServicePrices` | 0 | 1 |
| `ServicePriceRemoteDatasourceImpl` | `updateServicePrice` | 0 | 1 |
| `ServicePriceRepositoryImpl` | `addServicePrice` | 0 | 1 |
| `ServicePriceRepositoryImpl` | `deleteServicePrice` | 0 | 1 |
| `ServicePriceRepositoryImpl` | `getServicePrices` | 0 | 1 |
| `ServicePriceRepositoryImpl` | `updateServicePrice` | 0 | 1 |
| `ServicePriceModel` | `fromJson` / `fromEntity` / `toJson` | 0 | 3 |
| | | **Total CC** | **11** |

> Minimum tests required for full branch coverage = **11**  
> Total tests written = **23** (includes argument verification and exception mock coverage)

---

---

## 1. Remote DataSource

**Source**: `lib/features/service_price/data/datasources/service_price_remote_datasource.dart`  
**Test File**: `test/features/service_price/data/datasources/service_price_remote_datasource_test.dart`  
**Mock**: `MockApiClient`

---

### Test Cases & Result

##### `addServicePrice(model)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R1 | Successful creation | Happy path | `apiClient.post` → single JSON | `ApiResponse<ServicePriceModel>` returned | ✅ PASS |
| R2 | API throws | Exception propagation | `apiClient.post` throws `ApiException(400)` | `ApiException` propagates | ✅ PASS |
| R3 | Correct endpoint & payload | Argument verification | Any | `post('/service-price', data: model.toJson())` called | ✅ PASS |

##### `deleteServicePrice(id)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R4 | Successful deletion | Happy path | `apiClient.delete` → single JSON | `ApiResponse<ServicePriceModel>` returned | ✅ PASS |
| R5 | API throws | Exception propagation | `apiClient.delete` throws `ApiException(400)` | `ApiException` propagates | ✅ PASS |
| R6 | Correct endpoint called | Argument verification | Any | `delete('/service-price/sp-123')` called | ✅ PASS |

##### `getServicePrices()` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R7 | Successful fetch | Happy path | `apiClient.get` → list JSON | `ApiResponse<List<ServicePriceModel>>` returned | ✅ PASS |
| R8 | API throws | Exception propagation | `apiClient.get` throws `ApiException(500)` | `ApiException` propagates | ✅ PASS |
| R9 | Correct endpoint called | Argument verification | Any | `get('/service-price')` called | ✅ PASS |

##### `updateServicePrice(model)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R10 | Successful update | Happy path | `apiClient.put` → single JSON | `ApiResponse<ServicePriceModel>` returned | ✅ PASS |
| R11 | API throws | Exception propagation | `apiClient.put` throws `ApiException(400)` | `ApiException` propagates | ✅ PASS |
| R12 | Correct endpoint & payload | Argument verification | Any | `put('/service-price/sp-123', data: model.toJson())` called | ✅ PASS |

**Section Total: 12 / 12 PASS**

---

---

## 2. Service Price Repository

**Source**: `lib/features/service_price/data/repositories/service_price_repository_impl.dart`  
**Test File**: `test/features/service_price/data/repositories/service_price_repository_impl_test.dart`  
**Mock**: `MockServicePriceRemoteDatasource`

---

### Test Cases & Result

##### `addServicePrice(data)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| I1 | Successful creation | Happy path | Remote returns model response | Returns Right(ServicePriceEntity) | ✅ PASS |
| I2 | Remote fails (400) | Error path | Remote throws `ApiException(400)` | Returns Left(ValidationFailure) | ✅ PASS |

##### `deleteServicePrice(id)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| I3 | Successful deletion | Happy path | Remote returns model response | Returns Right(ServicePriceEntity) | ✅ PASS |
| I4 | Remote fails (404) | Error path | Remote throws `ApiException(404)` | Returns Left(ServerFailure) | ✅ PASS |

##### `getServicePrices()` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| I5 | Successful fetch | Happy path | Remote returns list response | Returns Right(List<ServicePriceEntity>) | ✅ PASS |
| I6 | Remote fails (500) | Error path | Remote throws `ApiException(500)` | Returns Left(ServerFailure "Server Sedang Gangguan") | ✅ PASS |

##### `updateServicePrice(data)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| I7 | Successful update | Happy path | Remote returns model response | Returns Right(ServicePriceEntity) | ✅ PASS |
| I8 | Remote fails (403) | Error path | Remote throws `ApiException(403)` | Returns Left(AuthFailure) | ✅ PASS |

**Section Total: 8 / 8 PASS**

---

---

## 3. Data Model

**Source**: `lib/features/service_price/data/model/`  
**Test File**: `test/features/service_price/data/model/service_price_models_test.dart`  
**Mocks**: None

---

### Test Cases & Result

| ID | Test Case | Branch / Path | Input / Payload | Expected | Result |
|---|---|---|---|---|---|
| M1 | ServicePriceModel.fromJson | Happy path | JSON payload with nested service summary | Correct ID, service ID, and price parsed | ✅ PASS |
| M2 | ServicePriceModel.fromEntity | Happy path | ServicePriceEntity | Returns ServicePriceModel copy | ✅ PASS |
| M3 | ServicePriceModel.toJson | Happy path | ServicePriceModel | JSON containing `_id`, `serviceId`, and `price` | ✅ PASS |

**Section Total: 3 / 3 PASS**

---

---

## Overall Result

| File | Tests | Passed | Failed | Pass Rate |
|---|---|---|---|---|
| `service_price_models_test.dart` | 3 | 3 | 0 | 100% |
| `service_price_remote_datasource_test.dart` | 12 | 12 | 0 | 100% |
| `service_price_repository_impl_test.dart` | 8 | 8 | 0 | 100% |
| **Total** | **23** | **23** | **0** | **100%** |

### Execution Command
```bash
flutter test test/features/service_price/ --reporter expanded
```

### Execution Output
```
00:00 +0: loading D:/0002 - Source Code/workorder_company_app/test/features/service_price/data/model/service_price_models_test.dart
00:00 +1: loading D:/0002 - Source Code/workorder_company_app/test/features/service_price/data/datasources/service_price_remote_datasource_test.dart
00:00 +2: loading D:/0002 - Source Code/workorder_company_app/test/features/service_price/data/repositories/service_price_repository_impl_test.dart
...
00:00 +23: All tests passed!
```

---

## Notes

- expected log messages such as `⛔ ApiException` or `❌ ERROR in safeCall` from error path testing are normal logger outputs and do not signify a failure.
