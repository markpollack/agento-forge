# Finishing Touches for Java Library Projects

This document captures the standard "finishing touches" applied to production-ready Java libraries. Use this as a checklist when polishing repositories.

> **This is the canonical Java engineering standard — edit it here.** Originally GP-9
> `java-library-finishing-touches.md` (grand-plan v2, January 2026). Two frozen snapshots of that
> original survive and must not be edited: `~/tuvium/projects/grand-plan/v2/architecture/` (the
> original, in a repo declared not-maintained) and the research KB's ingest snapshot at
> `~/tuvium/projects/tuvium-research-conversation-agent/conversations/archive/grand-plan-v2/architecture/`.
> Both carry pointers back here. Projects citing "the research-KB Java standard" (agent-workflow's
> standing directive, 2026-07-23) mean this file.

---

## Principles

Proven across the gates below (ACP Java SDK, 2026-09-30 to 2026-10-01). Each new gate's first run was a
bug hunt: ArchUnit found 3 cycles, NullAway 9 real bugs, Error Prone's own checks 3 real bugs.

1. **Falsify every gate.** Plant the violation, see red, revert. A checker that is silent is
   indistinguishable from one that is off (§4.7), and that holds for every tool here.
2. **Each gate's first run is a bug hunt; budget for it.** Real bugs get a test that was red first.
3. **Fix rather than baseline**, when the library has few consumers and is pre-1.0. A baseline file turns
   today's problems into permanent exemptions.
4. **Gates live in the build.** A check that only some contributors can run (an IDE, a cloud service) is
   advice, not a gate.
5. **Add one gate at a time, and land each before the next.** Each new gate changes code the next one
   reads. When agents work in parallel clones, rebase each branch onto `main` before landing.
6. **No secrets on organisation repositories you don't administer.** Choose tools that need none: OSV
   over NVD, `GITHUB_TOKEN` over tokens.

---

## 1. Code Coverage with JaCoCo

### Purpose
Measure test coverage to identify untested code paths.

### Maven Configuration

**Parent pom.xml** (in `<pluginManagement>`):
```xml
<plugin>
    <groupId>org.jacoco</groupId>
    <artifactId>jacoco-maven-plugin</artifactId>
    <version>0.8.11</version>
    <executions>
        <execution>
            <id>prepare-agent</id>
            <goals>
                <goal>prepare-agent</goal>
            </goals>
        </execution>
        <execution>
            <id>report</id>
            <phase>test</phase>
            <goals>
                <goal>report</goal>
            </goals>
        </execution>
    </executions>
</plugin>
```

**Module pom.xml** (in `<plugins>`):
```xml
<plugin>
    <groupId>org.jacoco</groupId>
    <artifactId>jacoco-maven-plugin</artifactId>
</plugin>
```

### Usage
```bash
./mvnw test
# Report at: target/site/jacoco/index.html
```

### Tips
- Run `./mvnw test` to generate the report
- View HTML report for visual coverage analysis
- Consider adding coverage thresholds for CI:
  ```xml
  <execution>
      <id>check</id>
      <goals><goal>check</goal></goals>
      <configuration>
          <rules>
              <rule>
                  <limits>
                      <limit>
                          <counter>LINE</counter>
                          <minimum>0.80</minimum>
                      </limit>
                  </limits>
              </rule>
          </rules>
      </configuration>
  </execution>
  ```

---

## 2. Architecture Tests with ArchUnit

