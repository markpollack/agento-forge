# The Second-Implementation Protocol

> How to run a cold independent implementation against your own contract so that it finds the
> assumptions everyone inside the design shares — and how to keep it from cheating.

> **Provenance**: a contract-and-authoring-surface effort, July–August 2026, where a cold second
> producer found a contract omission that five adversarial review rounds and two audits had missed.
> **Status: PROVISIONAL** — one project, two executions (a spike and a full design pass).

## What it is, and what makes it work

[Review lens 6](../concepts/review-lenses.md) is *build a minimal independent implementation against
the contract and see what a cold reader constructs differently*. This guide is the protocol for
running it.

Its power comes from one property: **the reference implementation's authors cannot find the assumptions
they share.** A gap that every insider fills identically from context is invisible to requirement
traceability, adversarial fidelity review, and schema validation alike — all of them are performed by
people who already know the answer. A second implementation is the only instrument that reliably
converts *shared assumption* into *observable divergence*.

It was prohibitively expensive when an implementation meant a team and a quarter. It is now an
afternoon, which is what makes this a routine pre-freeze gate rather than an aspiration.

## The independence discipline

The protocol is worthless if the second implementation reads the first. Four rules.

**1. The contract and published artifacts are the authority.** The specification text, the committed
schemas, the published fixtures and conformance vectors, the change ledger. That is the input set.

**2. The reference implementation's internals are off-limits on the first pass.** Not its source, not
its tests, not its internal design notes. The point of the exercise is destroyed by a single glance at
the code that answers the question.

**3. The reference's *published surface* is a parity reference, not a derivation.** Its public API
signatures, its package documentation, its committed output artifacts — a second implementation may read
these, because a real second implementer would. The line is: **what it emits and what it publicly
promises, yes; how it decides, no.** State which side of that line every claim in the writeup came from,
and cite the artifact.

**4. Every rule learnable only from the reference is a contract defect — even when the guess is right.**

This is the rule that makes the protocol pay. The temptation, when the second implementation guesses
correctly, is to record nothing. But *"a competent implementer guessed right"* and *"the contract says
so"* are different states, and only one of them survives a third implementation written by someone less
lucky. If the only statement of a rule anywhere is a method in the reference's source, the rule is
missing from the contract and the finding stands.

Worked instance: a type→schema mapping existed only as the behaviour of one public method in the
reference. Every committed artifact conformed. A second producer reading its own ecosystem's conventions
would have emitted a defensibly different schema for enumerated types, and diverged correctly by its own
lights. Classification: **contract omission**, disposed as its own act *before* the implementation pass —
because the implementation pass cannot honour a rule that is not written, and "copy the reference's
table" is exactly what rule 4 forbids.

## Classify every difference

A difference is not automatically a defect. Five classes, and the classification is the deliverable:

| Class | Meaning | Disposition |
|---|---|---|
| **Omission** | no rule exists | a contract act, before implementation continues |
| **Ambiguity** | a rule exists and admits two readings | a contract act; pick one and say why |
| **Discoverability defect** | the rule exists and is correct, but is unfindable from where a reader starts | a documentation act — cheaper, still real |
| **Bug** | one implementation violates a clear rule | fix, with the divergence as a committed fixture |
| **Intentionally permitted variation** | both are conforming; the contract does not and should not constrain this | a **register entry**, see below |

**Permitted variations need a register, not a shrug.** Each row states the variation, its **ground**
(why the difference is legitimate — usually a language or platform property the contract has no business
knowing about), and its **cost, priced** (what is lost — a symmetry, a diagnostic, a reader's
expectation). A row with no cost stated is usually a row nobody thought about.

The governing distinction, worth stating in the register's header: **the thing being kept identical is
the emitted artifact and the reachability of every construct — never keystroke parity across
languages.** Call shape is language conduct. Forcing one language's forced move onto another exports a
scar into a language without the wound.

## Byte-diffing under-reports; build the semantic layer

The obvious comparison is to diff the two implementations' output. It is necessary and it is not
sufficient — measured, twice, in one act:

- a real defect that was **byte-identical**, because the wrong value had no downstream reader;
- a real defect that emitted **more** bytes, so the diff showed it as growth rather than as a defect.

So the comparison instrument is a **semantic normal form** computed from each output, over which
equality is asserted. Each normalization is chosen for a specific divergence class it either absorbs
(a legitimate difference) or exposes (something a byte-diff misses):

| Normalization | Absorbs | Exposes |
|---|---|---|
| resolve indirections (aliases → targets) | naming derivations that differ legitimately | two aliases pointing at one target, or one alias re-pointed |
| canonicalize equivalent spellings into one representation | two wire forms of the same meaning | a call that used the wrong form |
| deduplicate and sort collections that carry no order | emission order | duplicate members carrying one condition (**more** bytes) |
| flatten precedence chains | which tier a value was declared at | a declaration at a tier that governs nothing |
| count and attribute references | — | inflated counts that change a rule while output bytes stay identical |
| strip environment-dependent provenance | file paths, line numbers, per-emitter identifiers | — (check as *shape*, separately) |

**Expect exact byte-identity to be impossible where output carries provenance**, and expect that to be
correct rather than a defect: two implementations live in different files. The oracle then splits in
two — **provenance-suppressed byte identity** (strip it, canonicalize, require equality) and
**provenance shape conformance** (check the provenance block against its rules, not against the other
implementation's values). If your contract already sanctions a provenance-suppressed comparison for
some other purpose, that instrument answers the cross-implementation question too.

## When to run it

**Before a freeze.** That is the cheapest moment a cold implementation can still move the contract;
afterwards every finding is a migration. The protocol is also worth running when a contract gains a
second consumer for the first time, and when a major new construct lands.

A **design-only pass** — deriving the second surface on paper, with the same input restrictions, and
measuring the questions in a scratchpad — is a legitimate and much cheaper form. It found the
largest finding on record. Run it first; it aims the implementation pass or retires it.

## Checklist

- [ ] Input set declared: contract + published artifacts, listed by name in the prompt
- [ ] Explicitly **not read**: the reference's internals — stated, so the reader can trust the result
- [ ] Every claim about what the reference *does* cites a published artifact or a public doc sentence
- [ ] Every rule learnable only from the reference is logged as a contract or discoverability finding —
      including the ones guessed correctly
- [ ] Differences classified into the five classes; each with a disposition
- [ ] Permitted-variation register: each row with its ground and its cost
- [ ] Comparison runs on a semantic normal form, not only a byte diff
- [ ] Provenance handled as two oracles (suppressed identity + shape conformance)
- [ ] Findings that require a contract change are disposed **before** the implementation pass

## Related

[`../concepts/review-lenses.md`](../concepts/review-lenses.md) (lens 6 — this guide's parent, and the
other eight lenses it complements) ·
[`../concepts/act-pipeline.md`](../concepts/act-pipeline.md) (restricted inputs as a general review
technique; where the resulting contract findings get ratified) ·
[`../concepts/refutation-by-counterexample.md`](../concepts/refutation-by-counterexample.md) (a
divergence is an exhibit; "we agree everywhere" is a recorded search) ·
[`authoring-surface-quality.md`](authoring-surface-quality.md) (when the second implementation is a
second authoring surface, its diagnostics get graded too).
