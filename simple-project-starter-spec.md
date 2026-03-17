# simple-project-starter — Build Spec v2

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

No `skills/` folder needed in this repo. Skills live in the upstream repos
and are fetched at runtime by Claude Code using `fetch-skill.sh`.

That is all. Do not create a project directory — this spec builds
the contents of the simple-project-starter repo itself, not a project.

---

## What This Is

A minimal project starter for human-in-the-loop Claude Code workflows.

No autonomous pipelines. No Python runtime machinery. Just:
- An AGENTS.md that defines the workflow
- Skills fetched on demand from three upstream repos
- A skill catalog so Claude Code knows what is available
- A workflow Claude Code follows on every project

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
│   ├── fetch-skill.sh        ← fetches skills from GitHub on demand
│   └── skills/               ← empty at init, populated at runtime
├── src/
├── docs/
└── tests/
```

Skills are fetched into `.agents/skills/<skill-name>/SKILL.md` by Claude Code
as needed, using `fetch-skill.sh`. Nothing is pre-installed.

---

## Skill Catalog

These are the skills available in the three upstream repos. Claude Code
consults this catalog when deciding which skills to fetch for a task.

**Last updated:** 2026-03-17

To refresh this catalog, run:
```bash
gh api repos/anthropics/skills/git/trees/HEAD:skills --jq '.tree[].path'
gh api repos/obra/superpowers/git/trees/HEAD:skills --jq '.tree[].path'
```

### Development Process — obra/superpowers

| Skill | Repo | Description |
|---|---|---|
| brainstorming | obra/superpowers | Interactive brainstorming before any code. Explores intent, requirements, design. Requires human approval before proceeding. |
| writing-plans | obra/superpowers | Write implementation plans assuming zero codebase context. Covers files, code, testing, docs. Emphasizes DRY, YAGNI, TDD. |
| executing-plans | obra/superpowers | Load a written plan, review critically, execute all tasks with review checkpoints. |
| test-driven-development | obra/superpowers | Write test first, watch it fail, write minimal code to pass. For all new features and bug fixes. |
| systematic-debugging | obra/superpowers | Root cause investigation before any fix. Symptom fixes are treated as failure. |
| requesting-code-review | obra/superpowers | Dispatch a code-reviewer subagent to catch issues. Mandatory after major features and before merging. |
| receiving-code-review | obra/superpowers | Handle incoming review feedback with technical rigor. Verify before implementing suggestions. |
| verification-before-completion | obra/superpowers | Run verification commands and confirm output before claiming work is done. Evidence before assertions. |
| dispatching-parallel-agents | obra/superpowers | Dispatch one agent per independent problem domain to work concurrently with isolated context. |
| subagent-driven-development | obra/superpowers | Execute plans by dispatching a fresh subagent per task with two-stage review after each. |
| finishing-a-development-branch | obra/superpowers | Guide completion when implementation is done. Present options for merge, PR, or cleanup. |
| using-git-worktrees | obra/superpowers | Create isolated git worktrees for feature work or plan execution. |
| writing-skills | obra/superpowers | Create, edit, or verify skills. TDD methodology applied to process documentation. |
| using-superpowers | obra/superpowers | Meta-skill: how to find and use other skills. |

### Documents & Media — anthropics/skills

| Skill | Repo | Description |
|---|---|---|
| docx | anthropics/skills | Create, read, edit Word documents. Tables of contents, headings, page numbers, letterheads. |
| pdf | anthropics/skills | Full PDF processing: read, merge, split, rotate, watermark, create, fill forms, OCR. |
| pptx | anthropics/skills | Create, read, edit PowerPoint files. Slide decks, pitch decks, templates, speaker notes. |
| xlsx | anthropics/skills | Create, read, edit spreadsheets. Formulas, formatting, charting, data cleaning. Zero formula errors. |
| doc-coauthoring | anthropics/skills | Structured co-authoring workflow: context gathering, refinement, reader testing. |
| internal-comms | anthropics/skills | Write internal communications: 3P updates, newsletters, FAQs, status reports, incident reports. |

### Design & Frontend — anthropics/skills

| Skill | Repo | Description |
|---|---|---|
| frontend-design | anthropics/skills | Production-grade frontend interfaces with high design quality. Avoids generic AI aesthetics. |
| canvas-design | anthropics/skills | Create visual art in PNG/PDF using design philosophy. Posters, static art, visual design. |
| web-artifacts-builder | anthropics/skills | Multi-component HTML artifacts with React 18, TypeScript, Vite, Tailwind, shadcn/ui. |
| theme-factory | anthropics/skills | Style artifacts with themes. 10 pre-set themes or generate new ones on-the-fly. |
| brand-guidelines | anthropics/skills | Apply brand colors and typography. Color palettes, font pairings, visual identity. |
| algorithmic-art | anthropics/skills | Generative art with p5.js. Flow fields, particle systems, seeded randomness. |
| slack-gif-creator | anthropics/skills | Create animated GIFs optimized for Slack emoji and message sizes. |

### Development Tools — anthropics/skills

| Skill | Repo | Description |
|---|---|---|
| claude-api | anthropics/skills | Build apps with Claude API or Anthropic SDK. Language detection, streaming, adaptive thinking. |
| mcp-builder | anthropics/skills | Create MCP servers for LLM-to-service integration. Python (FastMCP) and Node/TypeScript. |
| webapp-testing | anthropics/skills | Test local web apps with Playwright. Screenshots, browser logs, UI verification. |
| skill-creator | anthropics/skills | Create and measure skill performance. Evals, benchmarking, description optimization. |

### Cross-Domain — get-zeked (standalone repos)

Each super-skill is a standalone repo with SKILL.md at root. Fetch with:
`bash .agents/fetch-skill.sh <skill-name> get-zeked/<skill-name>`

| Skill | Repo | Description |
|---|---|---|
| **dev-engineering-super-skill** | get-zeked/dev-engineering-super-skill | **REQUIRED.** Comprehensive full-stack development reference: architecture, frontend, backend, TDD, debugging, code review, DevOps, security. |
| ai-agent-super-skill | get-zeked/ai-agent-super-skill | AI/ML agent building |
| marketing-super-skill | get-zeked/marketing-super-skill | Marketing & growth |
| sales-super-skill | get-zeked/sales-super-skill | Sales & revenue |
| finance-super-skill | get-zeked/finance-super-skill | Finance & accounting |
| legal-super-skill | get-zeked/legal-super-skill | Legal operations |
| pm-super-skill | get-zeked/pm-super-skill | Product management & UX |
| operations-cx-super-skill | get-zeked/operations-cx-super-skill | Operations & customer experience |
| research-knowledge-super-skill | get-zeked/research-knowledge-super-skill | Research & data |
| content-creative-super-skill | get-zeked/content-creative-super-skill | Creative studio |

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
   Compare the output with the Skill Catalog section below. If new skills
   appear that are not in the catalog, add them. If listed skills are gone,
   remove them. Tell the human what changed (if anything).

2. **Fetch the brainstorming skill.** Check whether .agents/skills/brainstorming/SKILL.md exists.
   If it does not exist, run:
   ```bash
   bash .agents/fetch-skill.sh brainstorming obra/superpowers
   ```

Do not proceed until both steps are complete.

### 1. Brainstorm
Read .agents/skills/brainstorming/SKILL.md and run it.
Do not write any code until brainstorm is complete and the human approves
the direction.

### 2. Identify and fetch skills
First, auto-fetch the required skills for any code task:

```bash
bash .agents/fetch-skill.sh writing-plans obra/superpowers
bash .agents/fetch-skill.sh test-driven-development obra/superpowers
bash .agents/fetch-skill.sh requesting-code-review obra/superpowers
bash .agents/fetch-skill.sh verification-before-completion obra/superpowers
bash .agents/fetch-skill.sh dev-engineering-super-skill get-zeked/dev-engineering-super-skill
```

Then consult the Skill Catalog below for any additional skills needed for this
specific task (e.g. frontend-design, xlsx, pdf).

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

Available skills that can be fetched on demand. Use `bash .agents/fetch-skill.sh <name> <repo>`.

### Development Process — obra/superpowers

| Skill | Description |
|---|---|
| brainstorming | Interactive brainstorming before any code |
| writing-plans | Write implementation plans with full context |
| executing-plans | Execute written plans with review checkpoints |
| test-driven-development | Write test first, watch it fail, write code to pass |
| systematic-debugging | Root cause investigation before any fix |
| requesting-code-review | Dispatch code-reviewer subagent |
| receiving-code-review | Handle review feedback with technical rigor |
| verification-before-completion | Evidence before completion claims |
| dispatching-parallel-agents | Concurrent agents for independent tasks |
| subagent-driven-development | Fresh subagent per task with two-stage review |
| finishing-a-development-branch | Merge, PR, or cleanup options |
| using-git-worktrees | Isolated git worktrees for feature work |
| writing-skills | Create or edit skills with TDD methodology |

### Documents & Media — anthropics/skills

| Skill | Description |
|---|---|
| docx | Word documents |
| pdf | PDF processing, creation, OCR |
| pptx | PowerPoint files |
| xlsx | Spreadsheets, formulas, charts |
| doc-coauthoring | Co-authoring workflow |
| internal-comms | Internal communications |

### Design & Frontend — anthropics/skills

| Skill | Description |
|---|---|
| frontend-design | Production-grade frontend interfaces |
| canvas-design | Visual art in PNG/PDF |
| web-artifacts-builder | Multi-component HTML artifacts |
| theme-factory | Styling with themes |
| brand-guidelines | Brand colors and typography |
| algorithmic-art | Generative art with p5.js |
| slack-gif-creator | Animated GIFs for Slack |

### Development Tools — anthropics/skills

| Skill | Description |
|---|---|
| claude-api | Claude API / Anthropic SDK |
| mcp-builder | MCP server creation |
| webapp-testing | Playwright web testing |
| skill-creator | Skill creation and measurement |

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

See the Skill Catalog in AGENTS.md for all available skills.
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

## fetch-skill.sh

**File:** `.agents/fetch-skill.sh`

This is the single mechanism for fetching skills from GitHub. Claude Code calls
it whenever it needs to install a skill. It searches the specified repo or
all repos in order and installs the first match found.

```bash
#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   bash .agents/fetch-skill.sh <skill-name>
#   bash .agents/fetch-skill.sh <skill-name> <org/repo>   # search specific repo only

