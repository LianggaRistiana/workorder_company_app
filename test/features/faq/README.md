# FAQ Feature — Whitebox Test Plan & Result

**Layer**: Data (DataSource & Repository)  
**Framework**: `flutter_test` + `mocktail`  
**Testing Method**: Whitebox (branch/path coverage)  
**Date**: 2026-06-12  

---

## 1. File Structure

```
test/features/faq/
├── README.md                          ← Test plan & result documentation
└── data/
    ├── datasources/
    │   └── faq_remote_datasource_test.dart
    ├── repositories/
    │   └── faq_repository_impl_test.dart
    └── model/
        └── faq_models_test.dart
```

---

## 2. Cyclomatic Complexity Reference Table

| Class | Method | Decision Points | CC | Min Tests |
|---|---|---|---|---|
| **FaqDocModel** | `fromJson` | None (`json.field` throws internally) | 1 | 1 |
| **FaqResponseModel** | `fromJson` | None | 1 | 1 |
| **PdfFaqDocModel** | `toJson` | None | 1 | 1 |
| | `fromDraft` | None | 1 | 1 |
| **TextFaqDocModel** | `toJson` | None | 1 | 1 |
| | `fromDraft` | None | 1 | 1 |
| **FaqRemoteDatasourceImpl** | `askQuestion` | None | 1 | 1 |
| **FaqConfigRemoteDatasourceImpl** | `deleteFaqDoc` | None | 1 | 1 |
| | `getFaqDocs` | None | 1 | 1 |
| | `toggleFaqFeature` | None | 1 | 1 |
| | `uploadTextDocs` | None | 1 | 1 |
| | `uploadPdfDoc` | Try/catch block (+1), status check (+1) | 3 | 3 |
| **FaqRepositoryImpl** | `askQuestion` | `result.fold` left/right (+1) | 2 | 2 |
| | `retry` | `result.fold` left/right (+1) | 2 | 2 |
| | `getRoomChat` | `indexWhere == -1` (+1) | 2 | 2 |
| | `clearCache` | None | 1 | 1 |
| **FaqConfigRepositoryImpl** | `deleteFaqDoc` | None (swallowed in `safeCall`) | 1 | 1 |
| | `getFaqDocs` | None (delegated to ListCacheHelper) | 1 | 1 |
| | `toggleFaqFeature` | None (delegated to `safeCall`) | 1 | 1 |
| | `uploadTextDocs` | None (delegated to `safeCall`) | 1 | 1 |
| | `uploadPdfDoc` | Stream mapped results checking (+1) | 2 | 2 |
| | `clearCache` | None | 1 | 1 |

---

## 3. Data Models

### 3.1 Cyclomatic Complexity
| Method | CC | Reason |
|---|---|---|
| `FaqDocModel.fromJson` | 1 | Direct parsing using `JsonField` validators. |
| `FaqResponseModel.fromJson` | 1 | Direct parsing using `JsonField` validators. |
| `PdfFaqDocModel` | 1 | Direct mappings. |
| `TextFaqDocModel` | 1 | Direct mappings. |

### 3.2 Test Cases
| ID | Test Case | Branch/Path | Input/Setup | Expected |
|---|---|---|---|---|
| **M1** | FaqDocModel fromJson happy path | Happy path | Valid JSON with all fields | Returns `FaqDocModel` with correct fields |
| **M2** | FaqDocModel fromJson missing key | Exception path | JSON missing `title` | Throws `ParsingException` |
| **M3** | FaqResponseModel fromJson happy path | Happy path | Valid JSON with `answer` | Returns `FaqResponseModel` with answer |
| **M4** | FaqResponseModel fromJson missing key | Exception path | JSON missing `answer` | Throws `ParsingException` |
| **M5** | PdfFaqDocModel toJson | Happy path | Valid PDF model | Serializes keys to `title` and `file` |
| **M6** | PdfFaqDocModel fromDraft | Happy path | Valid draft | Returns model with matching fields |
| **M7** | TextFaqDocModel toJson | Happy path | Valid text model | Serializes keys to `title` and `content` |
| **M8** | TextFaqDocModel fromDraft | Happy path | Valid draft | Returns model with matching fields |

### 3.3 Test Result
| ID | Description | Result | Note |
|---|---|---|---|
| **M1** | fromJson parses all fields correctly from valid JSON | ✅ PASS | |
| **M2** | fromJson throws ParsingException when required fields are missing | ✅ PASS | |
| **M3** | fromJson parses answer correctly from valid JSON | ✅ PASS | |
| **M4** | fromJson throws ParsingException when answer is missing | ✅ PASS | |
| **M5** | toJson serializes PDF model fields to correct key names | ✅ PASS | |
| **M6** | fromDraft constructs correct model from draft entity | ✅ PASS | |
| **M7** | toJson serializes Text model fields to correct key names | ✅ PASS | |
| **M8** | fromDraft constructs correct model from draft entity | ✅ PASS | |

