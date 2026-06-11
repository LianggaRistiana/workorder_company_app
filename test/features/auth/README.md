# Auth Feature — Whitebox Test Documentation

**Layer**: Data (DataSource & Repository)  
**Framework**: `flutter_test` + `mocktail`  
**Testing Method**: Whitebox (branch/path coverage)  
**Date**: 2026-06-12

---

## File Structure

```
test/features/auth/
└── data/
    ├── datasources/
    │   ├── auth_local_datasource_test.dart   (8 tests)
    │   └── auth_remote_datasource_test.dart  (11 tests)
    ├── repositories/
    │   └── auth_repository_impl_test.dart    (23 tests)
    └── model/
        └── auth_models_test.dart             (12 tests)
```

---

## Cyclomatic Complexity Reference

> **Formula**: CC = Number of decision points + 1  
> Decision points: `if`, `else if`, `on`, `catch`, `case`, `&&`, `||`

| Class | Method | Decision Points | CC |
|---|---|---|---|
| `AuthLocalDatasourceImpl` | `saveUser` | 0 | 1 |
| `AuthLocalDatasourceImpl` | `getUser` | 1 | 2 |
| `AuthLocalDatasourceImpl` | `clearUser` | 0 | 1 |
| `AuthRemoteDatasourceImpl` | `login` | 0 | 1 |
| `AuthRemoteDatasourceImpl` | `logout` | 0 | 1 |
| `AuthRemoteDatasourceImpl` | `getUser` | 0 | 1 |
| `AuthRemoteDatasourceImpl` | `userRegistration` | 0 | 1 |
| `AuthRemoteDatasourceImpl` | `companyRegistration` | 0 | 1 |
| `AuthRepositoryImpl` | `login` | 2 | 3 |
| `AuthRepositoryImpl` | `getCurrentUser` | 6 | **7** |
| `AuthRepositoryImpl` | `saveUser` | 1 | 2 |
| `AuthRepositoryImpl` | `logOut` | 2 | 3 |
| `AuthRepositoryImpl` | `userRegistration` | 0 | 1 |
| `AuthRepositoryImpl` | `companyRegistration` | 0 | 1 |
| `AuthRepositoryImpl` | `clearCache` | 0 | 1 |
| Models (`fromJson` / `toJson`) | various | 0–2 | 1–3 |
| | | **Total CC** | **27** |

> Minimum tests required for full branch coverage = **27**  
> Total tests written = **54** (includes argument verification and edge cases)

---

---

## 1. AuthLocalDatasource

**Source**: `lib/features/auth/data/datasources/auth_local_datasource.dart`  
**Test File**: `test/features/auth/data/datasources/auth_local_datasource_test.dart`  
**Mock**: `MockFlutterSecureStorage`

---

### Cyclomatic Complexity

| Method | CC | Decision Points |
|---|---|---|
| `saveUser` | 1 | None — straight-line: cast → encode → write |
| `getUser` | 2 | `if (jsonString == null) return null` |
| `clearUser` | 1 | None — log then delete |

---

### Test Cases & Result

#### `saveUser(UserEntity user)` — CC = 1

| ID | Test Case | Branch / Path | Input | Expected | Result |
|---|---|---|---|---|---|
| L1 | Save valid UserModel | Straight-line | `UserModel(name, email, role=ownerCompany, position=null)` | `storage.write(key='auth_user')` called; JSON contains `name`, `email`, `role` | ✅ PASS |
| L2 | Save UserModel with null position | Null-field serialization | `UserModel(position=null)` | JSON output has `"position": null` | ✅ PASS |
| L3 | UserModel input — cast succeeds | No cast exception | `UserModel` instance | No exception thrown | ✅ PASS |
| L4 | Bare `UserEntity` — cast fails | `user as UserModel` throws | `UserEntity` (not a `UserModel`) | Throws `TypeError` | ✅ PASS |

#### `getUser()` — CC = 2

| ID | Test Case | Branch / Path | Storage State | Expected | Result |
|---|---|---|---|---|---|
| L5 | Valid JSON in storage | Null guard = false → parse → return model | Valid JSON string | Returns `UserModel` with correct `email` and `role` | ✅ PASS |
| L6 | Empty storage | Null guard = true → early return | `null` | Returns `null` | ✅ PASS |
| L7 | Malformed JSON in storage | `json.decode()` throws | `"NOT_VALID_JSON{{{"` | Throws `FormatException` | ✅ PASS |

#### `clearUser()` — CC = 1

| ID | Test Case | Branch / Path | Expected | Result |
|---|---|---|---|---|
| L8 | Normal clear | Straight-line | `storage.delete(key='auth_user')` called once | ✅ PASS |

**Section Total: 8 / 8 PASS**

---

---

