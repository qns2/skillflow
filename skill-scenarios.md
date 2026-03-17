# Skill Scenarios

Standard mappings of common task types to upstream skills, with specific
checkpoint criteria for each. Used by:

- **AGENTS.md workflow** — step 2 auto-fetches based on scenario match
- **Checkpoint** — pass/fail criteria derived from the assigned skills
- **skill-creator** — when building custom project skills, start from the
  matching scenario and add domain-specific procedures on top

---

## Code Scenarios

### Feature Development

**Skills:**
| Skill | Source | Role |
|---|---|---|
| brainstorming | obra/superpowers | Shape the approach |
| writing-plans | obra/superpowers | Plan before coding |
| dev-engineering-super-skill | get-zeked | Architecture, code quality reference |
| test-driven-development | obra/superpowers | Red-green-refactor |
| requesting-code-review | obra/superpowers | Dispatch reviewer subagent |
| verification-before-completion | obra/superpowers | Evidence before done |

**Checkpoint:**
- [ ] Plan written and approved before any code?
- [ ] Tests written before implementation code?
- [ ] Tests watched failing before writing code?
- [ ] Code review subagent dispatched and issues addressed?
- [ ] All tests pass with evidence shown?

---

### Bug Fix

**Skills:**
| Skill | Source | Role |
|---|---|---|
| systematic-debugging | obra/superpowers | Root cause investigation |
| dev-engineering-super-skill | get-zeked | Debugging reference |
| test-driven-development | obra/superpowers | Regression test first |
| verification-before-completion | obra/superpowers | Evidence before done |

**Checkpoint:**
- [ ] Root cause identified before fix attempted?
- [ ] Hypothesis stated explicitly?
- [ ] Regression test written that reproduces the bug?
- [ ] Fix addresses root cause, not symptom?
- [ ] All tests pass with evidence shown?

---

### Frontend / UI

**Skills:**
| Skill | Source | Role |
|---|---|---|
| brainstorming | obra/superpowers | Shape the approach |
| writing-plans | obra/superpowers | Plan before coding |
| frontend-design | anthropics/skills | Production-grade interfaces |
| dev-engineering-super-skill | get-zeked | Frontend engineering reference |
| webapp-testing | anthropics/skills | Playwright testing |
| test-driven-development | obra/superpowers | Red-green-refactor |
| requesting-code-review | obra/superpowers | Dispatch reviewer subagent |
| verification-before-completion | obra/superpowers | Evidence before done |

**Checkpoint:**
- [ ] Plan written and approved before any code?
- [ ] Design approach reviewed (not generic AI aesthetics)?
- [ ] Tests written before implementation code?
- [ ] UI tested with Playwright or equivalent?
- [ ] Code review subagent dispatched and issues addressed?
- [ ] All tests pass with evidence shown?

---

### API / Backend

**Skills:**
| Skill | Source | Role |
|---|---|---|
| brainstorming | obra/superpowers | Shape the approach |
| writing-plans | obra/superpowers | Plan before coding |
| dev-engineering-super-skill | get-zeked | Backend engineering reference |
| test-driven-development | obra/superpowers | Red-green-refactor |
| requesting-code-review | obra/superpowers | Dispatch reviewer subagent |
| verification-before-completion | obra/superpowers | Evidence before done |

**Checkpoint:**
- [ ] Plan written and approved before any code?
- [ ] Tests written before implementation code?
- [ ] Error handling at system boundaries?
- [ ] Code review subagent dispatched and issues addressed?
- [ ] All tests pass with evidence shown?

---

### MCP Server

**Skills:**
| Skill | Source | Role |
|---|---|---|
| brainstorming | obra/superpowers | Shape the approach |
| mcp-builder | anthropics/skills | FastMCP / Node SDK patterns |
| dev-engineering-super-skill | get-zeked | Engineering reference |
| test-driven-development | obra/superpowers | Red-green-refactor |
| requesting-code-review | obra/superpowers | Dispatch reviewer subagent |
| verification-before-completion | obra/superpowers | Evidence before done |

**Checkpoint:**
- [ ] MCP server follows mcp-builder patterns?
- [ ] Tests written before implementation code?
- [ ] Code review subagent dispatched?
- [ ] Server tested end-to-end with evidence shown?

---

