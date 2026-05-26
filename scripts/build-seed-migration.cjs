/* eslint-disable no-console */
/**
 * Reads /Users/marsmith/Downloads/live_mass_tort_class_action_seed_cases (1).xlsx
 * and produces a fully idempotent SQL migration that:
 *  - Adds new descriptive columns to the cases table
 *  - Inserts/updates 30 cases by slug
 *  - Inserts/updates 5 reusable global questions (used across all cases)
 *  - Inserts/updates 90 case-specific questions (3 per case x 30 cases)
 *  - Links 8 questions to each case via case_questions (240 rows)
 *  - Wipes & rewrites matching_rules tagged with `[seed:2026-05-25]`
 *
 * The output is written to:
 *   supabase/migrations/20260525190000_seed_30_live_cases.sql
 */

const XLSX = require('xlsx');
const fs = require('fs');
const path = require('path');

const SRC = '/Users/marsmith/Downloads/live_mass_tort_class_action_seed_cases (1).xlsx';
const OUT = path.join(__dirname, '..', 'supabase', 'migrations', '20260525190000_seed_30_live_cases.sql');
const SEED_TAG = '[seed:2026-05-25]';

const wb = XLSX.readFile(SRC);
const cases = XLSX.utils.sheet_to_json(wb.Sheets['Cases'], { defval: null });
const questions = XLSX.utils.sheet_to_json(wb.Sheets['QualificationQuestions'], { defval: null });

// ---------- helpers ----------
/** Wrap text in a dollar-quoted PostgreSQL string. Avoids any escaping issues. */
function pgStr(v) {
  if (v == null || v === '') return 'NULL';
  const s = String(v);
  // Pick a unique tag that does not appear in the value.
  let tag = 'q';
  while (s.includes(`$${tag}$`)) tag += 'x';
  return `$${tag}$${s}$${tag}$`;
}

function pgArray(arr) {
  if (!arr || arr.length === 0) return `'{}'::text[]`;
  const inner = arr.map(v => `${pgStr(v)}`).join(', ');
  return `ARRAY[${inner}]::text[]`;
}

function caseTypeFor(t) {
  if (!t) return 'mass_tort';
  return /class action/i.test(t) ? 'class_action' : 'mass_tort';
}

function priorityFor(confidence) {
  if (!confidence) return 50;
  if (/high/i.test(confidence)) return 75;
  if (/medium/i.test(confidence)) return 55;
  if (/low/i.test(confidence)) return 35;
  return 50;
}

function confidenceLabelFor(c) {
  return c ? c.replace(/\s+/g, ' ').trim() : null;
}

function shortDescFor(row) {
  const s = (row.summary || '').toString().trim();
  if (s.length <= 200) return s;
  return s.slice(0, 197).trimEnd() + '…';
}

function sourceUrlsFor(s) {
  if (!s) return [];
  return String(s).split(/[;\n]+/).map(x => x.trim()).filter(Boolean);
}

function docOptionsFor(likelyDocsText) {
  if (!likelyDocsText) return ['Other / Not sure'];
  // Comma-separated free text, ending in a period
  const parts = String(likelyDocsText)
    .replace(/\.$/, '')
    .split(/,(?![^()]*\))/)
    .map(p => p.trim())
    .filter(Boolean);
  // De-dupe & cap to keep UI clean
  const seen = new Set();
  const cleaned = [];
  for (const p of parts) {
    const norm = p.replace(/\s+/g, ' ').trim();
    const lc = norm.toLowerCase();
    if (!seen.has(lc) && norm.length <= 100) {
      seen.add(lc);
      cleaned.push(norm);
    }
  }
  return [...cleaned, 'Other / Not sure', 'I do not have records yet'];
}

const US_STATES = [
  'AL','AK','AZ','AR','CA','CO','CT','DE','FL','GA','HI','ID','IL','IN','IA','KS','KY','LA','ME',
  'MD','MA','MI','MN','MS','MO','MT','NE','NV','NH','NJ','NM','NY','NC','ND','OH','OK','OR','PA',
  'RI','SC','SD','TN','TX','UT','VT','VA','WA','WV','WI','WY','DC',
];

