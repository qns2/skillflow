# skillflow

Agentic skill-based project workflows made easy.

An adaptive workflow for [Claude Code](https://docs.anthropic.com/en/docs/agents-and-tools/claude-code/overview) that fetches skills on demand, scales from quick bug fixes to complex multi-step projects, and enforces quality through testable checkpoints.

No autonomous pipelines. No Python runtime. Just markdown files Claude Code reads and follows.

---

## Quick start

### Option A: Full project setup

```bash
mkdir my-project
cd my-project
git clone https://github.com/qns2/skillflow.git
bash skillflow/init-project.sh
claude
```

### Option B: Standalone skill

Install `skillflow-skill.md` as a Claude Code skill. It bootstraps itself on first run — no clone needed.

---

## What is skillflow?

A workflow that makes Claude Code follow structured development practices. It fetches skills from three upstream repos, matches your task to a scenario with pre-defined skill assignments, and verifies work through testable checkpoints.

**Skills** are markdown instruction files that give Claude domain-specific expertise — TDD, code review, financial modeling, market research, document writing, and more. Skillflow orchestrates which skills to use and when.

---

## What is in this repo

| File | Purpose |
|---|---|
| `init-project.sh` | Scaffolds a new project |
| `skillflow-skill.md` | Standalone installable skill (self-bootstrapping) |
| `agents.md` | The adaptive workflow |
| `fetch-skill.sh` | Skill fetcher with safety scanner |
| `skill-catalog.md` | 40+ skills from 3 upstream repos |
| `skill-scenarios.md` | 16 scenario mappings with chain declarations and checkpoints |
| `skillflow-spec.md` | Full spec and documentation |

---

## How it works

1. Clone skillflow inside your project folder (or install the standalone skill)
2. Run `init-project.sh` — creates AGENTS.md, copies tools into `.agents/`
3. Open Claude Code — it reads AGENTS.md and follows the workflow
4. Update skillflow anytime: `cd skillflow && git pull`

### Project structure after init

```
my-project/
├── skillflow/              ← this repo (gitignored)
├── AGENTS.md               ← points to .agents/agents.md
├── .agents/
│   ├── agents.md           ← the workflow
│   ├── fetch-skill.sh      ← skill fetcher + safety scanner
│   ├── skill-catalog.md    ← available skills
│   ├── skill-scenarios.md  ← scenario mappings + checkpoints
│   └── skills/             ← fetched at runtime
├── src/
├── docs/
│   └── summaries/          ← chain execution summaries
└── tests/
```

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

## Skill sources

Skills are fetched on demand from:

- [anthropics/skills](https://github.com/anthropics/skills) — documents, design, development tools (17 skills)
- [obra/superpowers](https://github.com/obra/superpowers) — development process, workflow (14 skills)
- [get-zeked](https://github.com/get-zeked) — cross-domain super-skills: dev, marketing, sales, finance, legal, PM, ops, research, content (10 skills)

See `skill-catalog.md` for the full catalog and `skill-scenarios.md` for task-to-skill mappings.

---

## Scenarios

16 pre-built scenarios matching common tasks to skills with chain declarations and testable checkpoints:

**Code:** Feature Development, Bug Fix, Frontend/UI, API/Backend, MCP Server, Claude API, Large Refactor, Multi-task Execution

**Business:** Business Plan, Marketing Plan, Sales Strategy, Financial Model, Pitch Deck, Product Spec/PRD, Legal/Compliance, Content/Creative

Each scenario defines which skills to fetch, the chain execution order, and specific pass/fail checkpoint criteria.

---

## Safety scanning

Every skill downloaded by `fetch-skill.sh` is automatically scanned before installation:

- **Network exfiltration** — `curl`/`wget`/`nc` targeting non-standard URLs
- **Credential access** — reading/transmitting `.env`, SSH keys, API keys
- **Destructive operations** — `rm -rf` with broad paths
- **Data exfiltration** — base64 encoding + network send
- **Safety bypass** — instructions to skip reviews or use `--no-verify`
- **Code injection** — `eval`/`exec` calls

Tested against all 32 upstream skills with zero false positives.

---

## Skill versioning

Every install is recorded to `.agents/skills.json` with repo, SHA, and timestamp.

```bash
bash .agents/fetch-skill.sh <skill-name> <repo> --refresh   # check for updates
bash .agents/fetch-skill.sh --freeze                         # lock versions
bash .agents/fetch-skill.sh --thaw                           # unlock
```

---

## Requirements

- [Claude Code](https://docs.anthropic.com/en/docs/agents-and-tools/claude-code/overview)
- [GitHub CLI](https://cli.github.com/) (`gh`) — for fetching skills from repos
- Python 3 — for placeholder substitution in init script

---

## Disclaimer

**The safety scanner is a best-effort heuristic, not a security guarantee.** It cannot detect obfuscated payloads, indirect exfiltration, prompt injection, or novel attack patterns.

**You are responsible for reviewing the skills you install.** Only fetch skills from repos you trust. The default sources (anthropics/skills, obra/superpowers, get-zeked) are community-maintained open-source projects.

---

## License

MIT
