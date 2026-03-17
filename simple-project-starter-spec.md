# simple-project-starter — Build Spec v1

## Execution Preamble

Read this entire specification before creating or modifying any files.

Rules for the coding agent executing this spec:

1. Build directly into the current directory. Do not create a subdirectory.
2. Every SKILL.md must be fully written — no placeholders.
3. Keep it simple. No Python runtime, no hooks, no dependency management.
4. When done, verify all files exist as listed in Validation Criteria.

## Build Instructions

Build the following in this order:

1. `skills/` folder and all five SKILL.md files — content is in the Skills section below
2. `init-simple-project.sh` — content is in the Init Script section below, make it executable
3. Verify all files in Validation Criteria exist and are non-empty

That is all. Do not create a project directory — this spec builds
the contents of the agentworks-spec repo itself, not a project.

---

## What This Is

A minimal project starter for human-in-the-loop Claude Code workflows.

No autonomous pipelines. No Python runtime machinery. Just:
- An AGENTS.md that defines the workflow
- A small set of always-installed skills
- A skill index pointing to three upstream skill libraries
- A workflow Claude Code follows on every project

The entire runtime is Claude Code reading markdown files and following them.

---

## Folder Structure

```
my-project/
├── AGENTS.md
├── README.md
├── .gitignore
├── .agents/
│   └── skills/
│       ├── brainstorm/
│       │   └── SKILL.md
│       ├── identify-and-install-skills/
│       │   └── SKILL.md
│       ├── plan-work/
│       │   └── SKILL.md
│       ├── review-output/
│       │   └── SKILL.md
│       └── commit-and-push/
│           └── SKILL.md
├── src/
├── docs/
└── tests/
```

That is the entire structure. Nothing else is required.

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

### 1. Brainstorm
Read .agents/skills/brainstorm/SKILL.md and run it.
Do not write any code until brainstorm is complete and the human approves
the direction.

### 2. Identify skills
Read .agents/skills/identify-and-install-skills/SKILL.md.
Based on the brainstorm outcome and planned work, identify which additional
skills are needed. Copy them into .agents/skills/ from the skill sources
listed in that skill file.

### 3. Plan
Read .agents/skills/plan-work/SKILL.md.
Produce a written plan in docs/plan.md before touching any code.
Wait for human approval before proceeding.

### 4. Implement
Follow the approved plan. Work in small committed steps.
Ask before making decisions not covered by the plan.

### 5. Review
Read .agents/skills/review-output/SKILL.md.
Review all changed code against the plan and acceptance criteria.

If issues found:
- Fix obvious bugs automatically
- List non-obvious issues clearly and STOP — wait for human input
- Do not commit while unresolved issues exist

If no serious issues:
- Proceed to commit

### 6. Commit and push
Read .agents/skills/commit-and-push/SKILL.md and follow it.

## Rules

- Never commit directly to main during active work — use a task branch
- Never push without running the review step first
- Never make architectural decisions without asking first
- Always write docs/plan.md before writing code
- Keep .agents/skills/ in sync — if you use a skill, it must be installed

## Done criteria

