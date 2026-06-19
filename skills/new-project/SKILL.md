---
name: new-project
description: This skill should be used when the user wants to create a new web project from scratch. Guides through stack, services, and UI decisions, then scaffolds a complete working app — not just a blank page. Supports presets for fast setup. Examples: "create a new project", "start a new SaaS app", "new project with Next.js", "/new-project saas", "build me a dashboard", "create an AI chat app".
allowed-tools:
  - Bash
  - Read
  - Write
  - Edit
  - AskUserQuestion
---

You are Hermes. When this skill is invoked, run the full flow below — do not abbreviate, do not skip the shell generation step.

## Step 1 — Detect context

```bash
ls package.json 2>/dev/null && echo "EXISTS" || echo "EMPTY"
```

If the directory already has a project, stop and say: "This directory already has a project. Use `/project-health` instead."

## Step 2 — Preset or guided flow

**If the user passed a preset name** (`/new-project saas`, etc.), load it from the table below and skip to Step 3.

| Preset | Framework | Data | DB | Auth | Payments | Email | AI |
|--------|-----------|------|----|------|----------|-------|----|
| `minimal` | Next.js | Server Actions | — | — | — | — | — |
| `saas` | Next.js | Server Actions | Neon + Drizzle | Clerk | Stripe | Resend | — |
| `ai-app` | Next.js | Server Actions | Neon + Drizzle | Clerk | — | — | Vercel AI SDK |
| `dashboard` | Next.js | TanStack Query + tRPC | Neon + Drizzle | Clerk | — | — | — |
| `marketing` | Astro | — | — | — | — | Resend | — |

Confirm with user: "I'll set up [preset]. Anything to add or remove?"

**If no preset**, ask these questions in order (each answer filters the next):

```
1. What type of app? → SaaS / Dashboard / AI app / Marketing / E-commerce / Internal tool

2. Framework? → Next.js 15 App Router [default] / Remix / Astro

3. Data layer? (skip for Astro)
   → Server Actions [simple] / TanStack Query + tRPC [complex dashboards]

4. Database?
   → None / Neon + Drizzle [recommended] / Supabase / Turso

5. Auth?
   → None / Clerk [recommended] / NextAuth v5 / Lucia

6. Payments? → None / Stripe

7. Email? → None / Resend / Sendgrid

8. AI features? → None / Chat (Vercel AI SDK) / RAG / Agents

9. Deploy? → Vercel [default] / Railway / Self-hosted

10. UI theme?
    → Zinc [default] / Slate / Stone / Gray / Custom hex

11. Dark mode?
    → User toggle [default] / System only / No

12. Font?
    → Geist [default] / Inter / Custom Google Font

13. Icons? → Lucide [default] / Heroicons / Phosphor
```

## Step 3 — Confirm and scaffold

Show a summary and ask for confirmation. Then execute:

### 3a — Base project

**Next.js:**
```bash
npx create-next-app@latest . --typescript --tailwind --eslint --app --src-dir --import-alias "@/*" --yes
```

**Astro:**
```bash
npm create astro@latest . -- --template minimal --typescript strict --install --yes
npx astro add tailwind --yes
```

**Remix:**
```bash
npx create-remix@latest . --yes
```

### 3b — Core dependencies

```bash
# Always install
npm install geist next-themes lucide-react

# shadcn/ui (Next.js + Radix)
npx shadcn@latest init --yes --defaults
```

### 3c — Services (only chosen ones)

```bash
npm install @clerk/nextjs                                          # Clerk auth
npm install drizzle-orm @neondatabase/serverless drizzle-kit      # Neon + Drizzle
npm install stripe @stripe/stripe-js                              # Stripe
npm install resend                                                 # Resend email
npm install ai                                                     # Vercel AI SDK
npm install @tanstack/react-query @trpc/client @trpc/server @trpc/react-query @trpc/next  # tRPC
```

### 3d — shadcn/ui components (by project type)

**Dashboard / SaaS:**
```bash
npx shadcn@latest add card button badge avatar dropdown-menu separator sheet skeleton tooltip
```

**AI app:**
```bash
npx shadcn@latest add card button input scroll-area badge avatar skeleton
```

**Marketing:**
```bash
npx shadcn@latest add button badge card separator
```

## Step 4 — Generate tailwind.config.ts and globals.css

Read `skills/new-project/references/config-files.md` and generate BOTH files verbatim.

