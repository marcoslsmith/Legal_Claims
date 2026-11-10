import { test } from 'node:test';
import assert from 'node:assert/strict';
import { makeHandler } from '../netlify/functions/staff.mjs';
import { exportRows } from '../public/admin/csv.js';

const origin = 'https://casehelpersapp.com';
const id = '11111111-1111-4111-8111-111111111111';

const env = {
  CASEHELPERS_SUPABASE_URL: 'https://fictional.supabase.co',
  CASEHELPERS_SUPABASE_PUBLISHABLE_KEY: 'public-test-key',
  CASEHELPERS_ALLOWED_ORIGIN: origin
};

function request(route, { token, body, headers = {} } = {}) {
  return new Request(origin + '/api/staff/' + route, {
    method: body ? 'POST' : 'GET',
    headers: {
      ...(token ? {
        cookie: '__Host-casehelpers-staff=' + token
      } : {}),
      ...(body ? {
        origin,
        'content-type': 'application/json'
      } : {}),
      ...headers
    },
    body: body ? JSON.stringify(body) : undefined
  });
}

function mock() {
  const calls = [];

  const handler = makeHandler(env, async (url, options) => {
    calls.push({ url: String(url), ...options });

    if (String(url).includes('/rpc/')) {
      return Response.json(
        options.headers.Authorization === 'Bearer staff'
      );
    }

    if (String(url).includes('/auth/')) {
      const email = JSON.parse(options.body).email;
      return Response.json({
        access_token:
          email === 'staff@example.invalid' ? 'staff' : 'outsider',
        expires_in: 3600
      });
    }

    return Response.json([{ request_id: id }]);
  });

  return { calls, handler };
}

test('anonymous users cannot read or write', async () => {
  const { handler, calls } = mock();

  for (const [route, body] of [
    ['leads'],
    ['status', {
      id, status: 'completed', previous: 'pending_callback'
    }],
    ['notes', { id, body: 'FICTIONAL TEST' }]
  ]) {
    const result = await handler(request(route, { body }));
    assert.equal(result.status, 401);
  }

  assert.equal(calls.length, 0);
});

test('signed-in nonstaff users cannot access records', async () => {
  const { handler, calls } = mock();

  for (const [route, body] of [
    ['leads'],
    ['notes?id=' + id],
    ['status', {
      id, status: 'completed', previous: 'pending_callback'
    }],
    ['notes', { id, body: 'FICTIONAL TEST' }]
  ]) {
    const result = await handler(
      request(route, { token: 'outsider', body })
    );
    assert.equal(result.status, 401);
  }

  assert(calls.every(call => call.url.includes('/rpc/')));
});

test('only staff receive a secure session cookie', async () => {
  const { handler } = mock();

  const denied = await handler(request('login', {
    body: {
      email: 'other@example.invalid',
      password: 'fictional'
    }
  }));
  assert.equal(denied.status, 403);

  const allowed = await handler(request('login', {
    body: {
      email: 'staff@example.invalid',
      password: 'fictional'
    }
  }));

  assert.equal(allowed.status, 200);
  assert.match(
    allowed.headers.get('set-cookie'),
    /Secure; HttpOnly; SameSite=Strict/
  );
  assert.deepEqual(await allowed.json(), {});
});

test('staff operations restrict which fields can change', async () => {
  const { handler, calls } = mock();

  const leads = await handler(request('leads', { token: 'staff' }));
  assert.equal(leads.status, 200);

  const note = await handler(request('notes', {
    token: 'staff',
    body: { id, body: ' FICTIONAL TEST ' }
  }));

  assert.equal(note.status, 200);
  assert.deepEqual(JSON.parse(calls.at(-1).body), {
    request_id: id,
    body: 'FICTIONAL TEST'
  });

  const status = await handler(request('status', {
    token: 'staff',
    body: {
      id,
      status: 'completed',
      previous: 'attempted',
      name: 'unauthorized change'
    }
  }));

  assert.equal(status.status, 200);
  assert.deepEqual(JSON.parse(calls.at(-1).body), {
    callback_status: 'completed'
  });
  assert.match(calls.at(-1).url, /callback_status=eq.attempted/);
  assert(calls.every(call => call.headers.apikey === 'public-test-key'));
});

test('cross-site requests and invalid inputs are denied', async () => {
  const { handler } = mock();

  const crossSite = await handler(request('notes', {
    token: 'staff',
    body: { id, body: 'FICTIONAL TEST' },
    headers: { origin: 'https://evil.invalid' }
  }));
  assert.equal(crossSite.status, 403);

  const invalidId = await handler(
    request('notes?id=bad', { token: 'staff' })
  );
  assert.equal(invalidId.status, 400);

  const invalidStatus = await handler(request('status', {
    token: 'staff',
    body: { id, status: 'invalid', previous: 'attempted' }
  }));
  assert.equal(invalidStatus.status, 400);
});

test('conflicts and unavailable services fail safely', async () => {
  const handler = makeHandler(env, async url =>
    Response.json(String(url).includes('/rpc/') ? true : [])
  );

  const conflict = await handler(request('status', {
    token: 'staff',
    body: { id, status: 'completed', previous: 'attempted' }
  }));
  assert.equal(conflict.status, 409);

  const unavailable = makeHandler(env, async () => {
    throw new Error('private upstream information');
  });

  const failure = await unavailable(
    request('leads', { token: 'staff' })
  );
  assert.equal(failure.status, 503);
  assert.deepEqual(await failure.json(), {});
});

test('CSV safely quotes values and neutralizes formulas', () => {
  const csv = exportRows([{
    name: '=HYPERLINK("bad")',
    phone: '+12025550147',
    intake: { answers: { test: 'line\nbreak' } }
  }]);

  assert(csv.startsWith('\uFEFF'));
  assert(csv.includes('"\u0027=HYPERLINK(""bad"")"'));
  assert(csv.includes('"\u0027+12025550147"'));
});