SKILL_NAME="${1:-}"
SPECIFIC_REPO="${2:-}"

if [[ -z "$SKILL_NAME" ]]; then
  echo "Error: skill name required" && exit 1
fi

SKILL_DIR=".agents/skills/$SKILL_NAME"
SKILL_FILE="$SKILL_DIR/SKILL.md"

if [[ -f "$SKILL_FILE" ]]; then
  echo "✓ $SKILL_NAME already installed, skipping"
  exit 0
fi

REPOS=(
  "anthropics/skills"
  "obra/superpowers"
)

if [[ -n "$SPECIFIC_REPO" ]]; then
  REPOS=("$SPECIFIC_REPO")
fi

FOUND=0

for REPO in "${REPOS[@]}"; do
  echo "→ Checking $REPO for skill: $SKILL_NAME"

  for SKILL_PATH in \
    "skills/$SKILL_NAME/SKILL.md" \
    "$SKILL_NAME/SKILL.md" \
    "SKILL.md" \
    "skills/$SKILL_NAME/skill.md" \
    "$SKILL_NAME/skill.md" \
    "skill.md"
  do
    DOWNLOAD_URL=""
    if DOWNLOAD_URL=$(gh api "repos/$REPO/contents/$SKILL_PATH" \
      --jq '.download_url' 2>/dev/null); then
      :
    else
      DOWNLOAD_URL=""
    fi

    if [[ -n "$DOWNLOAD_URL" && "$DOWNLOAD_URL" != "null" && "$DOWNLOAD_URL" != *"Not Found"* ]]; then
      mkdir -p "$SKILL_DIR"
      gh api "repos/$REPO/contents/$SKILL_PATH" \
        --jq '.content' \
        | base64 --decode > "$SKILL_FILE"

      if [[ -s "$SKILL_FILE" ]]; then
        # ── Safety scan ──────────────────────────────────────────────
        WARNINGS=""

        # Network exfiltration patterns (actual invocations, not documentation references)
        if grep -iE '^\s*(curl|wget|nc|netcat)\s+(http|ftp|\$|`)|`(curl|wget|nc|netcat)\s+(http|ftp|\$|`)|\$\((curl|wget|nc|netcat)\s' "$SKILL_FILE" 2>/dev/null \
          | grep -qivE 'github\.com|anthropic|example\.com|localhost|127\.0\.0\.1'; then
          WARNINGS="${WARNINGS}  ⚠ Contains network commands (curl/wget/nc) targeting non-standard URLs\n"
        fi

        # Credential/secret access
        if grep -qiE '\.env\b|credentials|\.ssh/|private.key|secret.key|api.key|token.*=|password.*=' "$SKILL_FILE" 2>/dev/null; then
          if grep -iE '\.env\b|credentials|\.ssh/|private.key|secret.key' "$SKILL_FILE" 2>/dev/null | grep -qiE 'read|cat|source|export|send|upload|curl|post'; then
            WARNINGS="${WARNINGS}  ⚠ References reading or transmitting credentials/secrets\n"
          fi
        fi

        # Destructive file operations (exclude harmless stderr redirection)
        if grep -iE 'rm\s+-rf\s+[~/\*]|rm\s+-rf\s+\$|shred' "$SKILL_FILE" 2>/dev/null \
          | grep -qivE 'rm\s+-rf\s+\$SKILL_DIR|rm\s+-f\s+\$SKILL_FILE'; then
          WARNINGS="${WARNINGS}  ⚠ Contains destructive file operations (rm -rf with broad paths)\n"
        fi

        # Base64 encode + send pattern (data exfiltration)
        if grep -qiE 'base64.*curl|base64.*wget|base64.*nc\b|encode.*send|encode.*post' "$SKILL_FILE" 2>/dev/null; then
          WARNINGS="${WARNINGS}  ⚠ Contains base64 encode + network send pattern (possible exfiltration)\n"
        fi

        # Disable safety/verification (exclude anti-pattern docs and non-safety contexts)
        if grep -iE 'skip.*(code review|safety review|security review|all review|all test|every test)|disable.*safety|ignore.*warning|--no-verify|bypass.*(safety|security|check|verification)' "$SKILL_FILE" 2>/dev/null \
          | grep -ivE 'never|don.t|do not|must not|should not|prohibited|anti.pattern|common mistake|"skip|rationalization|^\s*-\s*skip|^\*\*skip' \
          | grep -qiE 'skip|disable|ignore|bypass|--no-verify'; then
          WARNINGS="${WARNINGS}  ⚠ Contains instructions to skip safety checks or reviews\n"
        fi

        # Eval/exec injection
        if grep -qiE '^\s*eval\b|\beval\s*\(|\bexec\s*\(' "$SKILL_FILE" 2>/dev/null; then
          WARNINGS="${WARNINGS}  ⚠ Contains eval/exec calls (code injection risk)\n"
        fi

        if [[ -n "$WARNINGS" ]]; then
          echo ""
          echo "⚠ SAFETY WARNINGS for $SKILL_NAME:"
          echo -e "$WARNINGS"
          echo "  Source: $REPO ($SKILL_PATH)"
          echo "  File saved to: $SKILL_FILE"
          echo ""
          echo "  Review the skill content before proceeding."
          echo "  To remove: rm -r $SKILL_DIR"
          echo ""
        else
          echo "✓ Installed $SKILL_NAME from $REPO ($SKILL_PATH)"
        fi

        FOUND=1
        break 2
      else
        rm -f "$SKILL_FILE"
      fi
    fi
  done
