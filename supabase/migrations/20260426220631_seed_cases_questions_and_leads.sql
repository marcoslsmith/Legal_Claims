
/*
  # Seed Data - Cases, Questions, and Sample Leads

  ## What this migration does
  1. Inserts 6 legal cases: Roundup, AFFF, Hair Relaxer, Depo-Provera, Data Breach, Wage & Hour
  2. Inserts broad quiz questions (reusable profile + screening questions)
  3. Inserts case-specific questions for each case
  4. Links questions to cases via case_questions
  5. Creates matching rules for each case
  6. Creates a sample admin user profile and sample leads for demo

  ## Notes
  - All cases start as 'active'
  - Broad quiz questions are marked is_profile_field = true where applicable
  - Sample lead data uses placeholder UUIDs that will need real auth users
*/

-- ==============================
-- BROAD QUIZ QUESTIONS
-- ==============================
INSERT INTO questions (id, question_text, field_key, question_type, answer_options, required, is_profile_field, category, help_text)
VALUES
  ('00000000-0000-0000-0000-000000000001', 'What state do you currently live in?', 'state_of_residence', 'dropdown', '["Alabama","Alaska","Arizona","Arkansas","California","Colorado","Connecticut","Delaware","Florida","Georgia","Hawaii","Idaho","Illinois","Indiana","Iowa","Kansas","Kentucky","Louisiana","Maine","Maryland","Massachusetts","Michigan","Minnesota","Mississippi","Missouri","Montana","Nebraska","Nevada","New Hampshire","New Jersey","New Mexico","New York","North Carolina","North Dakota","Ohio","Oklahoma","Oregon","Pennsylvania","Rhode Island","South Carolina","South Dakota","Tennessee","Texas","Utah","Vermont","Virginia","Washington","West Virginia","Wisconsin","Wyoming"]', true, true, 'profile', 'This helps us match you to claims available in your state.'),
  ('00000000-0000-0000-0000-000000000002', 'Have you used any prescription medications in the past 10 years?', 'used_prescription_medications', 'yes_no', '[]', true, false, 'medical', 'Include any medications prescribed by a doctor.'),
  ('00000000-0000-0000-0000-000000000003', 'Have you used any products that are currently involved in lawsuits?', 'used_lawsuit_products', 'yes_no', '[]', false, false, 'product_exposure', 'Examples: Roundup herbicide, hair relaxer products, AFFF firefighting foam.'),
  ('00000000-0000-0000-0000-000000000004', 'Have you been diagnosed with cancer or another serious illness or injury?', 'diagnosed_serious_condition', 'yes_no', '[]', false, false, 'medical', 'This includes any cancer diagnosis, organ damage, or chronic condition.'),
  ('00000000-0000-0000-0000-000000000005', 'Have you served in the military or lived/worked near a contaminated site?', 'military_or_contaminated_site', 'yes_no', '[]', false, false, 'military', 'Examples: Camp Lejeune, military bases with AFFF use, industrial sites.'),
  ('00000000-0000-0000-0000-000000000006', 'Have you received a data breach notification in the past 5 years?', 'received_data_breach_notice', 'yes_no', '[]', false, false, 'data_breach', 'This includes emails or letters from companies notifying you of a data breach.'),
  ('00000000-0000-0000-0000-000000000007', 'Have you experienced wage or employment issues such as unpaid overtime, misclassification, or wrongful termination?', 'experienced_employment_issues', 'yes_no', '[]', false, false, 'employment', ''),
  ('00000000-0000-0000-0000-000000000008', 'Have you experienced consumer billing issues such as unauthorized charges, hidden fees, or junk fees?', 'experienced_consumer_issues', 'yes_no', '[]', false, false, 'consumer', '')
ON CONFLICT (field_key) DO NOTHING;

