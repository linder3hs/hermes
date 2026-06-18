# UI Options Reference

## Component Libraries

### shadcn/ui (Recommended)
**Philosophy:** "Open code" — you own the components, not a library
**Install:** `npx shadcn@latest init`
**Why it wins:** AI tools (v0, Cursor) are trained on it; consistent with Vercel design system; composable; easy to customize
**Pairs with:** Tailwind v4, Radix UI primitives under the hood

### Radix UI (Unstyled)
**Philosophy:** Behavior-only — you bring all the styles
**Install:** `npm install @radix-ui/react-*`
**Use when:** Full custom design system where you want zero default styles

### Mantine
**Philosophy:** Batteries-included, great defaults
**Install:** `npm install @mantine/core @mantine/hooks`
**Use when:** Internal tools, dashboards where speed of development > custom branding

### Chakra UI
**Philosophy:** Accessible, theme-friendly, CSS-in-JS
**Install:** `npm install @chakra-ui/react`
**Use when:** Team already familiar with it, or need accessible defaults fast

---

## CSS Approach

### Tailwind v4 (Recommended)
**Config:** `tailwind.config.ts` with content paths
**Dark mode:** `darkMode: 'class'` (toggle via class) or `'media'` (system)
**With shadcn/ui:** Uses CSS variables via `@layer base` in `globals.css`

### CSS Modules
**Use when:** Avoiding utility class sprawl, strong separation of concerns
**Works with:** Any component library that accepts className

### vanilla-extract
**Use when:** Need typed CSS-in-JS at build time (zero runtime), complex design tokens
**Tradeoff:** More setup, smaller ecosystem

---

## Color Themes (shadcn/ui)

All themes use HSL CSS variables. Official palettes from shadcn/ui:

### Zinc (Recommended — warm neutral)
```css
/* Light */
--background: 0 0% 100%;
--foreground: 240 10% 3.9%;
--primary: 240 5.9% 10%;
--primary-foreground: 0 0% 98%;
--muted: 240 4.8% 95.9%;
--muted-foreground: 240 3.8% 46.1%;
--border: 240 5.9% 90%;
```

### Slate (Cool neutral)
```css
--background: 0 0% 100%;
--foreground: 222.2 84% 4.9%;
--primary: 222.2 47.4% 11.2%;
--primary-foreground: 210 40% 98%;
--muted: 210 40% 96.1%;
--muted-foreground: 215.4 16.3% 46.9%;
--border: 214.3 31.8% 91.4%;
```

### Stone (Warm neutral)
```css
--background: 0 0% 100%;
--foreground: 20 14.3% 4.1%;
--primary: 24 9.8% 10%;
--primary-foreground: 60 9.1% 97.8%;
--muted: 60 4.8% 95.9%;
--muted-foreground: 25 5.3% 44.7%;
--border: 20 5.9% 90%;
```

---

## Dark Mode Patterns

### System Preference Only (no toggle)
```ts
// tailwind.config.ts
darkMode: 'media'
```
No extra packages. CSS `@media (prefers-color-scheme: dark)` handles it.

### User Toggle (next-themes)
```bash
npm install next-themes
```

```tsx
// components/theme-provider.tsx
'use client'
import { ThemeProvider as NextThemesProvider } from 'next-themes'

export function ThemeProvider({ children }: { children: React.ReactNode }) {
  return (
    <NextThemesProvider attribute="class" defaultTheme="system" enableSystem>
      {children}
    </NextThemesProvider>
  )
}
```

```tsx
// components/theme-toggle.tsx
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
    </Button>
  )
}
```

```ts
// tailwind.config.ts
darkMode: 'class'
```

---

## Fonts

### Geist (Recommended)
```tsx
import { GeistSans } from 'geist/font/sans'
// Apply: className={GeistSans.variable}
// CSS var: --font-geist-sans
```

### Inter
```tsx
import { Inter } from 'next/font/google'
const inter = Inter({ subsets: ['latin'], variable: '--font-inter' })
```

### Cal Sans
Download from `https://github.com/calcom/font` — free for headings.

---

## Icon Libraries

### Lucide (Recommended)
```bash
npm install lucide-react
```
```tsx
import { Home, Settings, User } from 'lucide-react'
```
Tree-shakeable, consistent stroke width, 1000+ icons.

### Heroicons
```bash
npm install @heroicons/react
```
24px solid + outline variants. Tailwind Labs official.

### Phosphor
```bash
npm install @phosphor-icons/react
```
Most variety, supports weight variants (thin/light/regular/bold/fill/duotone).
