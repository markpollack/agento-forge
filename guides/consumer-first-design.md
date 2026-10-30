# Design from the consumer's next action

Suppose you are designing a report client. A developer wants a monthly summary, then a shorter
version of that same report. This is the program they should be able to write. The API is invented
and **proposed**; the [worked example](../examples/consumer-first-client/README.md) defines every
signature and provides a compile-only check. No report service is implemented here.

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

The client reads inputs from `reports`. A channel keeps the report history. `submit` returns a job
handle immediately; `get` waits for a result whose `text` contains the report. The program prints that
text; it does not save an output file. The first job remains open while the follow-up runs. The scopes
release jobs, then the channel, then the client.

Now consider a draft that says only “`get` returns a result.” Its implementation might publish the
result before releasing the channel for another job. The developer then needs this extra step:

```java
// Fragment inside the program above, showing the underspecified draft's workaround:
ReportClient.Result summary = first.get();
first.awaitSettlement(java.time.Duration.ofSeconds(5));
// Only now can the caller submit the ordinary follow-up.
```

The extra wait exposes a missing promise. For this client, normal return from `get` should mean that
the report and required cleanup are finished and this job no longer reserves the channel. If the
channel is healthy and open, with no competing caller, the next submission can start. Optional
progress displays may still be running. Cancellation has a different boundary: accepting a request
to stop does not prove that the work has stopped.

That promise is an **operation contract**. What becomes true on return is its **postcondition**.
Writing the program first revealed which postcondition the internal design must deliver.

## Put today's code beside the proposal

For each main consumer task, show how someone does it today beside the proposed program. Read the
existing code at a pinned repository revision and cite its source locations. Compare result meaning,
follow-up, failure and cleanup as well as method names. If the task has no existing path, say so.
Do the same for visible product flows, using the implementation that supports today's flow.

Here is an invented predecessor to the report client. Both sketches below are pseudocode; `v1`
is a fictional version label, **not evidence from an existing implementation**. In an actual design,
replace it with a repository commit and source references and supply the complete programs.
The complete proposed Java program is at the start of this guide.

**Task: create a report, then shorten it using the same history.**

| Today — invented v1 | Proposed — the report client above |
|---|---|
| Open `ReportEngine` with input directory `reports`; open its `monthly` channel. | Open `ReportClient` with input directory `reports`; open its `monthly` channel. |
| Call `channel.generate("Summarize March sales")`; print the raw text. | Submit the same request; call the job's `get()`; print `Result.text()`. |
| Call `channel.generate("Shorten that summary")`; print the raw text. | Submit the follow-up on the same channel; call `get()` and print the result. |
| Close the channel and engine on success or failure. | Close jobs, channel and client on success or failure. |

The old lower-level path makes the consumer's task possible, but suppose it returns raw output
without the required validation promised by the new client. Leaving that path public would let a
consumer bypass the new promise even if every new example compiles.

Search the pinned code for **every public way to reach that capability**, including factories,
lower-level APIs and returned handles that the proposed examples never use. Give each path a row:

| Capability | Existing public path in invented v1 | Proposed disposition and reason |
|---|---|---|
| Generate a report | `ReportEngine.open` → `openChannel` → `generate` | **Removed** from the public API; callers move to `ReportClient`. Internal engine access cannot remain a public escape from validation. |
| Generate a report | `ReportTool.generate` | **Routed through** `ReportClient` submission and `get`; validation completes before the wrapper returns text. Keep this second public way temporarily for script compatibility; remove it in the next breaking release. |
| Generate a report | `ReportShortcut.generate` | **Removed**; redundant alias with no compatibility need. Use `ReportClient`. |

A **retained** path needs an explanation of why it already cannot bypass the new contract, with
the enforcement point identified in pinned source. A **routed** path names where it will enter the
contract and obtain its guarantees. A **removed** path names the entry points and replacement or
deliberate loss. Plan checks for these decisions; a proposal does not prove the old path is gone.

Use **one public way per capability unless a reason is recorded**, as with the temporary script
wrapper above. Do not hide several ways behind a single “old type becomes new type” migration row.
This is still bounded by the capability being designed, not an inventory of unrelated libraries.

## Write the smallest useful set of examples

