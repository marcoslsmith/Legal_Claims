/*
  # Fix circular RLS policy on profiles table

  ## Problem
  The "Admins can read all profiles" policy queries the profiles table itself to check is_admin,
  causing infinite recursion when RLS evaluates the policy. This silently returns no rows,
  meaning admin users get a null profile back, isAdmin stays false, and they're redirected away.

  ## Fix
  - Drop the recursive admin policy
  - Create a security definer function that reads is_admin bypassing RLS
  - Recreate the admin read-all policy using that function
*/

-- Create a security definer function to safely check admin status without RLS recursion
CREATE OR REPLACE FUNCTION public.is_admin(user_id uuid)
RETURNS boolean
LANGUAGE sql
SECURITY DEFINER
STABLE
AS $$
  SELECT COALESCE(is_admin, false) FROM public.profiles WHERE id = user_id;
$$;

-- Drop the recursive policy
DROP POLICY IF EXISTS "Admins can read all profiles" ON public.profiles;

-- Recreate using the security definer function
CREATE POLICY "Admins can read all profiles"
  ON public.profiles
  FOR SELECT
  TO authenticated
  USING (public.is_admin(auth.uid()));
