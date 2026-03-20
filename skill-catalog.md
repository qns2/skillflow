# Skill Catalog

Available skills that can be fetched on demand. Use `bash .agents/fetch-skill.sh <name> <repo>`.

**Last updated:** 2026-03-20

To refresh, run:
```bash
gh api repos/anthropics/skills/git/trees/HEAD:skills --jq '.tree[].path'
gh api repos/obra/superpowers/git/trees/HEAD:skills --jq '.tree[].path'
gh api repos/mattpocock/skills/git/trees/HEAD --jq '.tree[].path'
gh api repos/trailofbits/skills/git/trees/HEAD:plugins --jq '.tree[].path'
gh api repos/affaan-m/everything-claude-code/git/trees/HEAD --jq '.tree[].path'
```

## Development Process — obra/superpowers

| Skill | Description |
|---|---|
| brainstorming | Interactive brainstorming before any code. Explores intent, requirements, design. Requires human approval before proceeding. |
| writing-plans | Write implementation plans assuming zero codebase context. Covers files, code, testing, docs. Emphasizes DRY, YAGNI, TDD. |
| executing-plans | Load a written plan, review critically, execute all tasks with review checkpoints. |
| test-driven-development | Write test first, watch it fail, write minimal code to pass. For all new features and bug fixes. |
| systematic-debugging | Root cause investigation before any fix. Symptom fixes are treated as failure. |
| requesting-code-review | Dispatch a code-reviewer subagent to catch issues. Mandatory after major features and before merging. |
| receiving-code-review | Handle incoming review feedback with technical rigor. Verify before implementing suggestions. |
| verification-before-completion | Run verification commands and confirm output before claiming work is done. Evidence before assertions. |
| dispatching-parallel-agents | Dispatch one agent per independent problem domain to work concurrently with isolated context. |
| subagent-driven-development | Execute plans by dispatching a fresh subagent per task with two-stage review after each. |
| finishing-a-development-branch | Guide completion when implementation is done. Present options for merge, PR, or cleanup. |
| using-git-worktrees | Create isolated git worktrees for feature work or plan execution. |
| writing-skills | Create, edit, or verify skills. TDD methodology applied to process documentation. |
| using-superpowers | Meta-skill: how to find and use other skills. |

## Documents & Media — anthropics/skills

| Skill | Description |
|---|---|
| docx | Create, read, edit Word documents. Tables of contents, headings, page numbers, letterheads. |
| pdf | Full PDF processing: read, merge, split, rotate, watermark, create, fill forms, OCR. |
| pptx | Create, read, edit PowerPoint files. Slide decks, pitch decks, templates, speaker notes. |
| xlsx | Create, read, edit spreadsheets. Formulas, formatting, charting, data cleaning. Zero formula errors. |
| doc-coauthoring | Structured co-authoring workflow: context gathering, refinement, reader testing. |
| internal-comms | Write internal communications: 3P updates, newsletters, FAQs, status reports, incident reports. |

## Design & Frontend — anthropics/skills

| Skill | Description |
|---|---|
| frontend-design | Production-grade frontend interfaces with high design quality. Avoids generic AI aesthetics. |
| canvas-design | Create visual art in PNG/PDF using design philosophy. Posters, static art, visual design. |
| web-artifacts-builder | Multi-component HTML artifacts with React 18, TypeScript, Vite, Tailwind, shadcn/ui. |
| theme-factory | Style artifacts with themes. 10 pre-set themes or generate new ones on-the-fly. |
| brand-guidelines | Apply brand colors and typography. Color palettes, font pairings, visual identity. |
| algorithmic-art | Generative art with p5.js. Flow fields, particle systems, seeded randomness. |
| slack-gif-creator | Create animated GIFs optimized for Slack emoji and message sizes. |

## Development Tools — anthropics/skills

| Skill | Description |
|---|---|
| claude-api | Build apps with Claude API or Anthropic SDK. Language detection, streaming, adaptive thinking. |
| mcp-builder | Create MCP servers for LLM-to-service integration. Python (FastMCP) and Node/TypeScript. |
| webapp-testing | Test local web apps with Playwright. Screenshots, browser logs, UI verification. |
| skill-creator | Create and measure skill performance. Evals, benchmarking, description optimization. |

