# Worked design: an ordinary follow-up without a second wait

A developer needs a monthly report, then a shorter version using the same report history. This
**invented, proposed** API illustrates a design technique. All custom types below belong to this
example; none is a released library. The first program should make sense before its internal design.

The client reads inputs from `reports`; the channel owns the history. A job is a handle, while
`Result.text()` is the report text. These examples print text and create no output files.
The guide's [today-versus-proposed comparison](../../guides/consumer-first-design.md#put-todays-code-beside-the-proposal)
adds an invented predecessor and inventories its public paths. Its fictional baseline illustrates
what to inspect in pinned real code; it is not implementation evidence for this proposed API.

<!-- compile: FollowUp.java -->
```java
import java.nio.file.Path;

public class FollowUp {
    public static void main(String[] args) throws Exception {
        try (ReportClient client = ReportClient.open(Path.of("reports"));
             ReportClient.Channel channel = client.openChannel("monthly")) {
            try (ReportClient.Job first = channel.submit("Summarize March sales")) {
                ReportClient.Result summary = first.get();
                System.out.println(summary.text());

                try (ReportClient.Job next = channel.submit("Shorten that summary")) {
                    System.out.println(next.get().text());
                }
            }
        }
    }
}
```

`submit` returns without waiting for the report. `get` waits. A normal result means required work
and cleanup have finished, and this job has released its reservation on the channel. If the channel
remains healthy/open and no competing caller submits or closes it, the follow-up can be accepted
immediately. Closing the old job and finishing its optional progress callbacks are not prerequisites.

## The trap in the earlier draft

Suppose the draft promised only that `get` returns report text. Publishing text before releasing
the channel would then satisfy its wording. An ordinary caller would need this workaround:

```java
// Fragment from FollowUp: workaround for the intentionally underspecified draft.
ReportClient.Result summary = first.get();
first.awaitSettlement(java.time.Duration.ofSeconds(5));
// Only then submit the follow-up.
```

The corrected contract above removes the second wait from normal use. It does not remove cleanup
reasoning: cancellation can become visible before work stops, and a caller may still need to wait
for settlement then. Here, **settlement** means the job's required processing and cleanup have ended
and its reservation was released or the channel was marked unusable. It does not mean all observers
have returned or that a failed channel is healthy.

## Independent work and targeted cancellation

Two channels have independent histories. Both jobs are submitted before waiting; cancellation targets
only the first. If completion won the race, its report is still available. Settlement waiting handles
the cancellation path without delaying the independent job's submission.

<!-- compile: CancelOne.java -->
```java
import java.nio.file.Path;
import java.time.Duration;

public class CancelOne {
    public static void main(String[] args) throws Exception {
        try (ReportClient client = ReportClient.open(Path.of("reports"));
             ReportClient.Channel monthly = client.openChannel("monthly");
             ReportClient.Channel annual = client.openChannel("annual");
             ReportClient.Job first = monthly.submit("Summarize March sales");
             ReportClient.Job second = annual.submit("Summarize annual sales")) {
            if (first.cancel()) {
                first.awaitSettlement(Duration.ofSeconds(5));
                System.out.println("First job stopped; prior effects are not undone.");
            } else {
                System.out.println(first.get().text());
            }
            System.out.println(second.get().text());
        }
    }
}
```

`cancel()` returning true means this call won cancellation, not that work already stopped. If the
settlement wait fails or times out, it does not establish safe reuse. The scopes still attempt close.
This example has one caller; a shared application must also account for other callers' cancellation.

## A wait limit is not an execution deadline

This caller stops waiting for the result after one second, then explicitly requests cancellation.
The five-second settlement wait has its own limit. Automatic close can wait again, so one second
is not an upper bound on the program's total time. Failures propagate to the caller of `main`.

<!-- compile: WaitLimit.java -->
```java
import java.nio.file.Path;
import java.time.Duration;
import java.util.concurrent.TimeoutException;

public class WaitLimit {
    public static void main(String[] args) throws Exception {
        try (ReportClient client = ReportClient.open(Path.of("reports"));
             ReportClient.Channel channel = client.openChannel("monthly");
             ReportClient.Job job = channel.submit("Summarize March sales")) {
            try {
                System.out.println(job.get(Duration.ofSeconds(1)).text());
            } catch (TimeoutException timedOut) {
                job.cancel();
                job.awaitSettlement(Duration.ofSeconds(5));
                System.out.println("Stopped waiting for the report; work has now settled.");
            }
        }
    }
}
```

