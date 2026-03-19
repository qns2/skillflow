#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   bash .agents/fetch-skill.sh <skill-name>
#   bash .agents/fetch-skill.sh <skill-name> <org/repo>
#   bash .agents/fetch-skill.sh <skill-name> <org/repo> --refresh   # check for updates
#   bash .agents/fetch-skill.sh --freeze                             # lock current versions
#   bash .agents/fetch-skill.sh --thaw                               # remove lock

MANIFEST=".agents/skills.json"
LOCKFILE=".agents/skills-lock.json"

# ── Freeze / Thaw commands ────────────────────────────────────────────────────
if [[ "${1:-}" == "--freeze" ]]; then
  if [[ ! -f "$MANIFEST" ]]; then
    echo "✗ No skills.json to freeze. Install some skills first."
    exit 1
  fi
  cp "$MANIFEST" "$LOCKFILE"
  SKILL_COUNT=$(python3 -c "import json; print(len(json.load(open('$LOCKFILE'))))")
  echo "✓ Frozen $SKILL_COUNT skills to skills-lock.json"
  echo "  Skills will be fetched at these exact versions until --thaw."
  exit 0
fi

if [[ "${1:-}" == "--thaw" ]]; then
  if [[ -f "$LOCKFILE" ]]; then
    rm "$LOCKFILE"
    echo "✓ Lock removed. Skills will float to latest upstream."
  else
    echo "✓ No lock file found. Already floating."
  fi
  exit 0
fi

# ── Record skill install to manifest ──────────────────────────────────────────
record_install() {
  local name="$1" repo="$2" path="$3" sha="$4"
  local date
  date=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  local entry
  entry=$(printf '{"repo":"%s","path":"%s","sha":"%s","fetched_at":"%s"}' "$repo" "$path" "$sha" "$date")

  if [[ -f "$MANIFEST" ]]; then
    python3 -c "
import json
with open('$MANIFEST') as f: data = json.load(f)
data['$name'] = json.loads('$entry')
with open('$MANIFEST', 'w') as f: json.dump(data, f, indent=2)
"
  else
    python3 -c "
import json
data = {'$name': json.loads('$entry')}
with open('$MANIFEST', 'w') as f: json.dump(data, f, indent=2)
"
  fi
}

# ── Parse arguments ───────────────────────────────────────────────────────────
SKILL_NAME="${1:-}"
SPECIFIC_REPO="${2:-}"
REFRESH=0

for arg in "$@"; do
  if [[ "$arg" == "--refresh" ]]; then
    REFRESH=1
    if [[ "$SPECIFIC_REPO" == "--refresh" ]]; then
      SPECIFIC_REPO=""
    fi
  fi
done

if [[ -z "$SKILL_NAME" ]]; then
  echo "Error: skill name required" && exit 1
fi

SKILL_DIR=".agents/skills/$SKILL_NAME"
SKILL_FILE="$SKILL_DIR/SKILL.md"
SHA_FILE="$SKILL_DIR/.sha"

