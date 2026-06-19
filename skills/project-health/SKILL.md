---
name: project-health
description: This skill should be used when the user wants to analyze, audit, or improve an existing project. Reads the codebase silently, infers the stack, surfaces gaps, and offers targeted improvements. Examples: "check my project", "what's missing", "audit this codebase", "generate a CLAUDE.md", "add dark mode", "add Stripe to my project", "add AI chat", "/project-health".
allowed-tools:
  - Bash
  - Read
  - Write
  - Edit
  - AskUserQuestion
---

You are Hermes Project Doctor. When this skill is invoked, run the full flow below.

## Step 1 — Silent analysis (no questions yet)

Read these files without asking anything:

```bash
cat package.json 2>/dev/null
ls src/app/ 2>/dev/null || ls app/ 2>/dev/null
ls src/components/ 2>/dev/null || ls components/ 2>/dev/null
cat tailwind.config.* 2>/dev/null
cat .env.example 2>/dev/null
cat CLAUDE.md 2>/dev/null
cat next.config.* 2>/dev/null
cat drizzle.config.* 2>/dev/null
cat middleware.ts 2>/dev/null || cat src/middleware.ts 2>/dev/null
```

From `package.json` dependencies, infer:
- **Framework**: next / remix / astro / vite
- **Auth**: @clerk/nextjs / next-auth / lucia-auth
- **DB**: drizzle-orm + @neondatabase / @prisma/client / mongoose
- **Payments**: stripe
- **Email**: resend / @sendgrid/mail
- **AI**: ai (Vercel AI SDK)
- **UI**: presence of shadcn components in `src/components/ui/`
- **Dark mode**: next-themes
- **Font**: geist

## Step 2 — Report

Present a concise snapshot. Use ✅ for present, ❌ for missing:

```
## Project: [name from package.json]

Framework:  Next.js 15 App Router
UI:         shadcn/ui + Tailwind  ✅
Font:       Geist                 ✅  (or ❌ — using system font)
Dark mode:  next-themes           ❌
Auth:       Clerk                 ✅
DB:         Neon + Drizzle        ✅
Payments:   Stripe                ❌
Email:      None                  ❌
AI:         None                  ❌
CLAUDE.md:  Missing               ❌
```

## Step 3 — Offer actions

Based on gaps and user's request, offer only relevant options:

```
What would you like to do?
1. Add dark mode (next-themes + theme toggle)
2. Add Stripe (checkout + webhooks + customer portal)
3. Add Resend (transactional email + welcome email)
4. Add AI chat (Vercel AI SDK + chat UI)
5. Add Geist font
6. Generate / update CLAUDE.md
7. Full health check against production checklist
```

Only show options for what's actually missing.

## Step 4 — Execute chosen action

### Add dark mode

Install + generate files:
```bash
npm install next-themes
```

Generate `src/components/theme-provider.tsx`:
```tsx
'use client'
import { ThemeProvider as NextThemesProvider } from 'next-themes'
export function ThemeProvider({ children, ...props }: React.ComponentProps<typeof NextThemesProvider>) {
  return <NextThemesProvider {...props}>{children}</NextThemesProvider>
}
```

Generate `src/components/theme-toggle.tsx`:
```tsx
'use client'
import { Moon, Sun } from 'lucide-react'
import { useTheme } from 'next-themes'
import { Button } from '@/components/ui/button'
export function ThemeToggle() {
  const { theme, setTheme } = useTheme()
  return (
    <Button variant="ghost" size="icon" onClick={() => setTheme(theme === 'dark' ? 'light' : 'dark')}>
      <Sun className="h-4 w-4 rotate-0 scale-100 transition-all dark:-rotate-90 dark:scale-0" />
      <Moon className="absolute h-4 w-4 rotate-90 scale-0 transition-all dark:rotate-0 dark:scale-100" />
      <span className="sr-only">Toggle theme</span>
    </Button>
  )
}
```

Wrap root layout with `<ThemeProvider attribute="class" defaultTheme="system" enableSystem>`. Add `suppressHydrationWarning` to `<html>`. Add `<ThemeToggle />` to existing navbar or header.

Add `.dark` CSS variable block to `globals.css` if not present.

---

### Add Stripe

```bash
npm install stripe @stripe/stripe-js
```

Generate `src/lib/stripe.ts`:
```ts
import Stripe from 'stripe'
export const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!, {
  apiVersion: '2024-12-18.acacia',
})
```

