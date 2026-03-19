# skillflow

A skill repository for Claude Code sessions. 49 skills across 4 repos, fetched on demand with safety scanning.

## Install

Tell Claude Code:

> Install the skillflow skill from https://github.com/qns2/skillflow

Or manually:

```bash
gh api repos/qns2/skillflow/contents/skillflow-skill.md \
  --jq '.content' | base64 --decode > .claude/skills/skillflow.md
```

That's it. Skillflow bootstraps itself on first use.

## What it does

- Adapts workflow to task complexity — bug fixes get a fast path, complex projects get chain execution with isolated subagents
- Fetches skills on demand from 4 upstream repos (49 skills)
- TDD, code review, testable checkpoints
- Safety scans every downloaded skill
- Version pinning with `--freeze`/`--thaw`
- Structured SUMMARY handoffs between chain tasks

## Example

You say: "Build a REST API for a task management app."

1. **Boot** — fetches 3 core skills (TDD, code review, dev-engineering), reads each one
2. **Scope** — Claude says "Standard task" and confirms with you
3. **Skills** — matches "Feature Development" scenario, fetches additional skills, shows checkpoint criteria
4. **Plan** — writes `docs/plan.md`, you approve
5. **Implement** — TDD: test first, watch it fail, implement, watch it pass. Each task writes a SUMMARY.
6. **Checkpoint** — verifies: tests exist? tests pass? code committed after tests? review done?
7. **Review + Commit** — on a task branch, conventional commit

For complex tasks (business plans, multi-step features), step 5 uses chain execution — one subagent per task, each with a single skill and fresh context. Summaries pass between agents as structured handoffs.

## Skill sources

| Repo | Skills | Focus |
|---|---|---|
| [anthropics/skills](https://github.com/anthropics/skills) | 17 | Documents, design, dev tools |
| [obra/superpowers](https://github.com/obra/superpowers) | 14 | Development process, workflow |
| [get-zeked](https://github.com/get-zeked) | 10 | Cross-domain: finance, legal, marketing, sales, PM |
| [mattpocock/skills](https://github.com/mattpocock/skills) | 8 | Architecture, PRDs, refactoring, git safety |

See `skill-catalog.md` for the full list.

## Safety

Every skill is scanned before installation for network exfiltration, credential access, destructive operations, data exfiltration, safety bypass, and code injection. Tested against all 49 upstream skills with zero false positives.

**The scanner is a best-effort heuristic, not a security guarantee.** You are responsible for reviewing the skills you install.

## License

MIT
