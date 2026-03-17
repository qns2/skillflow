# simple-project-starter

A minimal starter for human-in-the-loop Claude Code projects.

No autonomous pipelines. No Python runtime. Just markdown files Claude Code reads and follows.

---

## What is in this repo

| File | Purpose |
|---|---|
| `simple-project-starter-spec.md` | Full spec — Claude Code reads this and builds the starter |
| `skills/` | Skill files copied into every new project (created by running the spec) |
| `init-simple-project.sh` | Script to create a new project (created by running the spec) |

---

## First time setup

Open Claude Code in this directory and say:

```
Read simple-project-starter-spec.md and execute it.
```

Claude Code creates `skills/` and `init-simple-project.sh`.
Then commit and push.

---

## Create a new project

```bash
bash init-simple-project.sh
cd <project-name>
claude
```

Tell Claude Code what you want to build. It handles the rest.

---

## Workflow every project follows

1. **Brainstorm** — shapes your idea before any code
2. **Identify skills** — pulls in skills from upstream sources as needed
3. **Plan** — writes docs/plan.md, waits for your approval
4. **Implement** — follows the plan
5. **Review** — fixes obvious bugs, flags the rest for you
6. **Commit and push** — conventional commits, summary printed

---

## Skill sources

Skills are pulled on demand from:

- https://github.com/anthropics/skills
- https://github.com/get-zeked/perplexity-super-skills
- https://github.com/obra/superpowers
