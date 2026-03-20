# skillflow

A skill repository for Claude Code sessions. 90+ skills across 6 repos, fetched on demand with safety scanning.

## Install

Tell Claude Code:

> Install the skillflow skill from https://github.com/qns2/skillflow

Or manually:

```bash
gh api repos/qns2/skillflow/contents/skillflow-skill.md \
  --jq '.content' | base64 --decode > .claude/skills/skillflow.md
```

That's it. Skillflow bootstraps itself on first use.

---

## What it does

- Adapts workflow to task complexity — bug fixes get a fast path, complex projects get chain execution with isolated subagents
- Fetches skills on demand from 4 upstream repos (49 skills)
- TDD, code review, testable checkpoints
- Safety scans every downloaded skill
- Version pinning with `--freeze`/`--thaw`
- Structured SUMMARY handoffs between chain tasks

---

## What is in this repo

| File | Purpose |
|---|---|
| `skillflow-skill.md` | Standalone installable skill (self-bootstrapping) |
| `agents.md` | The adaptive workflow |
| `fetch-skill.sh` | Skill fetcher with safety scanner |
| `skill-catalog.md` | 49 skills from 4 upstream repos |
| `skill-scenarios.md` | 16 scenario mappings with chain declarations and checkpoints |
| `init-project.sh` | Alternative setup: scaffolds a full project |
| `skillflow-spec.md` | Full spec and documentation |

---

## Walkthrough

### Step 0: Boot

Claude fetches 3 core dev skills (TDD, code review, dev-engineering) with `--refresh`. Reads each one. Always happens, every session.

### Step 1: Assess Scope

You say what you want. Claude categorizes:

- **"Fix the login bug"** → Quick. Goes straight to step 3.
- **"Add user authentication"** → Standard. Brief brainstorm, then step 2.
- **"Build a business plan for my startup"** → Complex. Full brainstorm, then step 2.

Claude tells you the scope. You confirm.

### Step 2: Identify and Fetch Skills (standard + complex only)

Claude reads `skill-scenarios.md`, matches your task. Says: "Matched Feature Development scenario."

Fetches the scenario's skills, reads each one, shows the summary table and checkpoint criteria. Shows you the full catalog in case you want extras. You confirm.

Quick tasks skip this — the 3 core skills from boot are enough.

### Step 3: Plan

- **Quick:** "I'll write a regression test, fix the login check, verify. OK?"
- **Standard:** Writes `docs/plan.md` with steps. You approve.
- **Complex:** Writes a chain plan with task/skill/reads/writes/next. You approve.

### Step 4: Implement

- **Quick + standard:** Claude does the work directly. TDD: write test, watch it fail, implement, watch it pass. Writes a SUMMARY for each task.

- **Complex:** Claude becomes coordinator only. Dispatches one subagent per task in the chain. Each subagent gets its assigned skill + relevant summaries. Writes output + SUMMARY. Claude reads the SUMMARY, shows you any issues, dispatches the next.

### Checkpoint

Claude runs the scenario's testable checks:

```
artifact: tests/test_login.py — PASS (3 test functions)
validation: pytest tests/ -v — PASS (3 passed)
forbidden: code before tests — PASS (git log confirms)
```

For quick tasks without a scenario: just "tests pass + review done."

Shows you the results. You approve or send back.

### Step 5: Review

Auto-fixes obvious issues. Flags anything that needs your input. If clean: "Review passed."

### Step 6: Commit

Task branch, conventional commit, push, summary.

---

The same workflow handles "fix this typo" and "build a business plan" — it just takes different paths through the same steps.

---

## Scenarios

16 pre-built scenarios matching common tasks to skills with chain declarations and testable checkpoints:

**Code:** Feature Development, Bug Fix, Frontend/UI, API/Backend, MCP Server, Claude API, Large Refactor, Multi-task Execution

**Business:** Business Plan, Marketing Plan, Sales Strategy, Financial Model, Pitch Deck, Product Spec/PRD, Legal/Compliance, Content/Creative

Each scenario defines which skills to fetch, the chain execution order, and specific pass/fail checkpoint criteria. See `skill-scenarios.md` for details.

---

## Skill sources

| Repo | Skills | Focus |
|---|---|---|
| [anthropics/skills](https://github.com/anthropics/skills) | 17 | Documents, design, dev tools |
| [obra/superpowers](https://github.com/obra/superpowers) | 14 | Development process, workflow |
| [get-zeked](https://github.com/get-zeked) | 10 | Cross-domain: finance, legal, marketing, sales, PM |
| [mattpocock/skills](https://github.com/mattpocock/skills) | 8 | Architecture, PRDs, refactoring, git safety |
| [trailofbits/skills](https://github.com/trailofbits/skills) | 22 | Security: static analysis, supply chain, smart contracts, binary analysis |
| [affaan-m/everything-claude-code](https://github.com/affaan-m/everything-claude-code) | 19 | AI agent ops, deep research, video editing, context optimization |

See `skill-catalog.md` for the full list.

---

## Skill safety scanning

Every skill downloaded by `fetch-skill.sh` is automatically scanned before installation. The scanner checks for:

- **Network exfiltration** — `curl`/`wget`/`nc` commands targeting non-standard URLs
- **Credential access** — patterns that read or transmit `.env`, SSH keys, API keys, or secrets
- **Destructive operations** — `rm -rf` with broad paths, `shred`
- **Data exfiltration** — base64 encoding combined with network send
- **Safety bypass** — instructions to skip code reviews, disable safety checks, or use `--no-verify`
- **Code injection** — `eval`/`exec` calls

Tested against all upstream skills with zero false positives.

---

## Skill versioning

Every skill install is recorded to `.agents/skills.json` with repo, SHA, and timestamp.

```bash
bash .agents/fetch-skill.sh <skill-name> <repo> --refresh   # check for updates
bash .agents/fetch-skill.sh --freeze                         # lock versions
bash .agents/fetch-skill.sh --thaw                           # unlock
```

---

## Alternative setup: Full project scaffolding

If you prefer a full project structure instead of just the skill:

```bash
mkdir my-project
cd my-project
git clone https://github.com/qns2/skillflow.git
bash skillflow/init-project.sh
claude
```

This creates AGENTS.md, copies tools into `.agents/`, and sets up `src/`, `docs/`, `tests/` directories.

---

## Requirements

- [Claude Code](https://docs.anthropic.com/en/docs/agents-and-tools/claude-code/overview)
- [GitHub CLI](https://cli.github.com/) (`gh`) — for fetching skills from repos
- Python 3 — for placeholder substitution in init script

---

## Disclaimer

**The safety scanner is a best-effort heuristic, not a security guarantee.** It cannot detect obfuscated payloads, indirect exfiltration, prompt injection, or novel attack patterns.

**You are responsible for reviewing the skills you install.** Only fetch skills from repos you trust.

## License

MIT
