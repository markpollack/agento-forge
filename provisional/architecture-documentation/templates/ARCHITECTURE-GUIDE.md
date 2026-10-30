# <Project> architecture

<!--
Skeleton for an architecture guide of existing code. Keep only the chapters the assessment selected,
in this order, and delete the rest including their comments. Each kept chapter names the reader
questions it answers (from the assessment record). Every statement carries an evidence label
(EVIDENCE.md). Authored diagrams: Mermaid, labelled conceptual. Generated diagrams: PlantUML source
and SVG under a generated/ directory, linked, never retyped.
-->

> Code at <repository>@<commit>. Assessment: <link to the assessment record>.
> Evidence labels used in this guide: declared design · declared policy · extracted structure · observed
> execution · executed check · static comparison · proposed. Figures drawn by hand are *conceptual*.

## 1. Purpose, context and boundaries

<!-- Always. Problem, who uses it, what it is not. Its neighbours and what crosses the boundary.
Constraints that change how the rest reads. One small picture. This chapter is the one-page layer. -->

## 2. Core concepts

<!-- When a shared model recurs across components: the domain or data model, the main lifecycle.
For a data product this is the product. A state diagram if a lifecycle is otherwise hard to follow. -->

## 3. The main flow

<!-- How input becomes output, step by step, with the governing idea (solution strategy) visible in it.
If defining a meaning and executing it are different flows, show them apart. -->

## 4. Allocation: files, processes, ownership

<!-- Only if consequential: child processes, persistence locations, which artifact is authoritative,
trust or failure isolation. Otherwise delete. -->

## 5. Module and runtime views

<!-- Module view: extracted component view with responsibilities and enforced boundaries (declared policy).
Runtime view: one observed scenario, compact overview linked to the full trace. Say which components the
runtime participants are. Concurrency only if it explains streaming, completion, cancellation or failure. -->

## 6. Worked examples

<!-- One concrete input traced end to end: source values, rule applied, stored result, provenance, check
outcome. Add the counterexample the checks reject, and say it is a deliberate negative control. -->

## 7. Contracts, verification and trust

<!-- What each boundary promises and refuses; what the checks establish and what they cannot.
If the system has a consequential quality question, answer it here with evidence. -->

## 8. Current support, limits and change

<!-- What is established at this revision, what is proposed, what is unexercised. Known risks and debt.
Where to make each common kind of change. How the generated material is regenerated and checked. -->
