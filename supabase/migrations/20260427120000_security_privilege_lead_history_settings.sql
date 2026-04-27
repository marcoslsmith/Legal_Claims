/*
  P0 hardening from production review:
  1) Prevent non-admins from setting profiles.is_admin via client INSERT/UPDATE
  2) Allow lead_status_history rows when the user owns the submission (consent / flow)
  3) platform_settings — match tier thresholds (tunable without redeploying the web app)
*/

-- ==============================
-- 1) Protect is_admin (trigger runs after RLS, enforces invariants)
-- ==============================
CREATE OR REPLACE FUNCTION public.protect_profile_privilege()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  actor_is_admin boolean;
BEGIN
  SELECT COALESCE(p.is_admin, false) INTO actor_is_admin
  FROM public.profiles p
  WHERE p.id = auth.uid();

  IF COALESCE(actor_is_admin, false) = true THEN
    RETURN NEW;
  END IF;

  IF TG_OP = 'INSERT' THEN
    NEW.is_admin := false;
  ELSIF TG_OP = 'UPDATE' THEN
    NEW.is_admin := OLD.is_admin;
  END IF;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_profiles_protect_privilege ON public.profiles;
CREATE TRIGGER trg_profiles_protect_privilege
  BEFORE INSERT OR UPDATE ON public.profiles
  FOR EACH ROW
  EXECUTE PROCEDURE public.protect_profile_privilege();

-- ==============================
-- 2) Users may record status history for their own submissions
-- ==============================
CREATE POLICY "Users can insert own lead status history"
  ON public.lead_status_history
  FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.submissions s
      WHERE s.id = lead_status_history.submission_id
        AND s.user_id = auth.uid()
    )
  );

-- ==============================
-- 3) Match tier thresholds (single row)
-- ==============================
CREATE TABLE IF NOT EXISTS public.platform_settings (
  id int PRIMARY KEY DEFAULT 1 CHECK (id = 1),
  strong_match_min int NOT NULL DEFAULT 80,
  possible_match_min int NOT NULL DEFAULT 50,
  updated_at timestamptz DEFAULT now()
);

INSERT INTO public.platform_settings (id, strong_match_min, possible_match_min)
VALUES (1, 80, 50)
ON CONFLICT (id) DO NOTHING;

ALTER TABLE public.platform_settings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can read platform settings"
  ON public.platform_settings
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Admins can update platform settings"
  ON public.platform_settings
  FOR UPDATE
  TO authenticated
  USING (public.is_admin(auth.uid()))
  WITH CHECK (public.is_admin(auth.uid()));