**Section Total: 8 / 8 PASS**

---

## 4. Remote DataSources

### 4.1 Cyclomatic Complexity
| Method | CC | Reason |
|---|---|---|
| `askQuestion` | 1 | Direct API Client call. |
| `deleteFaqDoc` | 1 | Direct API Client call. |
| `getFaqDocs` | 1 | Direct API Client call. |
| `toggleFaqFeature` | 1 | Direct API Client call. |
| `uploadTextDocs` | 1 | Direct API Client call. |
| `uploadPdfDoc` | 3 | Stream controller wraps progress listener, handles ApiException and generic exception catches. |

### 4.2 Test Cases
| ID | Test Case | Branch/Path | Input/Setup | Expected |
|---|---|---|---|---|
| **R1** | askQuestion success | Happy path | API returns 200 + answer payload | Returns `ApiResponse<FaqResponseModel>` |
| **R2** | askQuestion fails | Exception path | API throws error | Propagates `ApiException` |
| **R3** | askQuestion payload check | Verification | Call with companyId & question | API post called with correct body |
| **R4** | deleteFaqDoc success | Happy path | API returns 200 + Empty payload | Returns `ApiResponse<Empty>` |
| **R5** | deleteFaqDoc fails | Exception path | API throws error | Propagates `ApiException` |
| **R6** | getFaqDocs success | Happy path | API returns list of docs | Returns `ApiResponse<List<FaqDocModel>>` |
| **R7** | getFaqDocs fails | Exception path | API throws error | Propagates `ApiException` |
| **R8** | toggleFaqFeature success | Happy path | API returns updated company | Returns `ApiResponse<CompanyModel>` with `isFaqActive=true` |
| **R9** | toggleFaqFeature fails | Exception path | API throws error | Propagates `ApiException` |
| **R10**| uploadTextDocs success | Happy path | API returns 200 + text doc response | Returns `ApiResponse<FaqDocModel>` |
| **R11**| uploadTextDocs fails | Exception path | API throws error | Propagates `ApiException` |
| **R12**| uploadPdfDoc success | Happy path (Stream) | API upload progress & response | Stream emits progress and then success result |
| **R13**| uploadPdfDoc ApiException | Exception path (Stream) | API post throws `ApiException` | Stream catches error and emits failure result |
| **R14**| uploadPdfDoc generic exception | Exception path (Stream) | API post throws other error | Stream catches error and emits default failure result |

### 4.3 Test Result
| ID | Description | Result | Note |
|---|---|---|---|
| **R1** | askQuestion returns ApiResponse<FaqResponseModel> on success | ✅ PASS | |
| **R2** | askQuestion propagates ApiException on error | ✅ PASS | |
| **R3** | askQuestion calls API post with correct endpoint and query payload | ✅ PASS | |
| **R4** | deleteFaqDoc returns ApiResponse<Empty> on success | ✅ PASS | |
| **R5** | deleteFaqDoc propagates ApiException on error | ✅ PASS | |
| **R6** | getFaqDocs returns ApiResponse<List<FaqDocModel>> on success | ✅ PASS | |
| **R7** | getFaqDocs propagates ApiException on error | ✅ PASS | |
| **R8** | toggleFaqFeature returns ApiResponse<CompanyModel> on success | ✅ PASS | |
| **R9** | toggleFaqFeature propagates ApiException on error | ✅ PASS | |
| **R10**| uploadTextDocs returns ApiResponse<FaqDocModel> on success | ✅ PASS | |
| **R11**| uploadTextDocs propagates ApiException on error | ✅ PASS | |
| **R12**| uploadPdfDoc emits progress and success results on successful file upload | ✅ PASS | |
| **R13**| uploadPdfDoc emits failure result when ApiException is thrown | ✅ PASS | |
| **R14**| uploadPdfDoc emits default failure result when generic exception is thrown | ✅ PASS | |

**Section Total: 14 / 14 PASS**

---

## 5. Repository Implementations

### 5.1 Cyclomatic Complexity
| Method | CC | Reason |
|---|---|---|
| **FaqRepositoryImpl** | | |
| `askQuestion` | 2 | Handles success/error callbacks in `result.fold`. |
| `retry` | 2 | Handles success/error callbacks in `result.fold`. |
| `getRoomChat` | 2 | Checks if company room exists in cache (`index == -1`). |
| `clearCache` | 1 | Direct clearing of cache. |
| **FaqConfigRepositoryImpl** | | |
| `deleteFaqDoc` | 1 | Delegated to `safeCall`. |
| `getFaqDocs` | 1 | Delegated to `ListCacheHelper.fetchList`. |
| `toggleFaqFeature` | 1 | Delegated to `safeCall`. |
| `uploadTextDocs` | 1 | Delegated to `safeCall`. |
| `uploadPdfDoc` | 2 | Checks stream result done state `result.isDone` (+1). |
| `clearCache` | 1 | Direct clearing of cache. |

