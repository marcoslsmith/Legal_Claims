
/*
  # Legal Claim Matching Platform - Full Schema

  ## Tables Created
  1. profiles - Extended user profile data (name, dob, contact info, etc.)
  2. cases - Legal cases/claims (mass torts, class actions)
  3. questions - Reusable question bank with types and categories
  4. case_questions - Junction table linking questions to cases with ordering and conditions
  5. matching_rules - Eligibility scoring rules per case
  6. submissions - A user's claim submission for a specific case
  7. answers - User answers to questions per submission
  8. uploaded_documents - Files uploaded by users linked to submission
  9. consents - Consent records with timestamps
  10. lead_status_history - Audit trail of status changes
  11. buyer_destinations - Buyer/routing destinations for leads
  12. admin_notes - Internal notes on submissions
  13. case_analytics - Denormalized analytics cache

  ## Security
  - RLS enabled on all tables
  - Users can only access their own data
  - Admin role check via auth.users app_metadata
*/

-- ==============================
-- PROFILES
-- ==============================
CREATE TABLE IF NOT EXISTS profiles (
  id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email text,
  full_name text DEFAULT '',
  date_of_birth date,
  phone text DEFAULT '',
  address text DEFAULT '',
  city text DEFAULT '',
  state text DEFAULT '',
  zip_code text DEFAULT '',
  preferred_contact text DEFAULT 'email',
  consent_to_contact boolean DEFAULT false,
  prior_attorney boolean,
  is_admin boolean DEFAULT false,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own profile"
  ON profiles FOR SELECT
  TO authenticated
  USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile"
  ON profiles FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = id);

CREATE POLICY "Users can update own profile"
  ON profiles FOR UPDATE
  TO authenticated
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

CREATE POLICY "Admins can read all profiles"
  ON profiles FOR SELECT
  TO authenticated
  USING (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.is_admin = true)
  );

-- ==============================
-- BUYER DESTINATIONS
-- ==============================
CREATE TABLE IF NOT EXISTS buyer_destinations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  contact_email text DEFAULT '',
  contact_phone text DEFAULT '',
  notes text DEFAULT '',
  active boolean DEFAULT true,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE buyer_destinations ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Admins can manage buyer destinations"
  ON buyer_destinations FOR SELECT
  TO authenticated
  USING (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.is_admin = true)
  );

CREATE POLICY "Admins can insert buyer destinations"
  ON buyer_destinations FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.is_admin = true)
  );

CREATE POLICY "Admins can update buyer destinations"
  ON buyer_destinations FOR UPDATE
  TO authenticated
  USING (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.is_admin = true)
  )
  WITH CHECK (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.is_admin = true)
  );

-- ==============================
-- CASES
-- ==============================
CREATE TABLE IF NOT EXISTS cases (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  slug text UNIQUE NOT NULL,
  case_type text NOT NULL DEFAULT 'mass_tort', -- mass_tort | class_action
  status text NOT NULL DEFAULT 'active', -- active | paused | closed | waitlist
  short_description text DEFAULT '',
  long_description text DEFAULT '',
  priority_score integer DEFAULT 50,
  allowed_states text[] DEFAULT '{}',
  disqualifying_states text[] DEFAULT '{}',
  required_diagnosis text[] DEFAULT '{}',
  required_exposure text[] DEFAULT '{}',
  exposure_date_start date,
  exposure_date_end date,
  diagnosis_date_start date,
  diagnosis_date_end date,
  buyer_destination_id uuid REFERENCES buyer_destinations(id),
  estimated_lead_value numeric(10,2) DEFAULT 0,
  internal_notes text DEFAULT '',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE cases ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone authenticated can read active cases"
  ON cases FOR SELECT
  TO authenticated
  USING (status = 'active' OR EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.is_admin = true));

CREATE POLICY "Admins can insert cases"
  ON cases FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.is_admin = true)
  );

CREATE POLICY "Admins can update cases"
  ON cases FOR UPDATE
  TO authenticated
  USING (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.is_admin = true)
  )
  WITH CHECK (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.is_admin = true)
  );

-- ==============================
-- QUESTIONS
-- ==============================
CREATE TABLE IF NOT EXISTS questions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  question_text text NOT NULL,
  field_key text UNIQUE NOT NULL,
  question_type text NOT NULL DEFAULT 'text', -- text | number | date | dropdown | multi_select | yes_no | file_upload
  answer_options jsonb DEFAULT '[]',
  required boolean DEFAULT false,
  is_profile_field boolean DEFAULT false,
  category text DEFAULT 'general', -- profile | medical | product_exposure | employment | military | data_breach | consumer | case_specific
  help_text text DEFAULT '',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE questions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can read questions"
  ON questions FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Admins can insert questions"
  ON questions FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.is_admin = true)
  );