-- ==============================
-- ROUNDUP-SPECIFIC QUESTIONS
-- ==============================
INSERT INTO questions (id, question_text, field_key, question_type, answer_options, required, is_profile_field, category, help_text)
VALUES
  ('00000000-0000-0000-0000-000000000101', 'Did you use Roundup or glyphosate-based herbicide products?', 'roundup_used_product', 'yes_no', '[]', true, false, 'product_exposure', 'Roundup is a brand of herbicide made by Monsanto/Bayer.'),
  ('00000000-0000-0000-0000-000000000102', 'Approximately how many years did you use Roundup?', 'roundup_years_used', 'number', '[]', false, false, 'product_exposure', ''),
  ('00000000-0000-0000-0000-000000000103', 'Were you diagnosed with Non-Hodgkin Lymphoma (NHL) or another cancer?', 'roundup_cancer_diagnosis', 'yes_no', '[]', true, false, 'medical', ''),
  ('00000000-0000-0000-0000-000000000104', 'What type of cancer were you diagnosed with?', 'roundup_cancer_type', 'dropdown', '["Non-Hodgkin Lymphoma","B-Cell Lymphoma","T-Cell Lymphoma","Other Cancer","Not Sure"]', false, false, 'medical', ''),
  ('00000000-0000-0000-0000-000000000105', 'What year were you diagnosed?', 'roundup_diagnosis_year', 'number', '[]', false, false, 'medical', '')
ON CONFLICT (field_key) DO NOTHING;

-- ==============================
-- AFFF-SPECIFIC QUESTIONS
-- ==============================
INSERT INTO questions (id, question_text, field_key, question_type, answer_options, required, is_profile_field, category, help_text)
VALUES
  ('00000000-0000-0000-0000-000000000201', 'Were you exposed to AFFF (aqueous film-forming foam) firefighting foam?', 'afff_exposed', 'yes_no', '[]', true, false, 'military', 'AFFF is used at military bases, airports, and fire training facilities.'),
  ('00000000-0000-0000-0000-000000000202', 'Were you a military firefighter, civilian firefighter, or worked at an airport or fire training facility?', 'afff_occupation', 'dropdown', '["Military Firefighter","Civilian Firefighter","Airport Worker","Fire Training Facility","Lived Near Military Base","Other"]', false, false, 'military', ''),
  ('00000000-0000-0000-0000-000000000203', 'Have you been diagnosed with cancer linked to PFAS/AFFF exposure?', 'afff_cancer_diagnosis', 'yes_no', '[]', true, false, 'medical', 'Cancers linked to AFFF include kidney, bladder, testicular, thyroid, and others.'),
  ('00000000-0000-0000-0000-000000000204', 'What type of cancer were you diagnosed with?', 'afff_cancer_type', 'dropdown', '["Kidney Cancer","Bladder Cancer","Testicular Cancer","Thyroid Cancer","Ulcerative Colitis","High Cholesterol","Other Cancer"]', false, false, 'medical', ''),
  ('00000000-0000-0000-0000-000000000205', 'Approximately what years were you exposed to AFFF?', 'afff_exposure_years', 'text', '[]', false, false, 'military', 'Example: 1990-2005')
ON CONFLICT (field_key) DO NOTHING;

-- ==============================
-- HAIR RELAXER-SPECIFIC QUESTIONS
-- ==============================
INSERT INTO questions (id, question_text, field_key, question_type, answer_options, required, is_profile_field, category, help_text)
VALUES
  ('00000000-0000-0000-0000-000000000301', 'Have you used chemical hair relaxer products?', 'hair_relaxer_used', 'yes_no', '[]', true, false, 'product_exposure', 'Brands include Dark & Lovely, Optimum, Just For Me, ORS, Motions, and others.'),
  ('00000000-0000-0000-0000-000000000302', 'How many years did you use hair relaxer products?', 'hair_relaxer_years', 'dropdown', '["Less than 1 year","1-2 years","3-5 years","6-10 years","More than 10 years"]', false, false, 'product_exposure', ''),
  ('00000000-0000-0000-0000-000000000303', 'Have you been diagnosed with uterine cancer, ovarian cancer, or uterine fibroids?', 'hair_relaxer_diagnosis', 'yes_no', '[]', true, false, 'medical', ''),
  ('00000000-0000-0000-0000-000000000304', 'What was your diagnosis?', 'hair_relaxer_diagnosis_type', 'dropdown', '["Uterine Cancer","Ovarian Cancer","Uterine Fibroids","Endometriosis","Other"]', false, false, 'medical', ''),
  ('00000000-0000-0000-0000-000000000305', 'What brand(s) of hair relaxer did you use?', 'hair_relaxer_brands', 'multi_select', '["Dark & Lovely","Optimum","Just For Me","ORS","Motions","Soft Sheen-Carson","Other"]', false, false, 'product_exposure', '')
