# simple-project-starter — Build Spec v3

## Execution Preamble

Read this entire specification before creating or modifying any files.

Rules for the coding agent executing this spec:

1. Build directly into the current directory. Do not create a subdirectory.
2. Keep it simple. No Python runtime, no hooks, no dependency management.
3. When done, verify all files exist as listed in Validation Criteria.
4. After validation, ask the human: "Ready. What would you like to build? Give me your project name and a short description."

## Build Instructions

Build the following in this order:

1. `init-simple-project.sh` — content is in the Init Script section below, make it executable
2. Verify all files in Validation Criteria exist and are non-empty
3. Ask the human for a project name and description to create a new project

The repo also contains two files used by `init-simple-project.sh` at runtime:
- `fetch-skill.sh` — the skill fetcher with safety scanner (single source of truth)
- `skill-catalog.md` — the categorized skill catalog (single source of truth)

These files are copied into every new project by the init script.
Do not duplicate their content — the init script reads them directly.

---

## What This Is

A minimal project starter for human-in-the-loop Claude Code workflows.

No autonomous pipelines. No Python runtime machinery. Just:
- An AGENTS.md that defines the workflow
- Skills fetched on demand from upstream repos
- A skill catalog so Claude Code knows what is available
- A safety scanner that checks every downloaded skill

The entire runtime is Claude Code reading markdown files and following them.

---

## Folder Structure

What the init script creates inside a new project:

```
my-project/
├── AGENTS.md
├── README.md
├── .gitignore
├── .agents/
│   ├── fetch-skill.sh        ← copied from repo, fetches skills with safety scan
│   ├── skill-catalog.md      ← copied from repo, refreshed on boot
│   └── skills/               ← empty at init, populated at runtime
├── src/
├── docs/
└── tests/
```

---

## AGENTS.md

The AGENTS.md is the heart of the starter. Claude Code reads it first
on every session. It must explain the workflow, the rules, and when to
stop and ask.

```markdown
# AGENTS.md

## What this repo is
{{PROJECT_DESCRIPTION}}

## Workflow

Every task follows this sequence. Do not skip steps.

### 0. Boot
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
   This installs the skill if missing, or checks for upstream updates if already installed.

Do not proceed until both steps are complete.

### 1. Brainstorm
Read .agents/skills/brainstorming/SKILL.md and run it.
Do not write any code until brainstorm is complete and the human approves
the direction.

### 2. Identify and fetch skills
First, auto-fetch the required skills for any code task:

```bash
bash .agents/fetch-skill.sh writing-plans obra/superpowers --refresh
bash .agents/fetch-skill.sh test-driven-development obra/superpowers --refresh
bash .agents/fetch-skill.sh requesting-code-review obra/superpowers --refresh
bash .agents/fetch-skill.sh verification-before-completion obra/superpowers --refresh
bash .agents/fetch-skill.sh dev-engineering-super-skill get-zeked/dev-engineering-super-skill --refresh
```

Then consult .agents/skill-catalog.md for any additional skills needed
for this specific task (e.g. frontend-design, xlsx, pdf).

For each additional skill:
```bash
bash .agents/fetch-skill.sh <skill-name> <repo-slug>
```

Tell the human which skills you fetched and which (if any) were not found.
Do not proceed until the human confirms.

### 3. Plan
Fetch the planning skill if not already present:
```bash
bash .agents/fetch-skill.sh writing-plans obra/superpowers
```

Read .agents/skills/writing-plans/SKILL.md.
Produce a written plan in docs/plan.md before touching any code.
Wait for human approval before proceeding.

### 4. Implement
Follow the approved plan. Work in small committed steps.
Ask before making decisions not covered by the plan.

### 5. Review
Review all changed code against docs/plan.md and acceptance criteria.

Categorize every issue found:
- **Auto-fix** — obvious bugs, typos, formatting, missing imports.
  Fix these immediately without asking.
- **Human review required** — logic errors, architectural decisions,
  unclear requirements, anything with more than one reasonable solution.
  List these clearly and STOP.

Fix all auto-fix issues. If human-review issues exist, print a numbered
list and stop. If no issues remain, print "Review passed. Ready to commit."

### 6. Commit and push
1. Verify the current branch is NOT main. If on main, create a task branch first.
2. Run a final check — no .env files staged, no secrets in diff.
3. Stage all changed files: `git add -A`
4. Write a Conventional Commits message: `<type>(<scope>): <description>`
5. Commit and push: `git commit -m "<message>" && git push origin HEAD`
6. Print summary: branch, commit message, files changed, next action.

## Skill Catalog

Read .agents/skill-catalog.md for all available skills.

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
```

