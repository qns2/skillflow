---
name: skillflow
description: Adaptive project workflow that scales from quick bug fixes to complex multi-step projects. Use this skill whenever working in a project with .agents/agents.md, or when the user mentions skillflow, project workflow, TDD workflow, chain execution, or wants structured development with skills, checkpoints, and summaries. Also use when the user says "build", "implement", "fix", or "create" in a skillflow-initialized project.
---

# Skillflow — Adaptive Project Workflow

An agentic workflow that adapts to task complexity. Quick tasks get a fast path. Complex tasks get chain execution with isolated subagents, structured summaries, and testable checkpoints.

## How It Works

Skills are fetched on demand from upstream repos (anthropics/skills, obra/superpowers, get-zeked). Each task is matched to a scenario with pre-defined skill assignments and checkpoint criteria. The workflow enforces TDD, code review, and evidence-based verification.

## Step 0: Boot

Every session starts here. Fetch or refresh the 3 core dev skills:

```bash
bash .agents/fetch-skill.sh test-driven-development obra/superpowers --refresh
bash .agents/fetch-skill.sh requesting-code-review obra/superpowers --refresh
bash .agents/fetch-skill.sh dev-engineering-super-skill get-zeked/dev-engineering-super-skill --refresh
```

Read each skill after fetching. These are always available regardless of task scope.

## Step 1: Assess Scope

Read the human's request. Categorize:

- **Quick** (bug fix, small change, < 30 min): Skip brainstorm and scenario matching. Go to step 3.
- **Standard** (feature, refactor, document): Brief brainstorm to align. Go to step 2.
- **Complex** (multi-step feature, business plan, research project): Full brainstorm with the brainstorming skill. Go to step 2.

Tell the human which scope you assessed. Confirm before proceeding.

Why this matters: a bug fix doesn't need chain execution. A business plan does. Matching intensity to task prevents both under-engineering and ceremony overhead.

## Step 2: Identify and Fetch Skills (standard + complex)

1. **Match the scenario.** Read `.agents/skill-scenarios.md`. Find the best match (Feature Development, Bug Fix, Business Plan, etc.). Tell the human.

2. **Fetch all skills for that scenario** with `--refresh`.

3. **Show the full catalog.** Read `.agents/skill-catalog.md`. Recommend extras. The human decides — you suggest, they choose.

4. **Domain knowledge gaps?** If the task needs expertise no upstream skill covers, fetch `skill-creator` from anthropics/skills and build a custom project skill.

5. **Read every fetched skill immediately.** Produce a summary table:

   | Skill | Key Procedure | Applies In |
   |---|---|---|
   | (name) | (what it requires) | (which step) |

6. **List the checkpoint criteria** from the matched scenario so the human knows what will be verified.

Present everything. Do not proceed until confirmed.

Why read immediately: skills fetched but not read get ignored. Reading produces the summary table, which creates accountability. The human sees what procedures each skill defines and can verify later that they were followed.

## Step 3: Plan

- **Quick tasks:** State what you'll do. Get verbal approval.
- **Standard tasks:** Write `docs/plan.md` with steps. Get approval.
- **Complex tasks:** Write a chain plan declaring tasks with skill/reads/writes/next:

```
Task 01 — [Name]
  skill: [skill-name] from [repo]
  reads: (none or previous summaries)
  writes: [output files], docs/summaries/SUMMARY-01.md
  next: Task 02
```

Do not implement anything until the human approves the plan.

## Step 4: Implement

### Quick + Standard Tasks
Do the work directly. Follow TDD from the test-driven-development skill:
1. Write the test
2. Watch it fail
3. Write minimal code to pass
4. Watch it pass

Write a SUMMARY to `docs/summaries/` for each task using the template in `.agents/skill-scenarios.md`.

### Complex Tasks — Chain Execution
You become a coordinator. You do NOT write implementation code.

For each task in the chain:
1. Read the task's `reads` summaries
2. Fetch the task's assigned skill (if not already fetched)
3. Dispatch a subagent with ONLY:
   - The task description
   - The assigned skill's SKILL.md content
   - The relevant SUMMARY files
   - The SUMMARY template
   - Instructions to write output AND a SUMMARY
4. Wait for completion
5. Read the SUMMARY
6. If issues reported for previous tasks → show the human → re-dispatch if approved
7. Proceed to next task

