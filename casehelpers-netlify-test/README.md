# CaseHelpers SSDI intake

## Preview

Run `python3 server.py` from this directory and open http://127.0.0.1:8765/. No dependencies are required beyond Python 3.9+. Use fictional information, such as Taylor Example and (202) 555-0147. Stop with Ctrl+C. Restarting clears test leads. The preview binds to loopback, keeps leads in an in-memory SQLite queue, and cannot send calls, notifications or referrals.

To test attribution, open `/?utm_source=preview&utm_campaign=callback-test`. The server records supported campaign tags and click IDs with the submission. No ad pixels, analytics scripts or external requests are used by the form.

## Deployment steps

1. Choose the final CaseHelpers hostname and a host that can run a same-origin intake API. Serve the files in `public/` over HTTPS and route `/api/session` and `/api/leads` to a production service. Use `server.py` as the request and validation reference. It is a local test harness. Keep staging access restricted and use test data.
2. Create a private, encrypted database and store each lead with an opaque ID, intake timestamp, answers, contact fields, supported attribution and exact consent text/version. Apply staff-only role-based access, audited reads and exports, retention and deletion rules, and encrypted backups. Exclude bodies and query strings from request, error and monitoring logs. Keep secrets in the host's secret store.
3. Insert the lead and a callback job in the same transaction. Acknowledge only after the write commits. Deduplicate retries using a unique request ID and use the lead ID as the CRM idempotency key. A worker should send the job to the team's restricted intake queue immediately, notify staff without including claimant details, retry failures and alert on delayed jobs. Staff place the callback within approved hours. Record first-attempt time and disposition. Confirm staffing and fallback coverage before advertising a callback timeframe.
4. Replace the preview token store and global throttle with short-lived same-origin tokens and shared edge/API rate limits. Keep server validation, request size limits, honeypot and replay protection. If abuse warrants a challenge, verify it server-side and choose an accessible flow that excludes claimant details.
5. Have counsel review the live copy, phone consent, operating hours, contact methods, privacy notice, terms, attribution handling and state-specific requirements. Replace both legal placeholders and update the consent version. During the callback, identify the independent provider, explain what would be shared and record separate permission before transmitting details. The form currently accepts adults with a U.S. callback number and does not reject adults based on screening answers.
6. In staging, confirm capture, retry deduplication, consent records, real CRM delivery and callback timing with fictional leads. Confirm that privacy and terms render and that no screening answers or contact details leave the approved intake systems. Then remove preview labels and replace the test thank-you copy with callback expectations. Point DNS at the selected host and verify HTTPS before sending ad traffic.

Report campaign performance from internal aggregate counts using recorded source tags and staff dispositions. Keep contact details, disability-related answers and lead-level qualification outcomes out of ad platforms. Review whether you need click IDs before enabling live capture.

References for legal review: [FTC on SSDI lead generation and calls](https://www.ftc.gov/business-guidance/blog/2025/09/are-you-telemarketing-business-heres-what-know-about-citizens-disability), [FTC on consumer health information](https://www.ftc.gov/business-guidance/resources/collecting-using-or-sharing-consumer-health-information-look-hipaa-ftc-act-health-breach), and [Social Security disability information](https://www.ssa.gov/disability).

## Staff callback review

The form adapts the publicly visible SSDI Guidance intake questions and adds checks drawn from [Oleg’s November 3 email](https://mail.google.com/mail/u/?authuser=marcos%40vividvisions.marketing#all/1a1a1e17cd8afce9). Each accepted lead stores a versioned `intake_screen` with the answers that need verification. Map these fields to the private CRM when integrating live delivery.

- **Possible match** (`possible_match`) — the self-reported answers align with the initial screen.
- **Needs review** (`needs_review`) — confirm uncertain answers, work credits, or an exception to the age guideline.
- **Likely outside intake criteria** (`likely_outside_intake_criteria`) — at least one reported answer conflicts with the initial criteria. Staff should confirm the answer and applicable rules.

All accepted submissions enter the same callback queue. The label is internal, unverified, and specific to the proposed DAG intake criteria. It does not establish SSA eligibility, representation, or billability. DAG described these as initial criteria for a proposed workflow. Confirm final rules with DAG before routing leads to them. No partner receives data from the preview. During the callback, ask “Have you already applied for SSDI?” If yes, ask whether they are waiting for a decision or have received a denial, and verify any appeal deadline. Also verify the treatment provider, work credits, and any missing details.

## Netlify and Supabase staging handoff

This folder is a standalone Netlify build. On a review branch of Legal_Claims, copy this folder as `casehelpers/` and merge a staging-only build configuration at the repository root to publish `casehelpers/public` and bundle `casehelpers/netlify/functions`. Keep the current main branch configuration until cutover. Verify your Netlify account supports the configured function rate limit. Restrict access to the preview in Netlify before enabling submission.

1. In a Supabase staging project, open **SQL Editor → New query** and run `setup-queue.sql` once. Use a separate staging project if available. The queue has no permissions for anonymous or signed-in website users. Limit Supabase dashboard access to authorized staff.
2. In Netlify’s environment variables for the staging deploy only, set `CASEHELPERS_SUPABASE_URL` to the project URL and `CASEHELPERS_SUPABASE_SECRET` to a Supabase secret API key. Use Functions scope. Set `CASEHELPERS_ALLOWED_ORIGIN` to the exact preview origin (HTTPS, no trailing slash), `CASEHELPERS_SIGNING_KEY` to a random secret of at least 32 bytes, and `CASEHELPERS_INTAKE_ENABLED` to `true`. Enter secrets directly in Netlify. Never commit them or share them in chat. Redeploy staging.
3. Submit a fictional test lead. In Supabase open **Table Editor → casehelpers_callback_queue**. Verify name, phone, consent, screening status and campaign tags. Verify a retry creates only one row. Check that the public API cannot list queue records and the stage endpoint cannot write without consent. This starter stores the queue only. It has no alerts or staff callback dashboard. Table Editor requires privileged access and should be limited to authorized operators.
4. Before production, configure private staff notifications and callback coverage, retention and access controls, finalize legal copy and screening rules, and test with fictional data. Update the preview label and confirmation copy so they accurately describe live storage. Keep intake disabled in production until those steps are complete.

## Staff dashboard

The existing Netlify deployment serves the dashboard at `/admin/`. Apply
`admin-migration.sql` in the Supabase project that already contains
`casehelpers_callback_queue`. Invite staff through Supabase Auth, then insert
each approved Auth user UUID into `public.casehelpers_staff` as a database
administrator. Remove that row to revoke queue access on the next request.
Set `CASEHELPERS_SUPABASE_PUBLISHABLE_KEY` in Netlify's Functions environment
for the same Supabase project. Keep the intake secret scoped to Functions.
The admin API uses the publishable key and the signed-in staff member's token.
Sessions expire after at most one hour and staff sign in again when needed.

The open dashboard checks for new submissions every five seconds. Alerts
contain no claimant details. Device alerts depend on browser support and
permission. A closed dashboard does not receive alerts. Exports include
contact information and should be handled as private claimant records.

Before production rollout, use fictional records in a restricted test
deployment. Verify anonymous and signed-in non-staff accounts cannot read
or change leads or notes, staff can do both, and the existing intake function
still inserts one row per request ID. Verify receipt, status edits, notes,
filtering, CSV and alerts in two separate staff sessions.