ON CONFLICT (field_key) DO NOTHING;

-- ==============================
-- DEPO-PROVERA-SPECIFIC QUESTIONS
-- ==============================
INSERT INTO questions (id, question_text, field_key, question_type, answer_options, required, is_profile_field, category, help_text)
VALUES
  ('00000000-0000-0000-0000-000000000401', 'Did you receive Depo-Provera (medroxyprogesterone acetate) injections?', 'depo_used', 'yes_no', '[]', true, false, 'product_exposure', 'Depo-Provera is a contraceptive injection given every 3 months.'),
  ('00000000-0000-0000-0000-000000000402', 'How long did you use Depo-Provera?', 'depo_duration', 'dropdown', '["Less than 1 year","1-2 years","3-5 years","More than 5 years"]', false, false, 'product_exposure', ''),
  ('00000000-0000-0000-0000-000000000403', 'Have you been diagnosed with a meningioma (brain tumor)?', 'depo_meningioma_diagnosis', 'yes_no', '[]', true, false, 'medical', 'Meningiomas are tumors that form on membranes covering the brain and spinal cord.'),
  ('00000000-0000-0000-0000-000000000404', 'Approximately what years did you use Depo-Provera?', 'depo_years_used', 'text', '[]', false, false, 'product_exposure', 'Example: 2010-2018'),
  ('00000000-0000-0000-0000-000000000405', 'Were you diagnosed with any other neurological conditions?', 'depo_neurological', 'yes_no', '[]', false, false, 'medical', '')
ON CONFLICT (field_key) DO NOTHING;

-- ==============================
-- DATA BREACH-SPECIFIC QUESTIONS
-- ==============================
INSERT INTO questions (id, question_text, field_key, question_type, answer_options, required, is_profile_field, category, help_text)
VALUES
  ('00000000-0000-0000-0000-000000000501', 'Did you receive a data breach notification letter or email?', 'databreach_received_notice', 'yes_no', '[]', true, false, 'data_breach', ''),
  ('00000000-0000-0000-0000-000000000502', 'Which company sent you the data breach notification?', 'databreach_company', 'text', '[]', false, false, 'data_breach', 'Example: T-Mobile, Equifax, LastPass, etc.'),
  ('00000000-0000-0000-0000-000000000503', 'What type of information was exposed in the breach?', 'databreach_info_type', 'multi_select', '["Social Security Number","Financial Account Numbers","Credit Card Numbers","Medical Records","Login Credentials","Home Address","Date of Birth","Other"]', false, false, 'data_breach', ''),
  ('00000000-0000-0000-0000-000000000504', 'Have you experienced identity theft or financial fraud as a result?', 'databreach_identity_theft', 'yes_no', '[]', false, false, 'data_breach', ''),
  ('00000000-0000-0000-0000-000000000505', 'When did you receive the data breach notice?', 'databreach_notice_date', 'date', '[]', false, false, 'data_breach', '')
ON CONFLICT (field_key) DO NOTHING;

-- ==============================
-- WAGE & HOUR-SPECIFIC QUESTIONS
-- ==============================
INSERT INTO questions (id, question_text, field_key, question_type, answer_options, required, is_profile_field, category, help_text)
VALUES
  ('00000000-0000-0000-0000-000000000601', 'What type of employment issue did you experience?', 'wage_issue_type', 'multi_select', '["Unpaid Overtime","Unpaid Wages","Meal/Rest Break Violations","Misclassification as Contractor","Tip Theft","Wrongful Termination","Other"]', true, false, 'employment', ''),
  ('00000000-0000-0000-0000-000000000602', 'What industry did you work in when this occurred?', 'wage_industry', 'dropdown', '["Restaurant/Food Service","Retail","Healthcare","Transportation/Delivery","Construction","Technology","Finance","Other"]', false, false, 'employment', ''),
  ('00000000-0000-0000-0000-000000000603', 'When did this employment issue occur?', 'wage_issue_date', 'date', '[]', false, false, 'employment', ''),
  ('00000000-0000-0000-0000-000000000604', 'Were other employees affected by the same issue at your workplace?', 'wage_other_employees_affected', 'yes_no', '[]', false, false, 'employment', ''),
  ('00000000-0000-0000-0000-000000000605', 'Are you currently employed by this employer?', 'wage_still_employed', 'yes_no', '[]', false, false, 'employment', '')
