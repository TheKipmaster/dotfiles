---
name: seed
description: Capture a concept surfaced during project work into the Zettelkasten inbox at ~/Zettelkasten/Seeds/_inbox.md. Use the moment a concept worth studying later comes up mid-task, so the capture costs the work nothing.
---

Captures are written **in flow**. You are mid-task, a concept surfaced, and the capture must not derail what you were doing. This is the one step in the pipeline that needs live session context — the insight in our own words, plus the trigger that produced it. Placement, deduping, and linking are not your job: a cold `librarian` subagent drains the inbox later and does all of that.

## Capture bar

Capture a concept when it is **named** — it has a term that could be looked up — and it was **load-bearing** in what just happened: it explained a bug, decided a design, or named the pattern in front of us. A term that merely passed through the conversation is not a capture.

If the vault likely covers it already, capture anyway when the angle is new. The librarian dedups and merges contexts; a duplicate capture is cheap and a lost insight is not.

## Write the entry

One bullet, three parts:

- **Insight** — the takeaway in our own words, not the textbook definition. What is now true about this concept that was not obvious ten minutes ago?
- **Context** — the project and the trigger: what were we doing when it surfaced?
- **Links** — a bare `[[Concept]]` for the concept itself, so it enters the graph as a frontier node immediately, plus `Relates to [[X]]` for any Seed already known to exist.

## Append it

```bash
obsidian append file=_inbox content="\n- $(date +%F) — Concept: [[X]] — insight. Context: ..."
```

The leading `\n` is what separates this entry from the previous one, and the CLI expands it inside `content=`. Append plainly, with no flags: the `inline` flag strips that newline and welds the entry onto the tail of whatever line came last.

`_inbox` has exactly **one blind appender** — capturing agents — and one section, which is what makes a plain append impossible to land wrong. Keep it that way: the librarian's processing log belongs in `_drained`.

If the CLI answers `unable to find Obsidian`, the app is closed. Append with `Edit` instead and mention it.

## Done when

The entry reads back as its own bullet under `## Pending` — confirm with `obsidian read path=Seeds/_inbox.md` once, then pick the task back up.
