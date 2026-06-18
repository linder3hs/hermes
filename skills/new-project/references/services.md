# Services Reference

Each service section includes: install command, required env vars, and key files to scaffold.

---

## Auth

### Clerk (Recommended)
**Best for:** Most projects — hosted, excellent DX, handles UI
**Install:** `npm install @clerk/nextjs`
**Env vars:**
```env
NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=
CLERK_SECRET_KEY=
NEXT_PUBLIC_CLERK_SIGN_IN_URL=/sign-in
NEXT_PUBLIC_CLERK_SIGN_UP_URL=/sign-up
NEXT_PUBLIC_CLERK_AFTER_SIGN_IN_URL=/dashboard
NEXT_PUBLIC_CLERK_AFTER_SIGN_UP_URL=/dashboard
```
**Key files:**
- `middleware.ts` — protect routes
- `app/(auth)/sign-in/[[...sign-in]]/page.tsx`
- `app/(auth)/sign-up/[[...sign-up]]/page.tsx`

### NextAuth v5
**Best for:** Self-hosted auth, more control over session/JWT
**Install:** `npm install next-auth@beta`
**Env vars:**
```env
AUTH_SECRET=
AUTH_GITHUB_ID=   # or chosen provider
AUTH_GITHUB_SECRET=
```
**Key files:**
- `auth.ts` — NextAuth config
- `app/api/auth/[...nextauth]/route.ts`
- `middleware.ts`

### Lucia
**Best for:** Fully custom auth flows, no external provider
**Install:** `npm install lucia arctic`
**Env vars:** Only DB connection (sessions stored in DB)

---

## Payments — Stripe

Full setup: checkout sessions, webhooks, customer portal, subscription management.

**Install:** `npm install stripe @stripe/stripe-js`
**Env vars:**
```env
STRIPE_SECRET_KEY=
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=
STRIPE_WEBHOOK_SECRET=
```

**Key files to scaffold:**

`lib/stripe.ts`
```ts
import Stripe from 'stripe'
export const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!, {
  apiVersion: '2024-12-18.acacia',
})
```

`app/api/webhooks/stripe/route.ts`
```ts
import { stripe } from '@/lib/stripe'
import { headers } from 'next/headers'

export async function POST(req: Request) {
  const body = await req.text()
  const sig = (await headers()).get('stripe-signature')!
  let event
  try {
    event = stripe.webhooks.constructEvent(body, sig, process.env.STRIPE_WEBHOOK_SECRET!)
  } catch {
    return new Response('Webhook error', { status: 400 })
  }
  switch (event.type) {
    case 'checkout.session.completed':
      // handle subscription activation
      break
    case 'customer.subscription.deleted':
      // handle cancellation
      break
  }
  return new Response(null, { status: 200 })
}
```

`app/api/checkout/route.ts` — Create checkout session
`app/api/portal/route.ts` — Customer portal session

---

## Email

### Resend (Recommended)
**Best for:** Transactional email with React templates
**Install:** `npm install resend`
**Env vars:**
```env
RESEND_API_KEY=
EMAIL_FROM=noreply@yourdomain.com
```

`lib/email.ts`
```ts
import { Resend } from 'resend'
export const resend = new Resend(process.env.RESEND_API_KEY)

export async function sendWelcomeEmail(to: string, name: string) {
  return resend.emails.send({
    from: process.env.EMAIL_FROM!,
    to,
    subject: 'Welcome!',
    html: `<p>Hi ${name}, welcome aboard!</p>`,
  })
}
```

### Sendgrid
**Install:** `npm install @sendgrid/mail`
**Env vars:**
```env
SENDGRID_API_KEY=
EMAIL_FROM=
```

---

## File Storage

### Vercel Blob
**Best for:** Vercel-hosted projects
**Install:** `npm install @vercel/blob`
**Env vars:**
```env
BLOB_READ_WRITE_TOKEN=
```

```ts
import { put } from '@vercel/blob'
export async function uploadFile(file: File) {
  const blob = await put(file.name, file, { access: 'public' })
  return blob.url
}
```

### S3-compatible (AWS S3 / Cloudflare R2)
**Install:** `npm install @aws-sdk/client-s3 @aws-sdk/s3-request-presigner`
**Env vars:**
```env
AWS_REGION=
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_BUCKET_NAME=
# For R2: also set AWS_ENDPOINT_URL_S3
```

---

## AI Features

### Vercel AI SDK + AI Gateway

**Install:** `npm install ai`
**Env vars:**
```env
# AI Gateway handles provider routing — no provider-specific keys needed for gateway usage
OPENAI_API_KEY=    # or use Vercel AI Gateway
```

**Chat route:** `app/api/chat/route.ts`
```ts
import { streamText } from 'ai'

export async function POST(req: Request) {
  const { messages } = await req.json()
  const result = streamText({
    model: 'anthropic/claude-sonnet-4-6', // via AI Gateway
    messages,
  })
  return result.toDataStreamResponse()
}
```

**Chat component:** `components/chat.tsx`
```tsx
'use client'
import { useChat } from 'ai/react'

export function Chat() {
  const { messages, input, handleInputChange, handleSubmit } = useChat()
  return (
    <div>
      {messages.map(m => (
        <div key={m.id}>{m.role}: {m.content}</div>
      ))}
      <form onSubmit={handleSubmit}>
        <input value={input} onChange={handleInputChange} placeholder="Message..." />
        <button type="submit">Send</button>
      </form>
    </div>
  )
}
```

**RAG addition:** Add `npm install @ai-sdk/openai` for embeddings + chosen vector DB (Neon pgvector, Pinecone, or Upstash Vector).