ON CONFLICT (field_key) DO NOTHING;

-- ==============================
-- CASES
-- ==============================
INSERT INTO cases (id, name, slug, case_type, status, short_description, long_description, priority_score, allowed_states, required_diagnosis, required_exposure, estimated_lead_value, internal_notes)
VALUES
  (
    'aaaaaaaa-0000-0000-0000-000000000001',
    'Roundup Weedkiller Cancer Lawsuit',
    'roundup',
    'mass_tort',
    'active',
    'Bayer/Monsanto''s Roundup herbicide has been linked to Non-Hodgkin Lymphoma and other cancers.',
    'Glyphosate, the active ingredient in Roundup, has been classified as a probable carcinogen by the World Health Organization. Thousands of lawsuits allege Monsanto/Bayer knew of the cancer risks and failed to warn consumers. If you used Roundup regularly and were diagnosed with Non-Hodgkin Lymphoma or another cancer, you may be eligible for compensation.',
    90,
    '{}',
    '{"Non-Hodgkin Lymphoma","B-Cell Lymphoma","T-Cell Lymphoma","Cancer"}',
    '{"Roundup","glyphosate"}',
    4500.00,
    'High value case. Focus on NHL diagnoses. Require minimum 2 years of product use.'
  ),
  (
    'aaaaaaaa-0000-0000-0000-000000000002',
    'AFFF Firefighting Foam Lawsuit',
    'afff',
    'mass_tort',
    'active',
    'AFFF firefighting foam contains PFAS "forever chemicals" linked to multiple cancers.',
    'Aqueous Film Forming Foam (AFFF) contains per- and polyfluoroalkyl substances (PFAS) — known as "forever chemicals" — that have been linked to kidney cancer, bladder cancer, testicular cancer, thyroid disease, and other serious conditions. Military personnel, civilian firefighters, and those living near military bases or airports where AFFF was used may be entitled to compensation.',
    85,
    '{}',
    '{"Kidney Cancer","Bladder Cancer","Testicular Cancer","Thyroid Cancer","Ulcerative Colitis"}',
    '{"AFFF","firefighting foam","PFAS"}',
    5000.00,
    'Military and civilian firefighters. Strong case value. Require documented exposure.'
  ),
  (
    'aaaaaaaa-0000-0000-0000-000000000003',
    'Hair Relaxer Cancer Lawsuit',
    'hair-relaxer',
    'mass_tort',
    'active',
    'Chemical hair relaxer products have been linked to uterine cancer, ovarian cancer, and fibroids.',
    'A 2022 study published in the Journal of the National Cancer Institute found that women who frequently use chemical hair straightening/relaxer products have a higher risk of developing uterine cancer. Major brands including Dark & Lovely, Optimum, and Just For Me are named in lawsuits. If you used hair relaxer products regularly and were diagnosed with uterine cancer, ovarian cancer, or uterine fibroids, you may qualify for compensation.',
    88,
    '{}',
    '{"Uterine Cancer","Ovarian Cancer","Uterine Fibroids","Endometriosis"}',
    '{"hair relaxer","hair straightener","chemical relaxer"}',
    4000.00,
    'Women only. Focus on uterine cancer diagnoses. Minimum 1 year product use.'
  ),
  (
    'aaaaaaaa-0000-0000-0000-000000000004',
    'Depo-Provera Brain Tumor Lawsuit',
    'depo-provera',
    'mass_tort',
    'active',
    'Depo-Provera birth control injections have been linked to increased risk of meningioma brain tumors.',
    'A major study found that women who used Depo-Provera (medroxyprogesterone acetate) for extended periods had a significantly increased risk of developing meningiomas — tumors that form on the membranes surrounding the brain. Pfizer, the manufacturer, faces thousands of lawsuits alleging it failed to adequately warn patients about this risk. If you used Depo-Provera and have been diagnosed with a meningioma, you may be entitled to significant compensation.',
    87,
    '{}',
    '{"Meningioma","Brain Tumor"}',
    '{"Depo-Provera","medroxyprogesterone"}',
    6000.00,
    'High value. Focus on meningioma diagnosis. Long-term users preferred.'
  ),
  (
    'aaaaaaaa-0000-0000-0000-000000000005',
    'Data Breach Class Action',
    'data-breach',
    'class_action',
    'active',
    'If your personal data was exposed in a corporate data breach, you may be entitled to compensation.',
    'Millions of Americans have had their personal information compromised in major data breaches affecting companies like T-Mobile, Equifax, AT&T, LastPass, and others. If you received a data breach notification and your Social Security number, financial data, or other sensitive information was exposed, you may be eligible to join a class action lawsuit seeking compensation for the increased risk of identity theft and other harms.',
    70,
    '{}',
    '{}',
    '{"data breach","identity theft"}',
    350.00,
    'High volume, lower value. Focus on SSN and financial data exposure.'
  ),
  (
    'aaaaaaaa-0000-0000-0000-000000000006',
    'Wage & Hour Class Action',
    'wage-hour',
    'class_action',
    'active',
    'If your employer failed to pay you proper wages, overtime, or violated break laws, you may have a claim.',
    'Employers in many industries routinely violate wage and hour laws by failing to pay overtime, denying required meal and rest breaks, misclassifying workers as independent contractors, or stealing tips. California, New York, and other states have strong worker protection laws. If you experienced wage theft or labor law violations in the past 3-4 years, you may be entitled to back pay and additional damages.',
    72,
    '{}',
    '{}',
    '{"wage theft","unpaid overtime","misclassification"}',
    800.00,
    'Multi-state class actions. Focus on CA, NY, IL, TX. High volume.'
  )