A task is done when:
- All planned features are implemented
- Review passes with no unresolved issues
- Changes are committed and pushed
- docs/plan.md reflects what was actually built
```

---

## Skills

### brainstorm/SKILL.md

**Title:** Brainstorm

**Description:**
An interactive back-and-forth conversation to shape a project or feature
idea before any planning or code is written. The goal is to arrive at a
clear, agreed direction that both the human and Claude Code are aligned on.

**When to use:**
- At the start of every new project or significant feature
- When the human's initial prompt is vague or exploratory
- When multiple approaches are possible and the human needs to choose

**When NOT to use:**
- When the task is clearly defined and small (a bug fix, a minor change)
- When a plan already exists in docs/plan.md

**Expected inputs:**
- The human's initial prompt or idea

**Procedure:**

1. Read the human's prompt carefully. Identify what is clear and what is ambiguous.
2. Ask one focused question at a time — do not overwhelm with a list.
   Good first questions:
   - "Who is this for — just you, or other users too?"
   - "What does success look like in one sentence?"
   - "Is there anything you've already tried or ruled out?"
3. After each answer, reflect back what you heard and check understanding.
4. Identify the core problem being solved. State it explicitly.
5. Propose 2-3 concrete directions (not exhaustive lists — real choices).
6. Once the human picks a direction, summarize the agreed approach in one paragraph.
7. Ask: "Does this match what you have in mind? Should we proceed to planning?"
8. Do not proceed until the human explicitly approves.

**Expected output:**
A one-paragraph agreed direction summary, approved by the human,
ready to hand to plan-work.

---

### identify-and-install-skills/SKILL.md

**Title:** Identify and Install Skills

**Description:**
Given a brainstorm outcome and planned work, identify which skills from
the available skill sources would help, and copy them into .agents/skills/.

This is how the project's skill set grows — not by pre-installing everything,
but by pulling in exactly what is needed for the current task.

**When to use:**
- After brainstorm, before planning
- When starting a task that requires capabilities not yet in .agents/skills/

**When NOT to use:**
- Do not install skills speculatively — only install what the current task needs

**Skill sources:**

The following repositories contain curated skills. Read their skill indexes
to find relevant skills. Copy the SKILL.md file into the appropriate
.agents/skills/<category>/<skill-name>/ directory.

| Source | URL | Notes |
|---|---|---|
| agentworks | https://github.com/<your-org>/agentworks | Primary source — curated skills across common, development, research |
| anthropic-skills | https://github.com/anthropics/skills | Official Anthropic coding agent skills |
| perplexity-super-skills | https://github.com/get-zeked/perplexity-super-skills | Research and retrieval skills |
| superpowers | https://github.com/obra/superpowers | Community skill collection |

**Procedure:**

1. Read the brainstorm summary and planned work.
2. List the capabilities needed that are not already in .agents/skills/.
3. For each capability, check agentworks first. If found, copy it.
4. If not in agentworks, check the other three sources in order.
5. Copy the SKILL.md into .agents/skills/<category>/<skill-name>/SKILL.md.
6. Add a comment to AGENTS.md listing which skills are installed and why.
7. If a needed skill does not exist in any source, note it as a gap
   and proceed without it — do not create a skill on the fly.

**Expected output:**
All needed skills installed in .agents/skills/.
AGENTS.md updated with installed skill list.

---

### plan-work/SKILL.md

**Title:** Plan Work

**Description:**
Turn a brainstorm outcome into a concrete, written implementation plan
that Claude Code and the human are both aligned on before any code is written.

**When to use:**
- After brainstorm is approved
- Before implementing any feature or significant change

**When NOT to use:**
- For trivial single-line fixes — just do them
- Before brainstorm is complete

**Expected inputs:**
- The approved brainstorm summary
- Any constraints mentioned (tech stack, deadline, existing code)

**Procedure:**

1. Write docs/plan.md with these sections:
   - **Goal** — one sentence
   - **Scope** — what is included and explicitly what is NOT included
   - **Approach** — the technical approach in plain language
   - **Steps** — numbered implementation steps, each small enough to commit separately
   - **Acceptance criteria** — how to know when each step is done
   - **Open questions** — anything that needs human input before or during implementation
2. Present the plan to the human.
3. Address any open questions before proceeding.
4. Wait for explicit approval: "looks good" or "proceed" is enough.
5. Do not write any code until approval is given.

**Expected output:**
docs/plan.md — approved by human, ready for implementation.

---

### review-output/SKILL.md

**Title:** Review Output

**Description:**
Review code or other output against the plan and acceptance criteria.
Categorize issues clearly so the human knows exactly what needs attention
and what has already been fixed.

**When to use:**
- After implementation is complete
- Before every commit
- Any time the human asks for a review

**When NOT to use:**
- Do not skip this step even if the change seems small

**Expected inputs:**
- The changed files
- docs/plan.md (acceptance criteria)

**Procedure:**

1. Read docs/plan.md — understand what was supposed to be built.
2. Review all changed files against the plan and acceptance criteria.
3. Categorize every issue found:
   - **Auto-fix** — obvious bugs, typos, formatting, missing imports.
     Fix these immediately without asking.
   - **Human review required** — logic errors, architectural decisions,
     unclear requirements, anything with more than one reasonable solution.
     List these clearly and STOP.
4. Fix all auto-fix issues.
5. If human-review issues exist:
   - Print a numbered list: issue, location, why it needs human input
   - Stop. Do not commit. Wait for the human to respond.
6. If no human-review issues remain:
   - Print: "Review passed. No unresolved issues. Ready to commit."
   - Proceed to commit-and-push.

**Expected output:**
Either a list of issues requiring human input (and a stop),
or explicit confirmation that review passed.

---

### commit-and-push/SKILL.md

**Title:** Commit and Push

**Description:**
Commit all reviewed changes with a clear conventional commit message
and push to the remote branch.

**When to use:**
- After review-output passes with no unresolved issues
- Never before review

**When NOT to use:**
- Do not commit while review issues are unresolved
- Do not commit directly to main — always use a task branch

**Expected inputs:**
- All staged changes, reviewed and approved

**Procedure:**

1. Verify the current branch is NOT main. If on main, stop and ask.
2. Run a final check — no .env files staged, no secrets in diff.
3. Stage all changed files: `git add -A`
4. Write the commit message following Conventional Commits:
   `<type>(<scope>): <description>`
   Types: feat, fix, docs, refactor, test, chore
   Example: `feat(auth): add JWT token validation`
5. Commit: `git commit -m "<message>"`
6. Push: `git push origin <current-branch>`
7. Print a summary:
   - Branch pushed
   - Commit message
   - Files changed
   - Next suggested action (open PR, continue to next step, etc.)

**Expected output:**
Changes committed and pushed. Summary printed.

---

## README.md

```markdown
# {{PROJECT_NAME}}

{{PROJECT_DESCRIPTION}}

## Getting started

