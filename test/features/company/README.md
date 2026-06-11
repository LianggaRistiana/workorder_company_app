# Company Feature — Whitebox Test Plan & Result

**Layer**: Data (DataSource & Repository)  
**Framework**: `flutter_test` + `mocktail`  
**Testing Method**: Whitebox (branch/path coverage)  
**Date**: 2026-06-12  

---

## 1. File Structure

```
test/features/company/
├── README.md                          ← Test plan & result documentation
└── data/
    ├── datasources/
    │   └── company_remote_datasource_test.dart
    ├── repositories/
    │   └── company_repository_impl_test.dart
    └── model/
        └── company_model_test.dart
```

---

## 2. Cyclomatic Complexity Reference Table

| Class | Method | Decision Points | CC | Min Tests |
|---|---|---|---|---|
| **CompanyModel** | `fromJson` | None (`??` counts as 0) | 1 | 1 |
| | `fromEntity` | None | 1 | 1 |
| | `toJson` | None | 1 | 1 |
| **CompanyManagementRemoteDatasourceImpl** | `getCompanyInformation` | None | 1 | 1 |
| | `updateCompanyInformation` | None | 1 | 1 |
| **PublicCompaniesRemoteDatasourceImpl** | `getCompanies` | None | 1 | 1 |
| | `getCompanyById` | None | 1 | 1 |
| **InternalCompanyRepositoryImpl** | `getCompanyInformation` | `if (!forceRefresh && _cache.hasValidValue)` (+1), `if (cached != null)` (+1) | 3 | 3 |
| | `updateCompanyInformation` | None (delegated to `safeCall`) | 1 | 1 |
| | `clearCache` | None | 1 | 1 |
| **PublicCompaniesRepositoryImpl** | `getCompanies` | None (delegated to `safeCall`) | 1 | 1 |
| | `getCompanyById` | None (delegated to `safeCall`) | 1 | 1 |

---

## 3. Data Models

### 3.1 Cyclomatic Complexity
| Method | CC | Reason |
|---|---|---|
| `fromJson` | 1 | Direct parsing, null coalescing operators (`??`) do not count as branch splits. |
| `fromEntity` | 1 | Direct mapping. |
| `toJson` | 1 | Direct mapping. |

### 3.2 Test Cases
| ID | Test Case | Branch/Path | Input/Setup | Expected |
|---|---|---|---|---|
| **M1** | fromJson full payload | Happy path | Valid JSON with all fields | Returns `CompanyModel` with correct fields |
| **M2** | fromJson null address | Null guard | JSON with `address: null` | Returns model with `address` as `""` |
| **M3** | fromJson null description | Null guard | JSON with `description: null` | Returns model with `description` as `""` |
| **M4** | fromJson null isActive | Null guard | JSON with `isActive: null` | Returns model with `isActive` as `true` |
| **M5** | fromJson null/absent isFaqActive | Null guard | JSON with `isFaqActive` null/absent | Returns model with `isFaqActive` as `false` |
| **M6** | fromJson explicitly true isFaqActive | Happy path | JSON with `isFaqActive: true` | Returns model with `isFaqActive` as `true` |
| **M7** | fromJson missing `_id` key | Cast/Null check | JSON missing `_id` | Throws `TypeError` |
| **M8** | fromEntity copies all fields | Happy path | Valid `CompanyEntity` | Returns `CompanyModel` with matching fields |
| **M9** | fromEntity preserves defaults | Happy path | Entity with empty address/desc | Returns model with `address` and `description` as `""` |
| **M10**| toJson output keys | Happy path | Valid model | Map contains exactly 6 expected keys |
| **M11**| toJson id key naming | Happy path | Valid model | Serialized ID key is `id`, NOT `_id` |
| **M12**| toJson values match | Happy path | Valid model | Serialized map values match fields exactly |

### 3.3 Test Result
| ID | Description | Result | Note |
|---|---|---|---|
| **M1** | fromJson maps all fields correctly when all are provided | ✅ PASS | |
| **M2** | fromJson uses empty string default when address is null | ✅ PASS | |
| **M3** | fromJson uses empty string default when description is null | ✅ PASS | |
| **M4** | fromJson uses true default when isActive is null | ✅ PASS | |
| **M5** | fromJson uses false default when isFaqActive is null or absent | ✅ PASS | |
| **M6** | fromJson parses isFaqActive correctly when explicitly true | ✅ PASS | |
| **M7** | fromJson throws TypeError when _id is missing or null | ✅ PASS | |
| **M8** | fromEntity copies all fields from entity correctly | ✅ PASS | |
| **M9** | fromEntity preserves empty string defaults from entity | ✅ PASS | |
| **M10**| toJson output includes all 6 keys | ✅ PASS | |
| **M11**| toJson maps model.id to key "id", not "_id" | ✅ PASS | |
| **M12**| toJson values match the model fields exactly | ✅ PASS | |