ON CONFLICT (slug) DO NOTHING;

-- ==============================
-- CASE QUESTIONS - Roundup
-- ==============================
INSERT INTO case_questions (case_id, question_id, display_order, required_for_case)
VALUES
  ('aaaaaaaa-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000101', 1, true),
  ('aaaaaaaa-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000102', 2, false),
  ('aaaaaaaa-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000103', 3, true),
  ('aaaaaaaa-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000104', 4, false),
  ('aaaaaaaa-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000105', 5, false)
ON CONFLICT (case_id, question_id) DO NOTHING;

-- ==============================
-- CASE QUESTIONS - AFFF
-- ==============================
INSERT INTO case_questions (case_id, question_id, display_order, required_for_case)
VALUES
  ('aaaaaaaa-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000201', 1, true),
  ('aaaaaaaa-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000202', 2, false),
  ('aaaaaaaa-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000203', 3, true),
  ('aaaaaaaa-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000204', 4, false),
  ('aaaaaaaa-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000205', 5, false)
ON CONFLICT (case_id, question_id) DO NOTHING;

-- ==============================
-- CASE QUESTIONS - Hair Relaxer
-- ==============================
INSERT INTO case_questions (case_id, question_id, display_order, required_for_case)
VALUES
  ('aaaaaaaa-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000301', 1, true),
  ('aaaaaaaa-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000302', 2, false),
  ('aaaaaaaa-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000303', 3, true),
  ('aaaaaaaa-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000304', 4, false),
  ('aaaaaaaa-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000305', 5, false)
ON CONFLICT (case_id, question_id) DO NOTHING;

