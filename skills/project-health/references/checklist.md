# Production-Ready Project Checklist

Use this to audit existing projects and surface gaps.

## Foundation
- [ ] TypeScript strict mode enabled
- [ ] ESLint configured
- [ ] `.env.example` exists with all required vars documented
- [ ] `CLAUDE.md` exists with stack and key decisions documented
- [ ] `README.md` with setup instructions

## Auth
- [ ] Auth solution chosen and configured
- [ ] Protected routes covered (middleware or layout-level)
- [ ] User session accessible in server components
- [ ] Auth redirects configured correctly

## Database (if applicable)
- [ ] ORM configured with DB connection
- [ ] Migration strategy in place (`drizzle-kit push` or `prisma migrate`)
- [ ] DB schema has indexes on frequently queried columns
- [ ] Connection pooling configured (PgBouncer for Neon, or serverless driver)

## Payments (if applicable)
- [ ] Stripe SDK configured
- [ ] Webhook endpoint exists and verifies signature
- [ ] Webhook handles: `checkout.session.completed`, `customer.subscription.deleted`
- [ ] Customer portal route exists
- [ ] Subscription status stored in DB and synced via webhooks

## Email (if applicable)
- [ ] Email SDK configured
- [ ] At least one transactional email implemented (welcome, reset password, etc.)
- [ ] From address uses custom domain (not @gmail)

## UI / Accessibility
- [ ] Dark mode considered (system or toggle)
- [ ] Color contrast meets WCAG AA
- [ ] Focus visible on interactive elements
- [ ] Images have alt text

## Performance
- [ ] Images use `next/image` (if Next.js)
- [ ] Fonts loaded with `next/font` (no FOUT)
- [ ] No large client bundles from server-only imports

## AI Features (if applicable)
- [ ] AI route uses streaming (`toDataStreamResponse`)
- [ ] Rate limiting on AI endpoints
- [ ] Error handling for model failures (fallback message)
- [ ] Usage tracked or capped per user

## Security
- [ ] No secrets in client-side code (`NEXT_PUBLIC_` prefix only for public values)
- [ ] Input validation at API boundaries (Zod recommended)
- [ ] CSRF protection (Next.js App Router handles this natively for Server Actions)
- [ ] Webhook signatures verified before processing

## Deploy
- [ ] Environment variables set in hosting dashboard (not just locally)
- [ ] `NEXTAUTH_URL` / `CLERK_SIGN_IN_URL` set correctly for production domain
- [ ] Stripe webhook endpoint registered in Stripe dashboard for production URL
- [ ] DB connection string uses pooled URL (not direct) for serverless