done

if [[ "$FOUND" -eq 0 ]]; then
  echo ""
  echo "✗ Could not find skill: $SKILL_NAME"
  echo "  Searched: ${REPOS[*]}"
  echo ""
  echo "Stop here. Ask the human how to proceed before continuing."
  exit 1
fi
```

---

## Init Script

**File:** `init-simple-project.sh`

Run from inside a freshly created, empty directory. Scaffolds everything into
the current directory. Project name is derived from the directory name.
Skills are NOT pre-copied — fetched from GitHub by Claude Code at runtime.

```bash
#!/usr/bin/env bash
set -euo pipefail

# ── Prompt ────────────────────────────────────────────────────────────────────
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

# ── Write fetch-skill.sh ────────────────────────────────────────────────────
cat > .agents/fetch-skill.sh << 'FETCHEOF'
#!/usr/bin/env bash
set -euo pipefail

SKILL_NAME="${1:-}"
SPECIFIC_REPO="${2:-}"

if [[ -z "$SKILL_NAME" ]]; then
  echo "Error: skill name required" && exit 1
fi

SKILL_DIR=".agents/skills/$SKILL_NAME"
SKILL_FILE="$SKILL_DIR/SKILL.md"

if [[ -f "$SKILL_FILE" ]]; then
  echo "✓ $SKILL_NAME already installed, skipping"
  exit 0