**Section Total: 12 / 12 PASS**

---

## 4. Remote DataSources

### 4.1 Cyclomatic Complexity
| Method | CC | Reason |
|---|---|---|
| `getCompanyInformation` | 1 | No logical branching inside implementation. |
| `updateCompanyInformation` | 1 | No logical branching inside implementation. |
| `getCompanies` | 1 | No logical branching inside implementation. |
| `getCompanyById` | 1 | No logical branching inside implementation. |

### 4.2 Test Cases
| ID | Test Case | Branch/Path | Input/Setup | Expected |
|---|---|---|---|---|
| **R1** | getCompanyInformation happy path | Happy path | API returns 200 + company JSON | Returns `ApiResponse<CompanyModel>` |
| **R2** | getCompanyInformation fails | Exception path | ApiClient throws `ApiException` | Throws `ApiException` |
| **R3** | updateCompanyInformation happy path | Happy path | API returns 200 + updated JSON | Returns `ApiResponse<CompanyModel>` |
| **R4** | updateCompanyInformation body check | Verification | Call update | API put is called with correct body |
| **R5** | updateCompanyInformation fails | Exception path | ApiClient throws `ApiException` | Throws `ApiException` |
| **R6** | getCompanies happy path | Happy path | API returns list of companies | Returns list of `CompanyModel` |
| **R7** | getCompanies empty array | Happy path | API returns empty list `[]` | Returns empty `List<CompanyModel>` |
| **R8** | getCompanies fails | Exception path | ApiClient throws `ApiException` | Throws `ApiException` |
| **R9** | getCompanyById happy path | Happy path | API returns company + meta JSON | Returns `ApiResponseWithMeta<CompanyModel>` |
| **R10**| getCompanyById path verification | Verification | Call getCompanyById with ID | ApiClient.get called with `/public/companies/{id}` |
| **R11**| getCompanyById fails | Exception path | ApiClient throws `ApiException` | Throws `ApiException` |

### 4.3 Test Result
| ID | Description | Result | Note |
|---|---|---|---|
| **R1** | getCompanyInformation returns ApiResponse<CompanyModel> on success | ✅ PASS | |
| **R2** | getCompanyInformation propagates ApiException on error | ✅ PASS | |
| **R3** | updateCompanyInformation returns ApiResponse<CompanyModel> on success | ✅ PASS | |
| **R4** | updateCompanyInformation calls API put with correct endpoint and body | ✅ PASS | |
| **R5** | updateCompanyInformation propagates ApiException on error | ✅ PASS | |
| **R6** | getCompanies returns ApiResponse<List<CompanyModel>> on success | ✅ PASS | |
| **R7** | getCompanies returns empty list when API returns empty array | ✅ PASS | |
| **R8** | getCompanies propagates ApiException on error | ✅ PASS | |
| **R9** | getCompanyById returns ApiResponseWithMeta<CompanyModel> on success | ✅ PASS | |
| **R10**| getCompanyById calls API get with correct ID-based endpoint path | ✅ PASS | |
| **R11**| getCompanyById propagates ApiException on error | ✅ PASS | |

**Section Total: 11 / 11 PASS**

---

## 5. Repository Implementations

### 5.1 Cyclomatic Complexity
| Method | CC | Reason |
|---|---|---|
| `getCompanyInformation` | 3 | Checks `!forceRefresh && _cache.hasValidValue` and `cached != null`. |
| `updateCompanyInformation` | 1 | Fully delegated to `safeCall`. |
| `clearCache` | 1 | Direct clearing of private cached resource. |
| `getCompanies` | 1 | Fully delegated to `safeCall`. |
| `getCompanyById` | 1 | Fully delegated to `safeCall`. |

### 5.2 Branch Tree (InternalCompanyRepositoryImpl.getCompanyInformation)
```
getCompanyInformation()
 ├── [A] forceRefresh=false AND cache valid AND cache.value != null ──> Right(cached) [Remote NOT called]
 ├── [B] forceRefresh=false AND cache empty/invalid ──> remote fetch ──> Right(data) [Cache updated]
 ├── [C] forceRefresh=true ──> remote fetch ──> Right(data) [Cache updated]
 └── [D] remote fetch fails ──> Left(Failure)
```

