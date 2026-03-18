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
mkdir -p {src,docs,docs/summaries,tests}
mkdir -p .agents/skills

# ── Copy files from skillflow/ ───────────────────────────────────────────────
cp skillflow/fetch-skill.sh .agents/fetch-skill.sh
chmod +x .agents/fetch-skill.sh

cp skillflow/skill-catalog.md .agents/skill-catalog.md
cp skillflow/skill-scenarios.md .agents/skill-scenarios.md
cp skillflow/agents-lite.md .agents/agents-lite.md
cp skillflow/agents-full.md .agents/agents-full.md

# ── Write AGENTS.md ───────────────────────────────────────────────────────────
cat > AGENTS.md << 'AGENTSEOF'
# AGENTS.md

## What this repo is
{{PROJECT_DESCRIPTION}}

## Mode Selection
At the start of each session, ask the human:

**"Full workflow or lite?"**
- **Lite** — daily dev: 3 skills, TDD, code review, fast. Read `.agents/agents-lite.md` and follow it.
- **Full** — bigger projects: chain execution, scenario matching, structured summaries, checkpoints. Read `.agents/agents-full.md` and follow it.

If the human doesn't specify, default to **lite**.
AGENTSEOF

# ── Write README.md ───────────────────────────────────────────────────────────
cat > README.md << 'READMEEOF'
# {{PROJECT_NAME}}

{{PROJECT_DESCRIPTION}}

## Getting started

1. Open Claude Code in this directory
2. Claude asks: "Full workflow or lite?"
3. Describe what you want to build

## Workflow modes

- **Lite** — daily dev: TDD, code review, fast
- **Full** — bigger projects: chain execution, scenarios, checkpoints

See AGENTS.md for details.
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
echo "  # Claude asks: full or lite?"
