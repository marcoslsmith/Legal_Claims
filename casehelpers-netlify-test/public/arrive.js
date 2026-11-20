// First-party arrival counter. Reports this page load's campaign tags to the
// site's own /api/arrivals endpoint. No third-party requests, no quiz
// answers, no contact data. Click-ID values are dropped server-side; only
// their presence is stored. Measurement must never break the page.
try {
  const keys = ['utm_source', 'utm_medium', 'utm_campaign', 'utm_content',
    'utm_term', 'utm_id', 'fbclid', 'gclid', 'msclkid'];
  const params = new URLSearchParams(location.search);
  const attribution = {};
  for (const key of keys) {
    const value = params.get(key);
    if (value && /^[\w .~+%:/-]{1,160}$/.test(value)) attribution[key] = value;
  }
  fetch('/api/arrivals', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ attribution }),
    keepalive: true,
  }).catch(() => {});
} catch {
  // Ignore measurement failures.
}