fi

REPOS=(
  "anthropics/skills"
  "obra/superpowers"
)

if [[ -n "$SPECIFIC_REPO" ]]; then
  REPOS=("$SPECIFIC_REPO")
fi

FOUND=0

for REPO in "${REPOS[@]}"; do
  echo "→ Checking $REPO for skill: $SKILL_NAME"

  for SKILL_PATH in \
    "skills/$SKILL_NAME/SKILL.md" \
    "$SKILL_NAME/SKILL.md" \
    "SKILL.md" \
    "skills/$SKILL_NAME/skill.md" \
    "$SKILL_NAME/skill.md" \
    "skill.md"
  do
    DOWNLOAD_URL=""
    if DOWNLOAD_URL=$(gh api "repos/$REPO/contents/$SKILL_PATH" \
      --jq '.download_url' 2>/dev/null); then
      :
    else
      DOWNLOAD_URL=""
    fi

    if [[ -n "$DOWNLOAD_URL" && "$DOWNLOAD_URL" != "null" && "$DOWNLOAD_URL" != *"Not Found"* ]]; then
      mkdir -p "$SKILL_DIR"
      gh api "repos/$REPO/contents/$SKILL_PATH" \
        --jq '.content' \
        | base64 --decode > "$SKILL_FILE"

      if [[ -s "$SKILL_FILE" ]]; then
        echo "✓ Installed $SKILL_NAME from $REPO ($SKILL_PATH)"
        FOUND=1
        break 2
      else
        rm -f "$SKILL_FILE"
      fi
    fi
  done