## Complete proposed public surface

Scope is this small local report API, excluding inherited `Object` methods. Every custom type and
method here is **proposed**. There is no existing implementation. Constructors/helpers used by the
programs are defined below. `AutoCloseable` is used only for scopes; no reactive framework is needed.

The block is a signature-only stub. Both `open` bodies deliberately refuse execution. `Result` is an
immutable value: its constructor rejects null text; its generated accessor, equality, hash and string
representation have ordinary record behavior. There are no hidden custom exceptions or builders.

<!-- compile: ReportClient.java -->
```java
import java.nio.file.Path;
import java.time.Duration;
import java.util.Objects;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeoutException;
import java.util.function.Consumer;

public interface ReportClient extends AutoCloseable {
    static ReportClient open(Path inputDirectory) {
        throw new UnsupportedOperationException("Signature-only stub");
    }
    static ReportClient open(Path inputDirectory, Consumer<String> progress) {
        throw new UnsupportedOperationException("Signature-only stub");
    }
    Channel openChannel(String name);
    @Override void close();

    interface Channel extends AutoCloseable {
        Job submit(String instruction);
        @Override void close();
    }

    interface Job extends AutoCloseable {
        Result get() throws InterruptedException, ExecutionException;
        Result get(Duration wait) throws InterruptedException, ExecutionException, TimeoutException;
        boolean cancel();
        void awaitSettlement(Duration wait) throws InterruptedException, TimeoutException;
        @Override void close();
    }

    record Result(String text) {
        public Result {
            Objects.requireNonNull(text);
        }
    }
}
```

Common proposed rules: null inputs are rejected with `NullPointerException`; blank names/instructions,
an unreadable input directory or nonpositive wait durations with `IllegalArgumentException`. These
checks accept no work and retain no resources. Open checks the directory before returning; later read
failures are job failures. Submitting on a busy, closed or unhealthy channel, or opening a channel on
a closed client, throws `IllegalStateException` without acceptance. Channel names are descriptive;
each `openChannel` creates a distinct history, even when names match.

Optional `progress` receives best-effort strings on a separate delivery path. Events may be dropped;
a blocked or throwing observer cannot delay required processing, settlement or close. No new
delivery begins after client close starts; an already-running callback may outlive close. Application
resources used by that callback remain application-owned. The overload without it installs no observer.

## Five-question contracts

These contracts specify the intended implementation; the stub does not implement them.

| Operation | What was accepted? | Normal return guarantees | Failure / cancellation | Safe next action | Remaining ownership |
|---|---|---|---|---|---|
| `open` (both) | Validated input directory and optional observer | New open client; no job started | Common validation errors; no retained resources | Open channels | Caller owns client; input files remain caller-owned |
| `openChannel` | Name on an open client | New, empty, independent history | Common validation/closed errors | Submit its first job | Client owns channel resources; caller must close channel or client |
| `submit` | One instruction on an idle, healthy, open channel | Immediate job handle; that job reserves the channel; no result promised yet | Pre-acceptance rejection throws; post-acceptance failure is observable through `get` | Await or cancel this job; use another channel | Client/channel owns work; caller owns handle |
| `get` and `get(wait)` | Observation of this job | Same immutable successful result on every call, after required processing, cleanup and reservation release; healthy/open channel eligible for follow-up | `ExecutionException` reports failure after settlement, possibly leaving channel unusable. `CancellationException` may precede settlement. Interrupted/timed-out wait ends only this caller's wait, without cancelling work | On success, follow up subject to competing callers/close; after cancellation await settlement; after failure close channel rather than assume health | Caller keeps result independently; open scopes still need closing |
| `cancel` | Attempt to stop only this job | True iff this call wins cancellation; false if another terminal outcome/cancellation already won. No cessation guarantee | Does not undo effects or cancel another channel; later `get` throws `CancellationException` if cancelled | Wait for settlement if needed; independent jobs remain usable | Library retains cleanup duty; caller keeps handle |
| `awaitSettlement(wait)` | Bounded observation of required work and cleanup | Settlement established, including when the job failed/cancelled; not a successful result or health assertion | Timeout/interruption leaves settlement unknown and does not release ownership | Retrieve a non-cancelled result, or close; reuse requires a separate healthy-channel guarantee | No resource ownership transfer |
| `Job.close` | Release this job handle; cancel unfinished work | Settled; no effect on a healthy channel's lifetime; completed results remain readable | Waits at most five seconds; timeout/interruption throws `IllegalStateException` (interrupt flag preserved). Cleanup continues under the library's ownership | Healthy/open channel may accept follow-up after confirmed settlement; on close failure use channel/client cleanup, not assumed reuse | Library keeps unresolved cleanup; caller retains immutable result |
| `Channel.close` | Stop admissions on this channel and cancel its unfinished job | Channel work settled and channel resources released; other channels unchanged | Same five-second total bound and failure report; unresolved cleanup remains owned by library | Use other channels; this one cannot reopen | Client retains unresolved cleanup duty |
| `ReportClient.close` | Stop all admissions, cancel remaining jobs | Required work settled and owned channel/client resources released | Same five-second total bound across channels, not per channel; report incomplete cleanup, never success | Retain/use results; create a new client if needed | Caller-owned files and callback resources remain; library retains unresolved cleanup duty |
| `Result(String)` / `text()` / record value methods | Construction from non-null text, or observation of a result | Immutable value; accessors do not start work or block | Null construction rejected; no cancellation | Read/retain text after scopes close | Caller owns value; no close needed |