Why isolation matters: a single agent with 6 skills skips procedures because nothing prevents it. Each subagent has one skill and one job — it either follows the procedure or it doesn't. The SUMMARY is both the handoff mechanism and the forced documentation step.

### SUMMARY Format

Every task writes a SUMMARY:

```
# SUMMARY-NN

Task: [what was done]
Skill: [skill used]

Inputs used:
- [file or summary read]

Outputs created:
- [file path] — [what it contains]

Key decisions:
- [choice and why]

Constraints:
- [carried forward or discovered]

Open issues:
- [unresolved items — triggers backwards feedback if critical]

What next task needs:
- [specific context for the next agent]
```

Every "Outputs created" must be a real file. Every "Inputs used" must reference a real file. No handwaving.

## Checkpoint

Before proceeding to review, run the scenario's testable checkpoint from `.agents/skill-scenarios.md`:

**A. Required artifacts** — verify files exist with expected content:
```
artifact: tests/test_*.py — PASS (7 test functions found)
artifact: docs/summaries/SUMMARY-01.md — PASS (exists, 34 lines)
```

**B. Required validations** — run commands, show output:
```
validation: python -m pytest tests/ -v — PASS (7 passed)
validation: SUMMARY-02 contains "red" — PASS (line 8: "red phase")
```

**C. Forbidden shortcuts** — prove they didn't happen:
```
forbidden: code before tests — PASS (git log shows test commit first)
forbidden: no review summary — PASS (SUMMARY-04.md exists)
```

For quick tasks without a matched scenario, verify at minimum:
- Tests pass (if applicable)
- Code review done

Present the full checkpoint to the human. Any FAIL must be fixed or explicitly approved to skip.

Why testable: "did you follow the skill?" is self-reported and unreliable. "Does the file exist? Does the command pass? Does git log confirm the order?" is verifiable by anyone.

## Step 5: Review

Review all changes against the plan.

- **Auto-fix** obvious bugs, typos, formatting immediately.
- **Human review required** for logic errors, architectural decisions, unclear requirements. List clearly and STOP.

If clean: "Review passed. Ready to commit."

## Step 6: Commit and Push

1. Task branch (not main)
2. No .env files or secrets in diff
3. `git add -A`
4. Conventional commit: `<type>(<scope>): <description>`
5. Push and summarize

## Known Failure Modes

These are real failures observed in practice, not theoretical risks:

**Fetching skills but not reading them.** You fetch 6 skills, feel confident you know enough, and proceed without reading any of them. The skill procedures exist to add value beyond your general knowledge — a research skill requires source citations, a finance skill requires sensitivity analysis. Without reading the skill, you produce general-knowledge output that misses these specifics. Fix: read every skill immediately in step 2 and summarize what it requires.

**Self-reporting compliance.** When asked "did you follow the skills?" you say "Yes" or "Partially" without pointing to evidence. This is meaningless — you're grading your own homework. Fix: the checkpoint requires artifacts (does the file exist?), validations (does the command pass?), and forbidden shortcut checks (does git log confirm the order?). Provable, not reportable.

**Optimizing for speed over process.** You know enough to write a business plan or implement a feature without the workflow. So you skip brainstorming, skip the plan, skip TDD, skip the review, and produce something "good enough." It works until it doesn't — the charset bug, the missing citations, the untested edge case. The workflow exists because "I know enough" is the exact failure mode it prevents.

**Human in the loop is the quality driver.** The chain execution running unattended produces correct but generic output. The same workflow with the human reviewing each summary and giving corrections produces specific, refined output. Architecture doesn't replace human input — it structures it. Always pause for human review at summaries, not just at the end.

**Skills that overlap cause confusion.** When multiple skills cover the same area (finance-super-skill and research-knowledge-super-skill both have data analysis), you either follow both redundantly or pick one arbitrarily. Fix: the plan assigns one primary skill per task. Each chain task has exactly one skill — no ambiguity.

**Simple tasks don't need complex workflows.** A todo app through chain execution with 5 subagents and structured summaries produces the same result as just writing it with TDD. Match intensity to task. The scope assessment in step 1 exists for this reason — quick tasks skip the ceremony.

## Rules

- Tests before code — always
- No architectural decisions without asking
- No commit without review
- No commit directly to main
- Fetch skills, don't copy from memory
- Read every skill after fetching
- Evidence before assertions
