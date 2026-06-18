---
name: project-health
description: This skill should be used when the user wants to analyze, audit, or improve an existing project. Triggers project-doctor to infer the current stack and surface gaps and improvement opportunities. Examples: "check my project", "what's missing in this codebase", "audit my project", "generate a CLAUDE.md", "add dark mode to my existing project", "/project-health".
allowed-tools:
  - Bash
  - Read
  - Write
  - Edit
  - AskUserQuestion
---

## Purpose

Analyze an existing project, surface gaps, and offer targeted improvements. No templates — adapts to what's already there.

## Usage

```
/project-health           # Full analysis + improvement options
/project-health --claude  # Only generate/update CLAUDE.md
/project-health --add [service]  # Add a specific service (stripe/auth/email/ai/darkmode)
```

## Flow

1. **Silent read** — `package.json`, folder structure, `CLAUDE.md`, config files
2. **Report** — project snapshot with what's present and what's missing
3. **Offer actions** — tailored to what the project needs
4. **Execute** — install, scaffold, configure the chosen improvements
5. **Update CLAUDE.md** — add or create with current state

## Reference Files

- [Health Checklist](references/checklist.md) — what a production-ready project should have
