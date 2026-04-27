/*
  Store attorney representation at the submission (case) level.
  A user may have counsel for one claim but not another.
*/

ALTER TABLE public.submissions
ADD COLUMN IF NOT EXISTS prior_attorney_for_case boolean;
