# Services Feature — Whitebox Test Documentation

**Layer**: Data (DataSource & Repository)  
**Framework**: `flutter_test` + `mocktail`  
**Testing Method**: Whitebox (branch/path coverage)  
**Date**: 2026-06-12

---

## File Structure

```
test/features/services/
├── README.md                                                          (test plan & result docs)
└── data/
    ├── datasources/
    │   ├── internal_services_management_remote_datasource_test.dart  (19 tests)
    │   └── public_services_remote_datasource_test.dart               (3 tests)
    ├── repositories/
    │   └── services_repository_impl_test.dart                         (17 tests)
    └── model/
        └── services_models_test.dart                                  (16 tests)
```

---

## Cyclomatic Complexity Reference

> **Formula**: CC = Number of decision points + 1  
> Decision points: `if`, `else if`, `on`, `catch`, `case`, `&&`, `||`

| Class / Component | Method | Decision Points | CC |
|---|---|---|---|
| `PublicServicesRemoteDatasourceImpl` | `getPublicServices` | 0 | 1 |
| `InternalServicesManagementRemoteDatasourceImpl` | `createService` | 0 | 1 |
| `InternalServicesManagementRemoteDatasourceImpl` | `getServiceById` | 0 | 1 |
| `InternalServicesManagementRemoteDatasourceImpl` | `getServices` | 0 | 1 |
| `InternalServicesManagementRemoteDatasourceImpl` | `updateService` | 0 | 1 |
| `InternalServicesManagementRemoteDatasourceImpl` | `removeService` | 0 | 1 |
| `InternalServicesManagementRemoteDatasourceImpl` | `toggleActive` | 0 | 1 |
| `ServicesRepositoryImpl` | `createService` | 0 | 1 |
| `ServicesRepositoryImpl` | `getPublicServices` | 0 | 1 |
| `ServicesRepositoryImpl` | `getServiceById` | 0 | 1 |
| `ServicesRepositoryImpl` | `getServices` | 0 | 1 |
| `ServicesRepositoryImpl` | `updateService` | 0 | 1 |
| `ServicesRepositoryImpl` | `removeService` | 0 | 1 |
| `ServicesRepositoryImpl` | `toggleActiveStatus` | 0 | 1 |
| `ServicesRepositoryImpl` | `clearCache` | 0 | 1 |
| Models | `fromJson` / `toJson` / mapping methods | 0 | 16 |
| | | **Total CC** | **31** |

> Minimum tests required for full branch coverage = **31**  
> Total tests written = **55** (includes caching updates, stream events, argument verification, and exception coverage)

---

---

## 1. Remote DataSources

### Public Services DataSource
**Source**: `lib/features/services/data/datasources/public_services_remote_datasource.dart`  
**Test File**: `test/features/services/data/datasources/public_services_remote_datasource_test.dart`  
**Mock**: `MockApiClient`

#### Test Cases & Result

##### `getPublicServices(companyId)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R1 | Successful fetch | Happy path | `apiClient.get` → list JSON | `ApiResponse<List<ServiceSummaryModel>>` returned | ✅ PASS |
| R2 | API throws `ApiException` | Exception propagation | `apiClient.get` throws `ApiException(500)` | `ApiException` propagates | ✅ PASS |
| R3 | Correct endpoint called | Argument verification | Any | `get('/public/companies/company-123/services')` called | ✅ PASS |

**Section Total: 3 / 3 PASS**

---

### Internal Services Management DataSource
**Source**: `lib/features/services/data/datasources/internal_services_management_remote_datasource.dart`  
**Test File**: `test/features/services/data/datasources/internal_services_management_remote_datasource_test.dart`  
**Mock**: `MockApiClient`

#### Test Cases & Result

##### `createService(service)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R4 | Successful creation | Happy path | `apiClient.post` → single JSON | `ApiResponse<ServiceModel>` returned | ✅ PASS |
| R5 | API throws | Exception propagation | `apiClient.post` throws `ApiException(400)` | `ApiException` propagates | ✅ PASS |
| R6 | Correct endpoint & body | Argument verification | Any | `post('/services', data: service.toJson())` called | ✅ PASS |

##### `getServiceById(id)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R7 | Successful fetch | Happy path | `apiClient.get` → single JSON | `ApiResponse<ServiceModel>` returned | ✅ PASS |
| R8 | API throws | Exception propagation | `apiClient.get` throws `ApiException(404)` | `ApiException` propagates | ✅ PASS |
| R9 | Correct endpoint called | Argument verification | Any | `get('/services/srv-123')` called | ✅ PASS |

##### `getServices()` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R10 | Successful fetch | Happy path | `apiClient.get` → list JSON | `ApiResponse<List<ServiceSummaryModel>>` returned | ✅ PASS |
| R11 | API throws | Exception propagation | `apiClient.get` throws `ApiException(500)` | `ApiException` propagates | ✅ PASS |
| R12 | Correct endpoint called | Argument verification | Any | `get('/services')` called | ✅ PASS |