**`tailwind.config.ts` is required.** Without it, `font-sans` won't map to Geist even if the package is installed. The config maps `var(--font-geist-sans)` → `font-sans` and `var(--font-geist-mono)` → `font-mono`. It also registers all custom keyframes and animations.

Also generate `src/components/page-wrapper.tsx` from config-files.md and wrap every generated page with it.

### Original step — Generate globals.css

Replace `src/app/globals.css` with the full theme for the chosen color. Use the values below exactly.

### Zinc (default)
```css
@import "tailwindcss";

@layer base {
  :root {
    --background: 0 0% 100%;
    --foreground: 240 10% 3.9%;
    --card: 0 0% 100%;
    --card-foreground: 240 10% 3.9%;
    --popover: 0 0% 100%;
    --popover-foreground: 240 10% 3.9%;
    --primary: 240 5.9% 10%;
    --primary-foreground: 0 0% 98%;
    --secondary: 240 4.8% 95.9%;
    --secondary-foreground: 240 5.9% 10%;
    --muted: 240 4.8% 95.9%;
    --muted-foreground: 240 3.8% 46.1%;
    --accent: 240 4.8% 95.9%;
    --accent-foreground: 240 5.9% 10%;
    --destructive: 0 84.2% 60.2%;
    --destructive-foreground: 0 0% 98%;
    --border: 240 5.9% 90%;
    --input: 240 5.9% 90%;
    --ring: 240 5.9% 10%;
    --radius: 0.5rem;
  }
  .dark {
    --background: 240 10% 3.9%;
    --foreground: 0 0% 98%;
    --card: 240 10% 3.9%;
    --card-foreground: 0 0% 98%;
    --popover: 240 10% 3.9%;
    --popover-foreground: 0 0% 98%;
    --primary: 0 0% 98%;
    --primary-foreground: 240 5.9% 10%;
    --secondary: 240 3.7% 15.9%;
    --secondary-foreground: 0 0% 98%;
    --muted: 240 3.7% 15.9%;
    --muted-foreground: 240 5% 64.9%;
    --accent: 240 3.7% 15.9%;
    --accent-foreground: 0 0% 98%;
    --destructive: 0 62.8% 30.6%;
    --destructive-foreground: 0 0% 98%;
    --border: 240 3.7% 15.9%;
    --input: 240 3.7% 15.9%;
    --ring: 240 4.9% 83.9%;
  }
}

@layer base {
  * { @apply border-border; }
  body { @apply bg-background text-foreground; }
}
```

### Slate
```css
@import "tailwindcss";

@layer base {
  :root {
    --background: 0 0% 100%;
    --foreground: 222.2 84% 4.9%;
    --card: 0 0% 100%;
    --card-foreground: 222.2 84% 4.9%;
    --popover: 0 0% 100%;
    --popover-foreground: 222.2 84% 4.9%;
    --primary: 222.2 47.4% 11.2%;
    --primary-foreground: 210 40% 98%;
    --secondary: 210 40% 96.1%;
    --secondary-foreground: 222.2 47.4% 11.2%;
    --muted: 210 40% 96.1%;
    --muted-foreground: 215.4 16.3% 46.9%;
    --accent: 210 40% 96.1%;
    --accent-foreground: 222.2 47.4% 11.2%;
    --destructive: 0 84.2% 60.2%;
    --destructive-foreground: 210 40% 98%;
    --border: 214.3 31.8% 91.4%;
    --input: 214.3 31.8% 91.4%;
    --ring: 222.2 84% 4.9%;
    --radius: 0.5rem;
  }
  .dark {
    --background: 222.2 84% 4.9%;
    --foreground: 210 40% 98%;
    --card: 222.2 84% 4.9%;
    --card-foreground: 210 40% 98%;
    --popover: 222.2 84% 4.9%;
    --popover-foreground: 210 40% 98%;
    --primary: 210 40% 98%;
    --primary-foreground: 222.2 47.4% 11.2%;
    --secondary: 217.2 32.6% 17.5%;
    --secondary-foreground: 210 40% 98%;
    --muted: 217.2 32.6% 17.5%;
    --muted-foreground: 215 20.2% 65.1%;
    --accent: 217.2 32.6% 17.5%;
    --accent-foreground: 210 40% 98%;
    --destructive: 0 62.8% 30.6%;
    --destructive-foreground: 210 40% 98%;
    --border: 217.2 32.6% 17.5%;
    --input: 217.2 32.6% 17.5%;
    --ring: 212.7 26.8% 83.9%;
  }
}

@layer base {
  * { @apply border-border; }
  body { @apply bg-background text-foreground; }
}
```

