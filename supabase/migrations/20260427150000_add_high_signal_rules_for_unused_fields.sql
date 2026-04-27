/*
  Improve lead quality by scoring high-signal intake fields that were previously unused.
  These are conservative scoring additions (no new disqualifiers) to improve ranking accuracy.
*/

WITH rule_seed AS (
  SELECT
    c.id AS case_id,
    v.field_key,
    v.operator,
    v.value,
    v.value_list,
    v.points,
    v.description
  FROM (
    VALUES
      -- AFFF: diagnosis subtype and occupational exposure strengthen qualification confidence.
      ('afff', 'afff_cancer_type', 'in_list', '', ARRAY['Kidney Cancer','Bladder Cancer','Testicular Cancer','Thyroid Cancer','Ulcerative Colitis']::text[], 20, 'Has qualifying AFFF-linked diagnosis type'),
      ('afff', 'afff_occupation', 'in_list', '', ARRAY['Military Firefighter','Civilian Firefighter','Airport Worker','Fire Training Facility']::text[], 15, 'High-likelihood AFFF exposure occupation'),

      -- Hair Relaxer: specific diagnosis type increases legal fit signal.
      ('hair-relaxer', 'hair_relaxer_diagnosis_type', 'in_list', '', ARRAY['Uterine Cancer','Ovarian Cancer','Uterine Fibroids','Endometriosis']::text[], 20, 'Has qualifying hair relaxer diagnosis type'),

      -- Depo-Provera: neurological impact adds corroborating medical signal.
      ('depo-provera', 'depo_neurological', 'equals', 'yes', ARRAY[]::text[], 10, 'Has additional neurological complications'),

      -- Roundup: longer usage duration improves exposure confidence.
      ('roundup', 'roundup_years_used', 'greater_than', '1', ARRAY[]::text[], 10, 'Used Roundup for more than one year')
  ) AS v(slug, field_key, operator, value, value_list, points, description)
  JOIN public.cases c ON c.slug = v.slug
)
INSERT INTO public.matching_rules (
  case_id,
  rule_type,
  field_key,
  operator,
  value,
  value_list,
  points,
  is_disqualifying,
  description
)
SELECT
  rs.case_id,
  'field_match',
  rs.field_key,
  rs.operator,
  rs.value,
  rs.value_list,
  rs.points,
  false,
  rs.description
FROM rule_seed rs
WHERE NOT EXISTS (
  SELECT 1
  FROM public.matching_rules mr
  WHERE mr.case_id = rs.case_id
    AND mr.field_key = rs.field_key
    AND mr.operator = rs.operator
    AND COALESCE(mr.value, '') = COALESCE(rs.value, '')
);
