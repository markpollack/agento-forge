# Finishing Touches for Java Library Projects

This document captures the standard "finishing touches" applied to production-ready Java libraries. Use this as a checklist when polishing repositories.

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
See [phase-review-template.md](phase-review-template.md) for the full parameterized prompt template and operational workflow.

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
- [ ] **OWASP** - Dependency vulnerability scanning
- [ ] **Javadoc** - Public API documentation
- [ ] **Phase Review** - API design + code quality + grammar + design conformance review ([template](phase-review-template.md))
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
