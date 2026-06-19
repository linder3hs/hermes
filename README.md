# Hermes 🪽

AI-powered project creation system for Claude Code. Guides you from zero to production-ready web app through a conversational decision tree — no stale templates, always uses the latest official CLIs.

## What it does

**Two modes:**
- `/new-project` — guided creation from scratch (stack + services + UI style)
- `/project-health` — analyzes existing projects and fills gaps

**On session start**, Hermes auto-detects your context and tells you what to run next.

## Install

**1. Add to `~/.claude/settings.json`:**

```json
{
  "extraKnownMarketplaces": {
    "hermes": {
      "source": {
        "source": "github",
        "repo": "linder3hs/hermes"
      }
    }
  },
  "enabledPlugins": {
    "hermes@hermes": true
  }
}
```

> If `extraKnownMarketplaces` or `enabledPlugins` already exist in your file, just add the `"hermes"` entries inside them.

**2. Restart Claude Code** (exit and run `claude` again in your terminal).

On next startup the plugin downloads automatically. You'll see `Hermes initializing...` in the status and `/new-project` + `/project-health` will be available as slash commands.

## Usage

```
/new-project              # Full guided flow — asks about stack, services, UI
/new-project saas         # Skip the tree, use a preset
/project-health           # Analyze and improve an existing project
```

## Presets

Skip the full decision tree with a named preset:

| Preset | Stack |
|--------|-------|
| `minimal` | Next.js + Tailwind + shadcn/ui |
| `saas` | + Clerk + Neon/Drizzle + Stripe + Resend |
| `ai-app` | + Vercel AI SDK + AI Gateway + Neon/Drizzle |
| `dashboard` | + TanStack Query + tRPC + Neon/Drizzle |
| `marketing` | Astro + Tailwind + shadcn/ui + Resend |

Each preset still runs the UI stylist — pick your color theme, dark mode, font, and icon set.

## Web Stack Coverage

| Layer | Options |
|-------|---------|
| Framework | Next.js 15 App Router, Remix, Astro |
| Data | TanStack Query + tRPC, Server Actions |
| UI | shadcn/ui, Radix UI, Mantine, Chakra UI |
| CSS | Tailwind v4, CSS Modules |
| Auth | Clerk, NextAuth v5, Lucia |
| DB | Neon, Supabase, Turso |
| ORM | Drizzle, Prisma |
| Payments | Stripe (checkout + webhooks + portal) |
| Email | Resend, Sendgrid |
| Storage | Vercel Blob, S3/R2 |
| AI | Vercel AI SDK + AI Gateway |
| Deploy | Vercel, Railway |

## Philosophy

- **Prompts > templates** — delegates to official CLIs (`npx create-next-app@latest`, etc.), never copies stale code
- **Never hardcodes versions** — always uses `@latest`
- **Infers before asking** — reads your `package.json` and codebase, doesn't interrogate you
- **Fully wired services** — SDK + env vars + example file, or not at all
- **CLAUDE.md in every project** — decisions documented so future sessions have context

## Agents

| Agent | Role |
|-------|------|
| `hermes` | Orchestrator — routes to the right specialist |
| `web-architect` | Stack + services decision tree |
| `ui-stylist` | Component library, theme, dark mode, fonts, icons |
| `project-doctor` | Analyzes and improves existing projects |

## Roadmap

- [ ] Phase 2: Mobile (React Native / Expo)
- [ ] Phase 3: Desktop (Tauri)
- [ ] Phase 4: Backend (FastAPI, Hono, NestJS)
- [ ] Phase 5: Monorepo (next-forge style)
