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
| `fetch-skill.sh` | Skill fetcher with safety scanner |
| `skill-catalog.md` | Categorized skill catalog |
| `skill-scenarios.md` | Standard scenario mappings with checkpoint criteria |
| `skillflow-spec.md` | Full spec and documentation |

---

## How it works

1. Clone skillflow inside your project folder
2. Run `init-project.sh` — it creates AGENTS.md, copies tools into `.agents/`, sets up the structure
3. Open Claude Code — it reads AGENTS.md and follows the workflow
4. Update skillflow anytime: `cd skillflow && git pull`

### Project structure after init

```
my-project/
├── skillflow/              ← this repo (gitignored)
├── AGENTS.md               ← project workflow
├── .agents/
│   ├── fetch-skill.sh      ← skill fetcher + safety scanner
│   ├── skill-catalog.md    ← available skills
│   ├── skill-scenarios.md  ← scenario mappings + checkpoints
│   └── skills/             ← fetched at runtime
├── src/
├── docs/
└── tests/
```

---

## Workflow every project follows

1. **Boot** — refreshes skill catalog, fetches brainstorming skill
2. **Brainstorm** — shapes your idea before any work
3. **Identify and fetch skills** — matches task to a scenario, fetches required skills, reads them, presents checkpoint criteria
4. **Plan** — writes docs/plan.md, waits for your approval
5. **Implement** — follows the plan
6. **Checkpoint** — self-evaluates skill compliance with evidence
7. **Review** — fixes obvious bugs, flags the rest for you
8. **Commit and push** — conventional commits, summary printed

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
