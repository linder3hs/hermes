# Hermes Presets

Presets are named stack combinations that skip the full decision tree. Each preset is a sensible starting point for a common project type.

## `minimal`

Best for: prototypes, personal projects, quick MVPs

| Layer | Choice |
|-------|--------|
| Framework | Next.js 15 App Router |
| UI | shadcn/ui + Tailwind v4 |
| Data | Server Actions |
| DB | None |
| Auth | None |
| Deploy | Vercel |

Install:
```bash
npx create-next-app@latest . --typescript --tailwind --eslint --app --src-dir --import-alias "@/*"
npx shadcn@latest init
```

---

## `saas`

Best for: subscription SaaS products

| Layer | Choice |
|-------|--------|
| Framework | Next.js 15 App Router |
| UI | shadcn/ui + Tailwind v4 |
| Data | Server Actions + TanStack Query |
| DB | Neon (Postgres) + Drizzle |
| Auth | Clerk |
| Payments | Stripe (checkout + webhooks + portal) |
| Email | Resend |
| Deploy | Vercel |

Install:
```bash
npx create-next-app@latest . --typescript --tailwind --eslint --app --src-dir --import-alias "@/*"
npx shadcn@latest init
npm install @clerk/nextjs drizzle-orm @neondatabase/serverless drizzle-kit stripe @stripe/stripe-js resend
```

Key files to scaffold:
- `lib/db.ts` — Drizzle + Neon connection
- `lib/stripe.ts` — Stripe client
- `lib/email.ts` — Resend client
- `app/api/webhooks/stripe/route.ts` — Stripe webhook handler
- `middleware.ts` — Clerk auth middleware
- `.env.example` — all required env vars

---

## `ai-app`

Best for: chat apps, AI assistants, RAG, AI-powered features

| Layer | Choice |
|-------|--------|
| Framework | Next.js 15 App Router |
| UI | shadcn/ui + Tailwind v4 |
| Data | Server Actions |
| DB | Neon (Postgres) + Drizzle |
| Auth | Clerk |
| AI | Vercel AI SDK + AI Gateway |
| Deploy | Vercel |

Install:
```bash
npx create-next-app@latest . --typescript --tailwind --eslint --app --src-dir --import-alias "@/*"
npx shadcn@latest init
npm install ai @clerk/nextjs drizzle-orm @neondatabase/serverless drizzle-kit
```

Key files to scaffold:
- `app/api/chat/route.ts` — AI SDK streaming route
- `components/chat.tsx` — Chat UI component
- `lib/db.ts` — Drizzle + Neon connection
- `middleware.ts` — Clerk auth middleware

---

## `dashboard`

Best for: admin panels, analytics dashboards, internal tools

| Layer | Choice |
|-------|--------|
| Framework | Next.js 15 App Router |
| UI | shadcn/ui + Tailwind v4 |
| Data | TanStack Query + tRPC |
| DB | Neon (Postgres) + Drizzle |
| Auth | Clerk |
| Deploy | Vercel |

Install:
```bash
npx create-next-app@latest . --typescript --tailwind --eslint --app --src-dir --import-alias "@/*"
npx shadcn@latest init
npm install @tanstack/react-query @trpc/client @trpc/server @trpc/react-query @trpc/next @clerk/nextjs drizzle-orm @neondatabase/serverless drizzle-kit
```

Key files to scaffold:
- `server/trpc.ts` — tRPC router setup
- `server/routers/` — example router
- `lib/db.ts` — Drizzle + Neon connection
- `app/api/trpc/[trpc]/route.ts` — tRPC handler
- `middleware.ts` — Clerk auth middleware

---

## `marketing`

Best for: landing pages, documentation sites, marketing sites

| Layer | Choice |
|-------|--------|
| Framework | Astro |
| UI | shadcn/ui + Tailwind v4 |
| Email | Resend (contact form) |
| Deploy | Vercel |

Install:
```bash
npm create astro@latest . -- --template minimal --typescript strict --install --no-git
npx astro add tailwind
npm install resend
```
