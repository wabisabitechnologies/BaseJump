AI Codebase Engagement Guide
A reusable guide for directing AI when analyzing or working in a codebase — for use at project start or mid-progress. Goal: ground every claim in evidence, avoid hallucination, and avoid speculative over-engineering.
1. Scope & Evidence Base
No shortcuts — only use code that is recent, not older than 6 months, unless told otherwise.
Be explicit about scope — specify which repo, branch, and commit/tag to use, so "recent" isn't ambiguous.
If no repo/path is given, require a full codebase scan first — treat that scan as the evidence base before answering, instead of guessing at a likely location.
Analyse the actual code before proposing anything; don't reason from assumed conventions.
2. Verification & Transparency
Present facts based on the code — return references as footnotes.
Find support from documentation and code reference. If it can't be found, it's not acceptable as a claim.
Require it to flag assumptions — if something can't be verified from code/docs, say so explicitly rather than filling the gap.
Ask for reproducible verification — commands or tests the user can run themselves to confirm the claim, not just narrative explanation.
State confidence/uncertainty — distinguish "confirmed in code" from "inferred" or "likely based on pattern."
Version and license awareness — note the dependency/library version referenced, since behavior changes across versions.
3. Artifacts & Edits
Produce an artifact that shows proof from code, not new/invented code.
Present artifacts like a research paper — every claim cited with a file/line reference or footnote, so it's traceable to actual code and not hallucinated.
No silent edits — any proposed change must show a diff/before-after, not just a description.
4. Best Practices Without Over-Engineering
Match the solution to existing conventions first — check how similar problems are already solved elsewhere in the codebase before introducing a new pattern/library.
Justify complexity against the actual requirement — any proposed abstraction, pattern, or dependency must state the concrete problem it solves right now, not a hypothetical future need.
Surface the tradeoff, not just the choice — for nontrivial decisions, name the alternative(s) not picked and why (performance vs. readability vs. time-to-ship).
Bound the blast radius — prefer the smallest change that satisfies the requirement; flag if a "best practice" fix would touch unrelated files/modules.
Cost/time awareness — for anything adding a build step, dependency, or runtime cost, estimate the resource/time impact (bundle size, API calls, latency).
5. Handling Existing Code Smell
Assess before matching — before reusing an existing pattern, flag if it's a known code smell (duplication, tight coupling, god objects, etc.) rather than assume "existing = correct."
Tiered proposals, not a single fix — when smell is present, present at least two explicitly labeled options:
Intermediate fix — low-risk, scoped to the immediate problem, doesn't block other work.
Long-term fix — addresses the root cause, larger blast radius.
No aggressive refactors by default — unless asked, default to the intermediate option; treat the long-term one as a proposal requiring separate sign-off, not something done inline.
6. Mode: New Project vs. In-Progress Project
New project / no clear path — run the full codebase scan (Section 1) before any answer; treat it as the evidence base.
In-progress project — do not halt active work to chase every observation.
Take note of the observation (smell, risk, better approach) instead of stopping.
Present it as an option for later, clearly separated from the current task's output, with the same evidence/citation standard as any other claim.
Only interrupt current work if the observation blocks correctness or safety of the task at hand.