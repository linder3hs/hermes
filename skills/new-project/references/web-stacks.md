# Web Stacks Reference

## Frameworks

### Next.js 15 App Router
**Best for:** SaaS, dashboards, AI apps, e-commerce, anything full-stack
**Strengths:** Server Components, Server Actions, streaming, built-in API routes, Vercel-native
**Data patterns:** Server Actions (simple), tRPC (type-safe complex), REST (external backend)
**When NOT to use:** Pure static sites (use Astro), if team hates React

### Remix
**Best for:** E-commerce, form-heavy apps, sites needing fine-grained loading states
**Strengths:** Nested routes, progressive enhancement, great form handling, optimistic UI
**Data patterns:** loaders + actions (native), no separate API layer needed
**When NOT to use:** Simple CRUD apps (Next.js is simpler), static sites

### Astro
**Best for:** Marketing sites, landing pages, documentation, blogs
**Strengths:** Zero JS by default, island architecture, fastest static output, multi-framework support
**Data patterns:** Static generation or SSR with adapters
**When NOT to use:** Anything needing complex client-side state or real-time features

---

## Data Layers

### Server Actions (Next.js)
**Best for:** Simple mutations, form submissions, MVP speed
**Tradeoff:** Less structured for complex data fetching, no built-in cache invalidation
**Use when:** Starting out, internal tools, simple CRUD

### TanStack Query + tRPC
**Best for:** Dashboards, complex data fetching, teams that want end-to-end type safety
**Strengths:** Automatic caching, background refetching, optimistic updates, typed procedures
**Tradeoff:** More setup than Server Actions
**Use when:** Multiple client components need the same data, complex caching needs

### REST API
**Best for:** When you have an existing backend or need to expose a public API
**Use when:** Mobile app + web app sharing same backend, microservices

---

## Databases

### Neon (Postgres)
**Best for:** Most projects — serverless Postgres with branching
**Strengths:** Serverless, scales to zero, branch per PR, compatible with Drizzle/Prisma
**Connection:** `@neondatabase/serverless` driver (HTTP-based, works on Edge)

### Supabase (Postgres)
**Best for:** Projects needing realtime, built-in auth, or file storage alongside DB
**Strengths:** Postgres + realtime + auth + storage in one
**Tradeoff:** More opinionated, can feel like lock-in

### Turso (SQLite/libSQL)
**Best for:** Edge-first apps, read-heavy workloads, low-latency global reads
**Strengths:** SQLite locally, libSQL distributed globally, extremely fast reads
**Tradeoff:** Less mature ecosystem, fewer tooling options

---

## ORMs

### Drizzle
**Best for:** New projects — lightweight, type-safe, SQL-first
**Strengths:** Zero runtime overhead, migrations as code, great TypeScript inference
**Recommended with:** Neon, Turso

### Prisma
**Best for:** Teams already using it, or needing Prisma Client extensions
**Strengths:** Mature, great docs, Studio UI, wide adapter support
**Tradeoff:** Heavier runtime, slower cold starts on serverless

---

## Deploy Targets

### Vercel
**Best for:** Next.js projects (native integration), any Node.js project
**Strengths:** Zero-config deploy, preview URLs, Edge Network, Fluid Compute, AI Gateway
**Price note:** Free tier generous, scales automatically

### Railway
**Best for:** Projects needing persistent servers, background jobs, or non-Node runtimes
**Strengths:** Simple pricing, supports any language, built-in Postgres/Redis/MySQL
**Use when:** Need a long-running process or non-serverless backend
