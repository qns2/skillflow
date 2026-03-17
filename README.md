# simple-project-starter

A minimal starter for human-in-the-loop Claude Code projects.

No autonomous pipelines. No Python runtime. Just markdown files Claude Code reads and follows.

---

## What is in this repo

| File | Purpose |
|---|---|
| `simple-project-starter-spec.md` | Full spec — Claude Code reads this and builds the starter |
| `init-simple-project.sh` | Script to create a new project (created by running the spec) |

---

## First time setup

Open Claude Code in this directory and say:

```
Read simple-project-starter-spec.md and execute it.
```

Claude Code creates `init-simple-project.sh`.

---

## Create a new project

```bash
mkdir my-project
cd my-project
bash /path/to/init-simple-project.sh
claude
```

Tell Claude Code what you want to build. It handles the rest.

---

## Workflow every project follows

1. **Boot** — refreshes the skill catalog from upstream, fetches brainstorming skill
2. **Brainstorm** — shapes your idea before any code
3. **Identify and fetch skills** — pulls in skills from upstream as needed
4. **Plan** — writes docs/plan.md, waits for your approval
5. **Implement** — follows the plan
6. **Review** — fixes obvious bugs, flags the rest for you
7. **Commit and push** — conventional commits, summary printed

---

## Skill sources

Skills are fetched on demand from:

- https://github.com/anthropics/skills
- https://github.com/obra/superpowers

See the Skill Catalog in `simple-project-starter-spec.md` for all available skills.