##### `updateService(service)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R13 | Successful update | Happy path | `apiClient.put` → single JSON | `ApiResponse<ServiceModel>` returned | ✅ PASS |
| R14 | API throws | Exception propagation | `apiClient.put` throws `ApiException(400)` | `ApiException` propagates | ✅ PASS |
| R15 | Correct endpoint & body | Argument verification | Any | `put('/services/srv-123', data: service.toJson())` called | ✅ PASS |

##### `removeService(serviceId)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R16 | Successful delete | Happy path | `apiClient.delete` → single JSON | `ApiResponse<ServiceModel>` returned | ✅ PASS |
| R17 | API throws | Exception propagation | `apiClient.delete` throws `ApiException(400)` | `ApiException` propagates | ✅ PASS |
| R18 | Correct endpoint called | Argument verification | Any | `delete('/services/srv-123')` called | ✅ PASS |

##### `toggleActive(service)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R19 | Successful toggle | Happy path | `apiClient.patch` → single JSON | `ApiResponse<ServiceModel>` returned | ✅ PASS |
| R20 | API throws | Exception propagation | `apiClient.patch` throws `ApiException(400)` | `ApiException` propagates | ✅ PASS |
| R21 | Active to inactive payload | Inverse isActive | active service input | `patch('/services/srv-123/toggle-active', data: {'isActive': false})` | ✅ PASS |
| R22 | Inactive to active payload | Inverse isActive | inactive service input | `patch('/services/srv-123/toggle-active', data: {'isActive': true})` | ✅ PASS |

**Section Total: 19 / 19 PASS**

---

---

## 2. Services Repository

**Source**: `lib/features/services/data/repositories/services_repository_impl.dart`  
**Test File**: `test/features/services/data/repositories/services_repository_impl_test.dart`  
**Mocks**: `MockInternalServicesRemoteDatasource`, `MockPublicServicesRemoteDatasource`

### Test Cases & Result

##### `createService(service)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup / State | Expected | Result |
|---|---|---|---|---|---|
| I1 | Successful creation | Happy path | Remote returns service; Cache has item | Returns Right(ServiceEntity); merges into cache; emits `cacheChanged` | ✅ PASS |
| I2 | Remote fails | Error path | Remote throws `ApiException(400)` | Returns Left(ServerFailure); cache unchanged; no notifications | ✅ PASS |

##### `getPublicServices(companyId)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| I3 | Successful fetch | Happy path | Remote returns list response | Returns Right(List<ServiceSummaryEntity>) | ✅ PASS |
| I4 | Remote fails | Error path | Remote throws `ApiException(500)` | Returns Left(ServerFailure "Server Sedang Gangguan") | ✅ PASS |

##### `getServiceById(id)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| I5 | Successful fetch | Happy path | Remote returns service response | Returns Right(ServiceEntity) | ✅ PASS |
| I6 | Remote fails | Error path | Remote throws `ApiException(404)` | Returns Left(ServerFailure) with message | ✅ PASS |

##### `getServices({forceRefresh})` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup / State | Expected | Result |
|---|---|---|---|---|---|
| I7 | Cached list valid, `forceRefresh=false` | Cache hit | Cache seeded; remote not called | Returns Right(cached list); remote is not called | ✅ PASS |
| I8 | Cache empty, `forceRefresh=false` | Cache miss | Cache empty; remote returns success | Calls remote; returns Right(data); cache updated | ✅ PASS |
| I9 | Cache seeded, `forceRefresh=true` | Cache bypass | Cache seeded; remote returns new data | Calls remote; returns Right(new data); cache updated | ✅ PASS |
| I10 | Remote fails | Error path | Remote throws `ApiException(500)` | Returns Left(ServerFailure "Server Sedang Gangguan") | ✅ PASS |

##### `updateService(service)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup / State | Expected | Result |
|---|---|---|---|---|---|
| I11 | Successful update | Happy path | Remote returns updated; Cache has old | Returns Right(ServiceEntity); cache updated; emits `cacheChanged` | ✅ PASS |
| I12 | Remote fails | Error path | Remote throws `ApiException(403)` | Returns Left(ServerFailure); cache unchanged; no notifications | ✅ PASS |

##### `removeService(serviceId)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup / State | Expected | Result |
|---|---|---|---|---|---|
| I13 | Successful deletion | Happy path | Remote returns deleted; Cache has item | Returns Right(ServiceEntity); removed from cache; emits `cacheChanged` | ✅ PASS |
| I14 | Remote fails | Error path | Remote throws `ApiException(400)` | Returns Left(ServerFailure); cache unchanged; no notifications | ✅ PASS |

