-- ==========================================================================
-- Upgrade the general qualification quiz from 8 generic yes/no questions to
-- 7 high-signal questions (mostly multi_select) tuned to the 30 live cases.
--
-- Strategy:
--  - Front-load high-payout triggers (diagnoses, branded products)
--  - Use brand names that trigger consumer memory ("Ozempic", "Hair relaxer")
--  - Multi-select multiplies signal-per-question
--  - Family-member framing captures NEC, social media youth, baby food, etc.
--  - "None of these — continue" option keeps every user in the funnel
--
-- Old broad-quiz questions are NOT deleted (existing user answers stay valid)
-- but their `category` is moved to 'deprecated_broad_quiz' so admin can see
-- they are legacy.
--
-- Idempotent: re-running this migration is safe.
-- ==========================================================================

-- 1. Mark old broad-quiz questions as deprecated (soft-retire)
UPDATE public.questions
SET category = 'deprecated_broad_quiz', updated_at = now()
WHERE field_key IN (
  'used_prescription_medications',
  'used_lawsuit_products',
  'diagnosed_serious_condition',
  'military_or_contaminated_site',
  'received_data_breach_notice',
  'experienced_employment_issues',
  'experienced_consumer_issues'
);

-- 2. Insert/update the 7 new broad-quiz questions