// ---------- SQL building ----------
const sql = [];
sql.push(`-- ==========================================================================
-- Seed 30 active mass-tort and class-action cases (research-grade)
-- Generated from: live_mass_tort_class_action_seed_cases (1).xlsx
-- Tag: ${SEED_TAG}
-- Idempotent: re-running this migration is safe.
-- ==========================================================================
`);

// 1. New columns on cases (additive, non-breaking)
sql.push(`-- ----- 1. Extend cases table with descriptive intake fields -----
ALTER TABLE public.cases
  ADD COLUMN IF NOT EXISTS category text,
  ADD COLUMN IF NOT EXISTS payout_language text,
  ADD COLUMN IF NOT EXISTS core_qualifications text,
  ADD COLUMN IF NOT EXISTS disqualifiers_summary text,
  ADD COLUMN IF NOT EXISTS likely_documents text,
  ADD COLUMN IF NOT EXISTS deadline_or_timing text,
  ADD COLUMN IF NOT EXISTS source_urls text[] DEFAULT '{}',
  ADD COLUMN IF NOT EXISTS admin_review_notes text,
  ADD COLUMN IF NOT EXISTS confidence_label text,
  ADD COLUMN IF NOT EXISTS is_research_grade boolean DEFAULT false;
`);

// 2. Insert 30 cases
sql.push(`-- ----- 2. Insert / update 30 cases -----`);
for (const c of cases) {
  const slug = c.case_id.replace(/_/g, '-');
  sql.push(`INSERT INTO public.cases (
  slug, name, case_type, status, short_description, long_description,
  priority_score, category, payout_language, core_qualifications,
  disqualifiers_summary, likely_documents, deadline_or_timing, source_urls,
  admin_review_notes, confidence_label, is_research_grade,
  require_medical_docs, required_doc_types, allowed_states, disqualifying_states
) VALUES (
  ${pgStr(slug)},
  ${pgStr(c.case_name)},
  ${pgStr(caseTypeFor(c.type))},
  'active',
  ${pgStr(shortDescFor(c))},
  ${pgStr(c.summary)},
  ${priorityFor(c.confidence)},
  ${pgStr(c.category)},
  ${pgStr(c.payout_language)},
  ${pgStr(c.core_qualifications)},
  ${pgStr(c.disqualifiers)},
  ${pgStr(c.likely_documents)},
  ${pgStr(c.deadline_or_timing)},
  ${pgArray(sourceUrlsFor(c.source_urls))},
  ${pgStr(c.admin_review_notes)},
  ${pgStr(confidenceLabelFor(c.confidence))},
  true,
  false,
  '{}'::text[],
  '{}'::text[],
  '{}'::text[]
)
ON CONFLICT (slug) DO UPDATE SET
  name = EXCLUDED.name,
  case_type = EXCLUDED.case_type,
  short_description = EXCLUDED.short_description,
  long_description = EXCLUDED.long_description,
  category = EXCLUDED.category,
  payout_language = EXCLUDED.payout_language,
  core_qualifications = EXCLUDED.core_qualifications,
  disqualifiers_summary = EXCLUDED.disqualifiers_summary,
  likely_documents = EXCLUDED.likely_documents,
  deadline_or_timing = EXCLUDED.deadline_or_timing,
  source_urls = EXCLUDED.source_urls,
  admin_review_notes = EXCLUDED.admin_review_notes,
  confidence_label = EXCLUDED.confidence_label,
  is_research_grade = EXCLUDED.is_research_grade,
  priority_score = GREATEST(public.cases.priority_score, EXCLUDED.priority_score),
  updated_at = now();
`);
}