---

## README.md

```markdown
# {{PROJECT_NAME}}

{{PROJECT_DESCRIPTION}}

## Getting started

1. Open Claude Code in this directory
2. Describe what you want to build
3. Claude Code fetches the brainstorming skill, brainstorms with you,
   fetches any additional skills needed, plans, implements, reviews, and commits

## Workflow

See AGENTS.md for the full workflow Claude Code follows.

## How skills work

Skills are fetched on demand from GitHub using `gh` CLI:

```bash
bash .agents/fetch-skill.sh <skill-name> <repo-slug>
```

Sources:
- https://github.com/anthropics/skills
- https://github.com/obra/superpowers
- https://github.com/get-zeked (standalone skill repos)

See .agents/skill-catalog.md for all available skills.
```

---

## .gitignore

```
.env
.env.local
__pycache__/
*.pyc
node_modules/
.DS_Store
```

---

## Init Script

**File:** `init-simple-project.sh`

Run from inside a freshly created, empty directory. Scaffolds everything into
the current directory. Project name is derived from the directory name.

The script copies `fetch-skill.sh` and `skill-catalog.md` from the spec repo
directory (where init-simple-project.sh lives). No heredoc duplication needed.

```bash
#!/usr/bin/env bash
set -euo pipefail

SPEC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_NAME="$(basename "$PWD")"

echo ""
echo "Initialising project: $PROJECT_NAME"
echo ""

read -rp "Project description: " DESCRIPTION

if [[ -n "$(ls -A . 2>/dev/null)" ]]; then
  echo "Error: directory is not empty. Run this from a fresh directory." && exit 1
fi

# ── Create structure ──────────────────────────────────────────────────────────
mkdir -p {src,docs,tests}
mkdir -p .agents/skills

# ── Copy fetch-skill.sh and skill-catalog.md from spec repo ──────────────────
cp "$SPEC_DIR/fetch-skill.sh" .agents/fetch-skill.sh
chmod +x .agents/fetch-skill.sh

cp "$SPEC_DIR/skill-catalog.md" .agents/skill-catalog.md

# ── Write AGENTS.md ───────────────────────────────────────────────────────────
cat > AGENTS.md << 'AGENTSEOF'
# AGENTS.md

## What this repo is
{{PROJECT_DESCRIPTION}}

## Workflow

Every task follows this sequence. Do not skip steps.

### 0. Boot
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
   This installs the skill if missing, or checks for upstream updates if already installed.

Do not proceed until both steps are complete.

### 1. Brainstorm
Read .agents/skills/brainstorming/SKILL.md and run it.
Do not write any code until brainstorm is complete and the human approves
the direction.

### 2. Identify and fetch skills
First, auto-fetch the required skills for any code task:

```bash
bash .agents/fetch-skill.sh writing-plans obra/superpowers --refresh
bash .agents/fetch-skill.sh test-driven-development obra/superpowers --refresh
bash .agents/fetch-skill.sh requesting-code-review obra/superpowers --refresh
bash .agents/fetch-skill.sh verification-before-completion obra/superpowers --refresh
bash .agents/fetch-skill.sh dev-engineering-super-skill get-zeked/dev-engineering-super-skill --refresh
```

Then consult .agents/skill-catalog.md for any additional skills needed
for this specific task (e.g. frontend-design, xlsx, pdf).

For each additional skill:
```bash
bash .agents/fetch-skill.sh <skill-name> <repo-slug>
```

Tell the human which skills you fetched and which (if any) were not found.
Do not proceed until the human confirms.

### 3. Plan
Fetch the planning skill if not already present:
```bash
bash .agents/fetch-skill.sh writing-plans obra/superpowers
```

Read .agents/skills/writing-plans/SKILL.md.
Produce a written plan in docs/plan.md before touching any code.
Wait for human approval before proceeding.

### 4. Implement
Follow the approved plan. Work in small committed steps.
Ask before making decisions not covered by the plan.

### 5. Review
Review all changed code against docs/plan.md and acceptance criteria.

Categorize every issue found:
- **Auto-fix** — obvious bugs, typos, formatting, missing imports.
  Fix these immediately without asking.
- **Human review required** — logic errors, architectural decisions,
  unclear requirements, anything with more than one reasonable solution.
  List these clearly and STOP.

Fix all auto-fix issues. If human-review issues exist, print a numbered
list and stop. If no issues remain, print "Review passed. Ready to commit."

### 6. Commit and push
1. Verify the current branch is NOT main. If on main, create a task branch first.
2. Run a final check — no .env files staged, no secrets in diff.
3. Stage all changed files: `git add -A`
4. Write a Conventional Commits message: `<type>(<scope>): <description>`
5. Commit and push: `git commit -m "<message>" && git push origin HEAD`
6. Print summary: branch, commit message, files changed, next action.

## Skill Catalog

Read .agents/skill-catalog.md for all available skills.

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
AGENTSEOF

# ── Write README.md ───────────────────────────────────────────────────────────
cat > README.md << 'READMEEOF'
# {{PROJECT_NAME}}

{{PROJECT_DESCRIPTION}}

## Getting started

1. Open Claude Code in this directory
2. Describe what you want to build
3. Claude Code fetches the brainstorming skill, brainstorms with you,
   fetches any additional skills needed, plans, implements, reviews, and commits

## Workflow

See AGENTS.md for the full workflow Claude Code follows.

## How skills work

Skills are fetched on demand from GitHub using `gh` CLI:

```bash
bash .agents/fetch-skill.sh <skill-name> <repo-slug>
```

Sources:
- https://github.com/anthropics/skills
- https://github.com/obra/superpowers
- https://github.com/get-zeked (standalone skill repos)

See .agents/skill-catalog.md for all available skills.
READMEEOF

# ── Write .gitignore ──────────────────────────────────────────────────────────
cat > .gitignore << 'IGNOREEOF'
.env
.env.local
__pycache__/
*.pyc
node_modules/
.DS_Store
IGNOREEOF

# ── Substitute placeholders ───────────────────────────────────────────────────
export _NAME="$PROJECT_NAME"
export _DESC="${DESCRIPTION:-A project built with Claude Code.}"

python3 - << 'PYEOF'
import os, pathlib

project = pathlib.Path(".")
desc = os.environ["_DESC"]
name = os.environ["_NAME"]

for path in project.rglob("*"):
    if not path.is_file():
        continue
    try:
        text = path.read_text(encoding="utf-8")
        new = text.replace("{{PROJECT_NAME}}", name)
        new = new.replace("{{PROJECT_DESCRIPTION}}", desc)
        if new != text:
            path.write_text(new, encoding="utf-8")
    except (UnicodeDecodeError, PermissionError):
        pass
PYEOF

unset _NAME _DESC 2>/dev/null || true

# ── Git ───────────────────────────────────────────────────────────────────────
git init -q
git add .
git commit -q -m "feat: initial project scaffold" 2>/dev/null || {
  echo ""
  echo "Note: git commit skipped — configure git identity first:"
  echo "  git config user.name  'Your Name'"
  echo "  git config user.email 'you@example.com'"
}

# ── Done ──────────────────────────────────────────────────────────────────────
echo ""
echo "✓ $PROJECT_NAME initialised"
echo ""
echo "Next:"
echo "  claude"
echo "  # Claude Code will fetch skills from GitHub as needed"
```

