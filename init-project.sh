#!/usr/bin/env bash
set -euo pipefail

# Run from the project root (parent of the skillflow/ folder).
# Usage: bash skillflow/init-project.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
PROJECT_NAME="$(basename "$PROJECT_DIR")"

cd "$PROJECT_DIR"

echo ""
echo "Initialising project: $PROJECT_NAME"
echo ""

# ── Check we're not inside the skillflow repo itself ─────────────────────────
if [[ -f "skillflow-spec.md" ]]; then
  echo "Error: you're inside the skillflow repo."
  echo "Run this from the project root (parent of skillflow/):"
  echo ""
  echo "  mkdir my-project"
  echo "  cd my-project"
  echo "  git clone https://github.com/qns2/skillflow.git"
  echo "  bash skillflow/init-project.sh"
  exit 1
fi

# ── Check skillflow folder exists ────────────────────────────────────────────
if [[ ! -d "skillflow" ]]; then
  echo "Error: skillflow/ folder not found."
  echo "Clone it first: git clone https://github.com/qns2/skillflow.git"
  exit 1
fi

# ── Check project isn't already initialised ──────────────────────────────────
if [[ -f "AGENTS.md" ]]; then
  echo "Error: AGENTS.md already exists. Project already initialised."
  exit 1
fi

read -rp "Project description: " DESCRIPTION

# ── Create structure ──────────────────────────────────────────────────────────
mkdir -p {src,docs,tests}
mkdir -p .agents/skills

# ── Copy files from skillflow/ ───────────────────────────────────────────────
cp skillflow/fetch-skill.sh .agents/fetch-skill.sh
chmod +x .agents/fetch-skill.sh

cp skillflow/skill-catalog.md .agents/skill-catalog.md
cp skillflow/skill-scenarios.md .agents/skill-scenarios.md

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

1. **Match the scenario.** Read .agents/skill-scenarios.md and find the
   standard scenario that best matches this task (e.g. "Feature Development",
   "Business Plan", "Bug Fix"). Tell the human which scenario you matched.

2. **Fetch all skills listed for that scenario.** Use `--refresh` on each:
   ```bash
   bash .agents/fetch-skill.sh <skill-name> <repo-slug> --refresh
   ```

3. **Check the catalog for extras.** Read .agents/skill-catalog.md. Show the
   human the full catalog and recommend any additional skills. The human
   decides what to add or remove.

4. **If domain knowledge is needed** that no upstream skill covers, fetch
   `skill-creator` from anthropics/skills and build a custom project skill.
   See the "Creating Custom Project Skills" section in skill-scenarios.md.

5. **Read every fetched skill immediately.** For each skill, read its
   SKILL.md and produce this summary:

   | Skill | Key Procedure | Will Apply In |
   |---|---|---|
   | (skill name) | (main process/steps the skill defines) | (which workflow step) |

6. **Note the checkpoint criteria.** The matched scenario in
   skill-scenarios.md defines specific pass/fail checkpoint items.
   List them so the human knows what will be verified after implementation.

Present all of the above to the human. Do not proceed until confirmed.

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

### Checkpoint: Skill Compliance
Before proceeding to review, complete two checks:

**A. Scenario checkpoint** — run through the specific pass/fail criteria
from the matched scenario in .agents/skill-scenarios.md:

| Checkpoint Item | Pass/Fail | Evidence |
|---|---|---|
| (each item from the scenario) | Pass/Fail | (point to specific output) |

Any "Fail" must be fixed or explicitly approved by the human to skip.

**B. Skill procedure check** — for each fetched skill:

| Skill | Key Procedure | Followed? | Evidence |
|---|---|---|---|
| (skill name) | (what it required) | Yes/No | (specific output) |

Rules:
- "Evidence" must point to concrete output (a file, a section, a specific
  action taken) — not just "I did it."
- Any "Fail" or "No" must be fixed or explicitly approved to skip.
- If more than half the items fail, go back to step 4.

Present both tables to the human before proceeding to review.

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
skillflow/
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
    if path.parts[0] == "skillflow":
        continue
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
echo "  # Tell Claude Code what you want to build"