// 3. Reusable global questions
sql.push(`\n-- ----- 3. Reusable global questions (shared across all 30 cases) -----`);
const globals = [
  {
    field_key: 'exposure_timing',
    question_text: 'Did the exposure happen before the injury, loss, or diagnosis?',
    question_type: 'yes_no',
    answer_options: [],
    help_text: 'For most claims, the harmful event must come before the injury or loss it caused.',
    category: 'case_specific',
  },
  {
    field_key: 'date_exposure',
    question_text: 'What approximate date range did the exposure, purchase, employment, or event occur?',
    question_type: 'date_range',
    answer_options: [],
    help_text: 'Approximate is fine — best guess of the start and end date.',
    category: 'case_specific',
  },
  {
    field_key: 'date_injury_loss',
    question_text: 'When were you diagnosed, injured, notified, charged, employed, or financially impacted?',
    question_type: 'date',
    answer_options: [],
    help_text: 'Approximate date is fine if you do not remember the exact one.',
    category: 'case_specific',
  },
  {
    field_key: 'state_of_event',
    question_text: 'What state did this happen in, or what state did you live in at the time?',
    question_type: 'dropdown',
    answer_options: US_STATES,
    help_text: 'Some claims have state-specific eligibility rules.',
    category: 'case_specific',
  },
  {
    field_key: 'contact_permission',
    question_text: 'Are you open to being contacted by an attorney about this case?',
    question_type: 'yes_no',
    answer_options: [],
    help_text: 'You can change your mind anytime. Attorneys in these cases work on contingency — no fees unless you win.',
    category: 'case_specific',
  },
];
for (const q of globals) {
  sql.push(`INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  ${pgStr(q.field_key)},
  ${pgStr(q.question_text)},
  ${pgStr(q.question_type)},
  ${q.answer_options.length ? `'${JSON.stringify(q.answer_options).replace(/'/g, "''")}'::jsonb` : `'[]'::jsonb`},
  ${pgStr(q.help_text)},
  ${pgStr(q.category)},
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  question_type = EXCLUDED.question_type,
  answer_options = EXCLUDED.answer_options,
  help_text = EXCLUDED.help_text,
  updated_at = now();
`);
}

// 4. Per-case questions (3 unique per case: confirm_exposure, confirm_injury_or_loss, records_available)
sql.push(`\n-- ----- 4. Per-case questions (case-specific exposure, injury, and records prompts) -----`);

// Build a lookup of question rows per case from the spreadsheet
const qByCase = {};
for (const q of questions) {
  qByCase[q.case_id] = qByCase[q.case_id] || {};
  qByCase[q.case_id][q.question_key] = q;
}

for (const c of cases) {
  const ce = qByCase[c.case_id]?.confirm_exposure;
  const ci = qByCase[c.case_id]?.confirm_injury_or_loss;
  const rc = qByCase[c.case_id]?.records_available;
  const docOptions = docOptionsFor(c.likely_documents);

  // confirm_exposure__<case_id>
  sql.push(`INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  ${pgStr('confirm_exposure__' + c.case_id)},
  ${pgStr(ce ? ce.question_text : `Were you exposed to: ${c.exposure_event}`)},
  'yes_no',
  '[]'::jsonb,
  ${pgStr(c.exposure_event)},
  'case_specific',
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  help_text = EXCLUDED.help_text,
  updated_at = now();
`);

  // confirm_injury_or_loss__<case_id>
  sql.push(`INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  ${pgStr('confirm_injury_or_loss__' + c.case_id)},
  ${pgStr(ci ? ci.question_text : `Did you experience: ${c.injury_loss}`)},
  'yes_no',
  '[]'::jsonb,
  ${pgStr(c.injury_loss)},
  'case_specific',
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  help_text = EXCLUDED.help_text,
  updated_at = now();
`);

  // records_available__<case_id>
  sql.push(`INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  ${pgStr('records_available__' + c.case_id)},
  ${pgStr(rc ? rc.question_text : `Do you have any of these supporting records?`)},
  'multi_select',
  '${JSON.stringify(docOptions).replace(/'/g, "''")}'::jsonb,
  ${pgStr('You can submit a claim without records — they just help speed up review.')},
  'case_specific',
  false
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  answer_options = EXCLUDED.answer_options,
  help_text = EXCLUDED.help_text,
  updated_at = now();
