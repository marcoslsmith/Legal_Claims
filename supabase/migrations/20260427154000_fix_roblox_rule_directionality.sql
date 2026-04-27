/*
  Fix Roblox case rule directionality:
  these criteria are qualifying checks, not disqualifiers.
  Convert to positive scoring rules so "yes/expected" answers improve qualification.
*/

UPDATE public.matching_rules r
SET
  is_disqualifying = false,
  points = CASE r.field_key
    WHEN 'child_under_18' THEN 10
    WHEN 'met_abuser' THEN 10
    WHEN 'diagnosis_before_abuse' THEN 10
    WHEN 'current_relationship' THEN 10
    ELSE COALESCE(r.points, 0)
  END
FROM public.cases c
WHERE r.case_id = c.id
  AND c.slug = 'roblox-child-sexual-abuse-lawsuit'
  AND r.field_key IN ('child_under_18', 'met_abuser', 'diagnosis_before_abuse', 'current_relationship');