## 2. AuthRemoteDatasource

**Source**: `lib/features/auth/data/datasources/auth_remote_datasource.dart`  
**Test File**: `test/features/auth/data/datasources/auth_remote_datasource_test.dart`  
**Mock**: `MockApiClient`

---

### Cyclomatic Complexity

All methods have **CC = 1** — no local branching. Each method delegates directly to `_apiClient` and wraps the result in `ApiResponse.fromJson`.

| Method | CC |
|---|---|
| `login` | 1 |
| `logout` | 1 |
| `getUser` | 1 |
| `userRegistration` | 1 |
| `companyRegistration` | 1 |

---

### Test Cases & Result

#### `login(email, password)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R1 | Successful login | Happy path | `apiClient.post` → valid JSON | `ApiResponse<LoginResponseModel>` with `token`, `user.email` correct | ✅ PASS |
| R2 | API throws `ApiException` | Exception propagation | `apiClient.post` throws `ApiException(401, 'Unauthorized')` | `ApiException` propagates to caller | ✅ PASS |
| R3 | Correct endpoint & body sent | Argument verification | Any | `post(Endpoints.login, data: {email, password})` called exactly once | ✅ PASS |

#### `logout()` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R4 | Successful logout | Happy path | `apiClient.post` → `{data: {loggedOut: true}}` | `ApiResponse<LogoutResponseModel>` with `loggedOut=true` | ✅ PASS |
| R5 | API throws | Exception propagation | `apiClient.post` throws `ApiException(500)` | `ApiException` propagates | ✅ PASS |

#### `getUser()` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R6 | Successful profile fetch | Happy path | `apiClient.get` → valid user JSON | `ApiResponse<UserModel>` with correct `email` and `role` | ✅ PASS |
| R7 | API throws `ApiException` | Exception propagation | `apiClient.get` throws `ApiException(403)` | `ApiException` propagates | ✅ PASS |

#### `userRegistration(model)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R8 | Successful registration | Happy path | `apiClient.post` succeeds | Returns normally, no exception | ✅ PASS |
| R9 | Correct endpoint & body | Argument verification | Any | `post(Endpoints.register, data: {name, email, role='staff_company', password})` called once | ✅ PASS |

#### `companyRegistration(model)` — CC = 1

| ID | Test Case | Branch / Path | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| R10 | Successful registration | Happy path | `apiClient.post` succeeds | Returns normally | ✅ PASS |
| R11 | Correct endpoint & body | Argument verification | Any | `post(Endpoints.registerCompany, data: {name, email, password, companyName})` called once | ✅ PASS |

**Section Total: 11 / 11 PASS**

---

---

## 3. AuthRepositoryImpl

**Source**: `lib/features/auth/data/repositories/auth_repository_impl.dart`  
**Test File**: `test/features/auth/data/repositories/auth_repository_impl_test.dart`  
**Mocks**: `MockAuthRemoteDatasource`, `MockAuthLocalDatasource`, `MockTokenStorage`

---

### Cyclomatic Complexity

| Method | CC | Decision Points |
|---|---|---|
| `login` | 3 | `try` + `on ApiException` + `catch` |
| `getCurrentUser` | **7** | `if (refresh)` + inner `catch` + 2× null-checks inside catch + 2× null-checks in non-refresh path + outer `catch` |
| `saveUser` | 2 | `try` + `catch` |
| `logOut` | 3 | Inner `try/catch` (swallows remote error) + outer `try/catch` |
| `userRegistration` | 1 | Delegated to `safeCall` |
| `companyRegistration` | 1 | Delegated to `safeCall` |
| `clearCache` | 1 | None |

---

### Test Cases & Result

#### `login(email, password)` — CC = 3

```
login()
 ├── [A] try → remote OK          → Right(LoginResponseModel)
 ├── [B] on ApiException catch    → Left(ServerFailure)
 └── [C] catch generic            → Left(UnexpectedFailure)
```

| ID | Test Case | Branch | Mock Setup | Expected | Result |
|---|---|---|---|---|---|
| I1 | Remote success | [A] try-success | Remote returns `ApiResponse<LoginResponseModel>` | `Right(LoginResponseModel)` with `token='jwt-token-abc'` | ✅ PASS |
| I2 | `ApiException` thrown | [B] on ApiException | Remote throws `ApiException(401, 'Unauthorized')` | `Left(ServerFailure(message='Unauthorized'))` | ✅ PASS |
| I3 | Generic exception | [C] catch generic | Remote throws `Exception('Network timeout')` | `Left(UnexpectedFailure(...))` | ✅ PASS |

---

#### `getCurrentUser({bool refresh})` — CC = 7

