# App Shells — Base Files by Project Type

After scaffolding the base project and installing deps, always generate these files. A shell is a working, navigable app — not a blank Next.js page.

---

## Dashboard Shell

Files to generate after `npx create-next-app@latest`:

### `src/app/layout.tsx`
```tsx
import type { Metadata } from 'next'
import { GeistSans } from 'geist/font/sans'
import { ThemeProvider } from '@/components/theme-provider'
import { Sidebar } from '@/components/sidebar'
import './globals.css'

export const metadata: Metadata = {
  title: 'Dashboard',
  description: 'Dashboard application',
}

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en" suppressHydrationWarning className={GeistSans.variable}>
      <body className="bg-background font-sans antialiased">
        <ThemeProvider attribute="class" defaultTheme="system" enableSystem>
          <div className="flex h-screen overflow-hidden">
            <Sidebar />
            <main className="flex-1 overflow-y-auto">
              <div className="container mx-auto p-6">
                {children}
              </div>
            </main>
          </div>
        </ThemeProvider>
      </body>
    </html>
  )
}
```

### `src/components/sidebar.tsx`
```tsx
'use client'
import Link from 'next/link'
import { usePathname } from 'next/navigation'
import { cn } from '@/lib/utils'
import { ThemeToggle } from '@/components/theme-toggle'
import {
  LayoutDashboard,
  Users,
  Settings,
  BarChart3,
  FileText,
} from 'lucide-react'

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
    <aside className="flex flex-col w-60 border-r bg-card h-screen">
      <div className="flex items-center h-16 px-6 border-b">
        <span className="font-semibold text-lg tracking-tight">Dashboard</span>
      </div>
      <nav className="flex-1 overflow-y-auto py-4 px-3 space-y-1">
        {links.map(({ href, label, icon: Icon }) => (
          <Link
            key={href}
            href={href}
            className={cn(
              'flex items-center gap-3 rounded-md px-3 py-2 text-sm font-medium transition-colors',
              pathname === href
                ? 'bg-primary text-primary-foreground'
                : 'text-muted-foreground hover:bg-accent hover:text-accent-foreground'
            )}
          >
            <Icon className="h-4 w-4" />
            {label}
          </Link>
        ))}
      </nav>
      <div className="border-t p-4 flex items-center justify-between">
        <span className="text-xs text-muted-foreground">v0.1.0</span>
        <ThemeToggle />
      </div>
    </aside>
  )
}
```

### `src/app/page.tsx`
```tsx
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Users, DollarSign, Activity, TrendingUp } from 'lucide-react'

const stats = [
  { title: 'Total Users', value: '0', icon: Users, change: '+0%' },
  { title: 'Revenue', value: '$0', icon: DollarSign, change: '+0%' },
  { title: 'Active Now', value: '0', icon: Activity, change: '+0%' },
  { title: 'Growth', value: '0%', icon: TrendingUp, change: '+0%' },
]

export default function Page() {
  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold tracking-tight">Overview</h1>
        <p className="text-muted-foreground">Welcome to your dashboard.</p>
      </div>
      <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
        {stats.map((stat) => (
          <Card key={stat.title}>
            <CardHeader className="flex flex-row items-center justify-between pb-2">
              <CardTitle className="text-sm font-medium text-muted-foreground">
                {stat.title}
              </CardTitle>
              <stat.icon className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">{stat.value}</div>
              <p className="text-xs text-muted-foreground mt-1">{stat.change} from last month</p>
            </CardContent>
          </Card>
        ))}
      </div>
    </div>
  )
}
```

### shadcn/ui components to install
```bash
npx shadcn@latest add card button badge avatar dropdown-menu separator
```

---

## SaaS Shell

### `src/app/layout.tsx` — public layout (marketing pages)
```tsx
import type { Metadata } from 'next'
import { GeistSans } from 'geist/font/sans'
import { ThemeProvider } from '@/components/theme-provider'
import { Navbar } from '@/components/navbar'
import './globals.css'

export const metadata: Metadata = {
  title: 'App',
  description: 'App description',
}

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

### `src/components/navbar.tsx`
```tsx
'use client'
import Link from 'next/link'
import { ThemeToggle } from '@/components/theme-toggle'
import { Button } from '@/components/ui/button'

export function Navbar() {
  return (
    <header className="sticky top-0 z-50 border-b bg-background/80 backdrop-blur-sm">
      <div className="container mx-auto flex h-16 items-center justify-between px-4">
        <Link href="/" className="font-semibold text-lg tracking-tight">
          AppName
        </Link>
        <nav className="hidden md:flex items-center gap-6">
          <Link href="/features" className="text-sm text-muted-foreground hover:text-foreground transition-colors">Features</Link>
          <Link href="/pricing" className="text-sm text-muted-foreground hover:text-foreground transition-colors">Pricing</Link>
          <Link href="/docs" className="text-sm text-muted-foreground hover:text-foreground transition-colors">Docs</Link>
        </nav>
        <div className="flex items-center gap-3">
          <ThemeToggle />
          <Button variant="ghost" size="sm" asChild>
            <Link href="/sign-in">Sign in</Link>
          </Button>
          <Button size="sm" asChild>
            <Link href="/sign-up">Get started</Link>
          </Button>
        </div>
      </div>
    </header>
  )
}
```

### `src/app/(dashboard)/layout.tsx` — authenticated app layout
```tsx
import { Sidebar } from '@/components/sidebar'