---

## Repo structure

```
simple-project-starter/
├── simple-project-starter-spec.md   ← this file: build instructions + templates
├── fetch-skill.sh                   ← skill fetcher with safety scanner
├── skill-catalog.md                 ← categorized skill catalog
├── init-simple-project.sh           ← generated by executing this spec
└── README.md
```

Single source of truth: `fetch-skill.sh` and `skill-catalog.md` are standalone
files. The init script copies them into projects. No duplication.

---

## Validation Criteria

The build is complete when these files exist and are non-empty:

- `init-simple-project.sh` — is executable, copies `fetch-skill.sh` and `skill-catalog.md`
- Running `bash init-simple-project.sh` produces a project with:
  - `.agents/fetch-skill.sh` — executable, contains safety scanner
  - `.agents/skill-catalog.md` — contains all skill categories
  - `AGENTS.md` — contains "Boot", "fetch-skill.sh", references skill-catalog.md
  - `README.md` — contains project name and description
  - `.gitignore`

After validation, ask the human:
> "Ready. What would you like to build? Give me your project name and a short description."

---

## Usage

### Create a new project

```bash
mkdir my-project
cd my-project
bash /path/to/init-simple-project.sh
```

The script scaffolds into the **current directory**. The project name is
taken from the directory name — no subdirectory is created.

### Then

```bash
claude
```

Tell Claude Code what you want to build.
It reads AGENTS.md, fetches the brainstorming skill, brainstorms with you,
fetches any additional skills needed, plans, implements, reviews, and commits.
You stay in the loop at every decision point.

---

## What this is NOT

- Not an autonomous pipeline — you are always in the loop
- Not a Python runtime — no hooks, no IterationState, no model config
- Not a framework — just markdown files Claude Code reads