done

if [[ "$FOUND" -eq 0 ]]; then
  echo ""
  echo "✗ Could not find skill: $SKILL_NAME"
  echo "  Searched: ${REPOS[*]}"
  echo ""
  echo "Stop here. Ask the human how to proceed before continuing."
  exit 1
fi
FETCHEOF

chmod +x .agents/fetch-skill.sh

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
   Compare the output with the Skill Catalog section below. If new skills
   appear that are not in the catalog, add them. If listed skills are gone,
   remove them. Tell the human what changed (if anything).

2. **Fetch the brainstorming skill.** Check whether .agents/skills/brainstorming/SKILL.md exists.
   If it does not exist, run:
   ```bash
   bash .agents/fetch-skill.sh brainstorming obra/superpowers
   ```

Do not proceed until both steps are complete.

### 1. Brainstorm
Read .agents/skills/brainstorming/SKILL.md and run it.
Do not write any code until brainstorm is complete and the human approves
the direction.

### 2. Identify and fetch skills
First, auto-fetch the required skills for any code task:

```bash
bash .agents/fetch-skill.sh writing-plans obra/superpowers
bash .agents/fetch-skill.sh test-driven-development obra/superpowers
bash .agents/fetch-skill.sh requesting-code-review obra/superpowers
bash .agents/fetch-skill.sh verification-before-completion obra/superpowers
bash .agents/fetch-skill.sh dev-engineering-super-skill get-zeked/dev-engineering-super-skill
```