Start with configuration, the ordinary action, the result, the next action and cleanup. Explain
what the result means and where artifacts live. Define every helper; label proposed methods,
types and errors so a reader does not mistake them for a released API.
A complete example can be a callable function that receives a configured dependency. Say who sets
it up and owns it. You need not invent a host application, credentials or factory to give it a main method.

| Change | Useful starting point |
|---|---|
| Small option or behavior change | One complete example and a paragraph |
| Ordinary feature | Two or three examples: success with a follow-up, plus consequential failure |
| Stateful client | Three or four: normal follow-up, independent work with cancellation, and retained lifetime or timeout/closure differences |
| Product feature | A main visible flow and a failure flow, if failure changes what the user can do |

These are starting sizes, not quotas. Combine paths when they stay readable. Add an example when
it reveals a different promise, caller or resource lifetime. Keep explicit deferrals out of scope.

## Answer five questions for each significant operation

1. What operation was accepted, with which inputs and preconditions?
2. What does normal return guarantee, and what does the result mean?
3. What happens on failure or cancellation; what may still be happening?
4. What may the consumer safely do next?
5. Which resources or artifacts remain owned, and by whom?

An operation needs its own answers if it changes work, state, ownership or the next action, or has
a waiting/failure boundary. Simple accessors can share answers. Submission and result retrieval
need separate contracts. A wait timing out, a job being cancelled and cleanup finishing are different
events. Required work, such as producing a result, also differs from optional progress observation.
If startup can fail after acquiring resources, include that path. What can the caller inspect or
clean up when no usable handle was returned? State which dependencies are borrowed and which are owned.

List the complete public surface within the feature's boundary, including construction, configuration,
results and exceptions. Give full signatures with an **existing at revision** or **proposed** label.
Include existing methods the examples depend on. A proposed API remains proposed after a stub compiles.
For a large existing surface, link a pinned appendix rather than copy every definition into the main
text. Account for relevant inherited/generated members and changed or retired entry points. Keep the
boundary explicit so “complete” does not grow into a catalog of unrelated libraries.

## Choose mechanisms that keep those promises

Use platform conventions and a few closely matched precedents from research. Record what their
documentation or tests establish, which assumption differs here, and what to reuse, adapt or avoid.
Do not import a framework just because a reference uses one. Resolve routine conventions; bring the
owner focused choices where expectations conflict or a tradeoff changes the product.

Then choose state changes, resource ownership, storage and error handling. Each mechanism and binding
requirement should point to an operation's promise or a **safeguard**: a named protection against a
concrete hazard, with a reason and a check. A security check need not appear in the happy-path example,
but it still needs to say whom it protects and what would fail without it.

Use this trace in a sentence or a table:

**Consumer need → operation postcondition → mechanism → test evidence.**

For the report client: ordinary follow-up → normal `get` releases this job's channel reservation →
finish required work and release before publishing the result → block an optional observer, obtain
the result and immediately submit the next job. The last item is a **planned test** until executed.
Check both directions: important promises need checks, and every mechanism or active requirement
needs a reason. Reuse requirement IDs; withdraw untraced rules with IDs reserved instead of quietly
renumbering them. Record genuinely deferred work separately.

## Review the program and its promises together

