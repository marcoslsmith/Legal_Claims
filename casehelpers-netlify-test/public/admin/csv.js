export const csvCell = value =>
  '"' +
  String(value ?? '')
    .replace(/^[\s=+@-]/, "'$&")
    .replaceAll('"', '""') +
  '"';

export function exportRows(rows) {
  const fields = [
    'request_id',
    'received_at',
    'callback_status',
    'name',
    'phone',
    'screening_status',
  ];

  const heading = fields.concat([
    'attribution',
    'answers',
    'screening',
    'consent',
  ]);

  const lines = rows.map(row => {
    const values = [
      ...fields.map(key => row[key]),
      ...['attribution', 'answers', 'intake_screen', 'consent']
        .map(key => JSON.stringify(row.intake?.[key] ?? {})),
    ];

    return values.map(csvCell).join(',');
  });

  return '\uFEFF' + [
    heading.map(csvCell).join(','),
    ...lines,
  ].join('\r\n');
}