```
getCurrentUser()
 ├── refresh = true
 │    ├── [A] remote OK            → update cache & local → Right(remoteUser)
 │    └── remote FAILS
 │         ├── [B] _cache != null  → Right(_cache!)
 │         ├── [C] local != null   → set _cache → Right(localUser)
 │         └── [D] local == null   → Left(ServerFailure)
 └── refresh = false
      ├── [E] _cache != null       → Right(_cache!)
      ├── [F] local != null        → set _cache → Right(localUser)
      └── [G] local == null        → Left(AuthFailure)
```

| ID | Test Case | Branch | Setup | Expected | Result |
|---|---|---|---|---|---|
| I4 | `refresh=true`, remote succeeds | [A] | Remote returns user | `Right(remoteUser)`, `local.saveUser` called, `_cache` set | ✅ PASS |
| I5 | `refresh=true`, remote fails, cache hit | [B] | Remote throws; cache pre-seeded via prior call | `Right(cachedUser)`, local never called | ✅ PASS |
| I6 | `refresh=true`, remote fails, no cache, local hit | [C] | Remote throws; cache empty; local returns user | `Right(localUser)`, `_cache` updated | ✅ PASS |
| I7 | `refresh=true`, all fallbacks exhausted | [D] | Remote throws; cache empty; local=`null` | `Left(ServerFailure)` | ✅ PASS |
| I8 | `refresh=false`, cache hit | [E] | Cache pre-seeded | `Right(cache)`, remote & local never called | ✅ PASS |
| I9 | `refresh=false`, no cache, local hit | [F] | Cache empty; local returns user | `Right(localUser)`, `_cache` updated | ✅ PASS |
| I10 | `refresh=false`, no cache, no local | [G] | Cache empty; local=`null` | `Left(AuthFailure)` | ✅ PASS |

---

#### `saveUser(UserEntity user)` — CC = 2

| ID | Test Case | Branch | Setup | Expected | Result |
|---|---|---|---|---|---|
| I11 | Local save succeeds | try-success | `local.saveUser` completes | `Right(null)`, `_cache` updated to saved user | ✅ PASS |
| I12 | Local save throws | catch | `local.saveUser` throws `Exception` | `Left(CacheFailure(...))` | ✅ PASS |

---

#### `logOut()` — CC = 3

```
logOut()
 └── outer try
      ├── inner try  → remote.logout()
      │    ├── [A] success — continues
      │    └── [B] catch — appLogger.e(), error swallowed
      ├── local.clearUser()
      ├── tokenStorage.clearToken()
      └── Right(null)
 └── outer catch
      └── [C] Left(CacheFailure('Gagal Menghapus Data Local'))
```

| ID | Test Case | Branch | Setup | Expected | Result |
|---|---|---|---|---|---|
| I13 | All steps succeed | [A] full success | Remote, local, token all OK | `Right(null)` | ✅ PASS |
| I14 | Remote fails — swallowed silently | [B] inner catch | Remote throws; local + token succeed | `Right(null)`; `clearUser` and `clearToken` still called | ✅ PASS |
| I15 | `clearUser` throws | [C] outer catch | `local.clearUser` throws | `Left(CacheFailure(message='Gagal Menghapus Data Local'))` | ✅ PASS |
| I16 | `clearToken` throws | [C] outer catch | `tokenStorage.clearToken` throws | `Left(CacheFailure(...))` | ✅ PASS |

---

#### `userRegistration(entity)` — CC = 1

| ID | Test Case | Branch | Setup | Expected | Result |
|---|---|---|---|---|---|
| I17 | Registration success | happy path | Remote returns normally | `Right(null)` | ✅ PASS |
| I18 | Remote throws `ApiException` | `safeCall` catch | Remote throws `ApiException(422)` | `Left(ValidationFailure(...))` | ✅ PASS |
| I19 | Entity-to-model mapping | Argument verification | Any | Remote receives `UserRegistrationModel` with matching `name`, `email`, `role`, `password` | ✅ PASS |

---

#### `companyRegistration(entity)` — CC = 1

| ID | Test Case | Branch | Setup | Expected | Result |
|---|---|---|---|---|---|
| I20 | Registration success | happy path | Remote returns normally | `Right(null)` | ✅ PASS |
| I21 | Remote throws `ApiException` | `safeCall` catch | Remote throws `ApiException(409)` | `Left(ServerFailure(...))` | ✅ PASS |
| I22 | Entity-to-model mapping | Argument verification | Any | Remote receives `CompanyRegistrationModel` with matching `name`, `email`, `password`, `companyName` | ✅ PASS |

---

#### `clearCache()` — CC = 1

| ID | Test Case | Branch | Setup | Expected | Result |
|---|---|---|---|---|---|
| I23 | Clears in-memory cache | Straight-line | Cache seeded via `getCurrentUser(refresh: true)` | `_cache = null`; `currentUser` getter returns `null` | ✅ PASS |

