# Hermes 🪽

AI-powered project creation system for Claude Code. Guides you from zero to a production-ready web app — complete layout, navigation, theme, fonts, and service integrations — through a conversational decision tree. No stale templates, always delegates to official CLIs.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/linder3hs/hermes/main/install.sh | bash
```

Then restart Claude Code (`Ctrl+C` → `claude`).

> **Manual install:** Add to `~/.claude/settings.json`:
> ```json
> {
>   "extraKnownMarketplaces": {
>     "hermes": { "source": { "source": "github", "repo": "linder3hs/hermes" } }
>   },
>   "enabledPlugins": { "hermes@hermes": true }
> }
> ```

## Usage

```
/new-project              # Full guided flow
/new-project saas         # Skip tree, use a preset
/project-health           # Analyze and improve an existing project
```

On session start, Hermes auto-detects your context and surfaces the right command.

## What you get

Every generated project includes:

- ✅ Working layout (sidebar for dashboards, navbar for SaaS, chat UI for AI apps)
- ✅ Geist font wired via `next/font`
- ✅ Dark mode toggle (next-themes)
- ✅ Full shadcn/ui theme (CSS variables, light + dark)
- ✅ All chosen services fully wired (SDK + env vars + example files)
- ✅ `CLAUDE.md` with stack decisions documented
- ✅ Build verified before finishing

## Presets

| Preset | Stack |
|--------|-------|
| `minimal` | Next.js + Tailwind + shadcn/ui |
| `saas` | + Clerk + Neon/Drizzle + Stripe + Resend |
| `ai-app` | + Vercel AI SDK + Neon/Drizzle + Clerk |
| `dashboard` | + TanStack Query + tRPC + Neon/Drizzle + Clerk |
| `marketing` | Astro + Tailwind + shadcn/ui + Resend |

Each preset still asks for your UI preferences (theme color, dark mode, font).

## Services supported

| Layer | Options |
|-------|---------|
| Framework | Next.js 15 App Router, Remix, Astro |
| Data | TanStack Query + tRPC, Server Actions |
| UI | shadcn/ui, Radix UI, Mantine, Chakra UI |
| Auth | Clerk, NextAuth v5, Lucia |
| DB | Neon, Supabase, Turso |
| ORM | Drizzle, Prisma |
| Payments | Stripe (checkout + webhooks + portal) |
| Email | Resend, Sendgrid |
| Storage | Vercel Blob, S3/R2 |
| AI | Vercel AI SDK + AI Gateway |
| Deploy | Vercel, Railway |

## Project Doctor (`/project-health`)

For existing projects:
- Reads `package.json` and infers your stack — no interrogation
- Reports what's present (✅) and what's missing (❌)
- Adds services one at a time (Stripe, AI chat, dark mode, etc.)
- Generates or updates `CLAUDE.md`
- Runs a full production checklist on demand

## Uninstall

```bash
curl -fsSL https://raw.githubusercontent.com/linder3hs/hermes/main/uninstall.sh | bash
```

## Philosophy

- **Prompts > templates** — delegates to official CLIs, never copies stale code
- **Never hardcodes versions** — always uses `@latest`
- **Infers before asking** — reads your codebase, doesn't interrogate you
- **Complete or nothing** — every service is fully wired, not half-scaffolded
- **Build must pass** — verifies compilation before reporting done

## Roadmap

- [ ] Mobile: React Native / Expo
- [ ] Desktop: Tauri
- [ ] Backend: FastAPI, Hono, NestJS
- [ ] Monorepo: next-forge style
