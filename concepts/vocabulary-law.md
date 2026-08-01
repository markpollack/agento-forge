# Vocabulary Law: one meaning per word

> Names are a contract with every future reader. The rules that keep them from quietly acquiring a
> second meaning — and the sweep that breaks them.

> **Provenance**: a contract-and-authoring-surface effort, July–August 2026, where naming produced
> findings at the same rate as logic. **Status: PROVISIONAL** — one project.

> **Two senses of "vocabulary" in this corpus, stated because this page is about exactly that problem.**
> A knowledge base's *controlled vocabulary* ([`knowledge-base-architecture.md`](knowledge-base-architecture.md))
> is a closed tag set for faceted metadata. This page is about **design vocabulary** — the words a
> project's contract, API, and documents use for its own concepts. Different referents, same word; the
> translation is this paragraph.

## The law

**One word, one meaning, within one context.** A word that names two things forces every reader to
disambiguate from surroundings, every time, forever — and one of them will get it wrong in a way that
compiles.

The corollary is the interesting half: **a word may legitimately mean different things in different
contexts, but the translation must be stated where they meet.** Contexts are real — a wire format, an
authoring surface, an operator's dashboard and a storage layer are four audiences with four
vocabularies, and forcing one word across all of them serves none of them.

Worked example. A fan-out construct's per-iteration coordinate was `unitIndex` in the wire format —
precise, because machines and operators read it and precision beats fluency there. The authoring surface
spelled the same construct `.doing(…)`, because *"for each item, doing this"* is what an author means.
Two names, one concept, two audiences, and the rule is not "pick one" — it is **coordinate vocabulary
and authoring vocabulary serve different readers, and the document that spans them says so**.

## Renames are decided by the fluency test

> **The owner misreading a name on first contact IS the finding.**

Not a data point to weigh against the name's precision. The finding. A name's job is to be understood
by someone who has not read the design document, and the first person to encounter it cold has run the
only experiment that matters. *"The word 'unit' feels foreign"* is a complete bug report.

Two consequences:

- **Precision does not outrank fluency on a surface people author against.** It outranks it in wire
  formats and logs. Know which one you are naming.
- **A name that must be explained has failed, however correct it is.** Budget the rename; it is cheaper
  now than after it ships into other people's code.

**One veto rule worth keeping:** reject a candidate name that collides with a *different* construct
being decided concurrently, even when it reads better in isolation. A name that teaches the reader the
opposite of a distinction you are simultaneously working to keep visible is worse than a bland one.

## Cross-act name seams: reserve by name

When two in-flight changes meet at a name — one act needs a word the other act is deciding the meaning
of — neither should decide the other's substance in passing.

**Reserve by name.** Act A states that the identifier is taken and what it is taken *for*, in one line,
and stops. Act B decides what it means, on its own review. The seam is recorded; the substance stays
with its owner.

The failure this prevents is subtle and common: a change reviewed for topic X quietly settles a question
belonging to topic Y, because the author needed *something* there to finish. Nobody reviews it, because
the reviewers were reading for X. See also the fix-round variant of this in
[`act-pipeline.md`](act-pipeline.md#3-the-fix-round).

## Counting occurrences is not classifying senses

> **A sweep that obeys a raw count is a defect class, not a cleanup.**

The pattern: someone notices a word appears 30 times where its counterpart appears once, concludes the
document is imbalanced, and sweeps. The sweep is wrong in both directions at once, because the 30
occurrences were never one thing:

- some are the sense the sweep intends to change,
- some are a **protected sense** — the word used correctly, in another context, meaning something else,
- and some are **inside quotations**.

**Re-spelling a word inside a quotation misquotes it.** Received evidence — a review finding, an owner's
words, an external specification — is filed verbatim and stays verbatim, whatever the house style
becomes later. A vocabulary sweep that edits quoted text has manufactured a false record, which is a
worse defect than the inconsistency it was fixing. (See
[records discipline](project-knowledge-layout.md#records-discipline-a-record-is-appended-to-never-rewritten).)

**The procedure that works:** enumerate occurrences → classify each by *sense* → decide per sense →
sweep only the classified set → leave quotations alone. If the count is large enough that classifying
is expensive, that is evidence the word is doing too much work, which is the actual finding.

## Rename mechanics that bite

Three, each observed:

- **Blanket textual sweeps clip unrelated identifiers.** A rename of `.unit(` caught an internal factory
  with a coincidentally-matching name. Cheap when the compiler catches it in seconds; not cheap when the
  match is in a string.
- **The name lives in strings no rename tool sees** — error messages, diagnostics, documentation
  examples, generated output. A refusal message advising the author to call the *old* verb name is a
  followable-advice defect introduced by a refactor. Grade the diagnostics after a rename, not just the
  code (see [`../guides/authoring-surface-quality.md`](../guides/authoring-surface-quality.md)).
- **A citation register is a vocabulary too.** Bare identifiers (`DD-21`, `§7.4`, `CD-4`) that resolve in
  two registers are the same defect in numeric clothing. The fix has the same shape: qualify at the
  boundary, and check it with a script rather than a habit.

## Related

[`act-pipeline.md`](act-pipeline.md) (where naming findings get graded, and where reserve-by-name
applies) · [`project-knowledge-layout.md`](project-knowledge-layout.md) (records discipline — quotations
and received evidence) · [`../guides/authoring-surface-quality.md`](../guides/authoring-surface-quality.md)
(a surface's verbs are its most-read vocabulary) ·
[`knowledge-base-architecture.md`](knowledge-base-architecture.md) (the *other* sense of vocabulary —
faceted metadata tags).
