# Hermes Plugin

AI-powered project creation and improvement system for Claude Code.

## Philosophy

- **Prompts > Templates** — delegate to official CLIs, never copy stale code
- **Never hardcode versions** — always use `@latest` or let the CLI decide
- **Infer before asking** — read the code, don't interrogate the user
- **Every service fully wired** — SDK + env vars + example file, or don't add it at all
- **CLAUDE.md in every project** — document decisions so future sessions have context

## Supported Web Stacks (Phase 1)

### Frameworks
- Next.js 15 App Router
- Remix
- Astro

### UI
- shadcn/ui + Tailwind v4 (primary)
- Radix UI, Mantine, Chakra UI (alternatives)

### Auth
- Clerk (recommended), NextAuth v5, Lucia

### Database
- Neon (Postgres) + Drizzle (recommended)
- Supabase, Turso (SQLite)
- Prisma as alternative ORM

### Services
- Payments: Stripe (checkout + webhooks + portal)
- Email: Resend, Sendgrid
- Storage: Vercel Blob, S3-compatible
- AI: Vercel AI SDK + AI Gateway

### Deploy
- Vercel (recommended), Railway, Self-hosted

## Agent Routing

| Situation | Agent |
|-----------|-------|
| New project, any type | hermes → web-architect → ui-stylist |
| Named preset requested | hermes → web-architect (preset mode) → ui-stylist |
| Existing project, add service | hermes → project-doctor |
| Existing project, add dark mode | hermes → project-doctor |
| Generate CLAUDE.md | project-doctor |
| Audit project | project-doctor |

## What NOT to Do

- Don't generate `package-lock.json` or `yarn.lock`
- Don't hardcode specific package versions (use `@latest`)
- Don't ask "what framework are you using?" when `package.json` is readable
- Don't scaffold partial integrations — if Stripe, include webhooks + portal, not just the SDK
- Don't add `// TODO` placeholders — either implement it or leave it out

## Phase 2 Roadmap

- Mobile: React Native / Expo
- Desktop: Tauri
- Backend: FastAPI, Hono, NestJS
- Monorepo: next-forge style with shared packages
