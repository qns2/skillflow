# Lite Workflow

Simple, fast workflow for daily development. Three skills, no ceremony.

## 0. Boot
Fetch or refresh the three required skills:
```bash
bash .agents/fetch-skill.sh test-driven-development obra/superpowers --refresh
bash .agents/fetch-skill.sh requesting-code-review obra/superpowers --refresh
bash .agents/fetch-skill.sh dev-engineering-super-skill get-zeked/dev-engineering-super-skill --refresh
```

Read each skill after fetching.

## 1. Brainstorm (if needed)
For small/clear tasks, skip this step.
For anything ambiguous, ask one clarifying question at a time before starting.

## 2. Plan
For tasks longer than 30 minutes, write a brief plan to docs/plan.md.
For quick fixes, state what you'll do and get approval.

## 3. Implement
Follow TDD: write test → watch it fail → implement → watch it pass.
Refer to dev-engineering-super-skill for code quality patterns.

## 4. Review
Dispatch a code review subagent (requesting-code-review skill).
Fix auto-fix issues. Flag human-review issues and stop.

## 5. Commit
- Use a task branch (not main)
- Conventional commit message
- Push and summarize

## Rules
- Tests before code — always
- No architectural decisions without asking
- No commit without review
