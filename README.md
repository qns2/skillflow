# skillflow

Agentic skill-based project workflows made easy.

No autonomous pipelines. No Python runtime. Just markdown files Claude Code reads and follows.

---

## Quick start

```bash
mkdir my-project
cd my-project
git clone https://github.com/qns2/skillflow.git
bash skillflow/init-project.sh
claude
```

Tell Claude Code what you want to build. It handles the rest.

---

## What is in this repo

| File | Purpose |
|---|---|
| `init-project.sh` | Scaffolds a new project in the parent directory |
| `agents.md` | The adaptive workflow (quick / standard / complex) |
| `fetch-skill.sh` | Skill fetcher with safety scanner |
| `skill-catalog.md` | Categorized skill catalog |
| `skill-scenarios.md` | Standard scenario mappings with checkpoint criteria |
| `skillflow-spec.md` | Full spec and documentation |

---

## How it works

1. Clone skillflow inside your project folder
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

- https://github.com/anthropics/skills
- https://github.com/obra/superpowers
- https://github.com/get-zeked (standalone skill repos)

See `skill-catalog.md` for all available skills and `skill-scenarios.md` for standard task-to-skill mappings.

---

## Skill safety scanning

Every skill downloaded by `fetch-skill.sh` is automatically scanned before installation. The scanner checks for:

- **Network exfiltration** — `curl`/`wget`/`nc` commands targeting non-standard URLs
- **Credential access** — patterns that read or transmit `.env`, SSH keys, API keys, or secrets
- **Destructive operations** — `rm -rf` with broad paths, `shred`
- **Data exfiltration** — base64 encoding combined with network send
- **Safety bypass** — instructions to skip code reviews, disable safety checks, or use `--no-verify`
- **Code injection** — `eval`/`exec` calls

If warnings are found, the skill is still saved to disk but the scanner prints the warnings and asks you to review the content before proceeding. To remove a flagged skill: `rm -r .agents/skills/<skill-name>`.

---

## Skill versioning

Every skill install is recorded to `.agents/skills.json` with repo, SHA, and timestamp.

```bash
# Check for updates
bash .agents/fetch-skill.sh <skill-name> <repo> --refresh

# Lock current versions
bash .agents/fetch-skill.sh --freeze

# Unlock
bash .agents/fetch-skill.sh --thaw
```

---

### Disclaimer

**The safety scanner is a best-effort heuristic, not a security guarantee.** It cannot detect obfuscated payloads, indirect exfiltration, prompt injection, or novel attack patterns.

**You are responsible for reviewing the skills you install.** Only fetch skills from repos you trust.