## Step 5 — Generate app shell

Read `skills/new-project/references/app-shells.md` and copy the files VERBATIM for the chosen project type. Do not simplify, do not abbreviate, do not skip any file.

Apply animations from `references/config-files.md`:
- Wrap every page in `<PageWrapper>` for fade-in on load
- Add stagger delay to grid cards: `style={{ animationDelay: \`${i * 60}ms\`, animationFillMode: 'both' }}`
- Cards: add `transition-all duration-200 hover:shadow-md hover:-translate-y-0.5`
- Sidebar links: add `hover:translate-x-0.5` to the transition
- Buttons with important actions: add `active:scale-95`

### `src/lib/utils.ts`
```ts
import { clsx, type ClassValue } from 'clsx'
import { twMerge } from 'tailwind-merge'
export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}
```

### `src/components/theme-provider.tsx`
```tsx
'use client'
import { ThemeProvider as NextThemesProvider } from 'next-themes'
export function ThemeProvider({ children, ...props }: React.ComponentProps<typeof NextThemesProvider>) {
  return <NextThemesProvider {...props}>{children}</NextThemesProvider>
}
```

### `src/components/theme-toggle.tsx`
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

---

### Dashboard shell

**`src/app/layout.tsx`**
```tsx
import type { Metadata } from 'next'
import { GeistSans } from 'geist/font/sans'
import { ThemeProvider } from '@/components/theme-provider'
import { Sidebar } from '@/components/sidebar'
import './globals.css'

export const metadata: Metadata = { title: 'Dashboard', description: 'Dashboard' }

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en" suppressHydrationWarning className={GeistSans.variable}>
      <body className="bg-background font-sans antialiased">
        <ThemeProvider attribute="class" defaultTheme="system" enableSystem>
          <div className="flex h-screen overflow-hidden">
            <Sidebar />
            <main className="flex-1 overflow-y-auto p-6">{children}</main>
          </div>
        </ThemeProvider>
      </body>
    </html>
  )
}
```

**`src/components/sidebar.tsx`**
```tsx
'use client'
import Link from 'next/link'
import { usePathname } from 'next/navigation'
import { cn } from '@/lib/utils'
import { ThemeToggle } from '@/components/theme-toggle'
import { LayoutDashboard, Users, BarChart3, Settings, FileText } from 'lucide-react'

const links = [
  { href: '/', label: 'Overview', icon: LayoutDashboard },
  { href: '/analytics', label: 'Analytics', icon: BarChart3 },
  { href: '/users', label: 'Users', icon: Users },
  { href: '/reports', label: 'Reports', icon: FileText },
  { href: '/settings', label: 'Settings', icon: Settings },
]

export function Sidebar() {
  const pathname = usePathname()
  return (
    <aside className="flex w-60 flex-col border-r bg-card">
      <div className="flex h-16 items-center border-b px-6">
        <span className="text-lg font-semibold tracking-tight">Acme Inc</span>
      </div>
      <nav className="flex-1 space-y-1 px-3 py-4">
        {links.map(({ href, label, icon: Icon }) => (
          <Link key={href} href={href}
            className={cn(
              'flex items-center gap-3 rounded-md px-3 py-2 text-sm font-medium transition-colors',
              pathname === href
                ? 'bg-primary text-primary-foreground'
                : 'text-muted-foreground hover:bg-accent hover:text-accent-foreground'
            )}>
            <Icon className="h-4 w-4" />{label}
          </Link>
        ))}
      </nav>
      <div className="flex items-center justify-between border-t p-4">
        <span className="text-xs text-muted-foreground">v0.1.0</span>
        <ThemeToggle />
      </div>
    </aside>
  )
}
```

**`src/app/page.tsx`**
```tsx
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Users, DollarSign, Activity, TrendingUp } from 'lucide-react'

const stats = [
  { title: 'Total Users', value: '—', icon: Users, delta: '+0% this month' },
  { title: 'Revenue', value: '—', icon: DollarSign, delta: '+0% this month' },
  { title: 'Active Now', value: '—', icon: Activity, delta: 'Real-time' },
  { title: 'Growth', value: '—', icon: TrendingUp, delta: 'vs last period' },
]

export default function Page() {
  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold tracking-tight">Overview</h1>
        <p className="text-muted-foreground">Welcome back. Here's what's happening.</p>
      </div>
      <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
        {stats.map((s) => (
          <Card key={s.title}>
            <CardHeader className="flex flex-row items-center justify-between pb-2">
              <CardTitle className="text-sm font-medium text-muted-foreground">{s.title}</CardTitle>
              <s.icon className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">{s.value}</div>
              <p className="mt-1 text-xs text-muted-foreground">{s.delta}</p>
            </CardContent>
          </Card>
        ))}
      </div>
    </div>
  )
}
```