-- ==============================
-- CASE QUESTIONS - Depo-Provera
-- ==============================
INSERT INTO case_questions (case_id, question_id, display_order, required_for_case)
VALUES
  ('aaaaaaaa-0000-0000-0000-000000000004', '00000000-0000-0000-0000-000000000401', 1, true),
  ('aaaaaaaa-0000-0000-0000-000000000004', '00000000-0000-0000-0000-000000000402', 2, false),
  ('aaaaaaaa-0000-0000-0000-000000000004', '00000000-0000-0000-0000-000000000403', 3, true),
  ('aaaaaaaa-0000-0000-0000-000000000004', '00000000-0000-0000-0000-000000000404', 4, false),
  ('aaaaaaaa-0000-0000-0000-000000000004', '00000000-0000-0000-0000-000000000405', 5, false)
ON CONFLICT (case_id, question_id) DO NOTHING;

-- ==============================
-- CASE QUESTIONS - Data Breach
-- ==============================
INSERT INTO case_questions (case_id, question_id, display_order, required_for_case)
VALUES
  ('aaaaaaaa-0000-0000-0000-000000000005', '00000000-0000-0000-0000-000000000501', 1, true),
  ('aaaaaaaa-0000-0000-0000-000000000005', '00000000-0000-0000-0000-000000000502', 2, false),
  ('aaaaaaaa-0000-0000-0000-000000000005', '00000000-0000-0000-0000-000000000503', 3, false),
  ('aaaaaaaa-0000-0000-0000-000000000005', '00000000-0000-0000-0000-000000000504', 4, false),
  ('aaaaaaaa-0000-0000-0000-000000000005', '00000000-0000-0000-0000-000000000505', 5, false)
ON CONFLICT (case_id, question_id) DO NOTHING;

-- ==============================
-- CASE QUESTIONS - Wage & Hour
-- ==============================
INSERT INTO case_questions (case_id, question_id, display_order, required_for_case)
VALUES
  ('aaaaaaaa-0000-0000-0000-000000000006', '00000000-0000-0000-0000-000000000601', 1, true),
  ('aaaaaaaa-0000-0000-0000-000000000006', '00000000-0000-0000-0000-000000000602', 2, false),
  ('aaaaaaaa-0000-0000-0000-000000000006', '00000000-0000-0000-0000-000000000603', 3, false),
  ('aaaaaaaa-0000-0000-0000-000000000006', '00000000-0000-0000-0000-000000000604', 4, false),
  ('aaaaaaaa-0000-0000-0000-000000000006', '00000000-0000-0000-0000-000000000605', 5, false)
ON CONFLICT (case_id, question_id) DO NOTHING;

-- ==============================
-- MATCHING RULES - Roundup
-- ==============================
INSERT INTO matching_rules (case_id, rule_type, field_key, operator, value, points, is_disqualifying, description)
VALUES
  ('aaaaaaaa-0000-0000-0000-000000000001', 'field_match', 'roundup_used_product', 'equals', 'yes', 40, false, 'Used Roundup product'),
  ('aaaaaaaa-0000-0000-0000-000000000001', 'field_match', 'roundup_cancer_diagnosis', 'equals', 'yes', 50, false, 'Has cancer diagnosis'),
  ('aaaaaaaa-0000-0000-0000-000000000001', 'field_match', 'prior_attorney', 'equals', 'true', 0, true, 'Already has attorney representation');

INSERT INTO matching_rules (case_id, rule_type, field_key, operator, value_list, points, is_disqualifying, description)
VALUES
  ('aaaaaaaa-0000-0000-0000-000000000001', 'field_match', 'roundup_cancer_type', 'in_list', '{"Non-Hodgkin Lymphoma","B-Cell Lymphoma","T-Cell Lymphoma"}', 20, false, 'Has qualifying cancer type');

-- ==============================
-- MATCHING RULES - AFFF
-- ==============================
INSERT INTO matching_rules (case_id, rule_type, field_key, operator, value, points, is_disqualifying, description)
VALUES
  ('aaaaaaaa-0000-0000-0000-000000000002', 'field_match', 'afff_exposed', 'equals', 'yes', 40, false, 'Was exposed to AFFF'),
  ('aaaaaaaa-0000-0000-0000-000000000002', 'field_match', 'afff_cancer_diagnosis', 'equals', 'yes', 50, false, 'Has cancer diagnosis from AFFF'),
  ('aaaaaaaa-0000-0000-0000-000000000002', 'field_match', 'prior_attorney', 'equals', 'true', 0, true, 'Already has attorney');

