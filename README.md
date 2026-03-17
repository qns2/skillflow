# skillflow

Agentic skill-based project workflows made easy.

No autonomous pipelines. No Python runtime. Just markdown files Claude Code reads and follows.

---

## What is in this repo

| File | Purpose |
|---|---|
| `skillflow-spec.md` | Build spec — Claude Code reads this and builds the starter |
| `fetch-skill.sh` | Skill fetcher with safety scanner (single source of truth) |
| `skill-catalog.md` | Categorized skill catalog (single source of truth) |
| `skill-scenarios.md` | Standard scenario mappings with checkpoint criteria |
| `init-project.sh` | Script to create a new project (created by running the spec) |

---

## First time setup

Open Claude Code in this directory and say:

```
Read skillflow-spec.md and execute it.
```

Claude Code creates `init-project.sh`.

---

## Create a new project

```bash
mkdir my-project
cd my-project
bash /path/to/init-project.sh
claude
```

Tell Claude Code what you want to build. It handles the rest.

---

## Workflow every project follows

1. **Boot** — refreshes the skill catalog from upstream, fetches and updates skills
2. **Brainstorm** — shapes your idea before any code
3. **Identify and fetch skills** — auto-fetches required skills (writing-plans, TDD, code review, verification, dev-engineering), plus any task-specific ones
4. **Plan** — writes docs/plan.md, waits for your approval
5. **Implement** — follows the plan
6. **Review** — fixes obvious bugs, flags the rest for you
7. **Commit and push** — conventional commits, summary printed

---

## Skill sources

Skills are fetched on demand from:

- https://github.com/anthropics/skills
- https://github.com/obra/superpowers
- https://github.com/get-zeked (standalone skill repos)

See `skill-catalog.md` for all available skills.

---

## Skill versioning

Every skill install is recorded to `.agents/skills.json` with repo, SHA, and timestamp — giving you full visibility into what version you're running.

### Checking for updates

```bash
bash .agents/fetch-skill.sh <skill-name> <repo> --refresh
```

Compares your local SHA with upstream. Re-fetches only if changed.

### Pinning versions

When your skills work well together, freeze them:

```bash
bash .agents/fetch-skill.sh --freeze    # lock current versions
```

While frozen:
- Fetches use the exact pinned SHA — no silent drift
- `--refresh` is blocked (tells you to thaw first)
- New project members get the same skill versions

To unfreeze:

```bash
bash .agents/fetch-skill.sh --thaw      # back to floating latest
```

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

### Disclaimer

**This scanner is a best-effort heuristic, not a security guarantee.** It uses pattern matching to flag common indicators of malicious intent. It cannot detect:

- Obfuscated or encoded payloads
- Indirect exfiltration via legitimate-looking API calls
- Prompt injection techniques embedded in skill instructions
- Novel attack patterns not covered by the current rule set

**You are responsible for reviewing the skills you install.** Only fetch skills from repos you trust. The three default sources (anthropics/skills, obra/superpowers, get-zeked) are community-maintained open-source projects — review their contents and reputation before relying on them. If you add custom skill sources, vet them carefully.