## Cross-Domain — get-zeked (standalone repos)

Fetch with: `bash .agents/fetch-skill.sh <skill-name> get-zeked/<skill-name>`

| Skill | Description |
|---|---|
| **dev-engineering-super-skill** | **REQUIRED.** Architecture, frontend, backend, fullstack, QA/testing, DevOps, CI/CD, code review, security, debugging, TDD. |
| ai-agent-super-skill | Agent architecture (ReAct, Plan-Execute), MCP servers, RAG pipelines, subagent coordination, prompt engineering. |
| marketing-super-skill | Content creation, SEO, campaign planning, demand gen, analytics, competitive intelligence, PMM, ASO. |
| sales-super-skill | Prospecting, outreach sequences, objection handling, pipeline management, customer interviews, RICE prioritization. |
| finance-super-skill | Financial statements, month-end close, audit prep, investment research, ML forecasting, data engineering. |
| legal-super-skill | Contract review & redlining, NDA triage, compliance (GDPR/CCPA), risk assessment, legal writing. |
| pm-super-skill | Feature specs/PRDs, roadmap prioritization (RICE/MoSCoW), sprint/agile ops, metrics/OKRs, UX research, design systems. |
| operations-cx-super-skill | Ticket triage, customer responses, escalation workflows, KB management, sprint ops, quality verification. |
| research-knowledge-super-skill | Deep research workflows, knowledge graphs, content extraction, data exploration, statistical analysis, visualization. |
| content-creative-super-skill | Video, speech, image generation, web building, canvas design, algorithmic art, brand guidelines, frontend design. |

## Architecture & Planning — mattpocock/skills

| Skill | Description |
|---|---|
| design-an-interface | Spawn parallel subagents to generate radically different API/interface designs, then compare. "Design it twice" pattern. |
| write-a-prd | Create a PRD through user interview, codebase exploration, and module design. Submits as GitHub issue. |
| prd-to-plan | Turn a PRD into phased implementation using tracer-bullet vertical slices. Saved as local markdown. |
| improve-codebase-architecture | Explore codebase for architectural improvements. Focus on testability and deepening shallow modules. |
| request-refactor-plan | Create detailed refactor plan with tiny commits via user interview. Filed as GitHub issue. |
| git-guardrails-claude-code | Set up Claude Code hooks to block destructive git commands (push, reset --hard, clean, branch -D). |
| grill-me | Devil's advocate — challenges your assumptions and plans before you commit to them. |
| ubiquitous-language | Enforce consistent terminology across a codebase. Useful for larger projects with domain language. |

## Security — trailofbits/skills

Skills are under `plugins/` directory. Fetch with: `bash .agents/fetch-skill.sh <name> trailofbits/skills`

Note: fetch-skill.sh will find these automatically under the `plugins/` path pattern.

| Skill | Description |
|---|---|
| property-based-testing | Property-based testing (Hypothesis, QuickCheck, fuzzing) for multiple languages and smart contracts. Different paradigm from TDD. |
| supply-chain-risk-auditor | Audit dependency supply chain: popularity, maintainers, CVEs, maintenance frequency. |
| static-analysis | Integrated CodeQL + Semgrep + SARIF parsing pipeline for vulnerability detection. |
| variant-analysis | Find similar vulnerabilities across codebases using pattern-based analysis. "Given one bug, find all like it." |
| semgrep-rule-creator | Create production-quality Semgrep rules for detecting bug patterns and security vulnerabilities. |
| semgrep-rule-variant-creator | Port existing Semgrep rules to new target languages with applicability analysis. |
| agentic-actions-auditor | Audit GitHub Actions workflows for security vulnerabilities in AI agent integrations. |
| building-secure-contracts | Smart contract security toolkit (Slither, Echidna, Medusa) based on Trail of Bits framework. |
| constant-time-analysis | Detect timing side-channel vulnerabilities in compiled cryptographic code. |
| entry-point-analyzer | Map attack surface entry points in smart contract codebases for security audits. |
| firebase-apk-scanner | Scan Android APKs for Firebase security misconfigurations (open DBs, exposed storage, auth bypasses). |
| fp-check | Systematic false positive verification when verifying suspected security bugs. |
| insecure-defaults | Detect insecure default configurations that create vulnerabilities. |
| seatbelt-sandboxer | Generate macOS Seatbelt sandbox configurations with minimum required permissions. |
| sharp-edges | Identify error-prone APIs, dangerous configurations, and footgun designs. |
| spec-to-code-compliance | Specification-to-code compliance checker for blockchain audits. |
| yara-authoring | Behavior-driven authoring of YARA-X detection rules for malware/threat detection. |
| zeroize-audit | Audit C/C++/Rust code for missing zeroization and compiler-removed memory wipes. |
| audit-context-building | Build deep architectural context through ultra-granular code analysis before vulnerability hunting. |
| burpsuite-project-parser | Extract and search data from Burp Suite .burp project files. |
| dwarf-expert | Analyze DWARF debug format files and write DWARF parsers. |
| testing-handbook-skills | Auto-generate security testing skills from Trail of Bits' Application Security Testing Handbook. |