### Claude API Integration

**Skills:**
| Skill | Source | Role |
|---|---|---|
| claude-api | anthropics/skills | SDK patterns, streaming, tool use |
| dev-engineering-super-skill | get-zeked | Engineering reference |
| test-driven-development | obra/superpowers | Red-green-refactor |
| verification-before-completion | obra/superpowers | Evidence before done |

**Checkpoint:**
- [ ] Correct SDK and model used per claude-api skill?
- [ ] Tests written before implementation?
- [ ] Streaming and error handling implemented?
- [ ] All tests pass with evidence shown?

---

### Large Refactor

**Skills:**
| Skill | Source | Role |
|---|---|---|
| writing-plans | obra/superpowers | Plan the refactor |
| dev-engineering-super-skill | get-zeked | Engineering reference |
| test-driven-development | obra/superpowers | Tests pass before AND after |
| requesting-code-review | obra/superpowers | Dispatch reviewer subagent |
| using-git-worktrees | obra/superpowers | Isolate the work |
| verification-before-completion | obra/superpowers | Evidence before done |

**Checkpoint:**
- [ ] All existing tests pass BEFORE refactor started?
- [ ] Refactor planned and approved?
- [ ] Work isolated in a worktree or branch?
- [ ] No behavior changes — same tests, same results?
- [ ] Code review subagent dispatched?
- [ ] All tests pass AFTER refactor with evidence shown?

---

### Multi-task Execution

**Skills:**
| Skill | Source | Role |
|---|---|---|
| dispatching-parallel-agents | obra/superpowers | Concurrent independent tasks |
| subagent-driven-development | obra/superpowers | Fresh subagent per task |
| executing-plans | obra/superpowers | Follow plan with checkpoints |

**Checkpoint:**
- [ ] Tasks are genuinely independent (no shared state)?
- [ ] Each subagent got precise context (not full session history)?
- [ ] Two-stage review after each task (spec compliance + code quality)?
- [ ] All tasks verified independently?

---

## Business Scenarios

### Business Plan

**Skills:**
| Skill | Source | Role |
|---|---|---|
| brainstorming | obra/superpowers | Shape the idea |
| research-knowledge-super-skill | get-zeked | Market research, competitive analysis |
| finance-super-skill | get-zeked | Financial projections, P&L, sensitivity |
| doc-coauthoring | anthropics/skills | Structured writing, reader testing |
| writing-plans | obra/superpowers | Plan before writing |
| verification-before-completion | obra/superpowers | Verify before done |

**Checkpoint:**
- [ ] Market data has source citations?
- [ ] Competitive landscape researched (not assumed)?
- [ ] Financial projections include sensitivity analysis (at least one variable)?
- [ ] Unit economics calculated with stated assumptions?
- [ ] Document reader-tested by fresh subagent?
- [ ] All spec requirements verified with evidence?

---

### Marketing Plan

**Skills:**
| Skill | Source | Role |
|---|---|---|
| brainstorming | obra/superpowers | Shape the approach |
| marketing-super-skill | get-zeked | Campaigns, SEO, analytics, competitive intelligence |
| research-knowledge-super-skill | get-zeked | Market research |
| doc-coauthoring | anthropics/skills | Document structure |
| verification-before-completion | obra/superpowers | Verify before done |

**Checkpoint:**
- [ ] Target audience defined with evidence?
- [ ] Channel strategy based on research (not assumptions)?
- [ ] Budget allocated with CAC/LTV estimates?
- [ ] Competitive positioning researched?
- [ ] Document reader-tested by fresh subagent?

---

### Sales Strategy

**Skills:**
| Skill | Source | Role |
|---|---|---|
| brainstorming | obra/superpowers | Shape the approach |
| sales-super-skill | get-zeked | Prospecting, pipeline, objection handling |
| research-knowledge-super-skill | get-zeked | Prospect research |
| doc-coauthoring | anthropics/skills | Document structure |
| verification-before-completion | obra/superpowers | Verify before done |

**Checkpoint:**
- [ ] Pipeline stages defined?
- [ ] Outreach sequences drafted (not generic)?
- [ ] Objection handling prepared for top 5 objections?
- [ ] Target prospect criteria defined?
- [ ] Document reader-tested by fresh subagent?

---

### Financial Model

