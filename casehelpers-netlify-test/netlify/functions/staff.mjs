const statuses = ['pending_callback', 'attempted', 'completed'];
const queue = '/rest/v1/casehelpers_callback_queue';
const notes = '/rest/v1/casehelpers_callback_notes';
const columns = 'request_id,received_at,callback_status,name,phone,screening_status,intake';
const uuid = /^[0-9a-f]{8}-(?:[0-9a-f]{4}-){3}[0-9a-f]{12}$/i;

function reply(status, body, headers) {
  return Response.json(body, { status, headers: { 'Cache-Control': 'no-store', ...headers } });
}

export function makeHandler(env, fetcher = fetch) {
  return async function staff(request) {
    const url = new URL(request.url);
    const key = env.CASEHELPERS_SUPABASE_PUBLISHABLE_KEY;
    const base = env.CASEHELPERS_SUPABASE_URL;
    if (!key || !base?.startsWith('https://')) return reply(503, {});
    if (url.origin !== env.CASEHELPERS_ALLOWED_ORIGIN || request.headers.get('sec-fetch-site') === 'cross-site') return reply(403, {});
    const write = request.method === 'POST';
    if (write && (request.headers.get('origin') !== url.origin || request.headers.get('content-type')?.split(';')[0] !== 'application/json')) return reply(403, {});
    const route = url.pathname.replace('/api/staff/', '');
    const call = (path, { token, method = 'GET', data, prefer } = {}) => fetcher(new URL(path, base), {
      method, headers: { apikey: key, 'Content-Type': 'application/json',
        ...(token && { Authorization: 'Bearer ' + token }), ...(prefer && { Prefer: prefer }) },
      body: data === undefined ? undefined : JSON.stringify(data), signal: AbortSignal.timeout(8000),
    });
    try {
      const token = request.headers.get('cookie')?.match(/(?:^|; )__Host-casehelpers-staff=([\w.-]+)(?:;|$)/)?.[1];
      const cookie = (value, maxAge) => ({ 'Set-Cookie': `__Host-casehelpers-staff=${value}; Path=/; Secure; HttpOnly; SameSite=Strict; Max-Age=${maxAge}` });
      let input;
      if (write) {
        const raw = await request.text();
        if (raw.length > 8192) return reply(413, {});
        try { input = JSON.parse(raw); } catch { return reply(400, {}); }
        if (!input || typeof input !== 'object' || Array.isArray(input)) return reply(400, {});
      }
      const staffAllowed = async accessToken => {
        const check = await call('/rest/v1/rpc/casehelpers_is_staff', { token: accessToken, method: 'POST', data: {} });
        if (check.status === 401 || check.status === 403) return false;
        if (!check.ok) throw new Error('Staff verification unavailable');
        return (await check.json()) === true;
      };
      if (write && route === 'logout') return reply(200, {}, cookie('', 0));
      if (write && route === 'login') {
        if (typeof input.email !== 'string' || input.email.length > 254 || typeof input.password !== 'string' || input.password.length > 1024) return reply(400, {});
        const auth = await call('/auth/v1/token?grant_type=password', { method: 'POST', data: { email: input.email, password: input.password } });
        if (!auth.ok) return reply(auth.status === 429 ? 429 : auth.status >= 500 ? 503 : 401, {});
        const session = await auth.json();
        if (typeof session.access_token !== 'string' || !/^[\w.-]+$/.test(session.access_token) || !await staffAllowed(session.access_token)) return reply(403, {});
        return reply(200, {}, cookie(session.access_token, Math.min(session.expires_in || 3600, 3600)));
      }
      if (!token || !await staffAllowed(token)) return reply(401, {}, cookie('', 0));
      const id = write ? input.id : url.searchParams.get('id');
      if (id && !uuid.test(id)) return reply(400, {});
      let result;
      if (request.method === 'GET' && route === 'leads') {
        const query = new URLSearchParams({ select: columns, order: 'received_at.desc,request_id.desc', limit: '100' });
        const offset = url.searchParams.get('offset') || '0';
        if (!/^\d{1,7}$/.test(offset)) return reply(400, {});
        query.set('offset', offset);
        const status = url.searchParams.get('status');
        if (status) {
          if (!statuses.includes(status)) return reply(400, {});
          query.set('callback_status', 'eq.' + status);
        }
        const campaign = url.searchParams.get('campaign');
        if (campaign) {
          if (!/^[A-Za-z0-9_ .~+%:/-]{1,160}$/.test(campaign)) return reply(400, {});
          query.set('intake->attribution->>utm_campaign', 'eq.' + campaign);
        }
        result = await call(queue + '?' + query, { token });
      } else if (request.method === 'GET' && route === 'notes' && id) {
        result = await call(notes + '?select=id,created_at,body&request_id=eq.' + id + '&order=created_at.desc,id.desc', { token });
      } else if (write && route === 'notes' && id && typeof input.body === 'string' && input.body.trim().length && input.body.trim().length <= 2000) {
        result = await call(notes + '?select=id,created_at,body', { token, method: 'POST', data: { request_id: id, body: input.body.trim() }, prefer: 'return=representation' });
      } else if (write && route === 'status' && id && statuses.includes(input.status) && statuses.includes(input.previous)) {
        result = await call(queue + '?select=request_id&request_id=eq.' + id + '&callback_status=eq.' + input.previous, { token, method: 'PATCH', data: { callback_status: input.status }, prefer: 'return=representation' });
      } else return reply(400, {});
      if (!result.ok) return reply(result.status === 401 || result.status === 403 ? 401 : 503, {});
      const data = await result.json();
      if (route === 'status' && !data.length) return reply(409, {});
      return reply(200, data);
    } catch {
      return reply(503, {});
    }
  };
}

export default makeHandler(process.env);
export const config = {
  path: ['/api/staff/login', '/api/staff/logout', '/api/staff/leads', '/api/staff/notes', '/api/staff/status'],
  rateLimit: { windowLimit: 120, windowSize: 60, aggregateBy: ['ip'] },
};