# ── Check lock file for pinned version ────────────────────────────────────────
PINNED_SHA=""
PINNED_REPO=""
PINNED_PATH=""
if [[ -f "$LOCKFILE" ]]; then
  PINNED_SHA=$(python3 -c "
import json, sys
try:
    data = json.load(open('$LOCKFILE'))
    entry = data.get('$SKILL_NAME', {})
    print(entry.get('sha', ''))
except: print('')
" 2>/dev/null)
  PINNED_REPO=$(python3 -c "
import json
try:
    data = json.load(open('$LOCKFILE'))
    print(data.get('$SKILL_NAME', {}).get('repo', ''))
except: print('')
" 2>/dev/null)
  PINNED_PATH=$(python3 -c "
import json
try:
    data = json.load(open('$LOCKFILE'))
    print(data.get('$SKILL_NAME', {}).get('path', ''))
except: print('')
" 2>/dev/null)
fi

# ── Already installed ─────────────────────────────────────────────────────────
if [[ -f "$SKILL_FILE" ]]; then
  if [[ "$REFRESH" -eq 0 ]]; then
    # If pinned, verify we have the pinned version
    if [[ -n "$PINNED_SHA" ]]; then
      LOCAL_SHA=$(cat "$SHA_FILE" 2>/dev/null || echo "")
      if [[ "$LOCAL_SHA" != "$PINNED_SHA" ]]; then
        echo "↻ $SKILL_NAME: installed version doesn't match lock, re-fetching pinned version..."
        rm -f "$SKILL_FILE" "$SHA_FILE"
        # Fall through to pinned fetch below
      else
        echo "✓ $SKILL_NAME already installed (pinned)"
        exit 0
      fi
    else
      echo "✓ $SKILL_NAME already installed, skipping"
      exit 0
    fi
  else
    # --refresh: check if upstream has changed
    if [[ -n "$PINNED_SHA" ]]; then
      echo "⚠ $SKILL_NAME is pinned (locked). Use --thaw first to update."
      exit 0
    fi

    LOCAL_SHA=$(cat "$SHA_FILE" 2>/dev/null || echo "")
    if [[ -z "$LOCAL_SHA" ]]; then
      echo "→ $SKILL_NAME: no local hash, will re-fetch"
    else
      REPOS_CHECK=("anthropics/skills" "obra/superpowers")
      if [[ -n "$SPECIFIC_REPO" ]]; then
        REPOS_CHECK=("$SPECIFIC_REPO")
      fi

      for REPO in "${REPOS_CHECK[@]}"; do
        for SKILL_PATH in \
          "skills/$SKILL_NAME/SKILL.md" \
          "$SKILL_NAME/SKILL.md" \
          "SKILL.md" \
          "skills/$SKILL_NAME/skill.md" \
          "$SKILL_NAME/skill.md" \
          "skill.md"
        do
          REMOTE_SHA=""
          if REMOTE_SHA=$(gh api "repos/$REPO/contents/$SKILL_PATH" \
            --jq '.sha' 2>/dev/null); then
            :
          else
            REMOTE_SHA=""
          fi

          if [[ -n "$REMOTE_SHA" && "$REMOTE_SHA" != "null" && "$REMOTE_SHA" != *"Not Found"* ]]; then
            if [[ "$REMOTE_SHA" == "$LOCAL_SHA" ]]; then
              echo "✓ $SKILL_NAME is up to date"
              exit 0
            else
              echo "↻ $SKILL_NAME has been updated upstream, re-fetching..."
              rm -f "$SKILL_FILE" "$SHA_FILE"
              break 2
            fi
          fi
        done
      done
    fi
  fi
fi

# ── Fetch skill (pinned or latest) ───────────────────────────────────────────
if [[ -n "$PINNED_SHA" && -n "$PINNED_REPO" && -n "$PINNED_PATH" ]]; then
  # Fetch exact pinned version by SHA
  echo "→ Fetching pinned version of $SKILL_NAME from $PINNED_REPO"
  mkdir -p "$SKILL_DIR"

  RESPONSE=$(gh api "repos/$PINNED_REPO/contents/$PINNED_PATH" 2>/dev/null || echo "")
  if [[ -n "$RESPONSE" ]]; then
    CURRENT_SHA=$(echo "$RESPONSE" | jq -r '.sha')
    if [[ "$CURRENT_SHA" == "$PINNED_SHA" ]]; then
      echo "$RESPONSE" | jq -r '.content' | base64 --decode > "$SKILL_FILE"
      echo "$CURRENT_SHA" > "$SHA_FILE"
    else
      echo "⚠ Pinned SHA ($PINNED_SHA) no longer matches upstream."
      echo "  The file may have been updated. Use --thaw and --refresh to get the latest."
      exit 1
    fi
  else
    echo "✗ Could not fetch pinned version from $PINNED_REPO"
    exit 1
  fi

  if [[ -s "$SKILL_FILE" ]]; then
    echo "✓ Installed $SKILL_NAME from $PINNED_REPO (pinned)"
    INSTALLED_SHA=$(cat "$SHA_FILE" 2>/dev/null || echo "unknown")
    record_install "$SKILL_NAME" "$PINNED_REPO" "$PINNED_PATH" "$INSTALLED_SHA"
    exit 0
  else
    rm -f "$SKILL_FILE" "$SHA_FILE"
    echo "✗ Pinned fetch produced empty file"
    exit 1
  fi
fi

# ── Normal fetch (latest) ────────────────────────────────────────────────────
REPOS=(
  "anthropics/skills"
  "obra/superpowers"
  "mattpocock/skills"
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

      # Fetch content and SHA together
      RESPONSE=$(gh api "repos/$REPO/contents/$SKILL_PATH" 2>/dev/null || echo "")
      if [[ -z "$RESPONSE" ]]; then
        continue
      fi

      echo "$RESPONSE" | jq -r '.content' | base64 --decode > "$SKILL_FILE"
      echo "$RESPONSE" | jq -r '.sha' > "$SHA_FILE"

      if [[ -s "$SKILL_FILE" ]]; then
        # ── Safety scan ──────────────────────────────────────────────
        WARNINGS=""

        # Network exfiltration (actual invocations, not doc references)
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

        # Destructive file operations (exclude harmless patterns)
        if grep -iE 'rm\s+-rf\s+[~/\*]|rm\s+-rf\s+\$|shred' "$SKILL_FILE" 2>/dev/null \
          | grep -qivE 'rm\s+-rf\s+\$SKILL_DIR|rm\s+-f\s+\$SKILL_FILE'; then
          WARNINGS="${WARNINGS}  ⚠ Contains destructive file operations (rm -rf with broad paths)\n"
        fi

        # Base64 encode + send pattern (data exfiltration)
        if grep -qiE 'base64.*curl|base64.*wget|base64.*nc\b|encode.*send|encode.*post' "$SKILL_FILE" 2>/dev/null; then
          WARNINGS="${WARNINGS}  ⚠ Contains base64 encode + network send pattern (possible exfiltration)\n"
        fi

        # Disable safety (exclude anti-pattern docs and non-safety contexts)
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

        # Record to manifest
        INSTALLED_SHA=$(cat "$SHA_FILE" 2>/dev/null || echo "unknown")
        record_install "$SKILL_NAME" "$REPO" "$SKILL_PATH" "$INSTALLED_SHA"

        FOUND=1
        break 2
      else
        rm -f "$SKILL_FILE" "$SHA_FILE"
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
