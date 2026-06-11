# Test Guidance — Workorder Company App

> **Purpose**: This guide instructs AI agents on how to write whitebox tests,  
> documentation, and produce consistent output for every feature in this project.  
> Follow this guide exactly to get the same test structure and docs as the `auth` feature.

---

## Quick Reference

| What | Where |
|---|---|
| Test framework | `flutter_test` + `mocktail` |
| Test root | `test/` |
| Feature tests | `test/features/<feature>/data/` |
| Feature docs | `test/features/<feature>/README.md` |
| Auth example | `test/features/auth/` |

---

## 1. Setup

### 1.1 Required `dev_dependencies`

In `pubspec.yaml`, ensure these entries exist under `dev_dependencies`:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mocktail: ^1.0.4
```

> **Why `mocktail` and NOT `mockito`?**  
> `mockito` requires `build_runner` for code generation and is incompatible  
> with `analyzer ^7.7.1` (bundled with the project's Dart SDK).  
> `mocktail` requires **no code generation** and has no analyzer dependency.  
> Never add `mockito` or `build_runner` to this project.

After editing `pubspec.yaml`, run:

```bash
flutter pub get
```

---

### 1.2 Folder Structure to Create

For a feature named `<feature>`, create this structure under `test/`:

```
test/
└── features/
    └── <feature>/
        ├── README.md                          ← test plan & result docs (required)
        └── data/
            ├── datasources/
            │   ├── <feature>_local_datasource_test.dart
            │   └── <feature>_remote_datasource_test.dart
            ├── repositories/
            │   └── <feature>_repository_impl_test.dart
            └── model/
                └── <feature>_models_test.dart
