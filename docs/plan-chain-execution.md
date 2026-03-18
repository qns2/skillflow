# Skillflow Chain Execution — Implementation Plan

## Goal

Add sequential subagent chain execution to skillflow. Each task in a plan gets its own subagent with one assigned skill, reading only the relevant summaries from previous tasks. A thin coordinator manages the chain.

## Context

Skillflow is at https://github.com/qns2/skillflow. Key files:
- `skillflow-spec.md` — workflow spec (AGENTS.md template, steps 0-6)
- `skill-scenarios.md` — scenario mappings (which skills for which task type)
- `fetch-skill.sh` — skill fetcher with safety scanner, --refresh, --freeze/--thaw
- `skill-catalog.md` — catalog of upstream skills
- `init-project.sh` — scaffolds new projects

The problem this solves: a single agent with multiple skills skips procedures because nothing structurally prevents it. The chain forces isolation — one agent, one skill, one task.

## What to Build

### 1. Update plan format in skill-scenarios.md

Add a `## Chain Execution` section explaining the plan format. Each scenario's tasks become a declared chain:

```markdown
### Task 01 — Value Proposition
skill: brainstorming
reads: (none — first in chain)
writes: sections/01-value-prop.md, docs/summaries/SUMMARY-01.md
next: Task 02

### Task 02 — Market Analysis
skill: research-knowledge-super-skill
reads: docs/summaries/SUMMARY-01.md
writes: sections/02-market.md, docs/summaries/SUMMARY-02.md
next: Task 03
```

### 2. Update AGENTS.md step 4 (Implement)

Replace the current "follow the plan" with the coordinator pattern:

```markdown
### 4. Implement (Chain Execution)

For each task in the plan chain:
1. Read the task's `reads` summaries
2. Fetch the task's assigned skill (if not already fetched)
3. Dispatch a subagent with:
   - The task description
   - The assigned skill's SKILL.md content
   - The relevant SUMMARY files
   - Instructions to write the output AND a SUMMARY file
4. Wait for the subagent to complete
5. Read the SUMMARY file it produced
6. If the subagent reports issues with previous work:
   - Re-dispatch the relevant earlier agent with updated context
   - Re-run from that point
7. Proceed to the next task

The coordinator does NOT do implementation work. It only manages handoffs.
```

### 3. Define SUMMARY format

Each SUMMARY must contain:
```markdown
# SUMMARY-NN: [Task Name]

## What was built
(concrete outputs, file paths)

## Key decisions
(choices made, with reasoning)

## Assumptions
(anything the next task should know)

## Issues for previous tasks
(if anything needs to change in earlier work — triggers backwards feedback)

## What the next task needs
(specific context for the next agent)
```

### 4. Add chain declarations to existing scenarios

Update each scenario in skill-scenarios.md with a standard chain. For example:

**Business Plan chain:**
1. brainstorming → SUMMARY-01 (direction, positioning)
2. research-knowledge → SUMMARY-02 (market data, competitors)
3. finance → SUMMARY-03 (projections, unit economics)
4. doc-coauthoring → SUMMARY-04 (assembled document)
5. verification → SUMMARY-05 (review results)

**Feature Development chain:**
1. writing-plans → SUMMARY-01 (plan)
2. test-driven-development → SUMMARY-02 (tests written)
3. dev-engineering → SUMMARY-03 (implementation)
4. requesting-code-review → SUMMARY-04 (review results)
5. verification → SUMMARY-05 (final check)

### 5. Test it

Create a test project, run a simple feature development chain, verify:
- Each subagent gets only its assigned context
- SUMMARY files are written between tasks
- The coordinator manages handoffs correctly
- Backwards feedback works (a later agent flags an issue, earlier agent gets re-dispatched)

## Files to modify

- `skill-scenarios.md` — add chain declarations and Chain Execution section
- `skillflow-spec.md` — update step 4 in AGENTS.md template

## Files to create

- `docs/summaries/` directory (created by init-project.sh)
- SUMMARY template (in skill-scenarios.md)

## What NOT to build

- No external orchestrator — Claude Code's Agent tool is the mechanism
- No parallel execution — strictly sequential
- No new CLI tools — summaries are just markdown files
- Don't change fetch-skill.sh, skill-catalog.md, or init-project.sh (except adding docs/summaries/ to the mkdir)
