---
name: research-draft-stress-test
description: Use when turning raw notes into a blog post, research paper, or technical write-up, or stress-testing a draft before publishing or submitting. Four passes - extract the strongest arguments, attack them as a hostile expert reader, steelman the weakest, then make the single highest-leverage revision and loop.
---

# Research draft stress test

Four passes, in order. Each pass feeds the next. The author does the thinking and writing; the model surfaces arguments, objections, and gaps.

## Inputs
- Raw notes, data, or a draft.
- The field and intended audience (e.g. "Intune admins", "PhD committee in HCI").
- The deadline, if any.

## Pass 1: Extract the strongest arguments
Prompt:
> You are a research methodology expert. Here are my raw notes. Identify the 3 strongest arguments buried in this material, rank them by originality, and show exactly where each one challenges or extends existing work. Cite the specific note or data point each argument rests on.

Check: every argument maps to something actually in the notes. Drop any that don't. Verify each "existing work" claim against a real source; the model will invent citations.

## Pass 2: Hostile peer review
Prompt:
> Simulate a hostile peer reviewer with deep expertise in this field. List every serious objection they would raise against my thesis. Then sort them: objections with merit, and objections I can refute, with the refutation.

Check: for each objection with merit, decide fix, concede, or scope out. Write that decision down.

## Pass 3: Steelman the weakest argument
Prompt:
> Take my weakest argument and steelman it harder than I did. Show what it would look like if it were airtight. Then list exactly what I would need to prove or cite to get it there.

Check: either gather that evidence or cut the argument. Don't keep it on vibes.

## Pass 4: Highest-leverage revision
Prompt:
> You are my advisor. I have <time left> before submission. Read this draft and name the single change that would most improve it. Be brutal and specific.

Make that change, then rerun Pass 2 against the new draft. Repeat until the remaining objections are ones you've consciously accepted. Usually 2-3 loops.

## Blog / technical post variant
Use when the deliverable is a practitioner blog post (e.g. PowerShell, endpoint management, DevOps field notes).
- Pass 1: rank takeaways by how much time or pain they save the reader, not academic originality. Pick one as the post's lead.
- Pass 2: the hostile reviewer is a senior practitioner who has run this in production. Ask for objections on correctness of commands and scripts, version or licensing assumptions, edge cases at scale, security or permission scope, and "the docs already say this".
- Pass 3: steelman the weakest takeaway with a reproducible test: exact environment, command, and observed output. If you can't reproduce it, cut it or label it untested.
- Pass 4: ask for the single change that most improves usefulness for a reader skimming on the job (usually: lead with the fix, tighten the title, or add the missing verification step).
- Before publishing: run every code block yourself, link primary docs for each claim, and state untested gaps plainly. Apply any house style skill after this loop.

## Rules
- Keep the notes and each pass's output. They are the evidence of your own process if authorship is questioned.
- Facts, numbers, and citations come from sources you opened, never from the model.
- Follow the venue's AI-use policy and disclose use where it's required.
- Stop when the conclusion survives every objection you still consider valid, not when the model runs out of criticism.

## Output
- Final draft.
- A short log: chosen arguments, objections and how each was handled, the revisions made.