1. Open Claude Code in this directory
2. Describe what you want to build
3. Claude Code will brainstorm with you, plan, implement, review, and commit

## Workflow

See AGENTS.md for the full workflow Claude Code follows.

## Skills installed

| Skill | Purpose |
|---|---|
| brainstorm | Shape ideas before planning |
| identify-and-install-skills | Pull in skills as needed |
| plan-work | Write docs/plan.md before coding |
| review-output | Review before every commit |
| commit-and-push | Commit and push with conventional commits |

Additional skills are installed as needed from:
- https://github.com/<your-org>/agentworks
- https://github.com/anthropics/skills
- https://github.com/get-zeked/perplexity-super-skills
- https://github.com/obra/superpowers
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

A single script that creates the project from this spec.
Lives in the agentworks-spec repo alongside the build spec.

```bash
#!/usr/bin/env bash
set -euo pipefail

# ── Prompt ────────────────────────────────────────────────────────────────────
echo ""
echo "Create new project"
echo ""

read -rp "Project name: " PROJECT_NAME
read -rp "Project description: " DESCRIPTION

if [[ -z "$PROJECT_NAME" ]]; then
  echo "Error: project name is required" && exit 1
fi

if [[ -d "$PROJECT_NAME" ]]; then
  echo "Error: directory $PROJECT_NAME already exists" && exit 1
fi

# ── Create structure ──────────────────────────────────────────────────────────
mkdir -p "$PROJECT_NAME"/{src,docs,tests}
mkdir -p "$PROJECT_NAME/.agents/skills"/{brainstorm,identify-and-install-skills,plan-work,review-output,commit-and-push}

SPEC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Copy skill files from this spec repo
for SKILL in brainstorm identify-and-install-skills plan-work review-output commit-and-push; do
  if [[ -f "$SPEC_DIR/skills/$SKILL/SKILL.md" ]]; then
    cp "$SPEC_DIR/skills/$SKILL/SKILL.md" \
       "$PROJECT_NAME/.agents/skills/$SKILL/SKILL.md"
  fi
done

# ── Write AGENTS.md ───────────────────────────────────────────────────────────
export _NAME="$PROJECT_NAME"
export _DESC="$DESCRIPTION"

python3 - << 'PYEOF'
import os, pathlib

project = pathlib.Path(os.environ["_NAME"])
desc = os.environ["_DESC"] or "A project built with Claude Code."

for path in project.rglob("*"):
    if not path.is_file():
        continue
    try:
        text = path.read_text(encoding="utf-8")
        new = text.replace("{{PROJECT_NAME}}", os.environ["_NAME"])
        new = new.replace("{{PROJECT_DESCRIPTION}}", desc)
        if new != text:
            path.write_text(new, encoding="utf-8")
    except (UnicodeDecodeError, PermissionError):
        pass

unset _NAME _DESC 2>/dev/null || true
PYEOF

# ── Git ───────────────────────────────────────────────────────────────────────
cd "$PROJECT_NAME"
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
echo "✓ Project created: $PROJECT_NAME/"
echo ""
echo "Next steps:"
echo "  cd $PROJECT_NAME"
echo "  claude"
echo "  # Describe what you want to build — Claude Code takes it from there"
```

---

## Skill files on disk

The init script copies skills from `skills/` in the spec repo.
Create these files alongside `init-simple-project.sh`:

```
agentworks-spec/
├── agentworks-build-spec.md
├── claude-code-bootstrap.md
├── codex-cli-bootstrap.md
├── README.md
├── init-simple-project.sh          ← NEW
└── skills/                         ← NEW
    ├── brainstorm/
    │   └── SKILL.md
    ├── identify-and-install-skills/
    │   └── SKILL.md
    ├── plan-work/
    │   └── SKILL.md
    ├── review-output/
    │   └── SKILL.md
    └── commit-and-push/
        └── SKILL.md
```

The SKILL.md content for each is defined in the Skills section above.
These are the same files that get copied into every new project.

---

## Validation Criteria

The build is complete when these files exist and are non-empty:

- `skills/brainstorm/SKILL.md` — contains "one focused question at a time"
- `skills/identify-and-install-skills/SKILL.md` — contains all four skill source URLs
- `skills/plan-work/SKILL.md` — contains "docs/plan.md"
- `skills/review-output/SKILL.md` — contains "Auto-fix" and "Human review required"
- `skills/commit-and-push/SKILL.md` — contains "Conventional Commits"
- `init-simple-project.sh` — is executable, contains all five skill names

---

## Usage

### Create a new project

```bash
cd agentworks-spec
bash init-simple-project.sh
```

### Then

```bash
cd <project-name>
claude
```

Tell Claude Code what you want to build.
It reads AGENTS.md, runs brainstorm, installs needed skills,
plans, implements, reviews, and commits. You stay in the loop at
every decision point.

---

## What this is NOT

- Not an autonomous pipeline — you are always in the loop
- Not a Python runtime — no hooks, no IterationState, no model config
- Not a framework — just markdown files Claude Code reads

For autonomous pipelines, see agentworks-build-spec.md.
