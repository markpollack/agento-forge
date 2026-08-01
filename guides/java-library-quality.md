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
mvn test
# Report at: target/site/jacoco/index.html
```

### Tips
- Run `mvn test` to generate the report
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

---

## 5. OWASP Dependency-Check

### Purpose
Scan dependencies for known security vulnerabilities (CVEs).

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

### NVD API Key (Recommended)

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
mvn verify -DnvdApiKey=${{ secrets.NVD_API_KEY }}
```

### Usage

```bash
# Run vulnerability scan
mvn dependency-check:check

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
- **Deterministic**: Coverage thresholds, ArchUnit rules, unused imports → `mvn verify`
- **AI-based**: Naming quality, documentation clarity, design conformance → Judge implementations
- **Manual**: Compound review combining all dimensions → this template

---

## Checklist Summary

When finishing a Java library project:

- [ ] **JaCoCo** - Code coverage reporting
- [ ] **ArchUnit** - Architecture rule enforcement
- [ ] **Oracle Review** - AI code smell detection
- [ ] **JSpecify** - Null safety with `@NullMarked` packages
- [ ] **NullAway at ERROR** - JSpecify has no enforcement; unchecked annotations are false claims. Budget the adoption triage (§4.7)
- [ ] **OWASP** - Dependency vulnerability scanning
- [ ] **Javadoc** - Public API documentation
- [ ] **Phase Review** - API design + code quality + grammar + design conformance review ([template](../phases/phase-review-template.md))
- [ ] **Dependency Audit** - Remove/replace heavy dependencies with CVEs

### Quick Commands

```bash
# Run tests with coverage
mvn clean test
# Coverage report: target/site/jacoco/index.html

# Run vulnerability scan
mvn dependency-check:check
# Report: target/dependency-check-report.html

# Check dependency tree
mvn dependency:tree

# Apply formatting
mvn spring-javaformat:apply
```
