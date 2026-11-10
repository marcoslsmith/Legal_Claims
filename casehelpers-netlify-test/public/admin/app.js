import { exportRows } from './csv.js';

const $ = id => document.getElementById(id);
const labels = {
  pending_callback: 'Pending callback',
  attempted: 'Attempted',
  completed: 'Completed'
};

let rows = [];
let selected;
let active = false;
let loading = false;
let known = new Set();
let initialized = false;
let notesGeneration = 0;
let sessionGeneration = 0;
let refreshNotes;

const say = text => {
  $('message').textContent = text;
};

function clearSession() {
  sessionGeneration++;
  active = false;
  rows = [];
  selected = undefined;
  known.clear();
  initialized = false;
  notesGeneration++;
  refreshNotes = undefined;
  $('leads').replaceChildren();
  $('detail').replaceChildren();
  $('workspace').hidden = $('logout').hidden = true;
  $('login').hidden = false;
  $('signin').reset();
}

async function api(route, data) {
  const response = await fetch('/api/staff/' + route, {
    method: data ? 'POST' : 'GET',
    headers: data ? { 'Content-Type': 'application/json' } : {},
    body: data ? JSON.stringify(data) : undefined,
    cache: 'no-store',
    signal: AbortSignal.timeout(15000)
  });

  if (!response.ok) {
    if (response.status === 401 && active) clearSession();

    throw new Error(
      response.status === 409
        ? 'Another staff member changed this status. Refresh and try again.'
        : response.status === 401 || response.status === 403
          ? 'Sign in with an approved staff account.'
          : 'Unable to complete this request. Please try again.'
    );
  }

  return response.json();
}

function el(tag, text, className) {
  const node = document.createElement(tag);
  if (text !== undefined) node.textContent = text;
  if (className) node.className = className;
  return node;
}

function filtered() {
  const term = $('search').value.trim().toLowerCase();

  return rows.filter(row =>
    (!term || (row.name + ' ' + row.phone).toLowerCase().includes(term)) &&
    (!$('status').value || row.callback_status === $('status').value) &&
    (!$('campaign').value.trim() ||
      row.intake?.attribution?.utm_campaign === $('campaign').value.trim())
  );
}

function render() {
  const visible = filtered();
  const pending = rows.filter(
    row => row.callback_status === 'pending_callback'
  ).length;

  $('count').textContent =
    `${visible.length} submissions · ${pending} pending`;

  $('leads').replaceChildren(...visible.map(row => {
    const button = el('button', undefined, 'lead');
    button.type = 'button';
    button.setAttribute('aria-pressed', String(selected === row.request_id));

    button.append(
      el('strong', row.name),
      el('span', labels[row.callback_status], 'badge'),
      el('div', new Date(row.received_at).toLocaleString(), 'meta'),
      el('div', row.intake?.attribution?.utm_campaign || 'No campaign', 'meta')
    );

    button.onclick = () => {
      selected = row.request_id;
      render();
      detail(row);
    };

    return button;
  }));

  if (!visible.length) {
    $('leads').append(el('p', 'No submissions match these filters.'));
  }
}

function pairs(title, data) {
  const section = el('section');
  section.append(el('h3', title));

  const dl = el('dl');

  for (const [key, value] of Object.entries(data || {})) {
    dl.append(
      el('dt', key.replaceAll('_', ' ')),
      el(
        'dd',
        typeof value === 'object'
          ? JSON.stringify(value, null, 2)
          : String(value)
      )
    );
  }

  section.append(dl);
  return section;
}