Then consult the Skill Catalog below for any additional skills needed for this
specific task (e.g. frontend-design, xlsx, pdf).

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

Available skills that can be fetched on demand. Use `bash .agents/fetch-skill.sh <name> <repo>`.

### Development Process — obra/superpowers

| Skill | Description |
|---|---|
| brainstorming | Interactive brainstorming before any code |
| writing-plans | Write implementation plans with full context |
| executing-plans | Execute written plans with review checkpoints |
| test-driven-development | Write test first, watch it fail, write code to pass |
| systematic-debugging | Root cause investigation before any fix |
| requesting-code-review | Dispatch code-reviewer subagent |
| receiving-code-review | Handle review feedback with technical rigor |
| verification-before-completion | Evidence before completion claims |
| dispatching-parallel-agents | Concurrent agents for independent tasks |
| subagent-driven-development | Fresh subagent per task with two-stage review |
| finishing-a-development-branch | Merge, PR, or cleanup options |
| using-git-worktrees | Isolated git worktrees for feature work |
| writing-skills | Create or edit skills with TDD methodology |

### Documents & Media — anthropics/skills

| Skill | Description |
|---|---|
| docx | Word documents |
| pdf | PDF processing, creation, OCR |
| pptx | PowerPoint files |
| xlsx | Spreadsheets, formulas, charts |
| doc-coauthoring | Co-authoring workflow |
| internal-comms | Internal communications |

### Design & Frontend — anthropics/skills

| Skill | Description |
|---|---|
| frontend-design | Production-grade frontend interfaces |
| canvas-design | Visual art in PNG/PDF |
| web-artifacts-builder | Multi-component HTML artifacts |
| theme-factory | Styling with themes |
| brand-guidelines | Brand colors and typography |
| algorithmic-art | Generative art with p5.js |
| slack-gif-creator | Animated GIFs for Slack |

### Development Tools — anthropics/skills

| Skill | Description |
|---|---|
| claude-api | Claude API / Anthropic SDK |
| mcp-builder | MCP server creation |
| webapp-testing | Playwright web testing |
| skill-creator | Skill creation and measurement |

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

See the Skill Catalog in AGENTS.md for all available skills.
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

## Updating the Skill Catalog

The skill catalog in AGENTS.md is a snapshot. Upstream repos may add new skills.
To refresh, run these commands and compare with the catalog:

```bash
# List anthropics/skills
gh api repos/anthropics/skills/git/trees/HEAD:skills --jq '.tree[].path'

# List obra/superpowers
gh api repos/obra/superpowers/git/trees/HEAD:skills --jq '.tree[].path'

# Read a specific skill's description
gh api repos/<org>/<repo>/contents/skills/<skill-name>/SKILL.md \
  --jq '.content' | base64 --decode | head -20
```

Add any new skills to the catalog tables in both this spec and the
AGENTS.md template in the init script. Remove skills that no longer exist.

---

## Repo structure

The spec repo only needs two files — no `skills/` folder required:

```
simple-project-starter/
├── simple-project-starter-spec.md
├── init-simple-project.sh
└── README.md
```

Skills live in the upstream repos. The init script ships `fetch-skill.sh`
into every project so Claude Code can pull them at runtime.

---

## Validation Criteria

The build is complete when these files exist and are non-empty:

- `init-simple-project.sh` — is executable, contains `fetch-skill.sh` write block
- Running `bash init-simple-project.sh` produces a project with:
  - `.agents/fetch-skill.sh` — executable, contains both repo URLs
  - `AGENTS.md` — contains "Boot", "fetch-skill.sh", and "Skill Catalog"
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