`);
}

// 5. case_questions wiring (8 per case in spreadsheet order)
sql.push(`\n-- ----- 5. Wire each case to its 8 questions in the documented order -----`);
const orderedKeys = [
  /* 1 */ (cid) => `confirm_exposure__${cid}`,
  /* 2 */ (_)   => `exposure_timing`,
  /* 3 */ (cid) => `confirm_injury_or_loss__${cid}`,
  /* 4 */ (_)   => `date_exposure`,
  /* 5 */ (_)   => `date_injury_loss`,
  /* 6 */ (cid) => `records_available__${cid}`,
  /* 7 */ (_)   => `state_of_event`,
  /* 8 */ (_)   => `contact_permission`,
];

for (const c of cases) {
  const slug = c.case_id.replace(/_/g, '-');
  orderedKeys.forEach((fn, idx) => {
    const key = fn(c.case_id);
    const required = !['records_available__' + c.case_id, 'state_of_event'].includes(key);
    sql.push(`INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, ${idx + 1}, ${required}
FROM public.cases c, public.questions q
WHERE c.slug = ${pgStr(slug)} AND q.field_key = ${pgStr(key)}
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;
`);
  });
}

// 6. Matching rules — wipe-and-replace by description tag
sql.push(`\n-- ----- 6. Matching rules — clear & rewrite all rules tagged ${SEED_TAG} -----
DELETE FROM public.matching_rules
WHERE description LIKE ${pgStr(SEED_TAG + '%')}
  AND case_id IN (
    SELECT id FROM public.cases WHERE slug IN (
      ${cases.map(c => pgStr(c.case_id.replace(/_/g, '-'))).join(',\n      ')}
    )
  );
`);

for (const c of cases) {
  const slug = c.case_id.replace(/_/g, '-');
  const rules = [
    {
      field_key: `confirm_exposure__${c.case_id}`,
      operator: 'equals', value: 'yes', points: 30, is_disqualifying: false,
      description: `${SEED_TAG} Confirmed exposure → strong qualifier (+30)`,
    },
    {
      field_key: `confirm_exposure__${c.case_id}`,
      operator: 'equals', value: 'no', points: 0, is_disqualifying: true,
      description: `${SEED_TAG} No qualifying exposure → not eligible`,
    },
    {
      field_key: `confirm_injury_or_loss__${c.case_id}`,
      operator: 'equals', value: 'yes', points: 30, is_disqualifying: false,
      description: `${SEED_TAG} Confirmed injury/loss → strong qualifier (+30)`,
    },
    {
      field_key: `confirm_injury_or_loss__${c.case_id}`,
      operator: 'equals', value: 'no', points: 0, is_disqualifying: true,
      description: `${SEED_TAG} No qualifying injury/loss → not eligible`,
    },
    {
      field_key: 'exposure_timing',
      operator: 'equals', value: 'yes', points: 20, is_disqualifying: false,
      description: `${SEED_TAG} Exposure preceded injury → causation signal (+20)`,
    },
    {
      field_key: 'contact_permission',
      operator: 'equals', value: 'no', points: 0, is_disqualifying: true,
      description: `${SEED_TAG} User declined attorney contact → not routable`,
    },
  ];
  for (const r of rules) {
    sql.push(`INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', ${pgStr(r.field_key)}, ${pgStr(r.operator)},
       ${pgStr(r.value)}, ${r.points}, ${r.is_disqualifying}, ${pgStr(r.description)}
FROM public.cases c WHERE c.slug = ${pgStr(slug)};
`);
  }
}

sql.push(`\n-- ==========================================================================
-- End of seed migration
-- ==========================================================================`);

fs.writeFileSync(OUT, sql.join('\n'));
console.log(`Wrote ${OUT}`);
console.log(`Cases: ${cases.length}`);
console.log(`Global questions: ${globals.length}`);
console.log(`Per-case questions: ${cases.length * 3}`);
console.log(`case_questions rows: ${cases.length * orderedKeys.length}`);
console.log(`Matching rules: ${cases.length * 6}`);
