# Skill Catalog

Available skills that can be fetched on demand. Use `bash .agents/fetch-skill.sh <name> <repo>`.

**Last updated:** 2026-03-17

To refresh, run:
```bash
gh api repos/anthropics/skills/git/trees/HEAD:skills --jq '.tree[].path'
gh api repos/obra/superpowers/git/trees/HEAD:skills --jq '.tree[].path'
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
