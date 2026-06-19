---
name: new-project
description: This skill should be used when the user wants to create a new web project from scratch. Guides through stack, services, and UI decisions, then scaffolds a complete production-ready app — layout, navigation, fonts, animations, DX tools, testing, security, and observability. Supports presets. Examples: "create a new project", "start a new SaaS app", "/new-project saas", "build me a dashboard", "create an AI chat app".
allowed-tools:
  - Bash
  - Read
  - Write
  - Edit
  - AskUserQuestion
---

You are Hermes. Run every step below in order. Do not skip any step. Do not abbreviate file contents.

## Step 1 — Detect context

```bash
ls package.json 2>/dev/null && echo "EXISTS" || echo "EMPTY"
```

If the directory already has a project: stop and say "This directory already has a project. Use `/project-health` instead."

---

## Step 2 — Gather decisions

**If the user passed a preset**, load from this table and confirm:

| Preset | Framework | Auth | DB | Payments | Email | AI |
|--------|-----------|------|----|----------|-------|----|
| `minimal` | Next.js | — | — | — | — | — |
| `saas` | Next.js | Clerk | Neon+Drizzle | Stripe | Resend | — |
| `saas-selfhosted` | Next.js | Better Auth | Neon+Drizzle | Stripe | Resend | — |
| `ai-app` | Next.js | Clerk | Neon+Drizzle | — | — | Vercel AI SDK |
| `dashboard` | Next.js | Clerk | Neon+Drizzle | — | — | — |
| `marketing` | Astro | — | — | — | Resend | — |

Confirm: "I'll set up [preset]. Anything to add or remove?"

**If no preset**, ask in this exact order:

```
1. App type? → SaaS / Dashboard / AI app / Marketing / E-commerce / Internal tool

2. Framework? → Next.js 15 [default] / Remix / Astro

3. Data? (skip for Astro)
   → Server Actions [simple] / TanStack Query + tRPC [dashboards/complex]

4. Database? → None / Neon + Drizzle [recommended] / Supabase / Turso

5. Auth?
   → None
   → Clerk [hosted, best DX, pricey at scale]
   → Better Auth [self-hosted, RBAC, orgs, passkeys — free]
   → NextAuth v5 [legacy, maintenance-only — not recommended]

6. Payments? → None / Stripe

7. Email? → None / Resend / Sendgrid

8. AI? → None / Chat (Vercel AI SDK) / RAG / Agents

9. Observability? (multi-select)
   → Sentry [error tracking]
   → PostHog [analytics + feature flags]
   → Vercel Analytics [lightweight, zero-config]
   → Arcjet [rate limiting + bot protection + security]

10. i18n? → No [default] / Yes (next-intl, locales: en + one more)

11. Deploy? → Vercel [default] / Railway / Self-hosted

12. UI theme? → Zinc [default] / Slate / Stone / Gray / Custom hex

13. Dark mode? → User toggle [default] / System only / No

14. Font? → Geist [default] / Inter / Custom Google Font

15. Icons? → Lucide [default] / Heroicons / Phosphor
```

---

## Step 3 — Confirm and scaffold base

Show decision summary, ask for confirmation, then execute:

### Next.js
```bash
npx create-next-app@latest . --typescript --tailwind --eslint --app --src-dir --import-alias "@/*" --yes
```

### Astro
```bash
npm create astro@latest . -- --template minimal --typescript strict --install --yes
npx astro add tailwind --yes
```

---

## Step 4 — Core dependencies

```bash
# Always
npm install geist next-themes lucide-react clsx tailwind-merge zod@^4

# shadcn/ui
npx shadcn@latest init --yes --defaults

# shadcn components (dashboard/SaaS)
npx shadcn@latest add card button badge avatar dropdown-menu separator sheet skeleton tooltip form input label textarea select

# DX tools
npm install --save-dev @biomejs/biome husky lint-staged @commitlint/cli @commitlint/config-conventional

# Testing
npm install --save-dev vitest @vitejs/plugin-react jsdom @testing-library/react @testing-library/jest-dom @testing-library/user-event

# Forms
npm install react-hook-form @hookform/resolvers
```

---

## Step 5 — Service dependencies (chosen ones only)

```bash
# Clerk
npm install @clerk/nextjs

# Better Auth
npm install better-auth

# Neon + Drizzle
npm install drizzle-orm @neondatabase/serverless drizzle-kit

# Stripe
npm install stripe @stripe/stripe-js

# Resend
npm install resend

# Vercel AI SDK
npm install ai @ai-sdk/openai

# TanStack Query + tRPC
npm install @tanstack/react-query @trpc/client @trpc/server @trpc/react-query @trpc/next

# Sentry
npm install @sentry/nextjs

# PostHog
npm install posthog-js posthog-node

# Vercel Analytics
npm install @vercel/analytics @vercel/speed-insights

# Arcjet
npm install @arcjet/next

# next-intl
npm install next-intl
```

---