```

---

## 2. Source Files to Read Before Writing Tests

Always read these source files **before** writing any test:

| File | Why |
|---|---|
| `lib/features/<feature>/data/datasources/*_local_datasource.dart` | Understand storage keys, cast patterns, null guards |
| `lib/features/<feature>/data/datasources/*_remote_datasource.dart` | Understand endpoints, request body, return types |
| `lib/features/<feature>/data/repositories/*_repository_impl.dart` | Map every branch (`if`, `catch`, `try`) for CC |
| `lib/features/<feature>/domain/repositories/*_repository.dart` | Understand the contract/interface |
| `lib/features/<feature>/data/model/*.dart` | Understand `fromJson`/`toJson` and null handling |
| `lib/core/error/failures.dart` | Know all `Failure` subtypes |
| `lib/core/error/exceptions.dart` | Know all `Exception` subtypes |
| `lib/core/utils/safe_call.dart` | Understand how `safeCall` maps exceptions to failures |
| `lib/core/services/network/api_response.dart` | Understand `ApiResponse<T>.fromJson` structure |
| `lib/core/services/network/endpoints.dart` | Use exact endpoint constants in argument verification |

---

## 3. Cyclomatic Complexity Calculation

Calculate CC for every **method under test** before writing test cases.

> **Formula**: `CC = number of decision points + 1`

**What counts as a decision point:**

| Construct | Counts as |
|---|---|
| `if` / `else if` | +1 |
| `on SomeException catch` | +1 |
| `catch (e)` | +1 |
| `case` in a `switch` | +1 per case |
| `&&` or `\|\|` in a condition | +1 per operator |
| `?? value` (null coalesce) | 0 — not a branch |
| Method delegated entirely to utility (e.g., `safeCall`) | CC = 1 |

**Minimum tests required** = CC value for that method.  
Write more than the minimum to cover edge cases and argument verification.

---

## 4. Writing Mock Classes

Place mock class definitions at the **top of each test file**, before `main()`.

```dart
// ── Mocks ─────────────────────────────────────────────────────────────────
class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}
class MockApiClient extends Mock implements ApiClient {}
class MockAuthRemoteDatasource extends Mock implements AuthRemoteDatasource {}
class MockAuthLocalDatasource extends Mock implements AuthLocalDatasource {}
class MockTokenStorage extends Mock implements TokenStorage {}
```

### Rules for mocking:

- Only mock **interfaces or abstract classes**. Concrete classes that take no  
  abstract dependency (like `FlutterSecureStorage`) can still be mocked because  
  `mocktail` uses `noSuchMethod`.
- Register fallback values in `setUpAll` for **any type passed as an argument**  
  to a mocked method that uses `captureAny()` or `any()`:

```dart
setUpAll(() {
  registerFallbackValue(const UserModel(
    userId: 'fallback',
    name: 'F',
    email: 'f@f.com',
    role: UserRole.client,
  ));
});
```

---

## 5. Test File Template

Use this exact template for every test file:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
// ... other imports

// ── Mocks ─────────────────────────────────────────────────────────────────
class MockX extends Mock implements X {}

void main() {
  late MockX mockX;
  late SubjectUnderTest subject;

  setUpAll(() {
    // registerFallbackValue(...) for any captured argument types
  });

  setUp(() {
    mockX = MockX();
    subject = SubjectUnderTest(mockX);
  });

  // ── fixtures / helpers ─────────────────────────────────────────────────
  SomeModel makeModel() => SomeModel(...);

  // ═══════════════════════════════════════════════════════════════════════
  // methodName  │  Cyclomatic Complexity = N
  //             │  Paths: describe each path in one line
  // ═══════════════════════════════════════════════════════════════════════
  group('methodName —', () {

    /// TC_ID | Branch: describe branch
    /// Expected: what must happen
    test('TC_ID: short description', () async {
      // arrange
      when(() => mockX.someMethod()).thenAnswer((_) async => someValue);

      // act
      final result = await subject.methodName();

      // assert
      expect(result, ...);
    });

  });
}
```

**Key rules for test code:**

- Use `group('methodName —', () { ... })` to group tests per method.
- Prefix every test name with its ID (e.g., `'L1: ...'`, `'R3: ...'`, `'I7: ...'`).
- Add a doc comment above every `test(...)` with the branch path and expected output.
- Use `when(() => mock.method()).thenAnswer(...)` for async stubs.
- Use `when(() => mock.method()).thenThrow(...)` for error path stubs.
- Use `verify(() => mock.method()).called(1)` for argument verification tests.
- Use `captureAny()` inside `verify(...)` to capture and inspect arguments.
- Use `verifyNever(() => mock.method())` to assert a method was NOT called.
- Use `clearInteractions(mock)` between arrange steps when re-using a mock.

---

## 6. Test ID Convention

Use a consistent prefix per test file:

| Prefix | File | Example |
|---|---|---|
| `L` + number | `*_local_datasource_test.dart` | `L1`, `L2`, `L7` |
| `R` + number | `*_remote_datasource_test.dart` | `R1`, `R3`, `R11` |
| `I` + number | `*_repository_impl_test.dart` | `I1`, `I10`, `I23` |
| `M` + number | `*_models_test.dart` | `M1`, `M5`, `M12` |

Number sequentially within each file.  
Do **not** reuse IDs across files.

---

## 7. What to Test Per Layer

### Local DataSource (`*_local_datasource_test.dart`)

| What to test | Notes |
|---|---|
| Happy path (data stored/read correctly) | Check key name and JSON shape |
| Null guard branches | E.g., `if (value == null) return null` |
| Exception/error paths | E.g., malformed JSON throws `FormatException` |
| Implicit cast risks | E.g., `user as UserModel` — test with wrong type |
| Correct storage key used | Use `verify()` + `captureAny` |

### Remote DataSource (`*_remote_datasource_test.dart`)

| What to test | Notes |
|---|---|
| Happy path (response parsed correctly) | Check returned model fields |
| Exception propagation | `ApiException` must propagate unchanged |
| Correct HTTP method called | `post`, `get`, `patch`, etc. |
| Correct endpoint string used | Use exact `Endpoints.*` constant |
| Correct request body sent | `captureAny(named: 'data')` and assert map |

### Repository Impl (`*_repository_impl_test.dart`)

| What to test | Notes |
|---|---|
| Every branch of every `if` | Trace CC to find all paths |
| Every `catch` block | Both swallowed and re-thrown errors |
| `Either` result type | Assert `isLeft()` / `isRight()` |
| `Failure` subtype returned | Assert exact `Failure` type and `message` |
| Private state (`_cache`) | Verify through public API side effects |
| Order of fallback logic | Verify which mock is/isn't called |
| Entity-to-model mapping | `captureAny()` on the remote call, inspect fields |

### Models (`*_models_test.dart`)

| What to test | Notes |
|---|---|
| `fromJson` happy path | All fields mapped correctly |
| `fromJson` with null optional fields | Null fields handled gracefully |
| `fromJson` missing required field | Throws (document which error) |
| `toJson` output shape | All keys present, values correct |
| Enum parsing (`fromString`) | Test every valid enum value |
| `toJson` enum serialization | Correct snake_case output |

---

## 8. Writing the README.md Documentation

Every feature test folder **must** contain a `README.md` at:

```
test/features/<feature>/README.md
```

### README.md Structure

The README must follow this exact section order:

```
# <Feature> — Whitebox Test Plan & Result

1. File Structure          (code block showing test files)
2. Cyclomatic Complexity   (table: class | method | decision points | CC)

For each component (Local DS, Remote DS, Repository, Models):
├── ### Cyclomatic Complexity  (table: method | CC | reason)
├── ### Test Cases             (table per method: ID | case | branch | input | expected)
└── ### Test Result            (table: ID | description | result ✅/❌ | note)

Overall Result                 (summary table + flutter test output line)
Notes                          (explain expected console noise from production logs)
```

### Documentation Rules

- Write CC table **before** test case tables in every section.
- Each test case table must have columns: `ID | Test Case | Branch/Path | Input/Setup | Expected | Result`
- Result column must use `✅ PASS` or `❌ FAIL`.
- For `❌ FAIL`, add a `Note` explaining the failure reason.
- Draw branch trees as ASCII diagrams for methods with CC ≥ 3.
- Add a `**Section Total: X / Y PASS**` line after each result table.
- End the document with the exact `flutter test` command and output line.

---

## 9. Running Tests

Run all tests for a feature:

```bash
flutter test test/features/<feature>/data/ --reporter expanded
```

Run a single test file:

```bash
flutter test test/features/<feature>/data/repositories/<feature>_repository_impl_test.dart --reporter expanded
```

Run all tests in the project:

```bash
flutter test --reporter expanded
```

### Interpreting Output

| Output | Meaning |
|---|---|
| `+N:` (no `-`) | N tests passed, none failed |
| `+N -M:` | N passed, M failed |
| `⛔` lines in output | `appLogger.e()` from production code — expected in error-path tests, NOT a failure |
| `❌ ERROR in safeCall` log line | Expected output from `safeCall` utility logging — not a test failure |
| `All tests passed!` | All tests passed |

> **Do not confuse production log output with test failures.**  
> A test only fails if the counter shows `-M` and the test name is followed by `[E]`.

---

## 10. Checklist Before Submitting

Before finishing tests for any feature, verify:

- [ ] `mocktail` is in `dev_dependencies` in `pubspec.yaml`
- [ ] `flutter pub get` has been run
- [ ] Test folder structure matches the pattern in Section 1.2
- [ ] CC is calculated for every method under test
- [ ] Every branch (CC value = minimum test count) has a corresponding test
- [ ] Test IDs use the correct prefix convention (L, R, I, M)
- [ ] `registerFallbackValue` is called for all captured argument types
- [ ] All tests pass (`flutter test test/features/<feature>/data/`)
- [ ] `README.md` is written in `test/features/<feature>/`
- [ ] README contains: CC table, test cases table, result table, overall result
- [ ] README result matches the actual `flutter test` output

---

## 11. Reference — Auth Feature (Completed Example)

Use the auth feature as a reference for all future features:

| File | Description |
|---|---|
| [`test/features/auth/README.md`](auth/README.md) | Complete test plan & result docs |
| [`test/features/auth/data/datasources/auth_local_datasource_test.dart`](auth/data/datasources/auth_local_datasource_test.dart) | 8 tests for local storage |
| [`test/features/auth/data/datasources/auth_remote_datasource_test.dart`](auth/data/datasources/auth_remote_datasource_test.dart) | 11 tests for API calls |
| [`test/features/auth/data/repositories/auth_repository_impl_test.dart`](auth/data/repositories/auth_repository_impl_test.dart) | 23 tests for repository logic |
| [`test/features/auth/data/model/auth_models_test.dart`](auth/data/model/auth_models_test.dart) | 12 tests for model serialization |

**Auth feature stats:**

| Metric | Value |
|---|---|
| Total CC | 27 |
| Total tests | 54 |
| Pass rate | 54 / 54 (100%) |
