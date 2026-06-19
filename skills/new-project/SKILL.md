---
name: new-project
description: This skill should be used when the user wants to create a new web project from scratch. Triggers the full guided flow: stack decisions (web-architect) → UI style (ui-stylist) → scaffold execution. Supports presets for fast setup. Examples: "create a new project", "start a new SaaS app", "new project with Next.js", "/new-project saas", "build me a dashboard app".
allowed-tools:
  - Bash
  - Read
  - Write
  - Edit
  - AskUserQuestion
---

## Purpose

Guide the creation of a new production-ready web project from scratch using a conditional decision tree. Delegates to `web-architect` and `ui-stylist` agents, then executes the scaffold.

## Usage

```
/new-project              # Full guided flow
/new-project [preset]     # Skip tree, use preset (minimal/saas/ai-app/dashboard/marketing)
/new-project --list       # Show available presets
```

## Flow

1. **Detect** — check if current directory is empty or already a project
2. **web-architect** — stack + services decisions (or load preset)
3. **ui-stylist** — component library, theme, dark mode, font, icons
4. **Confirm** — show full summary before executing
5. **Scaffold** — run CLIs, install deps, create config files, write CLAUDE.md

## Scaffold Sequence

After all decisions are confirmed, execute in order:

```bash
# 1. Create base project
npx create-next-app@latest . --typescript --tailwind --eslint --app --src-dir --import-alias "@/*"
# (adapt command for Remix or Astro if chosen)

# 2. Initialize shadcn/ui (if chosen)
npx shadcn@latest init

# 3. Install service SDKs
npm install [chosen services]@latest

# 4. Generate config files
# tailwind.config.ts, globals.css, theme-provider, etc.
```

## Agent Prompts

Load these files for detailed decision logic:

- [Hermes Orchestrator](agents/hermes.md) — context detection and routing
- [Web Architect](agents/web-architect.md) — stack + services decision tree
- [UI Stylist](agents/ui-stylist.md) — component library, theme, dark mode, fonts, icons

## Reference Files

- [Web Stacks](references/web-stacks.md) — framework options and tradeoffs
- [Presets](references/presets.md) — predefined stack combinations
- [UI Options](references/ui-options.md) — component libraries, themes, dark mode
- [Services](references/services.md) — auth, payments, email, storage, AI options
- [App Shells](references/app-shells.md) — complete base files per project type (layout, sidebar/navbar, home page)