## AI & Agent Operations — affaan-m/everything-claude-code

Fetch with: `bash .agents/fetch-skill.sh <name> affaan-m/everything-claude-code`

| Skill | Description |
|---|---|
| architecture-decision-records | Auto-capture architectural decisions as structured ADRs with context, alternatives, and rationale. |
| context-budget | Audit Claude Code context window consumption across agents, skills, MCP servers. Identify bloat and produce token-savings recommendations. |
| deep-research | Multi-source deep research using Firecrawl and Exa MCPs with cited reports and source attribution. |
| ai-regression-testing | Regression testing strategies for AI-assisted development. Catch blind spots where the same model writes and reviews code. |
| eval-harness | Formal evaluation framework for Claude Code sessions implementing eval-driven development (EDD). |
| video-editing | AI-assisted video editing: cutting, structuring footage through FFmpeg, Remotion, ElevenLabs, fal.ai, Descript. |
| agent-eval | Head-to-head comparison of coding agents (Claude Code, Aider, Codex) on custom tasks with pass rate, cost, time metrics. |
| agent-harness-construction | Design and optimize AI agent action spaces, tool definitions, and observation formatting. |
| ai-first-engineering | Engineering operating model for teams where AI agents generate a large share of implementation output. |
| continuous-learning-v2 | Self-improving agent system that observes sessions, creates atomic instincts with confidence scoring, evolves them into skills. |
| cost-aware-llm-pipeline | Cost optimization patterns for LLM API usage: model routing, budget tracking, retry logic, prompt caching. |
| data-scraper-agent | Build fully automated AI-powered data collection agents running on GitHub Actions with LLM enrichment. |
| enterprise-agent-ops | Production operations for AI agents: observability, security boundaries, lifecycle management. |
| fal-ai-media | Unified media generation via fal.ai: image, video, audio generation (text-to-image, TTS, video-to-audio). |
| iterative-retrieval | Pattern for progressively refining context retrieval to solve the subagent context problem. |
| nutrient-document-processing | Process, convert, OCR, extract, redact, sign, and fill documents using the Nutrient DWS API. |
| content-hash-cache-pattern | Cache expensive file processing using SHA-256 content hashes. Path-independent, auto-invalidating. |
| foundation-models-on-device | Apple FoundationModels framework for on-device LLM in iOS 26+. |
| liquid-glass-design | iOS 26 Liquid Glass design system patterns for SwiftUI, UIKit, and WidgetKit. |

## Extended Sources

For skills beyond this catalog, browse these repos directly:

| Repo | Skills | Focus |
|---|---|---|
| [trailofbits/skills](https://github.com/trailofbits/skills) | 35 | Security analysis, smart contracts, binary analysis |
| [affaan-m/everything-claude-code](https://github.com/affaan-m/everything-claude-code) | 116 | Language patterns, infrastructure, AI agent ops |
| [VoltAgent/awesome-agent-skills](https://github.com/VoltAgent/awesome-agent-skills) | 549+ | Curated index from Stripe, Vercel, Cloudflare, HashiCorp, and more |