##### `toggleActiveStatus(service)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup / State | Expected | Result |
|---|---|---|---|---|---|
| I15 | Successful toggle | Happy path | Remote returns updated; Cache has old | Returns Right(ServiceEntity); merges into cache; emits `cacheChanged` | ✅ PASS |
| I16 | Remote fails | Error path | Remote throws `ApiException(403)` | Returns Left(ServerFailure); cache unchanged; no notifications | ✅ PASS |

##### `clearCache()` — CC = 1

| ID | Test Case | Branch / Path | State | Expected | Result |
|---|---|---|---|---|---|
| I17 | Cache clear | Happy path | Cache seeded | Cache invalidated; subsequent `getServices` calls remote | ✅ PASS |

**Section Total: 17 / 17 PASS**

---

---

## 3. Data Models

**Source**: `lib/features/services/data/model/`  
**Test File**: `test/features/services/data/model/services_models_test.dart`  
**Mocks**: None

### Test Cases & Result

| ID | Test Case | Branch / Path | Input / Payload | Expected | Result |
|---|---|---|---|---|---|
| M1 | ServiceSummaryModel.fromJson | Happy path | JSON with description | Correct id, title, accessType, and isActive parsed | ✅ PASS |
| M2 | ServiceSummaryModel.toEntity | Happy path | ServiceSummaryModel instance | Returns ServiceSummaryEntity copy | ✅ PASS |
| M3 | ServiceSummaryModel.fromServiceEntity | Happy path | ServiceEntity instance | Returns ServiceSummaryModel copy | ✅ PASS |
| M4 | ServiceRequestConfigModel.fromJson | Happy path | JSON with intake/review forms | intakeForm, reviewForm, and access types parsed | ✅ PASS |
| M5 | ServiceRequestConfigModel.fromJsonTemplate | Happy path | JSON templates | forms parsed with random IDs | ✅ PASS |
| M6 | ServiceRequestConfigModel.fromEntity | Happy path | ServiceRequestConfigEntity | Returns ServiceRequestConfigModel copy | ✅ PASS |
| M7 | ServiceRequestConfigModel.toJson | Happy path | ServiceRequestConfigModel | JSON matching DB schema | ✅ PASS |
| M8 | WorkOrderConfigModel.fromJson | Happy path | JSON config | Forms, minStaff, and maxStaff parsed | ✅ PASS |
| M9 | WorkOrderConfigModel.fromJsonTemplate | Happy path | JSON templates | Config parsed with template models | ✅ PASS |
| M10 | WorkOrderConfigModel.fromEntity | Happy path | WorkOrderConfigEntity | Returns WorkOrderConfigModel copy | ✅ PASS |
| M11 | WorkOrderConfigModel.toJson | Happy path | WorkOrderConfigModel | JSON matching DB schema | ✅ PASS |
| M12 | ServiceModel.fromJson | Happy path | Service JSON | Fully nested models parsed correctly | ✅ PASS |
| M13 | ServiceModel.fromJsonTemplate | Happy path | Service JSON template | Generates random ID and parses configs | ✅ PASS |
| M14 | ServiceModel.fromEntity | Happy path | ServiceEntity | Returns ServiceModel copy | ✅ PASS |
| M15 | ServiceModel.toJson | Happy path | ServiceModel | JSON matching DB schema | ✅ PASS |
| M16 | ServiceModel.toSummaryEntity | Happy path | ServiceModel | Returns ServiceSummaryEntity copy | ✅ PASS |

**Section Total: 16 / 16 PASS**

---

---

## Overall Result

| File | Tests | Passed | Failed | Pass Rate |
|---|---|---|---|---|
| `services_models_test.dart` | 16 | 16 | 0 | 100% |
| `public_services_remote_datasource_test.dart` | 3 | 3 | 0 | 100% |
| `internal_services_management_remote_datasource_test.dart` | 19 | 19 | 0 | 100% |
| `services_repository_impl_test.dart` | 17 | 17 | 0 | 100% |
| **Total** | **55** | **55** | **0** | **100%** |

### Execution Command
```bash
flutter test test/features/services/ --reporter expanded
```

### Execution Output
```
00:00 +0: loading D:/0002 - Source Code/workorder_company_app/test/features/services/data/model/services_models_test.dart
00:00 +1: loading D:/0002 - Source Code/workorder_company_app/test/features/services/data/datasources/internal_services_management_remote_datasource_test.dart
00:00 +2: loading D:/0002 - Source Code/workorder_company_app/test/features/services/data/datasources/public_services_remote_datasource_test.dart
00:00 +3: loading D:/0002 - Source Code/workorder_company_app/test/features/services/data/repositories/services_repository_impl_test.dart
...
00:00 +55: All tests passed!
```

---

## Notes

- expected log messages such as `⛔ ApiException` or `❌ ERROR in safeCall` from error path testing are normal logger outputs and do not signify a failure.