**Skills:**
| Skill | Source | Role |
|---|---|---|
| finance-super-skill | get-zeked | P&L, cash flow, forecasting, ratio analysis |
| xlsx | anthropics/skills | Excel export with formatting |
| verification-before-completion | obra/superpowers | Verify before done |

**Checkpoint:**
- [ ] P&L, cash flow, and break-even included?
- [ ] All assumptions explicitly stated?
- [ ] Sensitivity analysis on at least 2 variables?
- [ ] Formulas verified (no circular references, no errors)?
- [ ] Excel output formatted and readable?

---

### Pitch Deck

**Skills:**
| Skill | Source | Role |
|---|---|---|
| brainstorming | obra/superpowers | Shape the narrative |
| research-knowledge-super-skill | get-zeked | Data-backed claims |
| pptx | anthropics/skills | PowerPoint creation |
| verification-before-completion | obra/superpowers | Verify before done |

**Checkpoint:**
- [ ] Data claims have sources?
- [ ] Clear ask / call-to-action on final slide?
- [ ] 10-15 slides max?
- [ ] Narrative arc: problem → solution → market → traction → team → ask?

---

### Product Spec / PRD

**Skills:**
| Skill | Source | Role |
|---|---|---|
| brainstorming | obra/superpowers | Shape the product |
| pm-super-skill | get-zeked | PRDs, roadmap, RICE/MoSCoW, OKRs |
| doc-coauthoring | anthropics/skills | Document structure |
| writing-plans | obra/superpowers | Implementation plan |
| verification-before-completion | obra/superpowers | Verify before done |

**Checkpoint:**
- [ ] Problem statement clear and validated?
- [ ] Success metrics defined (OKRs or equivalent)?
- [ ] Features prioritized (RICE, MoSCoW, or similar framework)?
- [ ] Scope explicitly defined (what's in AND what's out)?
- [ ] Document reader-tested by fresh subagent?

---

### Legal / Compliance Review

**Skills:**
| Skill | Source | Role |
|---|---|---|
| legal-super-skill | get-zeked | Contract review, compliance, risk assessment |
| research-knowledge-super-skill | get-zeked | Regulatory research |
| doc-coauthoring | anthropics/skills | Document structure |
| verification-before-completion | obra/superpowers | Verify before done |

**Checkpoint:**
- [ ] Applicable regulations identified and cited?
- [ ] Risk assessment completed?
- [ ] Recommendations actionable (not just "consult a lawyer")?
- [ ] Document reviewed for accuracy?

---

### Content / Creative

**Skills:**
| Skill | Source | Role |
|---|---|---|
| brainstorming | obra/superpowers | Shape the creative direction |
| content-creative-super-skill | get-zeked | Video, image, web, brand |
| frontend-design | anthropics/skills | If web-based |
| verification-before-completion | obra/superpowers | Verify before done |

**Checkpoint:**
- [ ] Creative direction approved before production?
- [ ] Brand guidelines followed (if applicable)?
- [ ] Output tested in target format/medium?
- [ ] Quality verified with evidence?

---

## Creating Custom Project Skills

When a task requires domain knowledge not covered by upstream skills
(e.g., maritime sector, healthcare compliance, real estate), use the
`skill-creator` skill (anthropics/skills) to build a custom project skill.

**Process:**
1. Identify the matching standard scenario above
2. Fetch `skill-creator` from anthropics/skills
3. Tell skill-creator:
   - The standard scenario and its skills (as the base)
   - The domain knowledge gap to fill
   - The checkpoint criteria from the scenario
4. skill-creator will:
   - Interview you about the domain
   - Draft a PROJECT-SKILL.md that combines the standard procedures with domain knowledge
   - Test it against sample prompts
   - Iterate until it works
5. The custom skill replaces the standard scenario for this project
6. Checkpoint criteria carry over from the standard scenario, plus any domain-specific checks

**Example:**
- Task: "Build a business plan for a maritime startup"
- Standard scenario: Business Plan (above)
- Domain gap: Maritime industry knowledge (regulations, classification societies, charter market dynamics)
- Custom skill: `rightyacht-bp/SKILL.md` — combines business plan procedures with maritime context
- Extra checkpoint: "Maritime regulations correctly referenced? Classification society landscape accurate?"
