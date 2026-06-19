# DX Tools — Developer Experience Setup

Generate all of these after the base scaffold. They are not optional for a professional project.

---

## Biome (replaces ESLint + Prettier)

Next.js 16 removed `next lint`. Biome is 15-20x faster and handles formatting + linting in one tool.

```bash
npm install --save-dev @biomejs/biome
npx biome init
```

### `biome.json`
```json
{
  "$schema": "https://biomejs.dev/schemas/2.0.0/schema.json",
  "vcs": {
    "enabled": true,
    "clientKind": "git",
    "useIgnoreFile": true
  },
  "files": {
    "ignoreUnknown": false,
    "ignore": ["node_modules", ".next", "dist", "build"]
  },
  "formatter": {
    "enabled": true,
    "indentStyle": "space",
    "indentWidth": 2,
    "lineWidth": 100
  },
  "organizeImports": {
    "enabled": true
  },
  "linter": {
    "enabled": true,
    "rules": {
      "recommended": true,
      "correctness": {
        "noUnusedVariables": "error",
        "noUnusedImports": "error"
      },
      "suspicious": {
        "noExplicitAny": "warn"
      },
      "style": {
        "noNonNullAssertion": "warn"
      }
    }
  },
  "javascript": {
    "formatter": {
      "quoteStyle": "single",
      "trailingCommas": "es5",
      "semicolons": "asNeeded"
    }
  }
}
```

### `package.json` scripts to add
```json
{
  "scripts": {
    "lint": "biome lint .",
    "lint:fix": "biome lint --write .",
    "format": "biome format --write .",
    "check": "biome check --write ."
  }
}
```

---

## Husky + lint-staged (Git hooks)

Runs Biome on staged files before every commit. Zero tolerance for broken code in the repo.

```bash
npm install --save-dev husky lint-staged
npx husky init
```

### `.husky/pre-commit`
```sh
npx lint-staged
```

### `.husky/commit-msg`
```sh
npx --no -- commitlint --edit "$1"
```

### `package.json` additions
```json
{
  "lint-staged": {
    "*.{ts,tsx,js,jsx,json}": [
      "biome check --write --no-errors-on-unmatched"
    ]
  }
}
```

---

## Commitlint (conventional commits)

```bash
npm install --save-dev @commitlint/cli @commitlint/config-conventional
```

### `commitlint.config.ts`
```ts
import type { UserConfig } from '@commitlint/types'

const config: UserConfig = {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'type-enum': [
      2,
      'always',
      ['feat', 'fix', 'docs', 'style', 'refactor', 'test', 'chore', 'perf', 'ci', 'revert'],
    ],
    'subject-case': [2, 'always', 'lower-case'],
    'header-max-length': [2, 'always', 72],
  },
}

export default config
```

---

## `next.config.ts` — Performance flags

```ts
import type { NextConfig } from 'next'

const nextConfig: NextConfig = {
  // Cache Components (stable Partial Pre-Rendering)
  experimental: {
    cacheComponents: true,
    // React Compiler — auto-memoization, replaces useMemo/useCallback
    reactCompiler: true,
    // Faster dev restarts via filesystem cache
    turbopackFileSystemCacheForDev: true,
  },

  // View Transitions API — production-ready since Oct 2025
  viewTransition: true,

  // Images: allow external domains as needed
  images: {
    formats: ['image/avif', 'image/webp'],
  },

  // Security headers
  async headers() {
    return [
      {
        source: '/(.*)',
        headers: [
          { key: 'X-Frame-Options', value: 'DENY' },
          { key: 'X-Content-Type-Options', value: 'nosniff' },
          { key: 'Referrer-Policy', value: 'strict-origin-when-cross-origin' },
          { key: 'Permissions-Policy', value: 'camera=(), microphone=(), geolocation=()' },
        ],
      },
    ]
  },
}

export default nextConfig
```

---

## Vitest — Unit tests

```bash
npm install --save-dev vitest @vitejs/plugin-react jsdom @testing-library/react @testing-library/jest-dom @testing-library/user-event
```

### `vitest.config.ts`
```ts
import { defineConfig } from 'vitest/config'
import react from '@vitejs/plugin-react'
import path from 'path'

export default defineConfig({
  plugins: [react()],
  test: {
    environment: 'jsdom',
    globals: true,
    setupFiles: ['./src/test/setup.ts'],
    coverage: {
      provider: 'v8',
      reporter: ['text', 'json', 'html'],
      exclude: ['node_modules/', '.next/', 'src/test/'],
    },
  },
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src'),
    },
  },
})
```

### `src/test/setup.ts`
```ts
import '@testing-library/jest-dom'
```

### `src/test/example.test.tsx`
```tsx
import { render, screen } from '@testing-library/react'
import { describe, it, expect } from 'vitest'

// Example: replace with your actual component
function Greeting({ name }: { name: string }) {
  return <h1>Hello, {name}</h1>
}

describe('Greeting', () => {
  it('renders the name', () => {
    render(<Greeting name="World" />)
    expect(screen.getByText('Hello, World')).toBeInTheDocument()
  })
})
```

### `package.json` scripts
```json
{
  "scripts": {
    "test": "vitest",
    "test:ui": "vitest --ui",
    "test:coverage": "vitest run --coverage"
  }
}
```

---

## Playwright — E2E tests

```bash
npm init playwright@latest -- --quiet --lang=ts --no-browsers
npx playwright install --with-deps chromium
```

### `playwright.config.ts`
```ts
import { defineConfig, devices } from '@playwright/test'

export default defineConfig({
  testDir: './e2e',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: 'html',
  use: {
    baseURL: 'http://localhost:3000',
    trace: 'on-first-retry',
  },
  projects: [
    { name: 'chromium', use: { ...devices['Desktop Chrome'] } },
  ],
  webServer: {
    command: 'npm run dev',
    url: 'http://localhost:3000',
    reuseExistingServer: !process.env.CI,
  },
})
```

### `e2e/home.spec.ts`
```ts
import { test, expect } from '@playwright/test'

test('home page loads', async ({ page }) => {
  await page.goto('/')
  await expect(page).toHaveTitle(/.*/)
})
```

### `package.json` scripts
```json
{
  "scripts": {
    "e2e": "playwright test",
    "e2e:ui": "playwright test --ui"
  }
}
```

---

## `.gitignore` additions

```
# Testing
/coverage
/playwright-report
/test-results
/blob-report

# Env
.env
.env.local
.env.*.local

# Biome
.biome/
```

---

## Final `package.json` scripts — complete set

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
    "db:push": "drizzle-kit push",
    "db:studio": "drizzle-kit studio",
    "db:generate": "drizzle-kit generate",
    "db:migrate": "drizzle-kit migrate",
    "typecheck": "tsc --noEmit"
  }
}
```
