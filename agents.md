# Workflow

## 0. Boot
Fetch or refresh the core skills:
```bash
bash .agents/fetch-skill.sh test-driven-development obra/superpowers --refresh
bash .agents/fetch-skill.sh requesting-code-review obra/superpowers --refresh
bash .agents/fetch-skill.sh dev-engineering-super-skill get-zeked/dev-engineering-super-skill --refresh
```

Read each skill after fetching.

## 1. Assess Scope
Read the human's request and determine the scope:

- **Quick task** (bug fix, small change, < 30 min): go to step 3 directly
- **Standard task** (feature, refactor, document): brainstorm briefly, then step 2
- **Complex task** (multi-step feature, business plan, research): full brainstorm, then step 2

Tell the human which scope you assessed and confirm.

## 2. Identify and Fetch Skills (standard + complex only)

1. **Match the scenario.** Read .agents/skill-scenarios.md and find the
   scenario that best matches. Tell the human which you matched.

2. **Fetch all skills for that scenario** with `--refresh`.

3. **Check the catalog for extras.** Read .agents/skill-catalog.md. Show the
   human the full catalog and recommend any additional skills. The human
   decides what to add or remove.

4. **If domain knowledge is needed**, fetch `skill-creator` from
   anthropics/skills and build a custom project skill.

5. **Read every fetched skill immediately.** Produce a summary:

   | Skill | Key Procedure | Will Apply In |
   |---|---|---|
   | (skill name) | (main process/steps) | (which step) |

6. **Note the checkpoint criteria** from the matched scenario.

Present all to the human. Do not proceed until confirmed.

## 3. Plan

**Quick tasks:** State what you'll do, get approval.

**Standard tasks:** Write a brief plan to docs/plan.md. Get approval.

**Complex tasks:** Fetch writing-plans skill. Write a detailed chain plan
to docs/plan.md with tasks declaring skill/reads/writes/next. Get approval.

## 4. Implement

**Quick + standard tasks:** Follow the plan. Use TDD (test first, watch
fail, implement, watch pass). Work in small committed steps.

**Complex tasks (chain execution):** Act as coordinator. For each task
in the chain:
1. Read the task's `reads` summaries
2. Dispatch a subagent with ONLY the task description, assigned skill, and relevant summaries
3. Wait for completion, read the SUMMARY
4. If SUMMARY reports issues with previous work, show the human and handle
5. Proceed to next task

The coordinator does NOT do implementation work on complex tasks.

Every task (any scope) writes a SUMMARY to docs/summaries/ using the
template in .agents/skill-scenarios.md.

## Checkpoint
Before proceeding to review, run the testable checkpoint from the
matched scenario in .agents/skill-scenarios.md:

**A. Required artifacts** — verify files exist with expected content:
```
artifact: tests/test_*.py — PASS (7 test functions found)
```

**B. Required validations** — run commands, show output:
```
validation: python -m pytest tests/ -v — PASS (7 passed)
```

**C. Forbidden shortcuts** — prove they didn't happen:
```
forbidden: code before tests — PASS (git log shows test commit first)
```

For **quick tasks** without a matched scenario, verify at minimum:
- Tests pass (if applicable)
- Code review done

Present checkpoint to the human before proceeding.

## 5. Review
Review all changes against the plan and acceptance criteria.

- **Auto-fix** obvious bugs, typos, formatting immediately.
- **Human review required** for logic errors, architectural decisions,
  unclear requirements. List clearly and STOP.

If no issues: "Review passed. Ready to commit."

## 6. Commit and Push
1. Use a task branch (not main)
2. No .env files or secrets in diff
3. `git add -A`
4. Conventional commit: `<type>(<scope>): <description>`
5. Push and summarize

## Rules
- Tests before code — always
- No architectural decisions without asking
- No commit without review
- No commit directly to main
- Fetch skills, don't copy from memory
- Read every skill after fetching