At the existing design checkpoint, read the complete examples before earlier findings. Then read
contracts, mechanisms and checks. Ask both whether ordinary use makes sense and whether the design
can uphold it. The [consumer-code lens](../concepts/review-lenses.md#consumer-code-lens) adds this
question to the same review; it does not require another review cycle.

Try to construct a program or flow that cannot proceed as promised. If none is found, report what
was checked. Keep evidence levels clear: a stub compile checks syntax/types, source inspection
checks what code says, deterministic tests exercise selected behavior, and live checks exercise a
real integration. None silently substitutes for the others.

Before calling the design ready, check that:

- A consumer can explain the main result and the next action.
- Every main task compares pinned current code with the proposal, or states that no current path
  exists. Every existing public path has a disposition and retained paths have a non-bypass reason;
  multiple public ways to the same capability have a recorded reason.
- Ordinary use needs no internal-state knowledge or unexplained conversions or extra waits.
- Acceptance, normal return, failure/cancellation, cleanup and ownership are clear where relevant.
- The complete in-scope surface labels existing/proposed behavior, including helpers and errors.
- Important promises and safeguards have scenarios and trace. Limits and deferrals are stated;
  no unresolved question blocks implementation planning.

An earlier API-only review can have open mechanism decisions. Say what is ready for that review and
what still blocks the full design; do not use a passing compile as permission to skip those decisions.

After implementation, attach the checks that actually demonstrate the promises at a named revision.
Carry the accepted examples into user documentation, while retaining the reviewed design revision.

## A small change: one example and one paragraph

This invented command adds CSV export. The example shows the next use of the file, not just export:

```text
$ report export --format csv --output ./report.csv
Saved ./report.csv (12 rows)
$ report inspect ./report.csv
Format: CSV; rows: 12
```

The command accepts a supported format and writable destination. Normal success means the complete
file is closed and ready to read. Invalid input, failed writing or interruption returns nonzero without
replacing an existing destination. The user can inspect or share the file and owns it; the exporter
releases temporary files and handles. Write to a temporary file and replace on success; check
export→inspect and failed/interrupted writes against an existing destination. That is enough design
for this bounded change; no separate API or requirements document is needed.

## A product feature: use the visible flow

For an export screen, write: choose range and format → Export → “Ready: March.csv” → Download or
export another range. “Ready” promises a complete downloadable file. State what Failure and Stop
leave behind, what can be retried, and who retains or deletes the file. Test Download immediately
after Ready and the consequential failure paths. Show internal job states only if they help the user
make a decision. The same five questions apply without inventing an API for the design document.

## Prompt for a design session

Paste this into a session prompt, followed by the feature's scope, accepted decisions, platform
constraints and selected reference material. It works without a slash command.

```text
Design this feature from the consumer's behavior first, within the supplied scope.

Begin with the smallest set of complete programs or visible user flows that shows
configuration, ordinary success, the next action and relevant failure/cancellation/
cleanup. Explain the result and where artifacts live. One example and a paragraph
may be enough for a small change. Define helpers and label proposed syntax.
Callable examples may take configured, caller-owned dependencies; state that boundary.
Use pinned appendices for large existing surfaces, with explicit scope and changes.

Today versus proposed: for each main consumer task, put today's program or flow
beside the proposed one. Pin existing code to its repository revision and source
locations. Compare results, follow-up, failure and cleanup. State when no current
path exists; do not invent an existing implementation for a greenfield task.

Inventory every public way to reach the same capability today, including lower-level
APIs, factories and returned handles absent from the new examples. Mark each retained
(explain why it cannot bypass the new contract), routed through the contract (name
where its guarantees are enforced), or removed (name replacement or deliberate loss).
Use one public way per capability unless a reason is recorded. A single type-migration
row does not settle these paths. Record inspected scope/revision or no baseline.

List the complete in-scope public surface as existing at a named revision or
proposed. For each significant operation answer:
1. What was accepted?
2. What does normal return guarantee?
3. What happens on failure or cancellation?
4. What may the consumer safely do next?
5. What resources remain owned, and by whom?
Include partial startup failure: what can be inspected or cleaned up when no usable
handle was returned? Distinguish borrowed dependencies from owned resources.

Use platform conventions and closely matched precedents. Record their actual
guarantees, differing assumptions and the smallest reuse/adaptation. Resolve
routine conventions; bring focused choices only for material tradeoffs or
conflicting expectations. Do not import an abstraction merely because it exists.

Design the mechanisms needed to keep those promises. Trace consumer need to
operation postcondition to mechanism to test evidence. Every active requirement
and public concept needs a contract or named safeguard behind it. Reuse IDs and
withdraw untraced rules with IDs reserved. Preserve explicit deferrals.

At the existing design checkpoint, read complete examples before earlier findings
and review usability and correctness together. Construct confusing or breaking
cases; record searches that find none. Define observable verification scenarios
before code. Separate prototype compilation, source inspection, deterministic
tests and live conformance; after implementation record checks actually run.

Call the design ready only when the result/next action is clear, ordinary use
needs no internal-state knowledge or unexplained waits, relevant lifecycle and
ownership boundaries are explicit, existing/proposed surface is labelled, and
important promises have checks with unresolved limits and deferrals stated.
Check each current-versus-proposed comparison and every existing path's disposition;
retained paths need non-bypass reasons, and multiple public ways need justification.
For an intermediate checkpoint, name what is ready to review and what still blocks
the full design. Respect the session's owner checkpoints. Do not add documents or
review cycles without a concrete need, or implement merely because the design is written.
```
