# Evidence: what backs each statement

## Labels

Every statement in the guide carries one label, in the text or in the caption of the figure it belongs
to. They are documentation labels, not a schema.

| Label | Meaning | Typical source |
|---|---|---|
| **declared design** | What the code is meant to do | Class documentation, requirements, contracts, design documents |
| **declared policy** | A rule the build enforces | Architecture tests, static-analysis and coverage gates |
| **extracted structure** | References that exist in the compiled code | A generated component view, dependency extraction |
| **observed execution** | Calls recorded while one named scenario ran | A scoped execution recording |
| **executed check** | A committed input judged by the build's checks, with the outcome quoted | Tests, conformance reports |
| **static comparison** | An artifact compared by hand or script, not by an executed test | A manually verified trail |
| **proposed** | Meaning or design awaiting approval, whether reviewed yet or not | Draft specs, open design items, unapproved catalogue entries |

In [specification mode](SPEC-MODE.md), approved intent is **declared design**; unapproved choices
are **proposed**. A rendered diagram establishes the proposal as written, not executable behaviour.
Preserve that before document and write the after evidence separately. Labels may cover a coherent
paragraph or table; split passages whose evidence differs.

Figures add one more: **conceptual**, for a diagram drawn by hand to explain an idea. A conceptual figure
must never look like, or be described as, a tool-extracted graph.

## Choose the claim before the tool

| Claim | Authoritative input | Can establish | Cannot establish |
|---|---|---|---|
| Component membership | Reviewed matching rules over compiled classes | Which inspected classes belong to which declared component | That the grouping is a good design |
| Actual static dependency | Imported bytecode | A reference exists in the analyzed population | That the path executed |
| Permitted dependency | A maintained rule or allowed-edge model | Intended policy | That every permitted edge exists |
| Observed sequence | A recording of a named scenario | What happened in that scenario within the instrumentation scope | Other inputs, other branches, uninstrumented code |
| Potential call relationship | A named static analysis | Possible relationships under its assumptions | Order, frequency or actual dispatch |
| Transformation | A fixture, the executed code and its stored output | What happened to that input | That the rule applied was the right one |
| Expected transformation | An independently authored, source-grounded example | The interpretation implementations are checked against | Anything, if it was produced by copying the implementation's output |
| Design intent | A recorded human decision and its rationale | Why, within that record's scope | History recovered from code shape |
| Support or readiness | Exact claims, exercised populations, check outcomes at a revision | Support at that revision and scope | Universal support or approval; a green build is neither |

Generated relationships must trace to an analyzed element, a declared rule or a recorded event. Labels
and grouping may be curated, with the mapping kept explicit and reviewable.

## Rules learned in the first application

Each of these cost time in the Agent Journal work before it became a rule.

**Organization**
1. **System explanation first.** Never open the guide with a work plan, an assessment or a release
   decision. Journal's long-form guide once put eleven pages of assessment before its architecture and
   readers lost the system.
2. **Rewrite the backbone; do not prepend.** When an earlier guide exists, extend its structure. A second
   introduction in front of the first leaves the reader with competing openings.
3. **Separate why it is so from what happens.** Defining or reviewing a meaning and executing it are two
   flows. A call trace cannot show why a definition was chosen; a design narrative cannot show which
   branch a run took.
4. **One worked example end to end.** Follow one concrete input through every stage to its stored value
   and its check. Keep large population counts out of the algorithm's explanation; they belong with the
   verification results.
5. **Explain deliberate test corruptions.** When the guide shows tests that inject a wrong value or delete
   a result, say they are negative controls the checker must reject, or readers take them for steps of
   the algorithm.
6. **Dated evidence stays dated.** Class counts, test counts and line numbers are facts about one revision,
   not invariants. State the revision beside them.

**Evidence**
7. **Separate code is not separate understanding.** An independent checker proves the implementation
   matches the agreed meaning, never that the meaning is right. Journal's writer and checker shared one
   misreading of a vendor field, and every comparison passed. Only a review that went back to the native
   records and the schema's definitions caught it.
8. **Allowed and actual edges stay distinct.** Generating a diagram from the code and then checking the
   same code against it is not conformance.
9. **Every rule proves it can fail.** Assert that its selection is non-empty, and keep a negative control
   that the rule rejects. A misnamed package otherwise yields a vacuous pass.
10. **Tool identifiers are not evidence of order.** AppMap event ids repeated across threads; an
    interleaving claim built on them was withdrawn. Use what the recording states directly: receiver
    object identity, return values, nesting within a thread.
11. **A rendered image is not provenance.** Keep the textual diagram source and the machine-readable
    facts beside every rendered figure.

**Tools and presentation**
12. **Scope a recorder before its first run.** An unscoped recording of one test produced 666 MB; entry
    methods of the packages that matter produced about 100 KB.
13. **Calibrate a linter on real output.** Run its defaults against the generated diagrams, keep each rule
    unless it misreads legitimate output, and write down why each departure exists.
14. **Overview and detail are different artifacts.** Fold within-component calls into a compact overview
    drawn from the same recording and grouping; link the full trace rather than shrinking it.
15. **Render and read every page.** Syntax checks, lint and link checks passing does not mean the reader
    can read it. Look at each figure at reading size.
16. **Concurrency belongs in a view only when it explains something**: streaming, completion,
    cancellation or failure.

**Review and publication**
17. **One cold reviewer, findings reproduced.** A reviewer who did not author the guide; each material
    finding reproduced against the source before it changes anything; non-findings recorded as searches.
18. **Public stands alone.** Public documentation must be readable without private material, and its
    links must resolve publicly. Keep the project README a short landing page (purpose, use, build,
    link to the documentation site); architecture lives in its own place.
