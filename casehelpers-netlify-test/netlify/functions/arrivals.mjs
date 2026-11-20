import schema from '../../public/schema.json' with { type: 'json' };

const env = process.env;
const UTM_KEYS = schema.attributionKeys.filter(key => key.startsWith('utm_'));
const CLICK_ID_KEYS = schema.attributionKeys.filter(key => !key.startsWith('utm_'));
const VALUE_PATTERN = /^[\w .~+%:/-]{1,160}$/;

function response(status, body) {
  return Response.json(body, { status, headers: { 'Cache-Control': 'no-store' } });
}

export default async function handler(request) {
  // Same explicit activation and configuration as the intake handler.
  if (env.CASEHELPERS_INTAKE_ENABLED !== 'true'
    || !env.CASEHELPERS_SUPABASE_URL || !env.CASEHELPERS_SUPABASE_SECRET
    || !env.CASEHELPERS_ALLOWED_ORIGIN) return response(503, {});
  const url = new URL(request.url);
  if (url.origin !== env.CASEHELPERS_ALLOWED_ORIGIN) return response(403, {});
  if (request.method !== 'POST') return response(405, {});
  if (request.headers.get('origin') !== url.origin) return response(403, {});
  if (request.headers.get('content-type')?.split(';')[0] !== 'application/json') return response(415, {});
  // Count real page loads only, never prefetches or prerenders.
  const purpose = ['purpose', 'sec-purpose', 'x-purpose', 'x-moz']
    .map(name => request.headers.get(name) ?? '').join(' ').toLowerCase();
  if (/prefetch|prerender|preview/.test(purpose)) return response(204, {});

  let body;
  try {
    const text = await request.text();
    if (Buffer.byteLength(text) > 2048) return response(413, {});
    body = JSON.parse(text);
  } catch {
    return response(400, {});
  }
  const source = body && typeof body === 'object' && !Array.isArray(body)
    && body.attribution && typeof body.attribution === 'object' && !Array.isArray(body.attribution)
    ? body.attribution : null;
  if (!source) return response(422, {});

  // Store UTM campaign tags only. Click-ID values are dropped; only their
  // presence is kept as a boolean. No IP, user agent, referrer or page data.
  const attribution = {};
  for (const [key, value] of Object.entries(source)) {
    if (UTM_KEYS.includes(key) && typeof value === 'string' && VALUE_PATTERN.test(value)) {
      attribution[key] = value;
    }
  }
  const hasClickId = CLICK_ID_KEYS.some(
    key => typeof source[key] === 'string' && VALUE_PATTERN.test(source[key]));

  try {
    const endpoint = new URL('/rest/v1/casehelpers_arrivals', env.CASEHELPERS_SUPABASE_URL);
    if (endpoint.protocol !== 'https:') return response(503, {});
    const result = await fetch(endpoint, {
      method: 'POST',
      headers: {
        apikey: env.CASEHELPERS_SUPABASE_SECRET,
        'Content-Type': 'application/json',
        Prefer: 'return=minimal',
      },
      body: JSON.stringify({ attribution, has_click_id: hasClickId }),
      signal: AbortSignal.timeout(6500),
    });
    return result.ok ? response(201, {}) : response(503, {});
  } catch {
    return response(503, {});
  }
}

export const config = {
  path: '/api/arrivals',
  rateLimit: { windowLimit: 30, windowSize: 60, aggregateBy: ['ip'] },
};