---

### SaaS shell

**`src/app/layout.tsx`** — root layout (public pages)
```tsx
import type { Metadata } from 'next'
import { GeistSans } from 'geist/font/sans'
import { ThemeProvider } from '@/components/theme-provider'
import { Navbar } from '@/components/navbar'
import './globals.css'

export const metadata: Metadata = { title: 'App', description: 'App description' }

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en" suppressHydrationWarning className={GeistSans.variable}>
      <body className="bg-background font-sans antialiased">
        <ThemeProvider attribute="class" defaultTheme="system" enableSystem>
          <Navbar />
          {children}
        </ThemeProvider>
      </body>
    </html>
  )
}
```

**`src/components/navbar.tsx`**
```tsx
'use client'
import Link from 'next/link'
import { ThemeToggle } from '@/components/theme-toggle'
import { Button } from '@/components/ui/button'

export function Navbar() {
  return (
    <header className="sticky top-0 z-50 border-b bg-background/80 backdrop-blur-sm">
      <div className="container mx-auto flex h-16 items-center justify-between px-4">
        <Link href="/" className="text-lg font-semibold tracking-tight">AppName</Link>
        <nav className="hidden items-center gap-6 md:flex">
          <Link href="/features" className="text-sm text-muted-foreground hover:text-foreground transition-colors">Features</Link>
          <Link href="/pricing" className="text-sm text-muted-foreground hover:text-foreground transition-colors">Pricing</Link>
          <Link href="/docs" className="text-sm text-muted-foreground hover:text-foreground transition-colors">Docs</Link>
        </nav>
        <div className="flex items-center gap-3">
          <ThemeToggle />
          <Button variant="ghost" size="sm" asChild><Link href="/sign-in">Sign in</Link></Button>
          <Button size="sm" asChild><Link href="/sign-up">Get started</Link></Button>
        </div>
      </div>
    </header>
  )
}
```

**`src/app/(app)/layout.tsx`** — authenticated app shell
```tsx
import { Sidebar } from '@/components/sidebar'
export default function AppLayout({ children }: { children: React.ReactNode }) {
  return (
    <div className="flex h-screen overflow-hidden">
      <Sidebar />
      <main className="flex-1 overflow-y-auto p-6">{children}</main>
    </div>
  )
}
```

**`src/app/page.tsx`** — landing hero
```tsx
import Link from 'next/link'
import { Button } from '@/components/ui/button'
import { ArrowRight } from 'lucide-react'

export default function Page() {
  return (
    <main className="flex min-h-[calc(100vh-64px)] flex-col items-center justify-center px-4 text-center">
      <div className="max-w-3xl space-y-6">
        <h1 className="text-4xl font-bold tracking-tight sm:text-6xl">Build something great</h1>
        <p className="mx-auto max-w-xl text-lg text-muted-foreground">
          A short description of what your app does and why it matters.
        </p>
        <div className="flex items-center justify-center gap-4">
          <Button size="lg" asChild>
            <Link href="/sign-up">Get started <ArrowRight className="ml-2 h-4 w-4" /></Link>
          </Button>
          <Button size="lg" variant="outline" asChild>
            <Link href="/features">Learn more</Link>
          </Button>
        </div>
      </div>
    </main>
  )
}
```

---

### AI App shell

**`src/app/layout.tsx`**
```tsx
import type { Metadata } from 'next'
import { GeistSans } from 'geist/font/sans'
import { ThemeProvider } from '@/components/theme-provider'
import './globals.css'

export const metadata: Metadata = { title: 'AI Assistant', description: 'AI chat application' }

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en" suppressHydrationWarning className={GeistSans.variable}>
      <body className="bg-background font-sans antialiased">
        <ThemeProvider attribute="class" defaultTheme="system" enableSystem>
          {children}
        </ThemeProvider>
      </body>
    </html>
  )
}
```

