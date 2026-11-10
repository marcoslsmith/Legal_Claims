import { createHmac, randomUUID, timingSafeEqual } from 'node:crypto';
import schema from '../../public/schema.json' with { type: 'json' };

const env = process.env;
const options = Object.fromEntries(schema.questions.map(q => [q.key, q.options]));

function response(status, body) {
  return Response.json(body, { status, headers: { 'Cache-Control': 'no-store' } });
}

function sign(value) {
  return createHmac('sha256', env.CASEHELPERS_SIGNING_KEY).update(value).digest('hex');
}

function validAnswers(answers) {
  return answers && typeof answers === 'object'
    && Object.keys(answers).length === schema.questions.length
    && schema.questions.every(q => options[q.key].includes(answers[q.key]))
    && answers.age !== 'Under 18';
}

function screen(answers) {
  const mismatches = [];
  const review = [];
  const expected = {
    employment: 'No', duration: 'Yes', treatment: 'Yes',
    documented: 'Yes', representation: 'No', benefits: 'No',
  };
  for (const [key, value] of Object.entries(expected)) {
    const answer = answers[key];
    if (answer === value) continue;
    const uncertain = answer.startsWith('I’m not sure') || (key === 'employment' && answer === 'I’m on leave');
    (uncertain ? review : mismatches).push(key);
  }
  if (answers.age === '62 or older') review.push('age');
  if (answers.work !== 'Yes' || !['Within the past year', '1 to 5 years ago', 'I’m currently working'].includes(answers.lastWorked)) {
    review.push('work_credits');
  }
  let status = 'possible_match';
  if (mismatches.length) status = 'likely_outside_intake_criteria';
  else if (review.length) status = 'needs_review';
  const reasons = {
    possible_match: 'All online checks passed based on self-reported answers. Staff must still verify claim stage, any appeal deadline, and work credits.',
    needs_review: 'One or more answers need clarification. Review the flagged items during the callback.',
    likely_outside_intake_criteria: 'One or more answers conflict with the initial intake criteria. Confirm the flagged answers during the callback.',
  };
  return {
    version: 'dag-initial-2026-11-03-v3',
    reason: reasons[status],
    status,
    reported_mismatches: mismatches,
    review_items: review,
    callback_checks: ['Confirm claim stage and any applicable appeal deadline.'],
  };
}

export default async function handler(request) {
  // Explicit activation is required for both staging and production.
  if (env.CASEHELPERS_INTAKE_ENABLED !== 'true' || !env.CASEHELPERS_SIGNING_KEY
    || !env.CASEHELPERS_SUPABASE_URL || !env.CASEHELPERS_SUPABASE_SECRET
    || !env.CASEHELPERS_ALLOWED_ORIGIN) return response(503, {});
  const url = new URL(request.url);
  if (url.origin !== env.CASEHELPERS_ALLOWED_ORIGIN) return response(403, {});
  if (url.pathname === '/api/session' && request.method === 'GET') {
    if (request.headers.get('sec-fetch-site') === 'cross-site') return response(403, {});
    const token = `${randomUUID()}.${Date.now()}`;
    return response(200, { id: `${token}.${sign(token)}` });
  }
  if (url.pathname !== '/api/leads' || request.method !== 'POST') return response(405, {});
  if (request.headers.get('origin') !== url.origin) return response(403, {});
  if (request.headers.get('content-type')?.split(';')[0] !== 'application/json') return response(415, {});

  let lead;
  try {
    const body = await request.text();
    if (Buffer.byteLength(body) > 8192) return response(413, {});
    lead = JSON.parse(body);
  } catch {
    return response(400, {});
  }
  const name = typeof lead?.name === 'string' ? lead.name.trim() : '';
  if (!validAnswers(lead?.answers) || lead.consent !== true || lead.website !== ''
    || lead.consentVersion !== schema.consentVersion || name.length < 2 || name.length > 100
    || /[\x00-\x1f]/.test(name) || typeof lead.phone !== 'string'
    || !/^[2-9]\d{2}[2-9]\d{6}$/.test(lead.phone)
    || !lead.attribution || typeof lead.attribution !== 'object' || Array.isArray(lead.attribution)
    || Object.entries(lead.attribution).some(([key, value]) => !schema.attributionKeys.includes(key)
      || typeof value !== 'string' || !/^[A-Za-z0-9_ .~+%:/-]{1,160}$/.test(value))) return response(422, {});

  const token = typeof lead.requestId === 'string'
    && lead.requestId.match(/^([a-f0-9-]{36})\.(\d{13})\.([a-f0-9]{64})$/);
  if (!token) return response(410, {});
  const [, id, issued, signature] = token;
  if (!timingSafeEqual(Buffer.from(signature), Buffer.from(sign(`${id}.${issued}`)))) return response(410, {});
  const age = Date.now() - Number(issued);
  if (age < 2000) return response(429, {});
  if (age > 3600000) return response(410, {});

  const screening = screen(lead.answers);
  try {
    const endpoint = new URL('/rest/v1/casehelpers_callback_queue?on_conflict=request_id', env.CASEHELPERS_SUPABASE_URL);
    if (endpoint.protocol !== 'https:') return response(503, {});
    const result = await fetch(endpoint, {
      method: 'POST',
      headers: {
        apikey: env.CASEHELPERS_SUPABASE_SECRET,
        'Content-Type': 'application/json',
        Prefer: 'resolution=ignore-duplicates,return=minimal',
      },
      body: JSON.stringify({
        request_id: id, name, phone: lead.phone, screening_status: screening.status,
        intake: {
          answers: lead.answers, attribution: lead.attribution, intake_screen: screening,
          consent: { accepted: true, version: schema.consentVersion, text: schema.consentText },
        },
      }),
      signal: AbortSignal.timeout(6500),
    });
    return result.ok ? response(201, { received: true }) : response(503, {});
  } catch {
    return response(503, {});
  }
}

export const config = {
  path: ['/api/session', '/api/leads'],
  rateLimit: { windowLimit: 20, windowSize: 60, aggregateBy: ['ip'] },
};
