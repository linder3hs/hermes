# Observability & Security — Optional Services

---

## Sentry — Error tracking + performance

```bash
npx @sentry/wizard@latest -i nextjs --silent
```

The wizard auto-configures `sentry.client.config.ts`, `sentry.server.config.ts`, and `sentry.edge.config.ts`. After running it, add:

### `src/lib/sentry.ts`
```ts
import * as Sentry from '@sentry/nextjs'

export function captureError(error: unknown, context?: Record<string, unknown>) {
  Sentry.captureException(error, { extra: context })
}

export function setUser(user: { id: string; email?: string }) {
  Sentry.setUser(user)
}

export function clearUser() {
  Sentry.setUser(null)
}
```

### `.env.example` additions
```env
# Sentry
SENTRY_DSN=
SENTRY_ORG=
SENTRY_PROJECT=
NEXT_PUBLIC_SENTRY_DSN=
```

---

## PostHog — Product analytics + feature flags

Self-hosteable, open source. Replaces Google Analytics with way more power.

```bash
npm install posthog-js posthog-node
```

### `src/lib/posthog.ts` — server client
```ts
import { PostHog } from 'posthog-node'

const posthog = new PostHog(process.env.POSTHOG_API_KEY!, {
  host: process.env.POSTHOG_HOST ?? 'https://app.posthog.com',
  flushAt: 1,
  flushInterval: 0,
})

export { posthog }
```

### `src/components/posthog-provider.tsx` — client
```tsx
'use client'
import posthog from 'posthog-js'
import { PostHogProvider as PHProvider, usePostHog } from 'posthog-js/react'
import { useEffect } from 'react'
import { usePathname, useSearchParams } from 'next/navigation'

function PostHogPageView() {
  const pathname = usePathname()
  const searchParams = useSearchParams()
  const ph = usePostHog()

  useEffect(() => {
    if (pathname && ph) {
      let url = window.origin + pathname
      if (searchParams.toString()) url += '?' + searchParams.toString()
      ph.capture('$pageview', { '$current_url': url })
    }
  }, [pathname, searchParams, ph])

  return null
}

export function PostHogProvider({ children }: { children: React.ReactNode }) {
  useEffect(() => {
    posthog.init(process.env.NEXT_PUBLIC_POSTHOG_KEY!, {
      api_host: process.env.NEXT_PUBLIC_POSTHOG_HOST ?? 'https://app.posthog.com',
      capture_pageview: false,
      capture_pageleave: true,
    })
  }, [])

  return (
    <PHProvider client={posthog}>
      <PostHogPageView />
      {children}
    </PHProvider>
  )
}
```

Wrap root layout:
```tsx
// src/app/layout.tsx
import { PostHogProvider } from '@/components/posthog-provider'
// Add inside ThemeProvider:
<PostHogProvider>{children}</PostHogProvider>
```

### `.env.example` additions
```env
# PostHog
NEXT_PUBLIC_POSTHOG_KEY=
NEXT_PUBLIC_POSTHOG_HOST=https://app.posthog.com
POSTHOG_API_KEY=
POSTHOG_HOST=https://app.posthog.com
```

---

## Arcjet — Rate limiting + bot protection + WAF

One SDK replaces: custom rate limiting, bot detection, WAF, and prompt injection protection. Patches Next.js middleware bypass CVE-2025-29927.

```bash
npm install @arcjet/next
```

### `src/lib/arcjet.ts`
```ts
import arcjet, { tokenBucket, shield, detectBot } from '@arcjet/next'

export const aj = arcjet({
  key: process.env.ARCJET_KEY!,
  characteristics: ['ip.src'],
  rules: [
    // Rate limit: 10 req/10s per IP
    tokenBucket({
      mode: 'LIVE',
      refillRate: 10,
      interval: 10,
      capacity: 10,
    }),
    // Block common attacks (SQLi, XSS, etc.)
    shield({ mode: 'LIVE' }),
    // Block bots (allow search engines)
    detectBot({
      mode: 'LIVE',
      allow: ['CATEGORY:SEARCH_ENGINE'],
    }),
  ],
})
```

### Usage in API routes
```ts
// src/app/api/example/route.ts
import { aj } from '@/lib/arcjet'
import { NextResponse } from 'next/server'
import { isSpoofedBot, isErrorDecision } from '@arcjet/next'

export async function POST(req: Request) {
  const decision = await aj.protect(req)

  if (isSpoofedBot(decision) || decision.isDenied()) {
    return NextResponse.json({ error: 'Forbidden' }, { status: 403 })
  }

  // your logic here
  return NextResponse.json({ ok: true })
}
```

### Usage for AI routes (prompt injection protection)
```ts
import arcjet, { tokenBucket, shield, protectAI } from '@arcjet/next'

export const ajAI = arcjet({
  key: process.env.ARCJET_KEY!,
  rules: [
    tokenBucket({ mode: 'LIVE', refillRate: 5, interval: 60, capacity: 20 }),
    shield({ mode: 'LIVE' }),
    protectAI({ mode: 'LIVE' }),  // blocks prompt injection
  ],
})
```

### `.env.example` additions
```env
# Arcjet
ARCJET_KEY=
```

---

## Vercel Analytics + Speed Insights

Zero-config, built into Vercel. Add to root layout.

```bash
npm install @vercel/analytics @vercel/speed-insights
```

### `src/app/layout.tsx` additions
```tsx
import { Analytics } from '@vercel/analytics/react'
import { SpeedInsights } from '@vercel/speed-insights/next'

// Inside <body>:
<Analytics />
<SpeedInsights />
```