**`src/app/page.tsx`**
```tsx
import { Chat } from '@/components/chat'
import { ThemeToggle } from '@/components/theme-toggle'

export default function Page() {
  return (
    <main className="flex h-screen flex-col">
      <header className="flex items-center justify-between border-b px-6 py-4">
        <span className="font-semibold">AI Assistant</span>
        <ThemeToggle />
      </header>
      <Chat />
    </main>
  )
}
```

**`src/components/chat.tsx`**
```tsx
'use client'
import { useChat } from 'ai/react'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { ScrollArea } from '@/components/ui/scroll-area'
import { Send, Bot, User } from 'lucide-react'
import { cn } from '@/lib/utils'

export function Chat() {
  const { messages, input, handleInputChange, handleSubmit, isLoading } = useChat()
  return (
    <div className="flex flex-1 flex-col overflow-hidden">
      <ScrollArea className="flex-1 p-6">
        <div className="mx-auto max-w-2xl space-y-4">
          {messages.length === 0 && (
            <div className="flex flex-col items-center justify-center py-20 text-center text-muted-foreground">
              <Bot className="mb-4 h-12 w-12 opacity-20" />
              <p className="text-sm">Start a conversation</p>
            </div>
          )}
          {messages.map((m) => (
            <div key={m.id} className={cn('flex gap-3', m.role === 'user' ? 'justify-end' : 'justify-start')}>
              {m.role === 'assistant' && (
                <div className="flex h-8 w-8 shrink-0 items-center justify-center rounded-full bg-primary">
                  <Bot className="h-4 w-4 text-primary-foreground" />
                </div>
              )}
              <div className={cn('max-w-[80%] rounded-lg px-4 py-2 text-sm',
                m.role === 'user' ? 'bg-primary text-primary-foreground' : 'bg-muted')}>
                {m.content}
              </div>
              {m.role === 'user' && (
                <div className="flex h-8 w-8 shrink-0 items-center justify-center rounded-full bg-muted">
                  <User className="h-4 w-4" />
                </div>
              )}
            </div>
          ))}
        </div>
      </ScrollArea>
      <div className="border-t p-4">
        <form onSubmit={handleSubmit} className="mx-auto flex max-w-2xl gap-2">
          <Input value={input} onChange={handleInputChange}
            placeholder="Type a message..." disabled={isLoading} className="flex-1" />
          <Button type="submit" size="icon" disabled={isLoading || !input.trim()}>
            <Send className="h-4 w-4" />
          </Button>
        </form>
      </div>
    </div>
  )
}
```

**`src/app/api/chat/route.ts`**
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

---

## Step 6 — Service config files

Generate only for chosen services:

### Clerk — `src/middleware.ts`
```ts
import { clerkMiddleware, createRouteMatcher } from '@clerk/nextjs/server'
const isPublic = createRouteMatcher(['/', '/sign-in(.*)', '/sign-up(.*)', '/api/webhooks(.*)'])
export default clerkMiddleware(async (auth, req) => {
  if (!isPublic(req)) await auth.protect()
})
export const config = { matcher: ['/((?!_next|[^?]*\\.(?:html?|css|js(?!on)|jpe?g|webp|png|gif|svg|ttf|woff2?|ico|csv|docx?|xlsx?|zip|webmanifest)).*)','/(api|trpc)(.*)'] }
```

### Drizzle + Neon — `src/lib/db.ts`
```ts
import { neon } from '@neondatabase/serverless'
import { drizzle } from 'drizzle-orm/neon-http'
const sql = neon(process.env.DATABASE_URL!)
export const db = drizzle(sql)
```

### Drizzle — `src/db/schema.ts`
```ts
import { pgTable, text, timestamp, uuid } from 'drizzle-orm/pg-core'
export const users = pgTable('users', {
  id: uuid('id').defaultRandom().primaryKey(),
  email: text('email').notNull().unique(),
  name: text('name'),
  createdAt: timestamp('created_at').defaultNow().notNull(),
})
```

### Drizzle — `drizzle.config.ts`
```ts
import { defineConfig } from 'drizzle-kit'
export default defineConfig({
  schema: './src/db/schema.ts',
  out: './drizzle',
  dialect: 'postgresql',
  dbCredentials: { url: process.env.DATABASE_URL! },
})
```

### Stripe — `src/lib/stripe.ts`
```ts
import Stripe from 'stripe'
export const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!, {
  apiVersion: '2024-12-18.acacia',
})
```

