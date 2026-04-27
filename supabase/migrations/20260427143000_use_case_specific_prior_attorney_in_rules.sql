/*
  Prior-attorney disqualification should be case-specific, not profile-global.
  Move existing rules from prior_attorney -> prior_attorney_for_case.
*/

UPDATE public.matching_rules
SET field_key = 'prior_attorney_for_case'
WHERE field_key = 'prior_attorney';