**Section Total: 23 / 23 PASS**

---

---

## 4. Data Models

**Source**: `lib/features/auth/data/model/`  
**Test File**: `test/features/auth/data/model/auth_models_test.dart`  
**Mocks**: None — pure unit tests

---

### Cyclomatic Complexity

| Model | Method | CC | Decision Points |
|---|---|---|---|
| `UserModel` | `fromJson` | 2 | `if (json['position'] != null)` |
| `UserModel` | `toJson` | 3 | `if (position == null)` + `if (position is PositionModel)` + `else` |
| `LoginResponseModel` | `fromJson` | 1 | None |
| `LogoutResponseModel` | `fromJson` | 1 | `?? false` (null coalesce) |
| `UserRegistrationModel` | `toJson` | 1 | None |
| `CompanyRegistrationModel` | `toJson` | 1 | None |

---

### Test Cases & Result

#### `UserModel` — CC = 2 / 3

| ID | Test Case | Method | Branch / Path | Input | Expected | Result |
|---|---|---|---|---|---|---|
| M1 | All fields with nested position | `fromJson` | Non-null position branch | JSON with `position: {_id, name}` | All fields mapped; `position.name='Engineer'` | ✅ PASS |
| M2 | Null position | `fromJson` | Null position guard | JSON with `position: null` | `user.position == null` | ✅ PASS |
| M3 | All 5 role variants parsed | `fromJson` | Each `case` in `UserRole.fromString` switch | 5 snake_case strings | Each maps to correct `UserRole` enum value | ✅ PASS |
| M4 | `toJson` with null position | `toJson` | Null branch | `UserModel(position=null)` | JSON has `"position": null` | ✅ PASS |

#### `LoginResponseModel` — CC = 1

| ID | Test Case | Method | Branch / Path | Input | Expected | Result |
|---|---|---|---|---|---|---|
| M5 | Valid full JSON | `fromJson` | Happy path | `{token, user: {...}}` | `token='jwt-abc'`, `user.email='budi@example.com'` | ✅ PASS |
| M6 | Missing `token` key | `fromJson` | Null / type error | `{user: {...}}` — no token field | Throws (`TypeError` or null check error) | ✅ PASS |

#### `LogoutResponseModel` — CC = 1

| ID | Test Case | Method | Branch / Path | Input | Expected | Result |
|---|---|---|---|---|---|---|
| M7 | `loggedOut: true` present | `fromJson` | Value present | `{loggedOut: true}` | `model.loggedOut == true` | ✅ PASS |
| M8 | Key absent | `fromJson` | `?? false` fallback | `{}` | `model.loggedOut == false` | ✅ PASS |

#### `UserRegistrationModel` — CC = 1

| ID | Test Case | Method | Branch / Path | Input | Expected | Result |
|---|---|---|---|---|---|---|
| M9 | All fields mapped | Constructor | Straight-line | `name, email, role=managerCompany, password` | All 4 fields match source entity | ✅ PASS |
| M10 | Role serialized to snake_case | `toJson` | Straight-line | `role=managerCompany` | JSON has `"role": "manager_company"` | ✅ PASS |

#### `CompanyRegistrationModel` — CC = 1

| ID | Test Case | Method | Branch / Path | Input | Expected | Result |
|---|---|---|---|---|---|---|
| M11 | All fields mapped | Constructor | Straight-line | `name, email, password, companyName` | All 4 fields match source entity | ✅ PASS |
| M12 | `companyName` key in JSON | `toJson` | Straight-line | Any | JSON contains `"companyName"` key with correct value | ✅ PASS |

**Section Total: 12 / 12 PASS**

---

---

## Overall Result

```
flutter test test/features/auth/data/ --reporter expanded

00:01 +54: All tests passed!
```

| Test File | Tests | Pass | Fail |
|---|---|---|---|
| `auth_local_datasource_test.dart` | 8 | 8 | 0 |
| `auth_remote_datasource_test.dart` | 11 | 11 | 0 |
| `auth_repository_impl_test.dart` | 23 | 23 | 0 |
| `auth_models_test.dart` | 12 | 12 | 0 |
| **Total** | **54** | **54** | **0** |

**✅ All 54 tests passed.**

---

## Notes

- `⛔` console lines in `logOut` error-path tests (`I14`, `I15`, `I16`) are `appLogger.e()` output from production code. They are **expected behavior** and do not indicate test failures.
- `safeCall` error log output (`❌ ERROR in safeCall`) in `I18` and `I21` is also expected production behavior being tested.
- Test I14 explicitly verifies the **whitebox-only** behavior that remote logout errors are silently swallowed — a behavior invisible to blackbox or integration tests.