export default function DashboardLayout({ children }: { children: React.ReactNode }) {
  return (
    <div className="flex h-screen overflow-hidden">
      <Sidebar />
      <main className="flex-1 overflow-y-auto">
        <div className="container mx-auto p-6">{children}</div>
      </main>
    </div>
  )
}
```

### `src/app/page.tsx` — landing page hero
```tsx
import Link from 'next/link'
import { Button } from '@/components/ui/button'
import { ArrowRight } from 'lucide-react'

export default function Page() {
  return (
    <main className="flex flex-col items-center justify-center min-h-[calc(100vh-64px)] text-center px-4">
      <div className="max-w-3xl space-y-6">
        <h1 className="text-4xl sm:text-6xl font-bold tracking-tight">
          Build something great
        </h1>
        <p className="text-lg text-muted-foreground max-w-xl mx-auto">
          A short description of what your app does and why it matters.
        </p>
        <div className="flex items-center justify-center gap-4">
          <Button size="lg" asChild>
            <Link href="/sign-up">
              Get started <ArrowRight className="ml-2 h-4 w-4" />
            </Link>
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

### shadcn/ui components to install
```bash
npx shadcn@latest add card button badge avatar dropdown-menu separator sheet
```

---

## AI App Shell

### `src/app/layout.tsx`
Same as SaaS layout but without Navbar — chat-first layout.

### `src/app/page.tsx`
```tsx
import { Chat } from '@/components/chat'

export default function Page() {
  return (
    <main className="flex h-screen flex-col">
      <header className="border-b px-6 py-4 flex items-center gap-3">
        <span className="font-semibold">AI Assistant</span>
      </header>
      <Chat />
    </main>
  )
}
```

### `src/components/chat.tsx`
```tsx
'use client'
import { useChat } from 'ai/react'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { ScrollArea } from '@/components/ui/scroll-area'
import { Send } from 'lucide-react'
import { cn } from '@/lib/utils'

export function Chat() {
  const { messages, input, handleInputChange, handleSubmit, isLoading } = useChat()
  return (
    <div className="flex flex-col flex-1 overflow-hidden">
      <ScrollArea className="flex-1 p-6">
        <div className="max-w-2xl mx-auto space-y-4">
          {messages.length === 0 && (
            <div className="text-center text-muted-foreground py-20">
              Start a conversation
            </div>
          )}
          {messages.map((m) => (
            <div
              key={m.id}
              className={cn(
                'flex',
                m.role === 'user' ? 'justify-end' : 'justify-start'
              )}
            >
              <div
                className={cn(
                  'rounded-lg px-4 py-2 max-w-[80%] text-sm',
                  m.role === 'user'
                    ? 'bg-primary text-primary-foreground'
                    : 'bg-muted'
                )}
              >
                {m.content}
              </div>
            </div>
          ))}
        </div>
      </ScrollArea>
      <div className="border-t p-4">
        <form onSubmit={handleSubmit} className="max-w-2xl mx-auto flex gap-2">
          <Input
            value={input}
            onChange={handleInputChange}
            placeholder="Type a message..."
            disabled={isLoading}
            className="flex-1"
          />
          <Button type="submit" size="icon" disabled={isLoading}>
            <Send className="h-4 w-4" />
          </Button>
        </form>
      </div>
    </div>
  )
}
```

### shadcn/ui components to install
```bash
npx shadcn@latest add card button input scroll-area badge avatar
```

---

## Marketing / Landing Shell

### `src/app/layout.tsx`
Same as SaaS public layout with Navbar.

### `src/components/navbar.tsx`
Same as SaaS navbar.

### shadcn/ui components to install
```bash
npx shadcn@latest add button badge card separator
```

---

## Shared Components (all project types)

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
    <Button
      variant="ghost"
      size="icon"
      onClick={() => setTheme(theme === 'dark' ? 'light' : 'dark')}
    >
      <Sun className="h-4 w-4 rotate-0 scale-100 transition-all dark:-rotate-90 dark:scale-0" />
      <Moon className="absolute h-4 w-4 rotate-90 scale-0 transition-all dark:rotate-0 dark:scale-100" />
      <span className="sr-only">Toggle theme</span>
    </Button>
  )
}
```

### `src/lib/utils.ts`
```ts
import { clsx, type ClassValue } from 'clsx'
import { twMerge } from 'tailwind-merge'

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}
```

### `.env.example`
Always generate this with documented placeholders for every service chosen.
