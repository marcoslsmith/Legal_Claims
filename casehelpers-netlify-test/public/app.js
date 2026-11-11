const get = id => document.getElementById(id);
const form = get('form');
const fields = get('fields');
const error = get('error');
const next = get('next');
const back = get('back');
const answers = {};
const contact = { name: '', phone: '', consent: false, website: '' };
let step = 0;
let busy = false;

function showError(message, input) {
  error.hidden = false;
  error.textContent = message;
  if (input) {
    input.setAttribute('aria-invalid', 'true');
    input.setAttribute('aria-describedby', 'error');
    input.focus();
  }
}

async function start() {
  const responses = await Promise.all(['/schema.json', '/api/session'].map(url => fetch(url)));
  if (responses.some(response => !response.ok)) throw new Error('Unavailable');
  const [schema, session] = await Promise.all(responses.map(response => response.json()));
  const { questions, consentText, consentVersion, attributionKeys } = schema;
  const params = new URLSearchParams(location.search);
  const attribution = Object.fromEntries(attributionKeys.flatMap(key => {
    const value = params.get(key);
    return value && /^[\w .~+%:/-]{1,160}$/.test(value) ? [[key, value]] : [];
  }));
  const requestId = session.id;
  get('progress').max = questions.length + 1;
  // Keep answers in this tab's memory only.
  function render(focus = true) {
    const question = questions[step];
    get('stage').textContent = question?.stage ?? 'Callback details';
    get('count').textContent = `Step ${step + 1} of ${questions.length + 1}`;
    get('progress').value = step + 1;
    error.hidden = true;
    back.hidden = step === 0;
    next.textContent = question ? 'Continue →' : 'Get my free callback →';
    fields.replaceChildren();
    if (question) {
      const group = document.createElement('fieldset');
      const title = document.createElement('legend');
      title.textContent = question.label;
      group.append(title);
      question.options.forEach(value => {
        const label = document.createElement('label');
        label.className = 'option';
        const input = document.createElement('input');
        Object.assign(input, { type: 'radio', name: question.key, value, required: true, checked: answers[question.key] === value });
        label.append(input, value);
        group.append(label);
      });
      fields.append(group);
    } else {
      fields.innerHTML = `<h2 class="question">Where should we call you?</h2>
        <label class="contact">Full name <input name="name" autocomplete="name" required maxlength="100"></label>
        <label class="contact">U.S. phone number <input type="tel" name="phone" autocomplete="tel" required maxlength="25"></label>
        <label class="consent"><input type="checkbox" name="consent" required><span id="consent-copy"></span></label>
        <div class="trap" aria-hidden="true"><label>Leave blank <input name="website" tabindex="-1" autocomplete="off"></label></div>
        <p class="small">Review the <a href="/privacy.html" target="_blank" rel="noopener">privacy notice</a> and <a href="/terms.html" target="_blank" rel="noopener">terms of use</a> (opens in a new tab).</p>`;
      get('consent-copy').textContent = consentText;
      form.elements.name.value = contact.name;
      form.elements.phone.value = contact.phone;
      form.elements.consent.checked = contact.consent;
      form.elements.website.value = contact.website;
    }
    if (focus) {
      const heading = fields.querySelector('legend, h2');
      heading.tabIndex = -1;
      heading.focus();
    }
  }

  back.addEventListener('click', () => {
    if (busy) return;
    if (step === questions.length) saveContact();
    step -= 1;
    render();
  });

  function saveContact() {
    for (const name of ['name', 'phone', 'website']) contact[name] = form.elements[name].value.trim();
    contact.consent = form.elements.consent.checked;
  }

  form.addEventListener('input', () => {
    error.hidden = true;
    fields.querySelectorAll('[aria-invalid]').forEach(input => {
      input.removeAttribute('aria-invalid');
      input.removeAttribute('aria-describedby');
    });
    const question = questions[step];
    if (question) answers[question.key] = form.elements[question.key].value;
  });

  form.addEventListener('submit', async event => {
    event.preventDefault();
    if (busy) return;
    const question = questions[step];
    if (question) {
      const value = form.elements[question.key].value;
      if (!value) return showError('Choose an answer to continue.', fields.querySelector('input'));
      if (question.key === 'age' && value === 'Under 18') {
        return showError('This callback form is for adults. Please visit Social Security for information about benefits for children.', fields.querySelector('input:checked'));
      }
      answers[question.key] = value;
      step += 1;
      return render();
    }
    saveContact();
    if (contact.name.length < 2) return showError('Enter your full name.', form.elements.name);
    const phone = contact.phone.replace(/\D/g, '').replace(/^1(?=\d{10}$)/, '');
    if (!/^[+\d(). -]+$/.test(contact.phone) || !/^[2-9]\d{2}[2-9]\d{6}$/.test(phone)) {
      return showError('Enter a valid 10-digit U.S. phone number.', form.elements.phone);
    }
    if (!contact.consent) return showError('Check the box if you agree to receive a call from CaseHelpers.', form.elements.consent);
    busy = true;
    next.disabled = back.disabled = true;
    next.textContent = 'Sending…';
    error.hidden = true;
    try {
      const response = await fetch('/api/leads', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ requestId, answers, ...contact, phone, consentVersion, attribution }),
        signal: AbortSignal.timeout(10000),
      });
      if (!response.ok) {
        if (response.status === 429) return showError('Please wait a moment before trying again.');
        if (response.status === 410) return showError('This form session expired. Reload the page to start again.');
        return showError('We couldn’t confirm your request. Please try again.');
      }
      get('flow').hidden = true;
      const thanks = get('thanks');
      thanks.innerHTML = '<h2 tabindex="-1">Request received.</h2><p>A member of the CaseHelpers team will call you at the number you provided to discuss your request.</p><a href="/">Return to CaseHelpers</a>';
      thanks.hidden = false;
      thanks.querySelector('h2').focus();
    } catch {
      showError('We couldn’t confirm your request. Check your connection and try again.');
    } finally {
      busy = false;
      next.disabled = back.disabled = false;
      next.textContent = 'Get my free callback →';
    }
  });
  get('flow').hidden = false;
  render(false);
}

start().catch(() => {
  const notice = get('preview');
  notice.hidden = false;
  notice.setAttribute('role', 'alert');
  notice.textContent = 'The callback form could not load. Please refresh to try again.';
});