### 5.2 Test Cases
| ID | Test Case | Branch/Path | Input/Setup | Expected |
|---|---|---|---|---|
| **I1** | askQuestion success | Happy path | Remote success | Returns RoomChatEntity with success chat state |
| **I2** | askQuestion remote failure | Exception path | Remote throws | Returns RoomChatEntity with error chat state |
| **I3** | askQuestion cache matching | Verification | Send multiple chats | Appends chatItem to existing room in cache |
| **I4** | retry success | Happy path | Remote success | Updates error chat item to success state |
| **I5** | retry failure | Exception path | Remote throws | Keeps chat item in error state |
| **I6** | getRoomChat cached | Cache hit | Pre-seeded cache | Returns cached room chat instance |
| **I7** | getRoomChat empty | Cache miss | Empty cache | Returns new empty room chat |
| **I8** | clearCache | Invalidation | Seed cache, clear, fetch | Returns new room chat (old cached room cleared) |
| **I9** | deleteFaqDoc success | Happy path | Remote success | Returns `Right(Empty)` and removes doc from cache list |
| **I10**| deleteFaqDoc failure | Exception path | Remote throws | Returns `Left(ServerFailure)` |
| **I11**| getFaqDocs cache hit | Cache hit | Pre-seeded cache | Returns cached doc list directly, no remote call |
| **I12**| getFaqDocs cache miss | Cache miss | Empty cache, remote success | Calls remote and returns Right(data) |
| **I13**| getFaqDocs failure | Exception path | Remote throws | Returns `Left(ServerFailure)` |
| **I14**| toggleFaqFeature success | Happy path | Remote success | Returns `Right(CompanyEntity)` |
| **I15**| toggleFaqFeature failure | Exception path | Remote throws | Returns `Left(ValidationFailure)` on 400 error |
| **I16**| uploadTextDocs success | Happy path | Remote success | Returns `Right(FaqDocEntity)` and merges it into cache list |
| **I17**| uploadTextDocs failure | Exception path | Remote throws | Returns `Left(Failure)` |
| **I18**| uploadPdfDoc success | Happy path | Remote success stream | Maps remote stream events and merges doc into cache |
| **I19**| uploadPdfDoc failure | Exception path | Remote failure stream | Maps failure stream event directly |

### 5.4 Test Result
| ID | Description | Result | Note |
|---|---|---|---|
| **I1** | returns RoomChatEntity containing success chat state on success | ✅ PASS | |
| **I2** | returns RoomChatEntity containing error chat state when remote fails | ✅ PASS | |
| **I3** | appends chatItem to existing room in cache if company room already exists | ✅ PASS | |
| **I4** | updates retry chat item to success state on remote success | ✅ PASS | |
| **I5** | updates retry chat item to error state when remote fails | ✅ PASS | |
| **I6** | getRoomChat returns cached room chat if company room already exists | ✅ PASS | |
| **I7** | getRoomChat returns new empty room chat when no cache exists | ✅ PASS | |
| **I8** | clearCache causes subsequent getRoomChat to return a fresh room chat | ✅ PASS | |
| **I9** | returns Right(Empty) and removes doc from cache on success | ✅ PASS | |
| **I10** | returns Left(ServerFailure) when remote delete fails | ✅ PASS | |
| **I11**| returns Right(cached) from cache when forceRefresh is false | ✅ PASS | |
| **I12**| calls remote and returns Right(data) when cache is empty | ✅ PASS | |
| **I13**| returns Left(ServerFailure) when remote getFaqDocs fails | ✅ PASS | |
| **I14**| returns Right(CompanyEntity) on remote toggle success | ✅ PASS | |
| **I15**| returns Left(ServerFailure) when remote toggle fails | ✅ PASS | |
| **I16**| returns Right(FaqDocEntity) and merges text doc into cache list on success | ✅ PASS | |
| **I17**| returns Left(ServerFailure) when remote uploadTextDocs fails | ✅ PASS | |
| **I18**| maps remote stream events and merges pdf doc into cache when done | ✅ PASS | |
| **I19**| maps failure stream event directly to caller | ✅ PASS | |

**Section Total: 19 / 19 PASS**

---

## 6. Overall Result

| Component | Total Tests | Passed | Failed | Pass Rate |
|---|---|---|---|---|
| **Models** | 8 | 8 | 0 | 100% |
| **Remote DataSources** | 14 | 14 | 0 | 100% |
| **Repository Implementations** | 19 | 19 | 0 | 100% |
| **TOTAL** | **41** | **41** | **0** | **100%** |

```bash
flutter test test/features/faq/ --reporter expanded
# Output: All tests passed!
```

---

## 7. Notes

* **Console Logging Output**: During execution of tests, error logs like `⛔ ❌ ERROR in safeCall` and printouts of ApiException are generated by production logger scripts when testing failure/exception branches. These are expected and do not indicate a test failure. A test only fails if marked with `[E]`.