## Step 6 — Generate config files

Read `skills/new-project/references/config-files.md` and `skills/new-project/references/dx-tools.md`.

Generate ALL of these files:

1. **`tailwind.config.ts`** — font mapping, custom keyframes, animations. MANDATORY.
2. **`src/app/globals.css`** — HSL variables for chosen theme (light + dark). MANDATORY.
3. **`next.config.ts`** — PPR, React Compiler, View Transitions, security headers. MANDATORY.
4. **`biome.json`** — linting + formatting config.
5. **`commitlint.config.ts`** — conventional commits.
6. **`vitest.config.ts`** — unit test config.
7. **`playwright.config.ts`** — E2E config.
8. **`.husky/pre-commit`** — runs lint-staged.
9. **`.husky/commit-msg`** — runs commitlint.
10. **`src/test/setup.ts`** — testing library setup.
11. **`src/test/example.test.tsx`** — example test.
12. **`e2e/home.spec.ts`** — example E2E test.

Initialize Husky:
```bash
npx husky init
```

---

## Step 7 — Generate app shell

Read `skills/new-project/references/app-shells.md` and generate verbatim for the chosen project type:

**Dashboard** → generate all: `layout.tsx`, `(dashboard)/layout.tsx`, `(dashboard)/page.tsx`, `components/sidebar.tsx`, `components/sidebar-sheet.tsx`, `components/header.tsx`, `components/stats-grid.tsx`, `components/theme-provider.tsx`, `components/theme-toggle.tsx`, `components/page-wrapper.tsx`, `lib/utils.ts`

**SaaS** → generate: root `layout.tsx`, `components/navbar.tsx`, `app/page.tsx` (hero), `app/(app)/layout.tsx` (dashboard shell), `components/theme-provider.tsx`, `components/theme-toggle.tsx`, `components/page-wrapper.tsx`, `lib/utils.ts`

**AI App** → generate: `layout.tsx`, `app/page.tsx`, `components/chat.tsx`, `app/api/chat/route.ts`, `components/theme-provider.tsx`, `components/theme-toggle.tsx`, `lib/utils.ts`

**Marketing** → generate: root `layout.tsx`, `components/navbar.tsx`, `app/page.tsx`, `components/theme-toggle.tsx`

Apply animations:
- Every page wrapped in `<PageWrapper>` (`animate-fade-in`)
- Stat cards staggered: `style={{ animationDelay: \`${i * 60}ms\`, animationFillMode: 'both' }}`
- Cards: `transition-all duration-200 hover:shadow-md hover:-translate-y-0.5`
- Sidebar links: `transition-all duration-150 hover:translate-x-0.5`
- Primary buttons: `active:scale-95`

---

## Step 8 — Generate service files

Read `skills/new-project/references/services.md` and `skills/new-project/references/observability.md`.

Generate for each chosen service:

**Clerk** → `src/middleware.ts`

**Better Auth** → `src/lib/auth.ts`, `src/lib/auth-client.ts`, `src/app/api/auth/[...all]/route.ts`

**Drizzle + Neon** → `src/lib/db.ts`, `src/db/schema.ts`, `drizzle.config.ts`

**Stripe** → `src/lib/stripe.ts`, `src/app/api/webhooks/stripe/route.ts`

**Resend** → `src/lib/email.ts`

**Vercel AI SDK** → `src/app/api/chat/route.ts`

**Arcjet** → `src/lib/arcjet.ts`

**Sentry** → run `npx @sentry/wizard@latest -i nextjs --silent`, then `src/lib/sentry.ts`

**PostHog** → `src/lib/posthog.ts`, `src/components/posthog-provider.tsx`, wrap root layout

**Vercel Analytics** → add `<Analytics />` and `<SpeedInsights />` to root layout

**next-intl** → `src/i18n/routing.ts`, `src/messages/en.json`, `src/messages/[second-locale].json`

---

## Step 9 — Forms scaffold

Read `skills/new-project/references/observability.md` (react-hook-form section).

Generate `src/components/forms/sign-in-form.tsx` using react-hook-form + Zod v4 pattern. This is a working example users can copy for any other form.

---

## Step 10 — Generate .env.example

Include only vars for chosen services:

```env
# App
NEXT_PUBLIC_APP_URL=http://localhost:3000

# Database (Neon + Drizzle)
DATABASE_URL=

# Auth — Clerk
NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=
CLERK_SECRET_KEY=
NEXT_PUBLIC_CLERK_SIGN_IN_URL=/sign-in
NEXT_PUBLIC_CLERK_SIGN_UP_URL=/sign-up
NEXT_PUBLIC_CLERK_AFTER_SIGN_IN_URL=/dashboard
NEXT_PUBLIC_CLERK_AFTER_SIGN_UP_URL=/dashboard

# Auth — Better Auth
BETTER_AUTH_SECRET=
BETTER_AUTH_URL=http://localhost:3000
GITHUB_CLIENT_ID=
GITHUB_CLIENT_SECRET=
GOOGLE_CLIENT_ID=
GOOGLE_CLIENT_SECRET=

# Payments (Stripe)
STRIPE_SECRET_KEY=
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=
STRIPE_WEBHOOK_SECRET=

# Email (Resend)
RESEND_API_KEY=
EMAIL_FROM=noreply@yourdomain.com

# AI
OPENAI_API_KEY=

# Sentry
SENTRY_DSN=
NEXT_PUBLIC_SENTRY_DSN=

# PostHog
NEXT_PUBLIC_POSTHOG_KEY=
NEXT_PUBLIC_POSTHOG_HOST=https://app.posthog.com
POSTHOG_API_KEY=

# Arcjet
ARCJET_KEY=
```