async function detail(row) {
  const generation = ++notesGeneration;
  const panel = $('detail');

  panel.replaceChildren(
    el('p', new Date(row.received_at).toLocaleString(), 'meta'),
    el('h2', row.name)
  );

  const call = el('a', 'Call ' + row.phone, 'call');
  call.href = 'tel:+1' + row.phone.replace(/\D/g, '');

  panel.append(
    call,
    el('p', 'Submission ' + row.request_id, 'meta')
  );

  const label = el('label', 'Callback status');
  const status = el('select');
  status.setAttribute('aria-label', 'Update callback status');

  for (const [value, text] of Object.entries(labels)) {
    const option = el('option', text);
    option.value = value;
    status.append(option);
  }

  status.value = row.callback_status;
  label.append(status);
  panel.append(label);

  status.onchange = async () => {
    status.disabled = true;

    try {
      await api('status', {
        id: row.request_id,
        status: status.value,
        previous:
          rows.find(item => item.request_id === row.request_id)
            ?.callback_status || row.callback_status
      });

      row.callback_status = status.value;
      render();
      say('Status saved.');
    } catch (error) {
      status.value = row.callback_status;
      say(error.message);
    } finally {
      status.disabled = false;
    }
  };

  panel.append(
    pairs('Screening · self-reported', {
      status: row.screening_status,
      ...row.intake?.intake_screen
    }),
    pairs('Submitted answers', row.intake?.answers),
    pairs('Campaign attribution', row.intake?.attribution),
    pairs('Consent record', row.intake?.consent)
  );

  const form = el('form');
  const noteLabel = el('label', 'Add a staff note');
  const body = el('textarea');
  body.required = true;
  body.maxLength = 2000;
  noteLabel.append(body);

  const save = el('button', 'Save note');
  form.append(noteLabel, save);

  const list = el('div');
  panel.append(el('h3', 'Staff notes'), form, list);

  const showNotes = notes => {
    list.replaceChildren(...notes.map(note => {
      const item = el('p', undefined, 'note');
      item.append(
        el('time', new Date(note.created_at).toLocaleString()),
        el('span', note.body)
      );
      return item;
    }));

    if (!notes.length) list.append(el('p', 'No notes yet.'));
  };

  form.onsubmit = async event => {
    event.preventDefault();
    save.disabled = true;

    try {
      await api('notes', {
        id: row.request_id,
        body: body.value
      });

      body.value = '';
      const notes = await api('notes?id=' + row.request_id);

      if (generation === notesGeneration) showNotes(notes);
      say('Note saved.');
    } catch (error) {
      say(error.message);
    } finally {
      save.disabled = false;
    }
  };

  refreshNotes = async () => {
    const notes = await api('notes?id=' + row.request_id);
    if (generation === notesGeneration) showNotes(notes);
  };

  try {
    await refreshNotes();
  } catch (error) {
    say(error.message);
  }
}

async function refresh() {
  if (loading) return;
  loading = true;
  const session = sessionGeneration;

  try {
    const all = [];

    for (let offset = 0; ; offset += 100) {
      const batch = await api('leads?offset=' + offset);
      all.push(...batch);
      if (batch.length < 100) break;
    }

    if (session !== sessionGeneration) return;

    if (active === false && $('login').hidden === false) {
      active = true;
      $('login').hidden = true;
      $('workspace').hidden = $('logout').hidden = false;
    }

    if (session !== sessionGeneration) return;

    const added = all.filter(row => !known.has(row.request_id));

    if (initialized && added.length) {
      const text =
        `${added.length} new submission${added.length === 1 ? '' : 's'} received.`;

      $('new').textContent = text;
      $('new').hidden = false;

      if ('Notification' in window &&
          Notification.permission === 'granted') {
        new Notification('CaseHelpers', {
          body: text,
          tag: 'casehelpers-new'
        });
      }
    }

    known = new Set(all.map(row => row.request_id));
    initialized = true;
    rows = all;
    render();

    $('sync').textContent =
      'Live · Updated ' + new Date().toLocaleTimeString() +
      ' · Checks every 5 seconds';

    if (refreshNotes) await refreshNotes();

    if (selected) {
      const current = rows.find(row => row.request_id === selected);
      const control = $('detail').querySelector('select');

      if (current && control && !control.disabled) {
        control.value = current.callback_status;
      }
    }
  } catch (error) {
    say(error.message);
    $('sync').textContent = 'Updates paused · Retry with Refresh';
  } finally {
    loading = false;
  }
}

$('signin').onsubmit = async event => {
  event.preventDefault();
  const button = event.target.querySelector('button');
  button.disabled = true;
  say('');

  try {
    await api('login', {
      email: event.target.email.value.trim(),
      password: event.target.password.value
    });

    event.target.reset();
    await refresh();
  } catch (error) {
    say(error.message);
  } finally {
    button.disabled = false;
  }
};

$('logout').onclick = async () => {
  try {
    await api('logout', {});
    clearSession();
    say('Signed out.');
  } catch (error) {
    say(error.message);
  }
};

for (const id of ['search', 'status', 'campaign']) {
  $(id).addEventListener('input', render);
}

$('refresh').onclick = refresh;

$('alerts').onclick = async () => {
  if (!('Notification' in window)) {
    return say(
      'Device alerts are unavailable in this browser. In-page alerts remain active.'
    );
  }

  const result = await Notification.requestPermission();

  say(
    result === 'granted'
      ? 'Device alerts enabled while this dashboard is open.'
      : 'Device alerts are off. In-page alerts remain active.'
  );
};

$('export').onclick = () => {
  const blob = new Blob([exportRows(filtered())], {
    type: 'text/csv;charset=utf-8'
  });

  const url = URL.createObjectURL(blob);
  const link = el('a');
  link.href = url;
  link.download =
    'casehelpers-private-' + new Date().toISOString().slice(0, 10) + '.csv';
  link.click();

  setTimeout(() => URL.revokeObjectURL(url), 1000);
};

setInterval(() => {
  if (active && !document.hidden) refresh();
}, 5000);

document.addEventListener('visibilitychange', () => {
  if (active && !document.hidden) refresh();
});

refresh();