### 5.3 Test Cases
| ID | Test Case | Branch/Path | Input/Setup | Expected |
|---|---|---|---|---|
| **I1** | forceRefresh=false, cache valid | Path [A] | Pre-seed cache | Returns `Right(cached)`, no remote call |
| **I2** | forceRefresh=false, cache empty | Path [B] | Empty cache, remote success | Returns `Right(data)`, cache updated |
| **I3** | forceRefresh=true, cache seeded | Path [C] | Seeded cache, remote success | Returns `Right(freshData)` via remote call |
| **I4** | forceRefresh=false, remote fails | Path [D] | Empty cache, remote `ApiException` | Returns `Left(ServerFailure)` |
| **I5** | forceRefresh=true, remote fails | Path [D] | Seeded cache, remote `ApiException` | Returns `Left(ServerFailure)` |
| **I6** | Cache validation side-effects | Verification | Consecutive fetch calls | Second call uses cache, no remote calls |
| **I7** | updateCompanyInformation success | Happy path | Remote update success | Returns `Right(entity)` and updates cache |
| **I8** | updateCompanyInformation fails | Exception path | Remote update throws `ApiException` | Returns `Left(ServerFailure)` |
| **I9** | updateCompanyInformation mapper | Verification | Call update | Remote is called with mapped `CompanyModel` |
| **I10**| clearCache side-effects | Verification | Call clearCache, then fetch | Cache cleared, next fetch calls remote |
| **I11**| getCompanies success | Happy path | Remote getCompanies success | Returns `Right(List<CompanyEntity>)` |
| **I12**| getCompanies fails | Exception path | Remote getCompanies throws `ApiException` | Returns `Left(AuthFailure)` for 403 status |
| **I13**| getCompanyById success | Happy path | Remote getCompanyById success | Returns `Right(Result<CompanyEntity>)` with meta |
| **I14**| getCompanyById fails | Exception path | Remote getCompanyById throws `ApiException` | Returns `Left(ServerFailure)` |

### 5.4 Test Result
| ID | Description | Result | Note |
|---|---|---|---|
| **I1** | returns Right(cached) and does not call remote when cache is valid and forceRefresh is false | ✅ PASS | |
| **I2** | calls remote, returns Right(data), and updates cache when cache is empty | ✅ PASS | |
| **I3** | calls remote even if cache is seeded when forceRefresh is true | ✅ PASS | |
| **I4** | returns Left(ServerFailure) when remote fails and forceRefresh is false | ✅ PASS | |
| **I5** | returns Left(ServerFailure) when remote fails and forceRefresh is true | ✅ PASS | |
| **I6** | subsequent call uses cached resource after success | ✅ PASS | |
| **I7** | returns Right(CompanyEntity) and updates cache on success | ✅ PASS | |
| **I8** | returns Left(ServerFailure) when remote update fails | ✅ PASS | |
| **I9** | calls remote update with correctly serialized CompanyModel mapped from CompanyEntity | ✅ PASS | |
| **I10**| clearing cache causes subsequent fetch to hit remote datasource | ✅ PASS | |
| **I11**| returns Right(List<CompanyEntity>) on remote success | ✅ PASS | |
| **I12**| returns Left(ServerFailure) when remote getCompanies fails | ✅ PASS | |
| **I13**| returns Right(Result<CompanyEntity>) with correct data and metadata on success | ✅ PASS | |
| **I14**| returns Left(ServerFailure) when remote getCompanyById fails | ✅ PASS | |

**Section Total: 14 / 14 PASS**

---

## 6. Overall Result

| Component | Total Tests | Passed | Failed | Pass Rate |
|---|---|---|---|---|
| **Models** | 12 | 12 | 0 | 100% |
| **Remote DataSources** | 11 | 11 | 0 | 100% |
| **Repository Implementations** | 14 | 14 | 0 | 100% |
| **TOTAL** | **37** | **37** | **0** | **100%** |

```bash
flutter test test/features/company/ --reporter expanded
# Output: All tests passed!
```

---

## 7. Notes

* **Console Logging Output**: During execution of the repository tests, you will see output like `⛔ ❌ ERROR in safeCall` and printouts of ApiException. These are generated by the production code's error handling and logging (`appLogger.e`), and are expected during testing of error/failure paths. They do not indicate test failures. A test only fails if it is marked with `[E]`.