-- ==============================
-- MATCHING RULES - Hair Relaxer
-- ==============================
INSERT INTO matching_rules (case_id, rule_type, field_key, operator, value, points, is_disqualifying, description)
VALUES
  ('aaaaaaaa-0000-0000-0000-000000000003', 'field_match', 'hair_relaxer_used', 'equals', 'yes', 30, false, 'Used hair relaxer'),
  ('aaaaaaaa-0000-0000-0000-000000000003', 'field_match', 'hair_relaxer_diagnosis', 'equals', 'yes', 50, false, 'Has qualifying diagnosis'),
  ('aaaaaaaa-0000-0000-0000-000000000003', 'field_match', 'prior_attorney', 'equals', 'true', 0, true, 'Already has attorney');

INSERT INTO matching_rules (case_id, rule_type, field_key, operator, value_list, points, is_disqualifying, description)
VALUES
  ('aaaaaaaa-0000-0000-0000-000000000003', 'field_match', 'hair_relaxer_years', 'in_list', '{"3-5 years","6-10 years","More than 10 years"}', 20, false, 'Long-term hair relaxer use');

-- ==============================
-- MATCHING RULES - Depo-Provera
-- ==============================
INSERT INTO matching_rules (case_id, rule_type, field_key, operator, value, points, is_disqualifying, description)
VALUES
  ('aaaaaaaa-0000-0000-0000-000000000004', 'field_match', 'depo_used', 'equals', 'yes', 40, false, 'Used Depo-Provera'),
  ('aaaaaaaa-0000-0000-0000-000000000004', 'field_match', 'depo_meningioma_diagnosis', 'equals', 'yes', 50, false, 'Has meningioma diagnosis'),
  ('aaaaaaaa-0000-0000-0000-000000000004', 'field_match', 'prior_attorney', 'equals', 'true', 0, true, 'Already has attorney');

INSERT INTO matching_rules (case_id, rule_type, field_key, operator, value_list, points, is_disqualifying, description)
VALUES
  ('aaaaaaaa-0000-0000-0000-000000000004', 'field_match', 'depo_duration', 'in_list', '{"3-5 years","More than 5 years"}', 20, false, 'Long-term Depo-Provera use');

-- ==============================
-- MATCHING RULES - Data Breach
-- ==============================
INSERT INTO matching_rules (case_id, rule_type, field_key, operator, value, points, is_disqualifying, description)
VALUES
  ('aaaaaaaa-0000-0000-0000-000000000005', 'field_match', 'databreach_received_notice', 'equals', 'yes', 50, false, 'Received data breach notice'),
  ('aaaaaaaa-0000-0000-0000-000000000005', 'field_match', 'databreach_identity_theft', 'equals', 'yes', 30, false, 'Experienced identity theft');

INSERT INTO matching_rules (case_id, rule_type, field_key, operator, value_list, points, is_disqualifying, description)
VALUES
  ('aaaaaaaa-0000-0000-0000-000000000005', 'field_match', 'databreach_info_type', 'in_list', '{"Social Security Number","Financial Account Numbers","Credit Card Numbers","Medical Records"}', 20, false, 'Sensitive data exposed');

-- ==============================
-- MATCHING RULES - Wage & Hour
-- ==============================
INSERT INTO matching_rules (case_id, rule_type, field_key, operator, value, points, is_disqualifying, description)
VALUES
  ('aaaaaaaa-0000-0000-0000-000000000006', 'field_match', 'experienced_employment_issues', 'equals', 'yes', 40, false, 'Experienced employment issues'),
  ('aaaaaaaa-0000-0000-0000-000000000006', 'field_match', 'wage_other_employees_affected', 'equals', 'yes', 30, false, 'Class action potential - others affected');

INSERT INTO matching_rules (case_id, rule_type, field_key, operator, value_list, points, is_disqualifying, description)
VALUES
  ('aaaaaaaa-0000-0000-0000-000000000006', 'field_match', 'wage_issue_type', 'in_list', '{"Unpaid Overtime","Unpaid Wages","Misclassification as Contractor"}', 30, false, 'High-value wage issue type');