-- Q1: Serious diagnoses (multi-select, high-payout signal)
INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text,
  category, required, is_profile_field
) VALUES (
  'serious_diagnoses',
  $q$Have you, or a close family member, been diagnosed with any of these conditions?$q$,
  'multi_select',
  $q$[
    "Cancer (any type)",
    "Brain tumor or meningioma",
    "Parkinson''s disease",
    "Hearing loss or persistent ringing (tinnitus)",
    "Sudden vision loss (NAION)",
    "Severe stomach or GI problems (gastroparesis)",
    "Dental injury — tooth decay, loss, or damage",
    "Hair loss, fibroids, or uterine cancer",
    "Lymphoma near a breast implant (BIA-ALCL)",
    "Autoimmune or neurological condition",
    "Necrotizing enterocolitis (NEC) in a baby",
    "Autism, ADHD, or developmental delay in a child",
    "Severe mental health diagnosis in a teen",
    "Other serious diagnosis (we will review together)",
    "None of these — continue"
  ]$q$::jsonb,
  $q$Select anything that may apply — even if you''re not 100% sure. Family members count.$q$,
  'profile',
  true,
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  question_type = EXCLUDED.question_type,
  answer_options = EXCLUDED.answer_options,
  help_text = EXCLUDED.help_text,
  category = EXCLUDED.category,
  is_profile_field = EXCLUDED.is_profile_field,
  updated_at = now();

-- Q2: Products / meds used (multi-select, branded for memory recall)
INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text,
  category, required, is_profile_field
) VALUES (
  'products_or_meds_used',
  $q$Have you used any of these products or medications in the last 10–15 years?$q$,
  'multi_select',
  $q$[
    "Hair relaxer or chemical straightener",
    "Talcum powder or baby powder",
    "Depo-Provera birth control shot",
    "Ozempic, Wegovy, Mounjaro, or other GLP-1 drug",
    "Tepezza (eye disease drug)",
    "Suboxone film (orally dissolving strips)",
    "Gardasil HPV vaccine",
    "Paragard IUD",
    "Recalled CPAP, BiPAP, or ventilator (Philips)",
    "Premature infant formula (Similac, Enfamil)",
    "Major-brand baby food (Gerber, Beech-Nut, Plum, etc.)",
    "Roundup weedkiller",
    "Paraquat herbicide",
    "AFFF firefighting foam (used or exposed to it)",
    "Generic metformin (since 2014)",
    "None of these — continue"
  ]$q$::jsonb,
  $q$Brand names help — try to remember any meds, products, or chemicals you''ve been around.$q$,
  'profile',
  true,
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  question_type = EXCLUDED.question_type,
  answer_options = EXCLUDED.answer_options,
  help_text = EXCLUDED.help_text,
  category = EXCLUDED.category,
  is_profile_field = EXCLUDED.is_profile_field,
  updated_at = now();

-- Q3: Surgeries / implants
INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text,
  category, required, is_profile_field
) VALUES (
  'surgeries_implants',
  $q$Have you ever had any of these surgeries or implants?$q$,
  'multi_select',
  $q$[
    "Joint replacement (knee, hip, ankle, or shoulder)",
    "Implanted port catheter (PowerPort) for chemo or IV",
    "Textured breast implants",
    "Synthetic cartilage implant in a foot or toe (Cartiva)",
    "Hernia mesh",
    "None of these — continue"
  ]$q$::jsonb,
  $q$Some implants and devices have been recalled or linked to injuries.$q$,
  'profile',
  true,
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  question_type = EXCLUDED.question_type,
  answer_options = EXCLUDED.answer_options,
  help_text = EXCLUDED.help_text,
  category = EXCLUDED.category,
  is_profile_field = EXCLUDED.is_profile_field,
  updated_at = now();

-- Q4: Toxic-exposure setting
INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text,
  category, required, is_profile_field
) VALUES (
  'toxic_exposure_setting',
  $q$Have you ever lived, worked, or been stationed at any of these?$q$,
  'multi_select',
  $q$[
    "Camp Lejeune or another military base with contaminated water",
    "Firefighter or fire training site (any era)",
    "Airport, refinery, or industrial site with foam or chemical exposure",
    "Lived near contaminated water, soil, or industrial pollution",
    "Worked closely with herbicides, pesticides, or industrial chemicals",
    "None of these — continue"
  ]$q$::jsonb,
  $q$Long-term environmental exposure can qualify even if you didn''t notice it at the time.$q$,
  'profile',
  true,
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  question_type = EXCLUDED.question_type,
  answer_options = EXCLUDED.answer_options,
  help_text = EXCLUDED.help_text,
  category = EXCLUDED.category,
  is_profile_field = EXCLUDED.is_profile_field,
  updated_at = now();

-- Q5: Family youth harm (yes/no)
INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text,
  category, required, is_profile_field
) VALUES (
  'family_youth_harm',
  $q$Has a child or teen in your family experienced serious mental health issues, addiction, or harm linked to social media or an online platform/game?$q$,
  'yes_no',
  '[]'::jsonb,
  $q$Includes Instagram, TikTok, Snapchat, Facebook, Roblox, and similar platforms.$q$,
  'profile',
  true,
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  question_type = EXCLUDED.question_type,
  answer_options = EXCLUDED.answer_options,
  help_text = EXCLUDED.help_text,
  category = EXCLUDED.category,
  is_profile_field = EXCLUDED.is_profile_field,
  updated_at = now();

-- Q6: Recent consumer / class-action triggers
INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text,
  category, required, is_profile_field
) VALUES (
  'recent_consumer_legal_events',
  $q$Have any of these happened to you or your household recently?$q$,
  'multi_select',
  $q$[
    "Received a data breach notification (Krispy Kreme, Fidelity, Comcast, Alera, or others)",
    "Bought a Hyundai or Kia (model years 2011–2018)",
    "Used Tinder Plus or Tinder Gold subscription before 2019",
    "Worked unpaid overtime as an hourly worker for FCA / Stellantis / Chrysler",
    "Was sexually assaulted by an Uber or Lyft driver",
    "Bought generic metformin (any pharmacy, since 2014)",
    "Owned Mylan / Viatris stock 2014–2019",
    "Received a class action settlement notice that I never claimed",
    "None of these — continue"
  ]$q$::jsonb,
  $q$Class action settlements often pay $50–$10,000+ for things you didn''t even realize were violations.$q$,
  'profile',
  true,
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  question_type = EXCLUDED.question_type,
  answer_options = EXCLUDED.answer_options,
  help_text = EXCLUDED.help_text,
  category = EXCLUDED.category,
  is_profile_field = EXCLUDED.is_profile_field,
  updated_at = now();

-- Q7: State of residence — make sure exists with full US state list
INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text,
  category, required, is_profile_field
) VALUES (
  'state_of_residence',
  $q$What state do you live in?$q$,
  'dropdown',
  $q$["AL","AK","AZ","AR","CA","CO","CT","DE","FL","GA","HI","ID","IL","IN","IA","KS","KY","LA","ME","MD","MA","MI","MN","MS","MO","MT","NE","NV","NH","NJ","NM","NY","NC","ND","OH","OK","OR","PA","RI","SC","SD","TN","TX","UT","VT","VA","WA","WV","WI","WY","DC"]$q$::jsonb,
  $q$Some legal claims have state-by-state eligibility rules.$q$,
  'profile',
  true,
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  question_type = EXCLUDED.question_type,
  answer_options = EXCLUDED.answer_options,
  help_text = EXCLUDED.help_text,
  category = EXCLUDED.category,
  is_profile_field = EXCLUDED.is_profile_field,
  updated_at = now();