### Purpose
Enforce architectural rules at compile/test time:
- Dependency direction (services → interfaces, not implementations)
- Layer isolation (models don't depend on services)
- Naming conventions
- Implementation patterns (decorators implement interfaces)

### Maven Dependency

```xml
<dependency>
    <groupId>com.tngtech.archunit</groupId>
    <artifactId>archunit-junit5</artifactId>
    <version>1.4.1</version>
    <scope>test</scope>
</dependency>
```

### Example Test Class

```java
@AnalyzeClasses(packages = "org.example.myproject",
        importOptions = ImportOption.DoNotIncludeTests.class)
class ArchitectureTest {

    // Services should depend on interfaces, not concrete implementations
    @ArchTest
    static final ArchRule services_depend_on_interfaces = noClasses()
        .that().haveSimpleNameEndingWith("Service")
        .should().dependOnClassesThat().haveSimpleName("ConcreteImplementation")
        .because("Services should depend on interfaces, not implementations");

    // Models should be pure data without service dependencies
    @ArchTest
    static final ArchRule models_are_pure = noClasses()
        .that().haveSimpleNameEndingWith("Request")
        .or().haveSimpleNameEndingWith("Result")
        .should().dependOnClassesThat().haveSimpleNameEndingWith("Service")
        .because("Model classes should be pure data");

    // Decorators must implement their interface
    @ArchTest
    static final ArchRule decorators_implement_interface = classes()
        .that().haveSimpleNameEndingWith("Client")
        .and().doNotHaveSimpleName("GitHubClient")  // exclude interface itself
        .should().implement(GitHubClient.class)
        .because("All *Client classes should implement the GitHubClient interface");

    // Only builders should instantiate concrete implementations
    @ArchTest
    static final ArchRule only_builder_creates_implementations = noClasses()
        .that().doNotHaveSimpleName("MyBuilder")
        .and().haveSimpleNameEndingWith("Service")
        .should().dependOnClassesThat().haveSimpleName("ConcreteRepository")
        .because("Only Builder should create concrete implementations");
}
```

### Common Rule Patterns

| Rule Type | Use Case |
|-----------|----------|
| `noClasses().that().X.should().dependOnClassesThat().Y` | Prevent unwanted dependencies |
| `classes().that().X.should().implement(Interface.class)` | Enforce interface implementation |
| `classes().that().X.should().beAssignableTo(Base.class)` | Enforce inheritance |
| `noClasses().that().X.should().accessClassesThat().resideInAPackage("java.io")` | Prevent direct I/O |

### Rules that find structure, not naming

The naming-based examples above are the easy part. The rules that found real problems in the ACP Java
SDK (3 cycles on the first run, including a five-class cycle in one transport package) are structural:

**Cycles at every depth, not just top-level packages.** A top-level slice rule missed a cycle that the
any-depth rule caught when planted:

```java
@ArchTest
static final ArchRule noPackageCyclesAtAnyDepth = slices()
    .matching("org.example.mylib.(**)")
    .should().beFreeOfCycles();
```

**Class-level cycles inside the packages that matter.** Package rules don't see two classes in one
package that use each other. Slice by top-level class, so nested classes count with their outer class.

**One architecture test per module, importing only that module.** In a multi-module build,
`@AnalyzeClasses(packages = ...)` imports matching classes from the whole classpath, so a module's rules
silently check its dependencies too. Import from the module's own output, through a `LocationProvider`
or `ClassFileImporter().importPath(...)`, and assert that nothing from another module came in.

**No empty passes.** ArchUnit passes a rule whose `that()` selects nothing. Add
`src/test/resources/archunit.properties` to every module:

```properties
# Fail a rule whose "that" clause selects no classes, so a rule cannot pass on an empty import.
archRule.failOnEmptyShould=true
```

**State each module's intent as a rule, with a one-line comment.** Examples: JSON implementation modules
use only the JSON interfaces and the schema; transports never reach the session implementation classes;
the annotations module depends on nothing in the library.

**Falsify every rule.** Plant the violation, see that exact rule fail, revert (the ACP SDK recorded 18
plantings). See principle 1.

**Fix violations by design.** Move a type or invert a dependency. Keep a named exemption only when the
fix is out of proportion, with a written reason.

---

## 3. Code Smell Detection via "Oracle" Review

### Purpose
Use AI/LLM as an "oracle" to review code for smells, anti-patterns, and improvements.

### Process

1. **Share the codebase** with the AI assistant
2. **Ask specific questions**:
   - "Review this code for code smells"
   - "What anti-patterns do you see?"
   - "How can I improve the architecture?"
   - "Are there any leaky abstractions?"

### Common Smells to Check

| Smell | Description | Fix |
|-------|-------------|-----|
| **Leaky Abstraction** | Internal types (e.g., `JsonNode`) exposed in APIs | Create DTOs at service boundary |
| **God Class** | Class doing too much | Split into focused classes |
| **Feature Envy** | Method uses another class's data more than its own | Move method to that class |
| **Primitive Obsession** | Using primitives instead of small objects | Create value objects |
| **Missing Interface** | Concrete class used directly | Extract interface for testability |
| **Hardcoded Dependencies** | `new ConcreteClass()` in business logic | Inject via constructor |

### Example Questions for Oracle

```
1. "Review the public API of this library - are there any leaky abstractions?"
2. "Check if services depend on concrete implementations instead of interfaces"
3. "Are there any classes that should be split?"
4. "Is the dependency graph clean? Any cycles?"
5. "Review the error handling - is it consistent?"
```

---

## 4. Null Safety with JSpecify

### Purpose
Prevent NullPointerExceptions through explicit nullability contracts using the emerging standard (JSpecify 1.0).

### Maven Dependency

```xml
<dependency>
    <groupId>org.jspecify</groupId>
    <artifactId>jspecify</artifactId>
    <version>1.0.0</version>
</dependency>
```

### Setup: Package-Level Null-Marking

Create `package-info.java` in each package:

```java
/**
 * This package is null-marked, meaning all reference types are
 * non-null by default unless explicitly annotated with @Nullable.
 */
@NullMarked
package org.example.myproject;

import org.jspecify.annotations.NullMarked;
```

### Best Practices

#### 1. Default to Non-Null
With `@NullMarked`, everything is non-null by default. Only annotate exceptions:

```java
// Good - @Nullable only where needed
public record Author(String login, @Nullable String name) {}

// The 'login' is implicitly non-null
// The 'name' is explicitly nullable
```

#### 2. Document Nullable Parameters

```java
/**
 * Get repository information.
 * @param repoName Repository name (required)
 * @param branch Branch name (null for default branch)
 */
public RepoInfo getRepo(String repoName, @Nullable String branch);
```

#### 3. Use for Record Components

```java
public record PullRequest(
    int number,
    String title,                    // Never null
    @Nullable String body,           // May be null if not provided
    @Nullable LocalDateTime closedAt // Null if still open
) {}
```

#### 4. Use for Method Returns

```java
public interface Repository {
    // May return null if not found
    @Nullable User findByUsername(String username);

    // Never returns null (throws if not found)
    User getByUsername(String username);
}
```

#### 5. Common Nullable Patterns

| Pattern | When to Use |
|---------|-------------|
| `@Nullable` return | Optional results, "not found" scenarios |
| `@Nullable` parameter | Optional configuration, default values |
| `@Nullable` in records | Optional fields in data objects |
| `@Nullable` in collections | Avoid - use empty collection instead |

#### 6. Avoid

```java
// BAD: Nullable collections
@Nullable List<String> getItems();

// GOOD: Return empty list
List<String> getItems();  // Returns Collections.emptyList() if none
```

#### 7. JSpecify is a specification, not an enforcer — wire a checker or the annotations are prose

**JSpecify ships only annotations.** `@NullMarked`/`@Nullable` carry no checking of any kind: javac
compiles a `@NullMarked` package whose methods return null against non-null declarations without a
murmur. An unchecked `@NullMarked` is worse than none — it is a **false claim** readers and tools
will trust. (Measured in the field, 2026-07-30: a public method in a `@NullMarked` package declared
non-null and returned null on its *ordinary* code path; the annotations had been in place for weeks,
verified by nothing.)

Enforcement is a separate tool, chosen and wired deliberately:

| Layer | What it gives | Enforcement? |
|---|---|---|
| JSpecify annotations | the vocabulary (which nulls are meaningful) | **none** |
| IDE (IntelliJ) inspections | squiggles while editing | advisory only |
| **NullAway** (Error Prone plugin) | fast build-breaking consistency check | **yes — at ERROR in the build** |
| Checker Framework | sound, exhaustive analysis | yes, heavier; rarely worth it for app/library code |

**What NullAway checks — and deliberately does not.** It enforces *consistency between declaration
and use*: passing/returning null where the declaration says non-null → error; dereferencing a
`@Nullable` without a check → error. **Meaningful nulls are fully supported** — `@Nullable` *is* the
spelling for "absence is legal here", and NullAway then forces every reader to handle it. What no
nullness checker can flag: a `@Nullable` slot that is *always* null across the whole program (a
dead capability rather than an illegal null) — that is a data-flow/usage question needing a custom
Error Prone `BugChecker` or value analysis, not a nullness tool.

##### Wiring NullAway into the Maven build

Error Prone and NullAway are annotation-processor paths on `maven-compiler-plugin`, not dependencies.
This configuration is in production use (agent-workflow `workflow-spec`/`workflow-flows`, JDK 21):

```xml
<properties>
    <jspecify.version>1.0.0</jspecify.version>
    <errorprone.version>2.50.0</errorprone.version>
    <nullaway.version>0.13.8</nullaway.version>
</properties>

<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-compiler-plugin</artifactId>
    <executions>
        <execution>
            <!-- default-compile only: main sources, NOT tests (see below) -->
            <id>default-compile</id>
            <configuration>
                <compilerArgs>
                    <arg>-XDcompilePolicy=simple</arg>
                    <arg>--should-stop=ifError=FLOW</arg>
                    <!-- Required on JDK 21; without it Error Prone fails and says so -->
                    <arg>-XDaddTypeAnnotationsToSymbol=true</arg>
                    <arg>-Xplugin:ErrorProne -XepDisableAllChecks -Xep:NullAway:ERROR -XepOpt:NullAway:JSpecifyMode=true -XepOpt:NullAway:OnlyNullMarked=true</arg>
                </compilerArgs>
                <annotationProcessorPaths>
                    <path>
                        <groupId>com.google.errorprone</groupId>
                        <artifactId>error_prone_core</artifactId>
                        <version>${errorprone.version}</version>
                    </path>
                    <path>
                        <groupId>com.uber.nullaway</groupId>
                        <artifactId>nullaway</artifactId>
                        <version>${nullaway.version}</version>
                    </path>
                </annotationProcessorPaths>
            </configuration>
        </execution>
    </executions>
</plugin>
```

Error Prone needs javac internals opened. Put this in `.mvn/jvm.config` (one line per flag):

```
--add-exports jdk.compiler/com.sun.tools.javac.api=ALL-UNNAMED
--add-exports jdk.compiler/com.sun.tools.javac.file=ALL-UNNAMED
--add-exports jdk.compiler/com.sun.tools.javac.main=ALL-UNNAMED
--add-exports jdk.compiler/com.sun.tools.javac.model=ALL-UNNAMED
--add-exports jdk.compiler/com.sun.tools.javac.parser=ALL-UNNAMED
--add-exports jdk.compiler/com.sun.tools.javac.processing=ALL-UNNAMED
--add-exports jdk.compiler/com.sun.tools.javac.tree=ALL-UNNAMED
--add-exports jdk.compiler/com.sun.tools.javac.util=ALL-UNNAMED
--add-opens jdk.compiler/com.sun.tools.javac.code=ALL-UNNAMED
--add-opens jdk.compiler/com.sun.tools.javac.comp=ALL-UNNAMED
```

Four decisions in that config, each with a measured reason:

| Setting | Why |
|---|---|
| `-XepDisableAllChecks` + `-Xep:NullAway:ERROR` | This act enforces **nullness**, not lint. Stock Error Prone checks scope to a *module*, not to `@NullMarked` packages, so enabling them lands lint on legacy/parked code that was never in scope |
| `OnlyNullMarked=true` (+ `JSpecifyMode=true`) | Scopes the check to `@NullMarked` packages — adoption is per-package, not per-module |
| Bound to `default-compile` | Test sources are deliberately **unchecked**: tests sit in the same package names and inherit `@NullMarked`, and checking them reported 72 sites in one repo, essentially all one shape (a test navigating a legitimately-absent chain where the surrounding assertion is the proof and NullAway cannot see through AssertJ). Annotation churn, no defect signal |
| Never `<fork>true</fork>` | compiler-plugin 3.14.0 then swallows every diagnostic and reports a bare "Compilation failure" |

**Libraries that target Java 17.** Error Prone 2.50 needs JDK 21 to run, but many libraries still
target 17. The pattern that works (ACP Java SDK):

- **Profile.** Put the Error Prone configuration in a profile activated by `<jdk>[21,)</jdk>`, and compile
  with `maven.compiler.release=17`. A JDK 21 build is checked and still produces Java 17 bytecode. A
  JDK 17 build is unchanged.
- **CI.** Add a JDK 21 job running `./mvnw -B clean verify` next to the existing JDK 17 jobs.
- **JVM flags.** The `.mvn/jvm.config` export flags are harmless on JDK 17.

Two failure modes worth recognizing: a missing `com.sun.tools.javac.processing` export fails as an
`IllegalAccessError` rather than a missing-flag message; and on JDK 21 a missing
`-XDaddTypeAnnotationsToSymbol=true` fails inside Error Prone itself.

**Adoption is never "just config."** Turning NullAway on at ERROR over an existing `@NullMarked`
codebase surfaces every place the annotations and the code disagree (measured: 33 sites in ~20
files of well-reviewed code). Budget a triage pass — each site is one of: the **annotation** is
wrong (add `@Nullable`), the **code** is wrong (fix the bug), or a known checker blind spot
(suppress *with a written reason*). The triage list is the point: it is the diff between what the
package claims and what it does.

Two things that measurement taught, worth expecting:

- **The denominator moves as you fix.** Correcting an annotation-wrong site *reveals* what its false
  claim was masking (a subtype's accessor surfaced the moment the base stopped claiming non-null), so
  the initial count is a floor, not a total.
- **Checker-limited sites usually mean the invariant is invisible, not absent.** Every one in that
  run closed by making it *visible* — a superclass field made `final` and constructor-injected, a
  `requireX` helper returning the value so the check and the use cannot separate twenty lines apart —
  or *asserted with its reason*. Zero needed `@SuppressWarnings`. Reach for suppression last.

Three more lessons for the triage pass (ACP Java SDK, 9 real bugs on first run, including requests that
were never answered):

- **Use `clean` in multi-module builds.** An incremental `compile` does not recheck dependent modules
  after an upstream change; the final clean build found two more sites.
- **Read what the checker can't.** `AtomicReference<T>` hid two getters that returned null; NullAway
  trusts the type argument. The fix was `AtomicReference<@Nullable T>` and a `@Nullable` return.
- **The wire-record exception to "never nullable collections."** On a JSON-RPC wire, an absent list and
  an empty list are different values, so optional collection components of wire records may be
  `@Nullable`. Everywhere else, the rule holds.

**`Optional<T>` vs `@Nullable` — classify by what the caller can DO, not by position.**

> **The test: can the caller act on the absence?**
> **Yes** — there is a different, meaningful path (a fallback, a retry, a distinct result) →
> `Optional`, which forces the caller to confront it.
> **No** — absence just flows onward as absence → `@Nullable`, which documents it with no wrapper,
> no allocation, and no unwrap at the call site.

A *positional* rule ("Optional for behavioral returns, `@Nullable` for record components") is a
proxy that usually correlates and fails at the edges. Measured counterexample (2026-07-31): a
public method returning provenance had exactly **one** caller, whose value's destiny was a
`@Nullable` wire component one line later — an `Optional` would have been constructed and unwrapped
adjacently, doing documentation work while pretending to do control-flow work. `@Nullable` was
correct despite being a behavioral return.

Two rules that *are* positional and do hold: never `Optional` for parameters or fields; never
nullable collections (return empty — §4.6 above). And note **why the choice is about API reading
rather than protection**: with NullAway at ERROR, a caller who ignores a `@Nullable` return breaks
the build exactly as surely as one who ignores an `Optional`.

**Also not the answer: throwing.** If absence is the *contract's normal case* — most artifacts lack
the value, and a test asserts success without it — an exception is wrong however rare it feels. The
question to ask is not "how often?" but **"is there a recovery to write?"** When every cause is
environmental and the caller can only catch-and-ignore, the throw is a worse spelling of absence.

**Falsify before trusting.** A checker that is silent is indistinguishable from a checker that is
off. Prove it runs: plant a null into a non-null component and confirm the build goes **RED**, then
confirm the legal-absence paths stay **green**. Only then is a silence a measurement.

#### 8. Error Prone's own checks, not only NullAway

The §4.7 configuration passes `-XepDisableAllChecks`, which leaves Error Prone's own bug checks off. For
a library you own end to end, turn them on: in the ACP Java SDK they found three real bugs on the first
run: stdout of a child process decoded in the platform charset; `toLowerCase()` without a locale
breaking media-type checks on a Turkish-locale machine; and an opaque `ClassCastException` for a handler
with the wrong return type. (The §4.7 reason for disabling them, that stock checks scope to a module and
land lint on parked legacy code, still applies when adopting on such a codebase; use `-XepDisableAllChecks`
there until the legacy code is in scope.)

Configuration, inside the same `default-compile` execution as NullAway:

```xml
<failOnWarning>true</failOnWarning>
<compilerArgs>
    <arg>-XDcompilePolicy=simple</arg>
    <arg>--should-stop=ifError=FLOW</arg>
    <arg>-XDaddTypeAnnotationsToSymbol=true</arg>
    <!-- Disabled as style for this code base, each with its reason:
         StatementSwitchToExpressionSwitch: arrow or colon switch is a style choice. -->
    <arg>-Xplugin:ErrorProne -Xep:StatementSwitchToExpressionSwitch:OFF -Xep:NullAway:ERROR -XepOpt:NullAway:JSpecifyMode=true -XepOpt:NullAway:OnlyNullMarked=true</arg>
</compilerArgs>
```

- **`failOnWarning` rather than a list of checks at ERROR.** Error Prone has no "warnings as errors"
  flag, and a hand-picked list silently misses checks added in later versions. Javac's own default
  warnings also fail; deprecation and unchecked stay notes unless `-Xlint` enables them.
- **Triage each finding** the way §4.7 triages NullAway: a real bug gets a fix and a test that was red
  first; a risky pattern gets fixed; a pure style check is disabled by name with a one-line reason in
  the pom. No `@SuppressWarnings` without a written reason.
- **Reactor libraries:** `-XepOpt:CheckReturnValue:Packages=reactor.core.publisher`, so a dropped `Mono`
  or `Flux`, which never runs, is a compile error. Keep a checked-in list of results that may be
  dropped, with reasons, via `-XepOpt:CheckReturnValue:ApiExclusionList=<file>`. `subscribe(...)` and
  terminal `tryEmit*` calls belong on it; `tryEmitNext` does not, because dropping its result loses a
  message.
- **Libraries that speak a protocol over stdout:** `-Xep:SystemOut:ERROR`, because a stray print
  corrupts the stream.
- **Upgrades need a triage pass.** New default checks arrive at ERROR with each Error Prone release; say
  so in a pom comment.
- **Falsify:** plant a dropped `Mono`, an `Integer == Integer` and an unused private field; all three
  must fail the JDK 21 build.

---

## 5. Dependency Scanning (OSV standard; OWASP optional)

### Purpose
Scan dependencies for known security vulnerabilities (CVEs), including ones published *after* the last
clean scan. The gap is time: in the ACP Java SDK, seven HIGH Jackson CVEs appeared after a release's
clean scan and nothing noticed until a manual Qodana run.

### Standard: OSV-Scanner over Maven's resolved tree

OWASP Dependency-Check needs an NVD API key in practice, and on an organisation repository the
maintainer is not an admin of, a CI secret is out of reach. OSV needs no account, key or local database:
Maven resolves the tree, then OSV-Scanner checks it.

```bash
./mvnw -q -B org.cyclonedx:cyclonedx-maven-plugin:2.9.3:makeAggregateBom \
    -DoutputFormat=json -DincludeTestScope=false
cp target/*-cyclonedx.json target/bom.cdx.json
osv-scanner scan source --config osv-scanner.toml --lockfile target/bom.cdx.json   # osv-scanner 2.6.0
```

- **Don't point OSV-Scanner at `pom.xml`.** Its own resolution fails on a reactor's SNAPSHOT links
  between modules and falls back to direct dependencies only. Let Maven resolve.
- **Gate rule:** fail on CVSS 7.0 or more, or on an unscored finding, so a new advisory can't pass
  silently. List lower findings without failing.
- **Accepted findings** go in `osv-scanner.toml`. Each entry needs an `id`, a `reason` and an
  `ignoreUntil` date, after which it fails again.
- **Triggers:** weekly on a schedule, on demand, and on pushes to `main` that change a `pom.xml`.
- **Pin the scanner** by version and SHA-256, and upload SARIF to code scanning
  (`security-events: write` on the job only).
- A complete, tested script and workflow are public at `agentclientprotocol/java-sdk`:
  `.github/scripts/osv-scan.sh` and `.github/workflows/dependency-scan.yml` (commit `3a129d6`). They were
  falsified: the scan fails on Jackson 2.22.2 naming the four CVEs, and passes on 2.22.3.

> **Dependabot is blind to BOM-managed versions.** Dependabot reads `pom.xml` without running Maven. For a
> dependency whose version comes from an imported BOM (`jackson-bom`, `reactor-bom`), GitHub's dependency
> graph records **no version**, so Dependabot never alerts on it. Check:
>
> ```bash
> gh api repos/<owner>/<repo>/dependency-graph/sbom \
>   -q '.sbom.packages[]|select(.name|test("jackson-databind"))|.versionInfo'
> ```
>
> An empty result means Dependabot is blind to that library. Leave it on for directly versioned
> libraries, but don't rely on it.

Scanning many repositories on a schedule belongs to whoever watches the whole estate, not to each library.

### Optional: OWASP Dependency-Check

A local cross-check for anyone with an NVD key. Not a gate: it needs a secret.

### Maven Configuration

```xml
<plugin>
    <groupId>org.owasp</groupId>
    <artifactId>dependency-check-maven</artifactId>
    <version>12.1.0</version>
    <configuration>
        <!-- Fail on HIGH severity (CVSS >= 7.0) -->
        <failBuildOnCVSS>7.0</failBuildOnCVSS>
        <!-- Disable OSS Index to avoid rate-limiting issues -->
        <ossindexAnalyzerEnabled>false</ossindexAnalyzerEnabled>
    </configuration>
    <executions>
        <execution>
            <goals>
                <goal>check</goal>
            </goals>
        </execution>
    </executions>
</plugin>
```

### NVD API Key

Get a free API key from https://nvd.nist.gov/developers/request-an-api-key

Add to `~/.m2/settings.xml`:
```xml
<settings>
    <profiles>
        <profile>
            <id>owasp</id>
            <activation>
                <activeByDefault>true</activeByDefault>
            </activation>
            <properties>
                <nvdApiKey>YOUR_KEY_HERE</nvdApiKey>
            </properties>
        </profile>
    </profiles>
</settings>
```

Or for CI, create an org-level secret `NVD_API_KEY` and pass via:
```bash
./mvnw verify -DnvdApiKey=${{ secrets.NVD_API_KEY }}
```

### Usage

```bash
# Run vulnerability scan
./mvnw dependency-check:check

# Report at: target/dependency-check-report.html
```

### Handling Vulnerabilities

| Action | When |
|--------|------|
| **Upgrade dependency** | Fixed version available |
| **Override transitive** | Vulnerable dep is transitive |
| **Add suppression** | False positive |
| **Adjust threshold** | Acceptable risk |

**Override transitive dependency:**
```xml
<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>commons-io</groupId>
            <artifactId>commons-io</artifactId>
            <version>2.14.0</version> <!-- Fixed version -->
        </dependency>
    </dependencies>
</dependencyManagement>
```

### Pro Tip: Remove Heavy Dependencies

If a dependency brings many transitives with CVEs, consider removing it entirely:
- Example: Removed `org.kohsuke:github-api` (40+ transitives, 3 CVEs)
- Replaced with: Direct HTTP calls using Java 11 HttpClient
- Result: Zero vulnerabilities, minimal dependencies

---

## 6. Public API Javadoc

### Purpose
Document all public APIs for library consumers.

### What to Document

| Element | Documentation |
|---------|---------------|
| **Interfaces** | Purpose, usage examples, contract |
| **Records** | `@param` for each component in class Javadoc |
| **Public methods** | `@param`, `@return`, `@throws` |
| **Configuration classes** | Field meanings, defaults, valid values |

### Style rules

Sources: Oracle, [How to Write Doc Comments for the Javadoc Tool](https://www.oracle.com/technical-resources/articles/java/javadoc-tool.html)
(Java 4 era; no `{@code}`, `{@implSpec}` or `{@index}`), and Bloch, *Effective Java* 3rd ed., Item 56, which
adds those and is current. Local copies for the team: `inbox/sources/` (not committed; both are copyrighted).

**The contract, not the mechanics.** A method's comment is the contract between method and caller: say
what it does, not how, except in classes designed for inheritance. List preconditions (usually as
`@throws` for unchecked exceptions, or in the `@param`), postconditions, and side effects (a method that
starts a background thread says so). State boundary conditions, null handling, and corner cases. Document
thread-safety for every class and static method, and the serialized form of serializable classes.

**The summary (first sentence).** It becomes the summary-table entry, so it must stand alone. It is
seldom a full sentence:
- methods and constructors: a verb phrase in the third person, "Returns the number of elements in this
  collection", not "Return the number…";
- classes, interfaces, fields: a noun phrase, "An instantaneous point on the time-line";
- no two members of a class share a summary (watch overloads);
- a period followed by a space ends it early, so wrap the abbreviation: `B.S., {@literal M.S.} or Ph.D.`

**Tags.**
- Order: `@author`, `@version` (classes and interfaces), `@param`, `@return`, `@throws`, `@see`, `@since`,
  `@serial`, `@deprecated`. `@param` tags follow declaration order.
- `@param` for every parameter and type parameter (`@param <K> the type of keys`), even when obvious.
- `@return` for every non-void method. Oracle requires it even when redundant; Bloch allows omitting it
  when identical to the description. **Standard here: include it**, and say something more specific where
  you can.
- `@param` and `@return` text is a noun phrase; `@throws` text is "if" plus the condition. A phrase is
  neither capitalized nor ended with a period (Oracle; Bloch agrees on the period). Write a full sentence
  only when you need one, and then capitalize it and end it with a period.
- Document every exception a method throws, checked or unchecked.

**Markup.** Use `{@code ...}` for code (code font, and `<` and `&` need no escaping), `{@literal ...}`
for HTML metacharacters in prose, `<p>` for paragraphs, `<pre>{@code ... }</pre>` for multi-line
examples (an annotation's `@` still needs escaping). Say "this list", not "the list", for the receiver.
Link with `{@link Class#method}`. Keep source lines to 80 characters (Oracle). If source and generated
HTML readability conflict, the generated documentation wins.

**Other elements.**
- `{@implSpec}` documents the method's contract with *subclasses* (self-use patterns); ordinary text is
  the contract with callers. Needed only on classes designed for inheritance.
- Enums: document every constant. Annotation types: summary is a verb phrase saying what the annotation
  means; document members as noun phrases.
- Package comments go in `package-info.java`; module comments in `module-info.java`.
- Public classes should not rely on default constructors; there is nowhere to document them.
- `{@inheritDoc}` or inherited comments avoid repeating an interface's text, but are tricky; use
  sparingly.

**Check it.** Javadoc's doclint runs by default (Bloch, Java 8+), and Checkstyle's Javadoc checks go
further. Then read the generated HTML for every API others will use: reading it usually changes a few
comments.

*Not yet decided:* which checker is the build gate, and how it is wired. Per principle 4 it must run in
`./mvnw verify`, not only in an IDE.

### Record Documentation Pattern

```java
/**
 * Represents a GitHub issue with all relevant metadata.
 *
 * <p>This record captures the essential data from a GitHub issue including
 * its content, state, timestamps, and associated entities.
 *
 * @param number the unique issue number within the repository
 * @param title the issue title (required, never null)
 * @param body the issue body/description (may be null if not provided)
 * @param state the issue state ("OPEN" or "CLOSED")
 * @param createdAt when the issue was created
 * @param closedAt when the issue was closed (null if still open)
 */
public record Issue(
    int number,
    String title,
    @Nullable String body,
    String state,
    LocalDateTime createdAt,
    @Nullable LocalDateTime closedAt
) {}
```

---

## 7. Phase Review (API + Quality + Grammar)

### Purpose
Structured quality gate at the end of each roadmap stage during Phase 4 (Learning Loop). Combines API design review, code quality review, grammar/documentation review, and design conformance review into a single compound evaluation.

### Template
See [phase-review-template.md](../phases/phase-review-template.md) for the full parameterized prompt template and operational workflow.

### How It Works (Current)
The implementation agent generates a populated review prompt file (`plans/prompts/phaseN-review-prompt.md`). The developer copies this to a separate Claude Code session (the QA agent), which reads all listed files and returns findings. Findings are fed back to the implementation agent for resolution. The loop repeats until zero MUST FIX findings remain. See "Operational Workflow" in the template for details.

### Severity Levels

| Level | Meaning | Blocks Phase? |
|-------|---------|---------------|
| MUST FIX | Bugs, design contract violations | Yes |
| SHOULD FIX | API issues, naming, missing tests, doc errors | No (fix before next phase) |
| CONSIDER | Style, minor improvements | No (log in learnings) |

### Automation Path
As the Judge Framework matures, review sections become automated judges:
- **Deterministic**: Coverage thresholds, ArchUnit rules, unused imports → `./mvnw verify`
- **AI-based**: Naming quality, documentation clarity, design conformance → Judge implementations
- **Manual**: Compound review combining all dimensions → this template

---

## 8. Concurrency Testing

### Purpose
Catch races that a multi-core CI runner hides.

### One-CPU contention job

Run the concurrency-sensitive tests (code with locks, ordering, or pending-response maps) in a CI job
pinned to one CPU:

```yaml
contention:
  runs-on: ubuntu-latest
  steps:
    # ... checkout, JDK
    - run: taskset -c 0 ./mvnw -B -pl <module> -am test -Dtest='<ContentionTests>' -Dsurefire.failIfNoSpecifiedTests=false
```

On one CPU, races that a multi-core runner hides stay open. In the ACP Java SDK, a lock released after a
response was published wedged the next request only under `taskset -c 0`
([issue #14](https://github.com/agentclientprotocol/java-sdk/issues/14)); the repro and its fix live in
this job.

*Not yet standard:* Lincheck, which model-checks a concurrent data structure against a sequential spec,
is being proven in the ACP SDK. See "Pending" at the end of §9.

---

## 9. Qodana: a Second Tool, Never the Gate

**Rule:** the gates live in the Maven build, where every contributor runs them. Not everyone who builds
this code has Qodana, so having two tools is good: Qodana is for whoever has it, for its visualisation and
its data-flow inspections. Per principle 4, a check only some contributors can run is advice, not a gate.

- **No Docker needed.** The native `qodana-jvm` mode runs it locally.
- **Its value is triage input.** Its first ACP SDK run found seven HIGH CVEs in Jackson published after
  the last release's clean scan, and about 25 data-flow warnings. It also reported 348 coverage notes,
  which belong to the coverage gate, and a long tail of style notes. Triage by hand into the gate-backed
  work.
- **Exclude ignored trees** in `qodana.yaml`, or it reports on files that aren't the library.
- **Expect a local cache.** It writes a large type-graph cache, `.repograph/`, into the project. Add it to
  `.gitignore` or `.git/info/exclude`.
- **Cloud upload.** It uploads to qodana.cloud when a token is configured, even when the project setting
  says "run locally".

### Pending (not yet standard)

Being proven in the ACP Java SDK; add here when its evidence arrives:

- **PMD + CPD** as a `verify` gate: cognitive complexity, method/class size (NCSS), GodClass, excessive
  parameter lists, copy-paste detection. Measured need: only 8 of 853 methods exceeded cyclomatic
  complexity 10, but one 159-line method was the same block copied 18 times, one constructor took 19
  arguments, and three classes ran about 1,000 lines each. Thresholds come from the tested ruleset.
- **SpotBugs**, high-confidence and rank ≤ 9 only, aimed at concurrency patterns.
- **Lincheck** (§8) and **PIT** mutation testing (a scoped pilot on one package, profile-only threshold,
  not a build gate).

Not proposed as gates: Checkstyle (style; overlaps PMD on what matters) and Sonar (needs a server).

---

## Checklist Summary

When finishing a Java library project:

- [ ] **JaCoCo** - Code coverage reporting
- [ ] **ArchUnit** - Architecture rule enforcement
- [ ] **ArchUnit cycles** - no package cycles at any depth; per-module tests; `failOnEmptyShould=true`; each rule falsified (§2)
- [ ] **Oracle Review** - AI code smell detection
- [ ] **JSpecify** - Null safety with `@NullMarked` packages
- [ ] **NullAway at ERROR** - JSpecify has no enforcement; unchecked annotations are false claims. Budget the adoption triage (§4.7)
- [ ] **Error Prone's own checks** - `-XepDisableAllChecks` removed, `failOnWarning`, style checks disabled by name with reasons (§4.8)
- [ ] **NullAway on Java 17 targets** - JDK 21 profile with `--release 17`, plus a JDK 21 CI job (§4.7)
- [ ] **Scheduled dependency scan** - OSV over Maven's resolved tree, weekly and on pom changes; fails on HIGH or unscored (§5)
- [ ] **Concurrency** - a CI job pinned to one CPU for code with locks or ordering (§8)
- [ ] **Javadoc** - Public API documentation
- [ ] **Phase Review** - API design + code quality + grammar + design conformance review ([template](../phases/phase-review-template.md))
- [ ] **Dependency Audit** - Remove/replace heavy dependencies with CVEs

### Quick Commands

```bash
# Run tests with coverage (use ./mvnw, never bare mvn; install the wrapper if missing)
./mvnw clean test
# Coverage report: target/site/jacoco/index.html

# Run vulnerability scan (OSV; see §5 for the full script)
./mvnw -q -B org.cyclonedx:cyclonedx-maven-plugin:2.9.3:makeAggregateBom -DoutputFormat=json -DincludeTestScope=false

# Check dependency tree
./mvnw dependency:tree

# Apply formatting
./mvnw spring-javaformat:apply
```