---

## Step 11 — Generate CLAUDE.md

```markdown
# Project: [name]

## Stack
- Framework: [e.g. Next.js 15 App Router]
- Language: TypeScript (strict)
- UI: shadcn/ui + Tailwind v4
- Theme: [e.g. Zinc — dark mode user toggle — Geist font]

## Services
- Auth: [e.g. Clerk / Better Auth]
- DB: [e.g. Neon (Postgres) + Drizzle ORM]
- Payments: [e.g. Stripe]
- Email: [e.g. Resend]
- AI: [e.g. Vercel AI SDK — gpt-4o-mini]
- Analytics: [e.g. PostHog + Vercel Analytics]
- Security: [e.g. Arcjet]
- Error tracking: [e.g. Sentry]

## DX
- Linter/formatter: Biome
- Git hooks: Husky + lint-staged + commitlint (conventional commits)
- Unit tests: Vitest + Testing Library
- E2E tests: Playwright

## Commands
- `npm run dev` — dev server (Turbopack)
- `npm run build` — production build
- `npm run check` — Biome lint + format
- `npm run test` — Vitest unit tests
- `npm run e2e` — Playwright E2E tests
- `npm run typecheck` — TypeScript check
- `npm run db:push` — push schema to DB
- `npm run db:studio` — Drizzle Studio UI

## Project structure
- `src/app/` — Next.js App Router pages + API routes
- `src/components/` — Shared UI components
- `src/components/ui/` — shadcn/ui components (auto-generated, don't edit)
- `src/lib/` — Utilities, DB, service clients
- `src/db/` — Drizzle schema + migrations
- `src/lib/validations/` — Zod schemas
- `src/components/forms/` — react-hook-form components
- `e2e/` — Playwright E2E tests
- `src/test/` — Vitest unit tests
```

---

## Step 12 — Update package.json scripts

Merge these scripts (don't replace existing ones):
```json
{
  "scripts": {
    "dev": "next dev --turbopack",
    "build": "next build",
    "start": "next start",
    "lint": "biome lint .",
    "lint:fix": "biome lint --write .",
    "format": "biome format --write .",
    "check": "biome check --write .",
    "test": "vitest",
    "test:ui": "vitest --ui",
    "test:coverage": "vitest run --coverage",
    "e2e": "playwright test",
    "e2e:ui": "playwright test --ui",
    "typecheck": "tsc --noEmit",
    "db:push": "drizzle-kit push",
    "db:studio": "drizzle-kit studio",
    "db:generate": "drizzle-kit generate",
    "db:migrate": "drizzle-kit migrate"
  },
  "lint-staged": {
    "*.{ts,tsx,js,jsx,json}": ["biome check --write --no-errors-on-unmatched"]
  }
}
```

---

## Step 13 — Verify build

```bash
npm run typecheck 2>&1 | tail -5
npm run build 2>&1 | tail -10
```

Fix any TypeScript errors before finishing. If Sentry wizard created conflicting files, resolve them.

Report to user:
- Final file tree (`find src -type f | sort`)
- Which services are wired
- Commands to run next (`npm run dev`, then fill `.env.local` from `.env.example`)

---

## Reference Files

- [Web Stacks](references/web-stacks.md)
- [Presets](references/presets.md)
- [UI Options](references/ui-options.md)
- [Services](references/services.md)
- [App Shells](references/app-shells.md)
- [Config Files](references/config-files.md) — tailwind.config.ts, globals.css, next.config.ts, page-wrapper
- [DX Tools](references/dx-tools.md) — Biome, Husky, commitlint, Vitest, Playwright
- [Observability](references/observability.md) — Sentry, PostHog, Arcjet, Better Auth, Zod v4, react-hook-form, next-intl

## Rules

- Generate every file in Steps 6–12. No exceptions.
- `tailwind.config.ts` is mandatory — font won't work without it.
- `next.config.ts` is mandatory — PPR and View Transitions need it.
- Biome replaces ESLint — remove `eslint` and `.eslintrc` if create-next-app generated them.
- Never leave `// TODO` in generated files — implement or omit.
- Never run `git commit` — leave to the user.
- Build must pass before reporting done.
- If a step fails, fix it before continuing.