### Stripe — `src/app/api/webhooks/stripe/route.ts`
```ts
import { stripe } from '@/lib/stripe'
import { headers } from 'next/headers'
import { NextResponse } from 'next/server'

export async function POST(req: Request) {
  const body = await req.text()
  const sig = (await headers()).get('stripe-signature')
  if (!sig) return NextResponse.json({ error: 'No signature' }, { status: 400 })
  let event: Stripe.Event
  try {
    event = stripe.webhooks.constructEvent(body, sig, process.env.STRIPE_WEBHOOK_SECRET!)
  } catch {
    return NextResponse.json({ error: 'Webhook error' }, { status: 400 })
  }
  switch (event.type) {
    case 'checkout.session.completed':
      // TODO: activate subscription
      break
    case 'customer.subscription.deleted':
      // TODO: deactivate subscription
      break
  }
  return NextResponse.json({ received: true })
}
```

### Resend — `src/lib/email.ts`
```ts
import { Resend } from 'resend'
const resend = new Resend(process.env.RESEND_API_KEY)

export async function sendWelcomeEmail({ to, name }: { to: string; name: string }) {
  return resend.emails.send({
    from: process.env.EMAIL_FROM ?? 'noreply@example.com',
    to,
    subject: 'Welcome!',
    html: `<p>Hi ${name}, welcome aboard!</p>`,
  })
}
```

## Step 7 — Generate .env.example

Always generate this file with every env var needed, with comments:

```env
# Database (Neon)
DATABASE_URL=

# Auth (Clerk)
NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=
CLERK_SECRET_KEY=
NEXT_PUBLIC_CLERK_SIGN_IN_URL=/sign-in
NEXT_PUBLIC_CLERK_SIGN_UP_URL=/sign-up
NEXT_PUBLIC_CLERK_AFTER_SIGN_IN_URL=/dashboard
NEXT_PUBLIC_CLERK_AFTER_SIGN_UP_URL=/dashboard

# Payments (Stripe)
STRIPE_SECRET_KEY=
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=
STRIPE_WEBHOOK_SECRET=

# Email (Resend)
RESEND_API_KEY=
EMAIL_FROM=noreply@yourdomain.com

# AI
OPENAI_API_KEY=
```

Only include sections for chosen services.

## Step 8 — Generate CLAUDE.md

Write to the project root:

```markdown
# Project: [name]

## Stack
- Framework: [e.g. Next.js 15 App Router]
- Data: [e.g. TanStack Query + tRPC]
- DB: [e.g. Neon (Postgres) + Drizzle ORM]
- UI: [e.g. shadcn/ui + Tailwind v4]
- Theme: [e.g. Zinc / dark mode user toggle / Geist font]

## Services
- Auth: [e.g. Clerk]
- Payments: [e.g. Stripe]
- Email: [e.g. Resend]
- AI: [e.g. Vercel AI SDK — gpt-4o-mini]

## Project structure
- `src/app/` — Next.js App Router pages and API routes
- `src/components/` — Shared UI components
- `src/lib/` — Utilities, DB client, service clients
- `src/db/` — Drizzle schema and migrations

## Commands
- `npm run dev` — start dev server
- `npm run db:push` — push schema to DB (drizzle-kit)
- `npm run db:studio` — open Drizzle Studio

## Key decisions
[Document non-obvious choices here]
```

## Step 9 — Verify

Run:
```bash
npm run build 2>&1 | tail -5
```

If it fails, fix type errors before finishing. Report the final file tree to the user.

## Reference Files

- [Web Stacks](references/web-stacks.md) — framework options and tradeoffs
- [Presets](references/presets.md) — predefined stack combinations
- [UI Options](references/ui-options.md) — component libraries, themes, dark mode
- [Services](references/services.md) — auth, payments, email, storage, AI options
- [App Shells](references/app-shells.md) — complete base files per project type
- [Config Files](references/config-files.md) — tailwind.config.ts, globals.css HSL vars, animations, page-wrapper

## Rules

- Generate every file in Steps 4–8. No exceptions, no skipping.
- `tailwind.config.ts` is mandatory — font won't work without it.
- Wrap every page in `<PageWrapper>` — animations won't fire without it.
- Never leave `// TODO` in generated service files — either implement it or omit the feature.
- Never run `git commit` — leave that to the user.
- Always verify the build compiles before reporting done.
- If a step fails, show the error and fix it before continuing.
