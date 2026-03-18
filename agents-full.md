# Full Workflow

Comprehensive workflow with chain execution, scenario matching,
structured summaries, and testable checkpoints.

## 0. Boot
Before doing anything else:

1. **Refresh the Skill Catalog.** Run:
   ```bash
   gh api repos/anthropics/skills/git/trees/HEAD:skills --jq '.tree[].path' 2>/dev/null
   gh api repos/obra/superpowers/git/trees/HEAD:skills --jq '.tree[].path' 2>/dev/null
   ```
   Compare the output with .agents/skill-catalog.md. If new skills
   appear that are not in the catalog, add them. If listed skills are gone,
   remove them. Tell the human what changed (if anything).

2. **Fetch or refresh the brainstorming skill.** Run:
   ```bash
   bash .agents/fetch-skill.sh brainstorming obra/superpowers --refresh
   ```

Do not proceed until both steps are complete.

## 1. Brainstorm
Read .agents/skills/brainstorming/SKILL.md and run it.
Do not write any code until brainstorm is complete and the human approves
the direction.

## 2. Identify and fetch skills

1. **Match the scenario.** Read .agents/skill-scenarios.md and find the
   standard scenario that best matches this task (e.g. "Feature Development",
   "Business Plan", "Bug Fix"). Tell the human which scenario you matched.

2. **Fetch all skills listed for that scenario.** Use `--refresh` on each:
   ```bash
   bash .agents/fetch-skill.sh <skill-name> <repo-slug> --refresh
   ```

3. **Check the catalog for extras.** Read .agents/skill-catalog.md. Show the
   human the full catalog and recommend any additional skills. The human
   decides what to add or remove.

4. **If domain knowledge is needed** that no upstream skill covers, fetch
   `skill-creator` from anthropics/skills and build a custom project skill.
   See the "Creating Custom Project Skills" section in skill-scenarios.md.

5. **Read every fetched skill immediately.** For each skill, read its
   SKILL.md and produce this summary:

   | Skill | Key Procedure | Will Apply In |
   |---|---|---|
   | (skill name) | (main process/steps the skill defines) | (which workflow step) |

6. **Note the checkpoint criteria.** The matched scenario in
   skill-scenarios.md defines specific pass/fail checkpoint items.
   List them so the human knows what will be verified after implementation.

Present all of the above to the human. Do not proceed until confirmed.

## 3. Plan
Fetch the planning skill if not already present:
```bash
bash .agents/fetch-skill.sh writing-plans obra/superpowers
```

Read .agents/skills/writing-plans/SKILL.md.
Produce a written plan in docs/plan.md before touching any code.
Wait for human approval before proceeding.

## 4. Implement (Chain Execution)

The plan declares tasks as a chain. Each task specifies a skill, what
summaries it reads, and what it writes. Execute as a coordinator:

For each task in the chain:
1. Read the task's `reads` summaries (if any)
2. Fetch the task's assigned skill (if not already fetched)
3. Dispatch a subagent with ONLY:
   - The task description from the plan
   - The assigned skill's SKILL.md content
   - The relevant SUMMARY files listed in `reads`
   - The SUMMARY template (see .agents/skill-scenarios.md)
   - Instructions to write the output files AND a SUMMARY file
4. Wait for the subagent to complete
5. Read the SUMMARY file it produced
6. If the SUMMARY reports issues with previous work:
   - Show the issues to the human
   - If approved, re-dispatch the relevant earlier agent with the feedback
   - Re-run the chain from that point
7. Proceed to the next task

Rules:
- The coordinator does NOT do implementation work — only manages handoffs
- Each subagent gets fresh context — no session history
- If a task is trivial (< 1 minute of work), the coordinator may do it
  inline instead of dispatching, but must still write the SUMMARY

## Checkpoint: Skill Compliance
Before proceeding to review, run the scenario's testable checkpoint
from .agents/skill-scenarios.md:

**A. Required artifacts** — verify each file exists and contains
what it should:
```
artifact: tests/test_*.py — PASS (7 test functions found)
artifact: docs/summaries/SUMMARY-01.md — PASS (exists, 34 lines)
```

**B. Required validations** — run each command, show output:
```
validation: python -m pytest tests/ -v — PASS (7 passed)
validation: SUMMARY-02 contains "red" — PASS (line 8: "red phase")
```

**C. Forbidden shortcuts** — check each, prove it didn't happen:
```
forbidden: code before tests — PASS (git log shows test commit first)
forbidden: no review summary — PASS (SUMMARY-04.md exists)
```

Rules:
- Every check must show concrete evidence (file path, line number,
  command output) — not just "I did it"
- Any FAIL must be fixed or explicitly approved by the human to skip
- If more than half the checks fail, go back to step 4

Present the full checkpoint to the human before proceeding to review.

## 5. Review
Review all changed code against docs/plan.md and acceptance criteria.

Categorize every issue found:
- **Auto-fix** — obvious bugs, typos, formatting, missing imports.
  Fix these immediately without asking.
- **Human review required** — logic errors, architectural decisions,
  unclear requirements, anything with more than one reasonable solution.
  List these clearly and STOP.

Fix all auto-fix issues. If human-review issues exist, print a numbered
list and stop. If no issues remain, print "Review passed. Ready to commit."

## 6. Commit and push
1. Verify the current branch is NOT main. If on main, create a task branch first.
2. Run a final check — no .env files staged, no secrets in diff.
3. Stage all changed files: `git add -A`
4. Write a Conventional Commits message: `<type>(<scope>): <description>`
5. Commit and push: `git commit -m "<message>" && git push origin HEAD`
6. Print summary: branch, commit message, files changed, next action.

## Rules

- Never commit directly to main during active work — use a task branch
- Never push without running the review step first
- Never make architectural decisions without asking first
- Always write docs/plan.md before writing code
- Keep .agents/skills/ in sync — if you use a skill, it must be fetched
- Never copy skill content from memory — always fetch from the repos
- When fetching skills, always specify the repo slug (e.g. obra/superpowers)

## Done criteria

A task is done when:
- All planned features are implemented
- Review passes with no unresolved issues
- Changes are committed and pushed
- docs/plan.md reflects what was actually built