---

## Zod v4 — Validation (mandatory)

```bash
npm install zod@^4
```

Key changes from v3:
- `z.string().email()` → same API, 14x faster
- `z.object()` → same API
- New: `z.json()` for JSON Schema output
- New: `z.toJSONSchema(schema)` for OpenAPI integration

### `src/lib/validations/` — organize schemas here

```ts
// src/lib/validations/user.ts
import { z } from 'zod'

export const createUserSchema = z.object({
  name: z.string().min(1).max(100),
  email: z.string().email(),
  password: z.string().min(8).max(100),
})

export type CreateUserInput = z.infer<typeof createUserSchema>
```

---

## react-hook-form + Zod — Form handling

```bash
npm install react-hook-form @hookform/resolvers zod@^4
```

### Example form component pattern
```tsx
'use client'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { z } from 'zod'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Form, FormControl, FormField, FormItem, FormLabel, FormMessage } from '@/components/ui/form'

const formSchema = z.object({
  email: z.string().email('Enter a valid email'),
  password: z.string().min(8, 'Password must be at least 8 characters'),
})

type FormValues = z.infer<typeof formSchema>

export function SignInForm() {
  const form = useForm<FormValues>({
    resolver: zodResolver(formSchema),
    defaultValues: { email: '', password: '' },
  })

  async function onSubmit(values: FormValues) {
    // call server action or API
    console.log(values)
  }

  return (
    <Form {...form}>
      <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-4">
        <FormField
          control={form.control}
          name="email"
          render={({ field }) => (
            <FormItem>
              <FormLabel>Email</FormLabel>
              <FormControl>
                <Input type="email" placeholder="you@example.com" {...field} />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />
        <FormField
          control={form.control}
          name="password"
          render={({ field }) => (
            <FormItem>
              <FormLabel>Password</FormLabel>
              <FormControl>
                <Input type="password" placeholder="••••••••" {...field} />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />
        <Button type="submit" className="w-full" disabled={form.formState.isSubmitting}>
          {form.formState.isSubmitting ? 'Signing in...' : 'Sign in'}
        </Button>
      </form>
    </Form>
  )
}
```

---

## Better Auth — Self-hosted auth (alternative to Clerk)

Use when: user wants to avoid Clerk pricing at scale ($24K/year gap at 100K MAU), needs RBAC, organizations, passkeys, or full data ownership.

```bash
npm install better-auth
```

### `src/lib/auth.ts`
```ts
import { betterAuth } from 'better-auth'
import { drizzleAdapter } from 'better-auth/adapters/drizzle'
import { db } from '@/lib/db'
import { organization, rbac, passkey } from 'better-auth/plugins'

export const auth = betterAuth({
  database: drizzleAdapter(db, { provider: 'pg' }),
  emailAndPassword: { enabled: true },
  plugins: [
    organization(),
    rbac(),
    passkey(),
  ],
  session: {
    expiresIn: 60 * 60 * 24 * 7, // 7 days
    updateAge: 60 * 60 * 24,
  },
  socialProviders: {
    github: {
      clientId: process.env.GITHUB_CLIENT_ID!,
      clientSecret: process.env.GITHUB_CLIENT_SECRET!,
    },
    google: {
      clientId: process.env.GOOGLE_CLIENT_ID!,
      clientSecret: process.env.GOOGLE_CLIENT_SECRET!,
    },
  },
})

export type Session = typeof auth.$Infer.Session
export type User = typeof auth.$Infer.Session.user
```

### `src/app/api/auth/[...all]/route.ts`
```ts
import { auth } from '@/lib/auth'
import { toNextJsHandler } from 'better-auth/next-js'
export const { GET, POST } = toNextJsHandler(auth)
```

### `src/lib/auth-client.ts`
```ts
import { createAuthClient } from 'better-auth/react'
import { organizationClient, rbacClient, passkeyClient } from 'better-auth/client/plugins'

export const authClient = createAuthClient({
  baseURL: process.env.NEXT_PUBLIC_APP_URL!,
  plugins: [organizationClient(), rbacClient(), passkeyClient()],
})

export const { signIn, signUp, signOut, useSession } = authClient
```

### `.env.example` additions
```env
# Better Auth
BETTER_AUTH_SECRET=         # openssl rand -base64 32
BETTER_AUTH_URL=http://localhost:3000
NEXT_PUBLIC_APP_URL=http://localhost:3000

# OAuth providers (optional)
GITHUB_CLIENT_ID=
GITHUB_CLIENT_SECRET=
GOOGLE_CLIENT_ID=
GOOGLE_CLIENT_SECRET=
```

---

## next-intl — Internationalization (optional)

```bash
npm install next-intl
```

### Directory structure
```
src/
  i18n/
    routing.ts
    request.ts
  messages/
    en.json
    es.json
  app/
    [locale]/
      layout.tsx
      page.tsx
```

### `src/i18n/routing.ts`
```ts
import { defineRouting } from 'next-intl/routing'

export const routing = defineRouting({
  locales: ['en', 'es'],
  defaultLocale: 'en',
})
```

### `src/messages/en.json`
```json
{
  "nav": {
    "overview": "Overview",
    "analytics": "Analytics",
    "users": "Users"
  },
  "home": {
    "title": "Overview",
    "subtitle": "Welcome back. Here's what's happening today."
  }
}
```

### Usage in components
```tsx
import { useTranslations } from 'next-intl'

export function Header() {
  const t = useTranslations('home')
  return <h1>{t('title')}</h1>
}
```