All close operations are idempotent after success. After an incomplete close, admissions remain
closed at that scope and another close retries the bounded wait. Cleanup uncertainty is reported;
the library cannot claim resources were released just because a deadline expired. `Job.get` remains
available after closing the handle, so close does not erase an already completed result.

No persistence/recovery, service job registry, execution deadlines, arbitrary capacity controls or
provider-success status are designed here. A normal result is successful report generation; failure
uses `ExecutionException`. A real product with non-success result values needs its own contract.

## Precedent and adaptation

Baseline: Java 21, ordinary interfaces and JDK exception types. The
[JDK Future contract](https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/util/concurrent/Future.html)
supplies familiar result waiting, timeout, interruption and cancellation concepts. This example's
`Job` does not implement `Future`; it selects a small explicit surface. Channel reusability after
normal return is an additional domain promise, not something a platform future establishes about
external resources. The five-second close bound is an illustrative design choice for this client.

## Mechanisms and checks the promises require

| Consumer need | Operation postcondition | Proposed mechanism | Planned behavioral evidence |
|---|---|---|---|
| Immediate ordinary follow-up | Normal `get` releases this job's reservation | Required processing and release happen before result publication | Block the optional observer with a latch, obtain the first result, immediately submit the follow-up on the single-owner healthy/open channel; no sleeps or internal-state polling |
| Stop only selected work | Cancellation targets one job | Per-job cancellation owner and independent channel ownership | Hold both jobs at controlled barriers, cancel one, prove the other completes |
| Distinguish stopped waiting from stopped work | Timed-out `get` does not cancel | Separate waiter deadline from job outcome | Hold work, let wait time out, release work and obtain result; separately test explicit cancel |
| Keep result after cleanup | Result is immutable and independent | Snapshot text before publication | Read and compare the result after closing job/channel/client |
| Know when cleanup is uncertain | Close cannot claim release on timeout | Bounded close report; cleanup retained by library | Hold required cleanup past the bound; assert failure, refusal of new work at closed scope, then successful close retry after releasing cleanup |
| Safeguard: two jobs must not corrupt one history | Only one accepted job per channel | Atomic admission/release | Race two submissions; exactly one accepted while independent channels admit both |

These are planned assertions, not test results. The signature-only check below establishes only that
the three programs and the guide use the declared types correctly. It supplies no report-processing,
cancellation, cleanup, concurrency or live-service evidence. The old second-wait workaround is a
specification counterexample, not an observed defect in a released library.

## Check the example syntax

With Python 3 and JDK 21 or newer, from the repository root:

```sh
python3 examples/consumer-first-client/check-syntax.py
```

The checker extracts the four named Java blocks into a temporary directory, verifies that the guide's
program matches, and compiles them with `javac --release 21`. It runs no program and leaves no build
output in the repository. The [guide](../../guides/consumer-first-design.md) explains how to apply
the method and includes a pasteable design-session prompt.