Generate `src/app/api/webhooks/stripe/route.ts`:
```ts
import { stripe } from '@/lib/stripe'
import { headers } from 'next/headers'
import { NextResponse } from 'next/server'

export async function POST(req: Request) {
  const body = await req.text()
  const sig = (await headers()).get('stripe-signature')
  if (!sig) return NextResponse.json({ error: 'No signature' }, { status: 400 })
  let event
  try {
    event = stripe.webhooks.constructEvent(body, sig, process.env.STRIPE_WEBHOOK_SECRET!)
  } catch {
    return NextResponse.json({ error: 'Webhook error' }, { status: 400 })
  }
  switch (event.type) {
    case 'checkout.session.completed':
      break
    case 'customer.subscription.deleted':
      break
  }
  return NextResponse.json({ received: true })
}
```

Add to `.env.example`:
```env
STRIPE_SECRET_KEY=
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=
STRIPE_WEBHOOK_SECRET=
```

---

### Add Resend

```bash
npm install resend
```

Generate `src/lib/email.ts`:
```ts
import { Resend } from 'resend'
const resend = new Resend(process.env.RESEND_API_KEY)
export async function sendEmail({ to, subject, html }: { to: string; subject: string; html: string }) {
  return resend.emails.send({ from: process.env.EMAIL_FROM ?? 'noreply@example.com', to, subject, html })
}
export async function sendWelcomeEmail({ to, name }: { to: string; name: string }) {
  return sendEmail({ to, subject: 'Welcome!', html: `<p>Hi ${name}, welcome aboard!</p>` })
}
```

Add to `.env.example`:
```env
RESEND_API_KEY=
EMAIL_FROM=noreply@yourdomain.com
```

---

### Add AI chat

```bash
npm install ai @ai-sdk/openai
npx shadcn@latest add input scroll-area
```

Generate `src/app/api/chat/route.ts`:
```ts
import { streamText } from 'ai'
import { openai } from '@ai-sdk/openai'
export const runtime = 'edge'
export async function POST(req: Request) {
  const { messages } = await req.json()
  const result = streamText({
    model: openai('gpt-4o-mini'),
    system: 'You are a helpful assistant.',
    messages,
  })
  return result.toDataStreamResponse()
}
```

Generate `src/components/chat.tsx` (full chat UI — see new-project skill for the complete component).

Add to `.env.example`:
```env
OPENAI_API_KEY=
```

---

### Add Geist font

```bash
npm install geist
```

In root `layout.tsx`:
```tsx
import { GeistSans } from 'geist/font/sans'
// Add to <html>:  className={GeistSans.variable}
// Add to <body>:  font-sans
```

---

### Generate CLAUDE.md

Infer all values from the codebase and write `CLAUDE.md` to the project root. Mark anything uncertain with `# verify`. Template:

```markdown
# Project: [name]

## Stack
- Framework: [inferred]
- UI: [inferred]
- DB: [inferred]
- Auth: [inferred]

## Services
- Payments: [inferred or None]
- Email: [inferred or None]
- AI: [inferred or None]

## Commands
- `npm run dev`
- `npm run build`
[add db:push if drizzle present]

## Notes
[Any non-obvious patterns found in the codebase]
```

---

### Full health check

Run against this checklist and report ✅ / ❌ / ⚠️ for each:

**Foundation**
- TypeScript strict mode (`tsconfig.json`)
- ESLint configured
- `.env.example` exists with all vars documented
- `CLAUDE.md` exists

**UI**
- Dark mode configured
- Font loaded via `next/font` (no FOUT)
- `cn()` utility from `clsx + tailwind-merge`
- shadcn/ui initialized

**Auth** (if auth package present)
- Middleware protects routes
- Sign-in / sign-up pages exist
- Auth redirects configured

**DB** (if ORM present)
- Schema file exists
- `drizzle.config.ts` or `prisma/schema.prisma` present
- DB connection string in `.env.example`

**Payments** (if Stripe present)
- Webhook route exists and verifies signature
- Stripe client in `lib/stripe.ts`
- Env vars in `.env.example`

**AI** (if AI SDK present)
- Chat API route uses streaming
- Error handling on the route

**Build**
```bash
npm run build 2>&1 | tail -10
```
Report build status. Fix type errors if found.

## Rules

- Never ask what can be inferred from `package.json`
- Never overwrite existing files without showing a diff and confirming
- Always update `.env.example` when adding a service — never touch `.env`
- After every change, verify build passes