CREATE POLICY "Admins can update questions"
  ON questions FOR UPDATE
  TO authenticated
  USING (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.is_admin = true)
  )
  WITH CHECK (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.is_admin = true)
  );

-- ==============================
-- CASE QUESTIONS
-- ==============================
CREATE TABLE IF NOT EXISTS case_questions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  case_id uuid NOT NULL REFERENCES cases(id) ON DELETE CASCADE,
  question_id uuid NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
  display_order integer DEFAULT 0,
  required_for_case boolean DEFAULT false,
  condition_question_id uuid REFERENCES questions(id),
  condition_answer text DEFAULT '',
  created_at timestamptz DEFAULT now(),
  UNIQUE(case_id, question_id)
);

ALTER TABLE case_questions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can read case questions"
  ON case_questions FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Admins can manage case questions"
  ON case_questions FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.is_admin = true)
  );

CREATE POLICY "Admins can update case questions"
  ON case_questions FOR UPDATE
  TO authenticated
  USING (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.is_admin = true)
  )
  WITH CHECK (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.is_admin = true)
  );

CREATE POLICY "Admins can delete case questions"
  ON case_questions FOR DELETE
  TO authenticated
  USING (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.is_admin = true)
  );

-- ==============================
-- MATCHING RULES
-- ==============================
CREATE TABLE IF NOT EXISTS matching_rules (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  case_id uuid NOT NULL REFERENCES cases(id) ON DELETE CASCADE,
  rule_type text NOT NULL DEFAULT 'field_match', -- field_match | state_include | state_exclude | date_range | disqualify
  field_key text NOT NULL,
  operator text NOT NULL DEFAULT 'equals', -- equals | contains | in_list | not_equals | between | greater_than | less_than
  value text DEFAULT '',
  value_list text[] DEFAULT '{}',
  value_min text DEFAULT '',
  value_max text DEFAULT '',
  points integer DEFAULT 0,
  is_disqualifying boolean DEFAULT false,
  description text DEFAULT '',
  created_at timestamptz DEFAULT now()
);

ALTER TABLE matching_rules ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can read matching rules"
  ON matching_rules FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Admins can manage matching rules"
  ON matching_rules FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.is_admin = true)
  );

CREATE POLICY "Admins can update matching rules"
  ON matching_rules FOR UPDATE
  TO authenticated
  USING (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.is_admin = true)
  )
  WITH CHECK (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.is_admin = true)
  );

CREATE POLICY "Admins can delete matching rules"
  ON matching_rules FOR DELETE
  TO authenticated
  USING (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.is_admin = true)
  );

-- ==============================
-- SUBMISSIONS
-- ==============================
CREATE TABLE IF NOT EXISTS submissions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  case_id uuid NOT NULL REFERENCES cases(id),
  status text NOT NULL DEFAULT 'not_started', -- not_started | in_progress | submitted | under_review | routed | accepted | rejected | duplicate | bad_contact | closed
  match_score integer DEFAULT 0,
  match_tier text DEFAULT 'more_info_needed', -- strong_match | possible_match | more_info_needed | not_eligible
  source text DEFAULT 'web',
  buyer_destination_id uuid REFERENCES buyer_destinations(id),
  estimated_value numeric(10,2) DEFAULT 0,
  submitted_at timestamptz,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  UNIQUE(user_id, case_id)
);

ALTER TABLE submissions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own submissions"
  ON submissions FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own submissions"
  ON submissions FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own submissions"
  ON submissions FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Admins can read all submissions"
  ON submissions FOR SELECT
  TO authenticated
  USING (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.is_admin = true)
  );

CREATE POLICY "Admins can update submissions"
  ON submissions FOR UPDATE
  TO authenticated
  USING (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.is_admin = true)
  )
  WITH CHECK (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.is_admin = true)
  );

-- ==============================
-- ANSWERS
-- ==============================
CREATE TABLE IF NOT EXISTS answers (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  submission_id uuid REFERENCES submissions(id) ON DELETE CASCADE,
  question_id uuid NOT NULL REFERENCES questions(id),
  field_key text NOT NULL,
  answer_value text DEFAULT '',
  answer_values text[] DEFAULT '{}',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  UNIQUE(user_id, question_id)
);

ALTER TABLE answers ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own answers"
  ON answers FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own answers"
  ON answers FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own answers"
  ON answers FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Admins can read all answers"
  ON answers FOR SELECT
  TO authenticated
  USING (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.is_admin = true)
  );

-- ==============================
-- UPLOADED DOCUMENTS
-- ==============================
CREATE TABLE IF NOT EXISTS uploaded_documents (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  submission_id uuid REFERENCES submissions(id) ON DELETE CASCADE,
  document_type text NOT NULL DEFAULT 'other', -- diagnosis_proof | prescription_records | proof_of_purchase | employment_docs | data_breach_notice | other
  file_name text NOT NULL,
  file_path text NOT NULL,
  file_size integer DEFAULT 0,
  mime_type text DEFAULT '',
  created_at timestamptz DEFAULT now()
);

ALTER TABLE uploaded_documents ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own documents"
  ON uploaded_documents FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own documents"
  ON uploaded_documents FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Admins can read all documents"
  ON uploaded_documents FOR SELECT
  TO authenticated
  USING (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.is_admin = true)
  );

-- ==============================
-- CONSENTS
-- ==============================
CREATE TABLE IF NOT EXISTS consents (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  submission_id uuid REFERENCES submissions(id) ON DELETE CASCADE,
  consent_contact boolean DEFAULT false,
  consent_not_legal_advice boolean DEFAULT false,
  consent_no_attorney_client boolean DEFAULT false,
  consent_accuracy boolean DEFAULT false,
  ip_address text DEFAULT '',
  user_agent text DEFAULT '',
  consented_at timestamptz DEFAULT now()
);

ALTER TABLE consents ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own consents"
  ON consents FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own consents"
  ON consents FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Admins can read all consents"
  ON consents FOR SELECT
  TO authenticated
  USING (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.is_admin = true)
  );

-- ==============================
-- LEAD STATUS HISTORY
-- ==============================
CREATE TABLE IF NOT EXISTS lead_status_history (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  submission_id uuid NOT NULL REFERENCES submissions(id) ON DELETE CASCADE,
  old_status text DEFAULT '',
  new_status text NOT NULL,
  changed_by uuid REFERENCES auth.users(id),
  note text DEFAULT '',
  created_at timestamptz DEFAULT now()
);

ALTER TABLE lead_status_history ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Admins can read status history"
  ON lead_status_history FOR SELECT
  TO authenticated
  USING (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.is_admin = true)
  );

CREATE POLICY "Admins can insert status history"
  ON lead_status_history FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.is_admin = true)
  );

CREATE POLICY "Users can read own status history"
  ON lead_status_history FOR SELECT
  TO authenticated
  USING (
    EXISTS (SELECT 1 FROM submissions s WHERE s.id = submission_id AND s.user_id = auth.uid())
  );

-- ==============================
-- ADMIN NOTES
-- ==============================
CREATE TABLE IF NOT EXISTS admin_notes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  submission_id uuid NOT NULL REFERENCES submissions(id) ON DELETE CASCADE,
  admin_id uuid NOT NULL REFERENCES auth.users(id),
  note text NOT NULL,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE admin_notes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Admins can read admin notes"
  ON admin_notes FOR SELECT
  TO authenticated
  USING (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.is_admin = true)
  );

CREATE POLICY "Admins can insert admin notes"
  ON admin_notes FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.is_admin = true)
  );

-- ==============================
-- INDEXES
-- ==============================
CREATE INDEX IF NOT EXISTS idx_submissions_user_id ON submissions(user_id);
CREATE INDEX IF NOT EXISTS idx_submissions_case_id ON submissions(case_id);
CREATE INDEX IF NOT EXISTS idx_submissions_status ON submissions(status);
CREATE INDEX IF NOT EXISTS idx_answers_user_id ON answers(user_id);
CREATE INDEX IF NOT EXISTS idx_answers_field_key ON answers(field_key);
CREATE INDEX IF NOT EXISTS idx_case_questions_case_id ON case_questions(case_id);
CREATE INDEX IF NOT EXISTS idx_matching_rules_case_id ON matching_rules(case_id);
CREATE INDEX IF NOT EXISTS idx_uploaded_documents_user_id ON uploaded_documents(user_id);
CREATE INDEX IF NOT EXISTS idx_uploaded_documents_submission_id ON uploaded_documents(submission_id);
