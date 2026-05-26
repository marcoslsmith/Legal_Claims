-- ==========================================================================
-- Seed 30 active mass-tort and class-action cases (research-grade)
-- Generated from: live_mass_tort_class_action_seed_cases (1).xlsx
-- Tag: [seed:2026-05-25]
-- Idempotent: re-running this migration is safe.
-- ==========================================================================

-- ----- 1. Extend cases table with descriptive intake fields -----
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

-- ----- 2. Insert / update 30 cases -----
INSERT INTO public.cases (
  slug, name, case_type, status, short_description, long_description,
  priority_score, category, payout_language, core_qualifications,
  disqualifiers_summary, likely_documents, deadline_or_timing, source_urls,
  admin_review_notes, confidence_label, is_research_grade,
  require_medical_docs, required_doc_types, allowed_states, disqualifying_states
) VALUES (
  $q$depo-provera-meningioma$q$,
  $q$Depo-Provera Brain Tumor / Meningioma$q$,
  $q$mass_tort$q$,
  'active',
  $q$Claims generally allege long-term use of Depo-Provera or generic depot medroxyprogesterone acetate followed by diagnosis of an intracranial meningioma.$q$,
  $q$Claims generally allege long-term use of Depo-Provera or generic depot medroxyprogesterone acetate followed by diagnosis of an intracranial meningioma.$q$,
  75,
  $q$Prescription drug$q$,
  $q$No guaranteed payout. Potential value depends on diagnosis, surgery, disability, damages, causation, and jurisdiction.$q$,
  $q$Used Depo-Provera or generic shot; used for roughly 1+ year or multiple injections; later diagnosed with meningioma; diagnosis after use; medical records available.$q$,
  $q$No Depo-Provera exposure; no meningioma diagnosis; only benign symptoms without tumor diagnosis; diagnosis clearly predates exposure.$q$,
  $q$Pharmacy records, OB/GYN records, injection records, MRI/CT reports, pathology, neurosurgery records.$q$,
  $q$No public universal claim deadline; statute of limitations varies by state.$q$,
  ARRAY[$q$https://www.jpml.uscourts.gov/sites/jpml/files/Pending_MDL_Dockets_By_Actions_Pending-April-1-2026.pdf$q$]::text[],
  $q$Attorney/admin review recommended before publishing. Do not present as legal advice or guaranteed eligibility.$q$,
  $q$High for active MDL; Medium for intake criteria$q$,
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

INSERT INTO public.cases (
  slug, name, case_type, status, short_description, long_description,
  priority_score, category, payout_language, core_qualifications,
  disqualifiers_summary, likely_documents, deadline_or_timing, source_urls,
  admin_review_notes, confidence_label, is_research_grade,
  require_medical_docs, required_doc_types, allowed_states, disqualifying_states
) VALUES (
  $q$afff-firefighting-foam-cancer$q$,
  $q$AFFF Firefighting Foam / PFAS Cancer$q$,
  $q$mass_tort$q$,
  'active',
  $q$Claims generally involve occupational or environmental exposure to AFFF firefighting foam containing PFAS and later cancer diagnosis.$q$,
  $q$Claims generally involve occupational or environmental exposure to AFFF firefighting foam containing PFAS and later cancer diagnosis.$q$,
  75,
  $q$Toxic exposure$q$,
  $q$No guaranteed payout. Higher value usually tied to cancer type, severity, duration of exposure, and economic loss.$q$,
  $q$Meaningful AFFF/PFAS exposure; qualifying cancer or serious disease; latency between exposure and diagnosis; records or work history available.$q$,
  $q$No AFFF/PFAS exposure; no qualifying diagnosis; only general PFAS concern without injury.$q$,
  $q$Employment/military/fire department records, exposure history, medical diagnosis records, pathology, cancer treatment records.$q$,
  $q$No public universal claim deadline; statute of limitations varies by state.$q$,
  ARRAY[$q$https://www.jpml.uscourts.gov/sites/jpml/files/Pending_MDL_Dockets_By_Actions_Pending-April-1-2026.pdf$q$, $q$https://www.epa.gov/pfas/pfas-explained$q$]::text[],
  $q$Attorney/admin review recommended before publishing. Do not present as legal advice or guaranteed eligibility.$q$,
  $q$High for active MDL; Medium for qualifying disease list$q$,
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

INSERT INTO public.cases (
  slug, name, case_type, status, short_description, long_description,
  priority_score, category, payout_language, core_qualifications,
  disqualifiers_summary, likely_documents, deadline_or_timing, source_urls,
  admin_review_notes, confidence_label, is_research_grade,
  require_medical_docs, required_doc_types, allowed_states, disqualifying_states
) VALUES (
  $q$hair-relaxer-cancer$q$,
  $q$Chemical Hair Relaxer / Straightener Cancer$q$,
  $q$mass_tort$q$,
  'active',
  $q$Claims generally allege frequent use of chemical hair relaxers or straighteners before diagnosis of hormone-related cancers or reproductive injuries.$q$,
  $q$Claims generally allege frequent use of chemical hair relaxers or straighteners before diagnosis of hormone-related cancers or reproductive injuries.$q$,
  75,
  $q$Consumer product / cosmetics$q$,
  $q$No guaranteed payout. Potential value depends on cancer type, treatment, fertility impact, surgery, and damages.$q$,
  $q$Regular chemical relaxer use before diagnosis; diagnosis of qualifying cancer or reproductive injury; stronger if frequent/long-term use and product brands can be identified.$q$,
  $q$No chemical relaxer use; diagnosis predates product use; no cancer or significant reproductive injury.$q$,
  $q$Medical diagnosis records, pathology, hysterectomy records, purchase/product history, photos, salon records if available.$q$,
  $q$No public universal claim deadline; statute of limitations varies by state.$q$,
  ARRAY[$q$https://www.jpml.uscourts.gov/sites/jpml/files/Pending_MDL_Dockets_By_Actions_Pending-April-1-2026.pdf$q$, $q$https://www.niehs.nih.gov/research/atniehs/labs/epi/studies/sister-study/hair-products-cancer-risk$q$]::text[],
  $q$Attorney/admin review recommended before publishing. Do not present as legal advice or guaranteed eligibility.$q$,
  $q$High for active MDL; Medium for broader non-cancer injuries$q$,
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

INSERT INTO public.cases (
  slug, name, case_type, status, short_description, long_description,
  priority_score, category, payout_language, core_qualifications,
  disqualifiers_summary, likely_documents, deadline_or_timing, source_urls,
  admin_review_notes, confidence_label, is_research_grade,
  require_medical_docs, required_doc_types, allowed_states, disqualifying_states
) VALUES (
  $q$paraquat-parkinsons$q$,
  $q$Paraquat / Parkinson’s Disease$q$,
  $q$mass_tort$q$,
  'active',
  $q$Claims generally allege agricultural or occupational paraquat exposure followed by Parkinson’s disease diagnosis.$q$,
  $q$Claims generally allege agricultural or occupational paraquat exposure followed by Parkinson’s disease diagnosis.$q$,
  75,
  $q$Pesticide exposure$q$,
  $q$No guaranteed payout. Potential value depends on diagnosis strength, duration of exposure, age, disability, and damages.$q$,
  $q$Paraquat exposure; Parkinson’s diagnosis after exposure; work/residence history supporting exposure; medical records available.$q$,
  $q$No likely paraquat exposure; no Parkinson’s diagnosis; diagnosis before exposure; exposure only to unrelated herbicides.$q$,
  $q$Work records, pesticide applicator records, farm records, diagnosis records, neurology records, medication history.$q$,
  $q$No public universal claim deadline; statute of limitations varies by state.$q$,
  ARRAY[$q$https://www.jpml.uscourts.gov/sites/jpml/files/Pending_MDL_Dockets_By_Actions_Pending-April-1-2026.pdf$q$, $q$https://www.epa.gov/ingredients-used-pesticide-products/paraquat-dichloride$q$]::text[],
  $q$Attorney/admin review recommended before publishing. Do not present as legal advice or guaranteed eligibility.$q$,
  $q$High for active MDL; Medium for causation because EPA has noted conflicting evidence$q$,
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

INSERT INTO public.cases (
  slug, name, case_type, status, short_description, long_description,
  priority_score, category, payout_language, core_qualifications,
  disqualifiers_summary, likely_documents, deadline_or_timing, source_urls,
  admin_review_notes, confidence_label, is_research_grade,
  require_medical_docs, required_doc_types, allowed_states, disqualifying_states
) VALUES (
  $q$glp1-gastrointestinal-injury$q$,
  $q$GLP-1 Drugs / Gastroparesis or Severe GI Injury$q$,
  $q$mass_tort$q$,
  'active',
  $q$Claims generally involve GLP-1 receptor agonists used for diabetes or weight loss followed by severe gastrointestinal injury.$q$,
  $q$Claims generally involve GLP-1 receptor agonists used for diabetes or weight loss followed by severe gastrointestinal injury.$q$,
  75,
  $q$Prescription drug$q$,
  $q$No guaranteed payout. Higher value usually tied to diagnosed gastroparesis/obstruction, hospitalization, surgery, and ongoing impairment.$q$,
  $q$GLP-1 drug use before symptoms; diagnosed serious GI condition; ER/hospitalization/surgery or prolonged treatment; records available.$q$,
  $q$No GLP-1 use; only mild nausea; condition predates drug use; no medical diagnosis.$q$,
  $q$Prescription records, pharmacy records, ER/hospital records, GI specialist notes, imaging, surgery records.$q$,
  $q$No public universal claim deadline; statute of limitations varies by state.$q$,
  ARRAY[$q$https://www.jpml.uscourts.gov/sites/jpml/files/Pending_MDL_Dockets_By_Actions_Pending-April-1-2026.pdf$q$, $q$https://www.fda.gov/drugs/postmarket-drug-safety-information-patients-and-providers/ozempic-semaglutide-injection$q$]::text[],
  $q$Attorney/admin review recommended before publishing. Do not present as legal advice or guaranteed eligibility.$q$,
  $q$High for active MDL; Medium for broad injury list$q$,
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

INSERT INTO public.cases (
  slug, name, case_type, status, short_description, long_description,
  priority_score, category, payout_language, core_qualifications,
  disqualifiers_summary, likely_documents, deadline_or_timing, source_urls,
  admin_review_notes, confidence_label, is_research_grade,
  require_medical_docs, required_doc_types, allowed_states, disqualifying_states
) VALUES (
  $q$glp1-naion-vision-loss$q$,
  $q$GLP-1 Drugs / NAION Vision Loss$q$,
  $q$mass_tort$q$,
  'active',
  $q$Claims generally involve GLP-1 receptor agonist use followed by non-arteritic anterior ischemic optic neuropathy (NAION) or sudden vision loss.$q$,
  $q$Claims generally involve GLP-1 receptor agonist use followed by non-arteritic anterior ischemic optic neuropathy (NAION) or sudden vision loss.$q$,
  75,
  $q$Prescription drug$q$,
  $q$No guaranteed payout. Potential value depends on permanence, one/both eyes, work impact, and damages.$q$,
  $q$GLP-1 use before vision event; diagnosed NAION or comparable optic nerve injury; ophthalmology records available.$q$,
  $q$No GLP-1 use; temporary blurred vision only; vision issue predates use; no ophthalmology diagnosis.$q$,
  $q$Prescription records, ophthalmology records, visual field testing, diagnosis records.$q$,
  $q$No public universal claim deadline; statute of limitations varies by state.$q$,
  ARRAY[$q$https://www.jpml.uscourts.gov/sites/jpml/files/Pending_MDL_Dockets_By_Actions_Pending-April-1-2026.pdf$q$]::text[],
  $q$Attorney/admin review recommended before publishing. Do not present as legal advice or guaranteed eligibility.$q$,
  $q$High for active MDL; Medium for intake criteria$q$,
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

INSERT INTO public.cases (
  slug, name, case_type, status, short_description, long_description,
  priority_score, category, payout_language, core_qualifications,
  disqualifiers_summary, likely_documents, deadline_or_timing, source_urls,
  admin_review_notes, confidence_label, is_research_grade,
  require_medical_docs, required_doc_types, allowed_states, disqualifying_states
) VALUES (
  $q$suboxone-dental-injury$q$,
  $q$Suboxone Film / Dental Injuries$q$,
  $q$mass_tort$q$,
  'active',
  $q$Claims generally allege use of dissolvable buprenorphine/naloxone film followed by severe tooth decay, tooth loss, or dental restoration.$q$,
  $q$Claims generally allege use of dissolvable buprenorphine/naloxone film followed by severe tooth decay, tooth loss, or dental restoration.$q$,
  75,
  $q$Prescription drug$q$,
  $q$No guaranteed payout. Potential value depends on extent of dental repair, pain, cost, and permanency.$q$,
  $q$Used dissolvable film before dental injury; injury diagnosed after use; dental records available; stronger if no comparable preexisting dental problems.$q$,
  $q$Tablet/injection only with no film; dental injury predates use; only minor routine cavities; no dental treatment records.$q$,
  $q$Prescription records, dental charts, treatment plans, extraction/crown/implant invoices, photos.$q$,
  $q$No public universal claim deadline; statute of limitations varies by state.$q$,
  ARRAY[$q$https://www.jpml.uscourts.gov/sites/jpml/files/Pending_MDL_Dockets_By_Actions_Pending-April-1-2026.pdf$q$, $q$https://www.fda.gov/drugs/drug-safety-and-availability/fda-warns-about-dental-problems-buprenorphine-medicines-dissolved-mouth-treat-opioid-use-disorder$q$]::text[],
  $q$Attorney/admin review recommended before publishing. Do not present as legal advice or guaranteed eligibility.$q$,
  $q$High for active MDL; High for FDA warning basis$q$,
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

INSERT INTO public.cases (
  slug, name, case_type, status, short_description, long_description,
  priority_score, category, payout_language, core_qualifications,
  disqualifiers_summary, likely_documents, deadline_or_timing, source_urls,
  admin_review_notes, confidence_label, is_research_grade,
  require_medical_docs, required_doc_types, allowed_states, disqualifying_states
) VALUES (
  $q$bard-powerport-injury$q$,
  $q$Implanted Port Catheter / PowerPort Injuries$q$,
  $q$mass_tort$q$,
  'active',
  $q$Claims generally involve implanted port catheters that fractured, migrated, caused infection, thrombosis, embolism, or required removal/revision.$q$,
  $q$Claims generally involve implanted port catheters that fractured, migrated, caused infection, thrombosis, embolism, or required removal/revision.$q$,
  75,
  $q$Medical device$q$,
  $q$No guaranteed payout. Higher value usually tied to surgery, embolism, infection, organ injury, or permanent harm.$q$,
  $q$Port implanted; serious complication after implant; imaging/surgical evidence; medical records available.$q$,
  $q$No implanted port; no complication; routine removal only; injury not related in time/location to device.$q$,
  $q$Implant card, operative report, radiology, revision/removal report, ER/hospital records.$q$,
  $q$No public universal claim deadline; statute of limitations varies by state.$q$,
  ARRAY[$q$https://www.jpml.uscourts.gov/sites/jpml/files/Pending_MDL_Dockets_By_Actions_Pending-April-1-2026.pdf$q$]::text[],
  $q$Attorney/admin review recommended before publishing. Do not present as legal advice or guaranteed eligibility.$q$,
  $q$High for active MDL; Medium for intake criteria$q$,
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

INSERT INTO public.cases (
  slug, name, case_type, status, short_description, long_description,
  priority_score, category, payout_language, core_qualifications,
  disqualifiers_summary, likely_documents, deadline_or_timing, source_urls,
  admin_review_notes, confidence_label, is_research_grade,
  require_medical_docs, required_doc_types, allowed_states, disqualifying_states
) VALUES (
  $q$tepezza-hearing-loss$q$,
  $q$Tepezza / Hearing Loss or Tinnitus$q$,
  $q$mass_tort$q$,
  'active',
  $q$Claims generally involve Tepezza infusions for thyroid eye disease followed by hearing loss, tinnitus, autophony, or ear symptoms.$q$,
  $q$Claims generally involve Tepezza infusions for thyroid eye disease followed by hearing loss, tinnitus, autophony, or ear symptoms.$q$,
  75,
  $q$Prescription drug$q$,
  $q$No guaranteed payout. Potential value depends on severity, permanence, hearing aids, and quality-of-life impact.$q$,
  $q$Tepezza use before ear injury; audiology/ENT diagnosis; symptoms began during or after treatment; records available.$q$,
  $q$No Tepezza exposure; temporary symptoms fully resolved; hearing loss clearly predates treatment; no diagnosis.$q$,
  $q$Infusion records, ENT/audiology records, audiograms, hearing aid records.$q$,
  $q$No public universal claim deadline; statute of limitations varies by state.$q$,
  ARRAY[$q$https://www.jpml.uscourts.gov/sites/jpml/files/Pending_MDL_Dockets_By_Actions_Pending-April-1-2026.pdf$q$, $q$https://www.fda.gov/drugs/postmarket-drug-safety-information-patients-and-providers/tepezza-teprotumumab-trbw$q$]::text[],
  $q$Attorney/admin review recommended before publishing. Do not present as legal advice or guaranteed eligibility.$q$,
  $q$High for active MDL; Medium for injury criteria$q$,
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

INSERT INTO public.cases (
  slug, name, case_type, status, short_description, long_description,
  priority_score, category, payout_language, core_qualifications,
  disqualifiers_summary, likely_documents, deadline_or_timing, source_urls,
  admin_review_notes, confidence_label, is_research_grade,
  require_medical_docs, required_doc_types, allowed_states, disqualifying_states
) VALUES (
  $q$philips-cpap-recall-injury$q$,
  $q$Recalled CPAP / BiPAP / Ventilator Foam Injury$q$,
  $q$mass_tort$q$,
  'active',
  $q$Claims generally involve recalled Philips CPAP, BiPAP, or ventilator devices with PE-PUR foam degradation and later respiratory illness or cancer.$q$,
  $q$Claims generally involve recalled Philips CPAP, BiPAP, or ventilator devices with PE-PUR foam degradation and later respiratory illness or cancer.$q$,
  75,
  $q$Medical device$q$,
  $q$No guaranteed payout. Potential value depends on injury type, duration of use, medical treatment, and causation.$q$,
  $q$Used recalled device; qualifying injury after use; device model/serial or proof of ownership; medical records available.$q$,
  $q$No recalled device; no injury; only economic loss resolved through recall/repair; symptoms predate use.$q$,
  $q$Device model/serial, recall registration, purchase records, sleep doctor records, pulmonary/oncology records.$q$,
  $q$No public universal injury claim deadline in this dataset; verify current settlement/injury deadlines before publishing.$q$,
  ARRAY[$q$https://www.jpml.uscourts.gov/sites/jpml/files/Pending_MDL_Dockets_By_Actions_Pending-April-1-2026.pdf$q$, $q$https://www.fda.gov/medical-devices/respiratory-devices/recalled-philips-ventilators-bipap-machines-and-cpap-machines$q$]::text[],
  $q$Attorney/admin review recommended before publishing. Do not present as legal advice or guaranteed eligibility.$q$,
  $q$High for active MDL; Medium for active intake timing$q$,
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

INSERT INTO public.cases (
  slug, name, case_type, status, short_description, long_description,
  priority_score, category, payout_language, core_qualifications,
  disqualifiers_summary, likely_documents, deadline_or_timing, source_urls,
  admin_review_notes, confidence_label, is_research_grade,
  require_medical_docs, required_doc_types, allowed_states, disqualifying_states
) VALUES (
  $q$exactech-joint-replacement-failure$q$,
  $q$Exactech Joint Replacement Failure$q$,
  $q$mass_tort$q$,
  'active',
  $q$Claims generally involve recalled Exactech hip, knee, or ankle polyethylene components with premature wear, failure, bone loss, or revision surgery.$q$,
  $q$Claims generally involve recalled Exactech hip, knee, or ankle polyethylene components with premature wear, failure, bone loss, or revision surgery.$q$,
  75,
  $q$Medical device$q$,
  $q$No guaranteed payout. Potential value is generally stronger with revision surgery or clear failure evidence.$q$,
  $q$Exactech implant; recalled/affected component; symptoms or revision after implant; surgeon or medical records available.$q$,
  $q$No Exactech implant; no failure/symptoms; unrelated joint pain; implant not affected.$q$,
  $q$Operative report, implant stickers, recall notice, orthopedic records, imaging, revision records.$q$,
  $q$No public universal claim deadline; statute of limitations varies by state.$q$,
  ARRAY[$q$https://www.jpml.uscourts.gov/sites/jpml/files/Pending_MDL_Dockets_By_Actions_Pending-April-1-2026.pdf$q$, $q$https://www.fda.gov/medical-devices/safety-communications/risks-exactech-joint-replacement-devices-defective-packaging-fda-safety-communication$q$]::text[],
  $q$Attorney/admin review recommended before publishing. Do not present as legal advice or guaranteed eligibility.$q$,
  $q$High for active MDL; High for recall basis$q$,
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

INSERT INTO public.cases (
  slug, name, case_type, status, short_description, long_description,
  priority_score, category, payout_language, core_qualifications,
  disqualifiers_summary, likely_documents, deadline_or_timing, source_urls,
  admin_review_notes, confidence_label, is_research_grade,
  require_medical_docs, required_doc_types, allowed_states, disqualifying_states
) VALUES (
  $q$paragard-iud-breakage$q$,
  $q$Paragard IUD Breakage / Removal Injury$q$,
  $q$mass_tort$q$,
  'active',
  $q$Claims generally allege Paragard IUD arms fractured during removal, requiring surgery or causing internal injury.$q$,
  $q$Claims generally allege Paragard IUD arms fractured during removal, requiring surgery or causing internal injury.$q$,
  75,
  $q$Medical device$q$,
  $q$No guaranteed payout. Potential value depends on surgery, injury severity, fertility impact, and damages.$q$,
  $q$Paragard implanted; breakage or retained fragment during removal; medical records confirm; stronger if surgical retrieval.$q$,
  $q$Non-Paragard IUD; no breakage; uncomplicated removal; injury predates device.$q$,
  $q$IUD insertion/removal records, operative report, ultrasound/X-ray, retained-fragment records.$q$,
  $q$No public universal claim deadline; statute of limitations varies by state.$q$,
  ARRAY[$q$https://www.jpml.uscourts.gov/sites/jpml/files/Pending_MDL_Dockets_By_Actions_Pending-April-1-2026.pdf$q$]::text[],
  $q$Attorney/admin review recommended before publishing. Do not present as legal advice or guaranteed eligibility.$q$,
  $q$High for active MDL; Medium for intake criteria$q$,
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

INSERT INTO public.cases (
  slug, name, case_type, status, short_description, long_description,
  priority_score, category, payout_language, core_qualifications,
  disqualifiers_summary, likely_documents, deadline_or_timing, source_urls,
  admin_review_notes, confidence_label, is_research_grade,
  require_medical_docs, required_doc_types, allowed_states, disqualifying_states
) VALUES (
  $q$talcum-powder-ovarian-cancer-mesothelioma$q$,
  $q$Talcum Powder / Ovarian Cancer or Mesothelioma$q$,
  $q$mass_tort$q$,
  'active',
  $q$Claims generally involve long-term use of talcum powder products and later ovarian cancer or mesothelioma.$q$,
  $q$Claims generally involve long-term use of talcum powder products and later ovarian cancer or mesothelioma.$q$,
  75,
  $q$Consumer product / toxic exposure$q$,
  $q$No guaranteed payout. Potential value depends on cancer type, treatment, survival, and damages.$q$,
  $q$Regular talc exposure before diagnosis; qualifying cancer; pathology/oncology records; stronger with long-term frequent use.$q$,
  $q$No talc exposure; no qualifying cancer; cornstarch-only use; diagnosis predates exposure.$q$,
  $q$Oncology records, pathology, product history/photos, purchase records, witness statements.$q$,
  $q$No public universal claim deadline; statute of limitations varies by state.$q$,
  ARRAY[$q$https://www.jpml.uscourts.gov/sites/jpml/files/Pending_MDL_Dockets_By_Actions_Pending-April-1-2026.pdf$q$]::text[],
  $q$Attorney/admin review recommended before publishing. Do not present as legal advice or guaranteed eligibility.$q$,
  $q$High for active MDL; Medium for individual screening$q$,
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

INSERT INTO public.cases (
  slug, name, case_type, status, short_description, long_description,
  priority_score, category, payout_language, core_qualifications,
  disqualifiers_summary, likely_documents, deadline_or_timing, source_urls,
  admin_review_notes, confidence_label, is_research_grade,
  require_medical_docs, required_doc_types, allowed_states, disqualifying_states
) VALUES (
  $q$nec-premature-infant-formula$q$,
  $q$Premature Infant Formula / NEC$q$,
  $q$mass_tort$q$,
  'active',
  $q$Claims generally involve premature infants fed cow’s milk-based formula or fortifier in NICU who developed necrotizing enterocolitis.$q$,
  $q$Claims generally involve premature infants fed cow’s milk-based formula or fortifier in NICU who developed necrotizing enterocolitis.$q$,
  75,
  $q$Infant nutrition product$q$,
  $q$No guaranteed payout. Cases involving surgery, disability, or death may have higher potential damages.$q$,
  $q$Premature infant; cow’s milk-based formula/fortifier exposure before NEC; confirmed NEC diagnosis; hospital/NICU records available.$q$,
  $q$Full-term infant only; no cow’s milk-based formula/fortifier; no NEC diagnosis; injury predates feeding.$q$,
  $q$Birth/NICU records, feeding logs, NEC diagnosis, surgery records, death certificate if applicable.$q$,
  $q$No public universal claim deadline; statute of limitations varies by state and minor/death rules.$q$,
  ARRAY[$q$https://www.jpml.uscourts.gov/sites/jpml/files/Pending_MDL_Dockets_By_Actions_Pending-April-1-2026.pdf$q$, $q$https://www.fda.gov/food/people-risk-foodborne-illness/advice-parents-caregivers-infant-formula$q$]::text[],
  $q$Attorney/admin review recommended before publishing. Do not present as legal advice or guaranteed eligibility.$q$,
  $q$High for active MDL; Medium for product-specific criteria$q$,
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

INSERT INTO public.cases (
  slug, name, case_type, status, short_description, long_description,
  priority_score, category, payout_language, core_qualifications,
  disqualifiers_summary, likely_documents, deadline_or_timing, source_urls,
  admin_review_notes, confidence_label, is_research_grade,
  require_medical_docs, required_doc_types, allowed_states, disqualifying_states
) VALUES (
  $q$social-media-minor-addiction-injury$q$,
  $q$Social Media / Minor Addiction and Mental Health Injury$q$,
  $q$mass_tort$q$,
  'active',
  $q$Claims generally allege minors suffered addiction-like use, mental health injuries, self-harm, eating disorders, or similar harms linked to social media platform design.$q$,
  $q$Claims generally allege minors suffered addiction-like use, mental health injuries, self-harm, eating disorders, or similar harms linked to social media platform design.$q$,
  75,
  $q$Youth mental health / product liability$q$,
  $q$No guaranteed payout. Potential value depends on severity, treatment, hospitalization, self-harm, and documentation.$q$,
  $q$Platform use as minor; significant compulsive use; diagnosed mental health injury or documented harm; parental/medical/school records available.$q$,
  $q$Adult-only use; no injury; minor ordinary use without damages; injury clearly predates platform use.$q$,
  $q$Medical/therapy records, school records, parental records, screen-time/device records, platform account history.$q$,
  $q$No public universal claim deadline; statute of limitations varies by state and minor tolling rules.$q$,
  ARRAY[$q$https://www.jpml.uscourts.gov/sites/jpml/files/Pending_MDL_Dockets_By_Actions_Pending-April-1-2026.pdf$q$, $q$https://www.hhs.gov/surgeongeneral/priorities/youth-mental-health/social-media/index.html$q$]::text[],
  $q$Attorney/admin review recommended before publishing. Do not present as legal advice or guaranteed eligibility.$q$,
  $q$High for active MDL; Medium for specific platform eligibility$q$,
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

INSERT INTO public.cases (
  slug, name, case_type, status, short_description, long_description,
  priority_score, category, payout_language, core_qualifications,
  disqualifiers_summary, likely_documents, deadline_or_timing, source_urls,
  admin_review_notes, confidence_label, is_research_grade,
  require_medical_docs, required_doc_types, allowed_states, disqualifying_states
) VALUES (
  $q$baby-food-heavy-metals-neurodevelopment$q$,
  $q$Baby Food Heavy Metals / Neurodevelopmental Injury$q$,
  $q$mass_tort$q$,
  'active',
  $q$Claims generally allege contaminated baby foods containing heavy metals contributed to autism, ADHD, or neurodevelopmental injuries.$q$,
  $q$Claims generally allege contaminated baby foods containing heavy metals contributed to autism, ADHD, or neurodevelopmental injuries.$q$,
  75,
  $q$Consumer product / child injury$q$,
  $q$No guaranteed payout. Potential value depends on diagnosis, severity, lifetime care, and proof of exposure.$q$,
  $q$Significant baby food exposure during early childhood; qualifying neurodevelopmental diagnosis; records and product history available.$q$,
  $q$No packaged baby food exposure; no diagnosis; diagnosis clearly unrelated/predates exposure; no records.$q$,
  $q$Pediatric records, diagnostic evaluations, IEP/therapy records, product purchase history, photos, feeding history.$q$,
  $q$No public universal claim deadline; statute of limitations varies by state and minor tolling rules.$q$,
  ARRAY[$q$https://www.jpml.uscourts.gov/sites/jpml/files/Pending_MDL_Dockets_By_Actions_Pending-April-1-2026.pdf$q$, $q$https://www.fda.gov/food/environmental-contaminants-food/closer-zero-reducing-childhood-exposure-contaminants-foods$q$]::text[],
  $q$Attorney/admin review recommended before publishing. Do not present as legal advice or guaranteed eligibility.$q$,
  $q$High for active MDL; Medium for causation/screening$q$,
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

INSERT INTO public.cases (
  slug, name, case_type, status, short_description, long_description,
  priority_score, category, payout_language, core_qualifications,
  disqualifiers_summary, likely_documents, deadline_or_timing, source_urls,
  admin_review_notes, confidence_label, is_research_grade,
  require_medical_docs, required_doc_types, allowed_states, disqualifying_states
) VALUES (
  $q$uber-passenger-sexual-assault$q$,
  $q$Rideshare Passenger Sexual Assault$q$,
  $q$mass_tort$q$,
  'active',
  $q$Claims generally involve passengers who allege sexual assault or serious sexual misconduct during rideshare trips.$q$,
  $q$Claims generally involve passengers who allege sexual assault or serious sexual misconduct during rideshare trips.$q$,
  75,
  $q$Personal injury / negligent safety$q$,
  $q$No guaranteed payout. Potential value depends on severity, evidence, treatment, and damages.$q$,
  $q$Incident occurred during/around rideshare trip; passenger victim; records or trip evidence available; stronger with police/medical/therapy documentation.$q$,
  $q$Not a passenger; unrelated to trip; only poor service/no assault; no identifiable trip or driver.$q$,
  $q$Trip receipt, app records, screenshots, police report, medical/SANE exam, therapy records.$q$,
  $q$No public universal claim deadline; statute of limitations varies by state and assault-related rules.$q$,
  ARRAY[$q$https://www.jpml.uscourts.gov/sites/jpml/files/Pending_MDL_Dockets_By_Actions_Pending-April-1-2026.pdf$q$]::text[],
  $q$Attorney/admin review recommended before publishing. Do not present as legal advice or guaranteed eligibility.$q$,
  $q$High for active MDL; Medium for intake criteria$q$,
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

INSERT INTO public.cases (
  slug, name, case_type, status, short_description, long_description,
  priority_score, category, payout_language, core_qualifications,
  disqualifiers_summary, likely_documents, deadline_or_timing, source_urls,
  admin_review_notes, confidence_label, is_research_grade,
  require_medical_docs, required_doc_types, allowed_states, disqualifying_states
) VALUES (
  $q$cartiva-synthetic-cartilage-implant$q$,
  $q$Cartiva Synthetic Cartilage Implant Failure$q$,
  $q$mass_tort$q$,
  'active',
  $q$Claims generally involve failure of Cartiva synthetic cartilage toe implants, persistent pain, collapse, revision, fusion, or removal.$q$,
  $q$Claims generally involve failure of Cartiva synthetic cartilage toe implants, persistent pain, collapse, revision, fusion, or removal.$q$,
  75,
  $q$Medical device$q$,
  $q$No guaranteed payout. Potential value stronger with revision/fusion and ongoing impairment.$q$,
  $q$Cartiva implant; failure symptoms after implant; orthopedic diagnosis; revision/fusion recommended or performed.$q$,
  $q$No Cartiva implant; normal recovery only; no diagnosed failure; unrelated foot condition.$q$,
  $q$Operative report, implant record, imaging, orthopedic notes, revision/fusion records.$q$,
  $q$No public universal claim deadline; statute of limitations varies by state.$q$,
  ARRAY[$q$https://www.jpml.uscourts.gov/sites/jpml/files/Pending_MDL_Dockets_By_Actions_Pending-April-1-2026.pdf$q$]::text[],
  $q$Attorney/admin review recommended before publishing. Do not present as legal advice or guaranteed eligibility.$q$,
  $q$High for active MDL existence; Medium for criteria$q$,
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

INSERT INTO public.cases (
  slug, name, case_type, status, short_description, long_description,
  priority_score, category, payout_language, core_qualifications,
  disqualifiers_summary, likely_documents, deadline_or_timing, source_urls,
  admin_review_notes, confidence_label, is_research_grade,
  require_medical_docs, required_doc_types, allowed_states, disqualifying_states
) VALUES (
  $q$gardasil-autoimmune-neuro-injury$q$,
  $q$Gardasil / Autoimmune or Neurologic Injury$q$,
  $q$mass_tort$q$,
  'active',
  $q$Claims generally involve serious autoimmune, neurologic, or dysautonomia-type injuries following HPV vaccination.$q$,
  $q$Claims generally involve serious autoimmune, neurologic, or dysautonomia-type injuries following HPV vaccination.$q$,
  75,
  $q$Vaccine / product liability$q$,
  $q$No guaranteed payout. Potential value depends on diagnosis, severity, permanence, and procedural route.$q$,
  $q$Gardasil vaccination before onset; medically diagnosed injury; symptom timing supports association; records available.$q$,
  $q$No Gardasil vaccine; symptoms predate vaccine; mild temporary soreness only; no diagnosis.$q$,
  $q$Immunization records, medical diagnosis records, specialist notes, ER/hospital records.$q$,
  $q$No public universal claim deadline; statute of limitations and vaccine-specific procedural rules vary.$q$,
  ARRAY[$q$https://www.jpml.uscourts.gov/sites/jpml/files/Pending_MDL_Dockets_By_Actions_Pending-April-1-2026.pdf$q$, $q$https://www.cdc.gov/vaccine-safety/vaccines/hpv.html$q$]::text[],
  $q$Attorney/admin review recommended before publishing. Do not present as legal advice or guaranteed eligibility.$q$,
  $q$High for active MDL; Medium for screening due vaccine-law complexity$q$,
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

INSERT INTO public.cases (
  slug, name, case_type, status, short_description, long_description,
  priority_score, category, payout_language, core_qualifications,
  disqualifiers_summary, likely_documents, deadline_or_timing, source_urls,
  admin_review_notes, confidence_label, is_research_grade,
  require_medical_docs, required_doc_types, allowed_states, disqualifying_states
) VALUES (
  $q$allergan-biocell-bia-alcl$q$,
  $q$Textured Breast Implants / BIA-ALCL$q$,
  $q$mass_tort$q$,
  'active',
  $q$Claims generally involve Allergan BIOCELL textured breast implants or expanders and diagnosis of BIA-ALCL or related complications.$q$,
  $q$Claims generally involve Allergan BIOCELL textured breast implants or expanders and diagnosis of BIA-ALCL or related complications.$q$,
  75,
  $q$Medical device$q$,
  $q$No guaranteed payout. Potential value depends on diagnosis, treatment, recurrence, and damages.$q$,
  $q$Textured implant exposure; BIA-ALCL diagnosis or serious implant-related complication; implant and oncology records available.$q$,
  $q$Smooth implants only; no diagnosis/complication; cosmetic dissatisfaction only.$q$,
  $q$Implant card, operative report, pathology, oncology records, explant records.$q$,
  $q$No public universal claim deadline; statute of limitations varies by state.$q$,
  ARRAY[$q$https://www.jpml.uscourts.gov/sites/jpml/files/Pending_MDL_Dockets_By_Actions_Pending-April-1-2026.pdf$q$, $q$https://www.fda.gov/medical-devices/breast-implants/breast-implant-associated-anaplastic-large-cell-lymphoma-bia-alcl$q$]::text[],
  $q$Attorney/admin review recommended before publishing. Do not present as legal advice or guaranteed eligibility.$q$,
  $q$High for active MDL; High for FDA condition$q$,
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

INSERT INTO public.cases (
  slug, name, case_type, status, short_description, long_description,
  priority_score, category, payout_language, core_qualifications,
  disqualifiers_summary, likely_documents, deadline_or_timing, source_urls,
  admin_review_notes, confidence_label, is_research_grade,
  require_medical_docs, required_doc_types, allowed_states, disqualifying_states
) VALUES (
  $q$krispy-kreme-data-breach$q$,
  $q$Krispy Kreme Data Incident Settlement$q$,
  $q$class_action$q$,
  'active',
  $q$Settlement for people notified their information may have been involved in the 2024 data incident.$q$,
  $q$Settlement for people notified their information may have been involved in the 2024 data incident.$q$,
  75,
  $q$Data breach$q$,
  $q$Potential benefits include documented-loss reimbursement up to stated cap or alternative cash payment/credit monitoring, subject to settlement terms.$q$,
  $q$Received notice of the data incident; submit claim by deadline; provide documentation for higher reimbursement if claiming losses.$q$,
  $q$No notice/identifier and not in settlement class; missed deadline; unsupported documented-loss claim.$q$,
  $q$Notice ID, proof of address/name, receipts, bank/credit statements, fraud reports, credit monitoring receipts.$q$,
  $q$Claim deadline: June 22, 2026.$q$,
  ARRAY[$q$https://krispykremedatasettlement.com/$q$, $q$https://krispykremedatasettlement.com/Login$q$]::text[],
  $q$Attorney/admin review recommended before publishing. Do not present as legal advice or guaranteed eligibility.$q$,
  $q$High$q$,
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

INSERT INTO public.cases (
  slug, name, case_type, status, short_description, long_description,
  priority_score, category, payout_language, core_qualifications,
  disqualifiers_summary, likely_documents, deadline_or_timing, source_urls,
  admin_review_notes, confidence_label, is_research_grade,
  require_medical_docs, required_doc_types, allowed_states, disqualifying_states
) VALUES (
  $q$fidelity-data-breach$q$,
  $q$Fidelity Investments Data Breach Settlement$q$,
  $q$class_action$q$,
  'active',
  $q$Settlement for people affected by the 2024 Fidelity data breach.$q$,
  $q$Settlement for people affected by the 2024 Fidelity data breach.$q$,
  75,
  $q$Data breach$q$,
  $q$Potential benefits include up to $5,000 documented losses plus other settlement benefits depending on eligibility.$q$,
  $q$Settlement class member/notice recipient; submit valid claim by deadline; provide documentation for reimbursement.$q$,
  $q$Not affected/not in class; missed claim deadline; no documentation for claimed losses.$q$,
  $q$Notice ID, claim form, receipts, credit monitoring costs, fraud/identity theft documentation, bank/credit reports.$q$,
  $q$Claim deadline: July 27, 2026.$q$,
  ARRAY[$q$https://fidelitydatasettlement.com/$q$, $q$https://www.claimdepot.com/settlements/fidelity-data-settlement$q$]::text[],
  $q$Attorney/admin review recommended before publishing. Do not present as legal advice or guaranteed eligibility.$q$,
  $q$High$q$,
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

INSERT INTO public.cases (
  slug, name, case_type, status, short_description, long_description,
  priority_score, category, payout_language, core_qualifications,
  disqualifiers_summary, likely_documents, deadline_or_timing, source_urls,
  admin_review_notes, confidence_label, is_research_grade,
  require_medical_docs, required_doc_types, allowed_states, disqualifying_states
) VALUES (
  $q$alera-group-data-breach$q$,
  $q$Alera Group Data Breach Settlement$q$,
  $q$class_action$q$,
  'active',
  $q$Settlement for people notified about the Alera Group data breach.$q$,
  $q$Settlement for people notified about the Alera Group data breach.$q$,
  75,
  $q$Data breach$q$,
  $q$Potential benefits include up to $3,500 documented losses or alternative cash payment, subject to settlement terms.$q$,
  $q$Settlement class member/notice recipient; file by deadline; provide documentation for higher reimbursement.$q$,
  $q$No notice/not in class; missed deadline; unsupported losses.$q$,
  $q$Notice ID, receipts, bank statements, credit reports, fraud reports, identity protection receipts.$q$,
  $q$Claim deadline: June 29, 2026.$q$,
  ARRAY[$q$https://www.claimdepot.com/settlements/alera-group-data-settlement$q$, $q$https://www.classaction.org/media/alera-group-notice.pdf$q$]::text[],
  $q$Attorney/admin review recommended before publishing. Do not present as legal advice or guaranteed eligibility.$q$,
  $q$High$q$,
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

INSERT INTO public.cases (
  slug, name, case_type, status, short_description, long_description,
  priority_score, category, payout_language, core_qualifications,
  disqualifiers_summary, likely_documents, deadline_or_timing, source_urls,
  admin_review_notes, confidence_label, is_research_grade,
  require_medical_docs, required_doc_types, allowed_states, disqualifying_states
) VALUES (
  $q$consumer-beef-antitrust$q$,
  $q$Consumer Indirect Beef Antitrust Settlement$q$,
  $q$class_action$q$,
  'active',
  $q$Settlement for consumers who purchased eligible fresh or frozen beef products for personal use during the class period in covered states.$q$,
  $q$Settlement for consumers who purchased eligible fresh or frozen beef products for personal use during the class period in covered states.$q$,
  75,
  $q$Antitrust / consumer purchases$q$,
  $q$Pro rata cash payment from settlement fund; final amount depends on valid claims.$q$,
  $q$Purchased covered beef products between August 1, 2014 and December 31, 2019; purchased in covered states/DC; for personal/family/household use; submit claim by deadline.$q$,
  $q$Business resale purchases; purchases outside covered state/time period; no covered products; missed deadline.$q$,
  $q$Receipts helpful if available, but claim rules may not require itemized proof for all claimants; authority docs if filing for someone else.$q$,
  $q$Claim deadline: June 30, 2026.$q$,
  ARRAY[$q$https://www.overchargedforbeef.com/$q$, $q$https://overchargedforbeef.com/Login$q$]::text[],
  $q$Attorney/admin review recommended before publishing. Do not present as legal advice or guaranteed eligibility.$q$,
  $q$High$q$,
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

INSERT INTO public.cases (
  slug, name, case_type, status, short_description, long_description,
  priority_score, category, payout_language, core_qualifications,
  disqualifiers_summary, likely_documents, deadline_or_timing, source_urls,
  admin_review_notes, confidence_label, is_research_grade,
  require_medical_docs, required_doc_types, allowed_states, disqualifying_states
) VALUES (
  $q$metformin-ndma-antitrust-marketing$q$,
  $q$Generic Metformin NDMA Settlement$q$,
  $q$class_action$q$,
  'active',
  $q$Settlement for consumers who paid for certain metformin-containing drugs during the class period.$q$,
  $q$Settlement for consumers who paid for certain metformin-containing drugs during the class period.$q$,
  75,
  $q$Prescription drug / consumer reimbursement$q$,
  $q$Pro rata or settlement-defined payment; final amount depends on approved claims and documentation.$q$,
  $q$Paid for eligible metformin-containing drug during the defined class period; provide proof/documentation; submit by deadline.$q$,
  $q$No covered metformin purchase/payment; outside class period; no documentation where required; missed deadline.$q$,
  $q$Pharmacy records, prescription records, receipts, insurance EOBs, payment records.$q$,
  $q$Claim deadline: July 10, 2026.$q$,
  ARRAY[$q$https://www.claimdepot.com/settlements/in-re-metformin-settlement$q$]::text[],
  $q$Attorney/admin review recommended before publishing. Do not present as legal advice or guaranteed eligibility.$q$,
  $q$High$q$,
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

INSERT INTO public.cases (
  slug, name, case_type, status, short_description, long_description,
  priority_score, category, payout_language, core_qualifications,
  disqualifiers_summary, likely_documents, deadline_or_timing, source_urls,
  admin_review_notes, confidence_label, is_research_grade,
  require_medical_docs, required_doc_types, allowed_states, disqualifying_states
) VALUES (
  $q$hyundai-kia-airbag-acu$q$,
  $q$Hyundai/Kia Airbag Control Unit Settlement$q$,
  $q$class_action$q$,
  'active',
  $q$Settlement for current/former owners or lessees of specific Hyundai/Kia vehicles with alleged ZF-TRW airbag control unit defect.$q$,
  $q$Settlement for current/former owners or lessees of specific Hyundai/Kia vehicles with alleged ZF-TRW airbag control unit defect.$q$,
  75,
  $q$Automotive defect$q$,
  $q$Potential reimbursement/out-of-pocket benefits and separate payment depending on claim type and vehicle.$q$,
  $q$Owned/leased covered Hyundai or Kia vehicle originally sold/leased in U.S.; VIN/model qualifies; submit claim by deadline for benefits.$q$,
  $q$Vehicle not covered by VIN/model; no ownership/lease interest; missed deadline; expenses unsupported where documentation required.$q$,
  $q$VIN, registration/title, lease/sale documents, repair receipts, towing/rental/out-of-pocket records.$q$,
  $q$Claim deadline listed by sources as March 29, 2027 or extended to April 8, 2027; verify administrator date before publishing.$q$,
  ARRAY[$q$https://www.acusettlement.com/hyundaikia$q$, $q$https://www.consumer-action.org/lawsuits/minical/2027/03/29$q$, $q$https://www.claimdepot.com/settlements/acu-settlement-hyundai-kia$q$]::text[],
  $q$Attorney/admin review recommended before publishing. Do not present as legal advice or guaranteed eligibility.$q$,
  $q$High, but deadline should be verified against official portal$q$,
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

INSERT INTO public.cases (
  slug, name, case_type, status, short_description, long_description,
  priority_score, category, payout_language, core_qualifications,
  disqualifiers_summary, likely_documents, deadline_or_timing, source_urls,
  admin_review_notes, confidence_label, is_research_grade,
  require_medical_docs, required_doc_types, allowed_states, disqualifying_states
) VALUES (
  $q$fca-hourly-wage-hour$q$,
  $q$FCA US Hourly Production Worker Wage Settlement$q$,
  $q$class_action$q$,
  'active',
  $q$Settlement for certain hourly production employees during the class period.$q$,
  $q$Settlement for certain hourly production employees during the class period.$q$,
  75,
  $q$Labor / wage and hour$q$,
  $q$Payment varies based on settlement formula and work history.$q$,
  $q$Hourly production employee between February 10, 2020 and May 12, 2025; included in settlement class; submit claim if required by terms.$q$,
  $q$Not hourly production employee; outside employment dates; excluded role; missed deadline.$q$,
  $q$Employment records, paystubs, W-2s, notice ID, dates worked.$q$,
  $q$Claim deadline: June 22, 2026.$q$,
  ARRAY[$q$https://www.claimdepot.com/settlements$q$]::text[],
  $q$Attorney/admin review recommended before publishing. Do not present as legal advice or guaranteed eligibility.$q$,
  $q$Medium-High; source is settlement database snippet, verify official notice before publishing$q$,
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

INSERT INTO public.cases (
  slug, name, case_type, status, short_description, long_description,
  priority_score, category, payout_language, core_qualifications,
  disqualifiers_summary, likely_documents, deadline_or_timing, source_urls,
  admin_review_notes, confidence_label, is_research_grade,
  require_medical_docs, required_doc_types, allowed_states, disqualifying_states
) VALUES (
  $q$tinder-age-discrimination-subscription$q$,
  $q$Tinder Plus/Gold Age-Based Pricing Settlement$q$,
  $q$class_action$q$,
  'active',
  $q$Settlement involving alleged age-based pricing for Tinder Plus/Gold subscriptions.$q$,
  $q$Settlement involving alleged age-based pricing for Tinder Plus/Gold subscriptions.$q$,
  55,
  $q$Consumer subscription / discrimination$q$,
  $q$Payment varies based on settlement formula and number of claims.$q$,
  $q$Purchased eligible subscription; age and date criteria match class definition; submit claim by deadline.$q$,
  $q$No eligible subscription; outside class period/geography/age group; missed deadline.$q$,
  $q$Account email/phone, subscription receipts, app store purchase history, payment records.$q$,
  $q$Claim deadline: August 18, 2026.$q$,
  ARRAY[$q$https://topclassactions.com/category/lawsuit-settlements/open-lawsuit-settlements/$q$]::text[],
  $q$Attorney/admin review recommended before publishing. Do not present as legal advice or guaranteed eligibility.$q$,
  $q$Medium; verify official settlement website before production$q$,
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

INSERT INTO public.cases (
  slug, name, case_type, status, short_description, long_description,
  priority_score, category, payout_language, core_qualifications,
  disqualifiers_summary, likely_documents, deadline_or_timing, source_urls,
  admin_review_notes, confidence_label, is_research_grade,
  require_medical_docs, required_doc_types, allowed_states, disqualifying_states
) VALUES (
  $q$comcast-cable-data-breach$q$,
  $q$Comcast Cable Data Breach Settlement$q$,
  $q$class_action$q$,
  'active',
  $q$Settlement process related to October 2023 data breach publicly disclosed in December 2023.$q$,
  $q$Settlement process related to October 2023 data breach publicly disclosed in December 2023.$q$,
  75,
  $q$Data breach$q$,
  $q$Settlement benefit details depend on final approved notice/claim form.$q$,
  $q$Notification recipient/settlement class member; file claim if claim form available; meet settlement deadlines.$q$,
  $q$Not notified/not class member; missed claim/opt-out deadlines; unsupported losses.$q$,
  $q$Notice ID, claim form, fraud/loss receipts, credit monitoring docs, bank/credit records.$q$,
  $q$Opt-out/objection deadline: July 1, 2026; final approval hearing: August 5, 2026. Verify claim deadline before publishing.$q$,
  ARRAY[$q$https://www.comcastbreachsettlement.com/$q$, $q$https://forms.ksacms.com/efiling/fr/eform/comcastbreachsettlement_claimform/new?form-version=1$q$]::text[],
  $q$Attorney/admin review recommended before publishing. Do not present as legal advice or guaranteed eligibility.$q$,
  $q$High for active settlement process; Medium for claim-specific payout fields$q$,
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

INSERT INTO public.cases (
  slug, name, case_type, status, short_description, long_description,
  priority_score, category, payout_language, core_qualifications,
  disqualifiers_summary, likely_documents, deadline_or_timing, source_urls,
  admin_review_notes, confidence_label, is_research_grade,
  require_medical_docs, required_doc_types, allowed_states, disqualifying_states
) VALUES (
  $q$mylan-securities-settlement$q$,
  $q$Mylan Securities Settlement$q$,
  $q$class_action$q$,
  'active',
  $q$Settlement for eligible investors who purchased or otherwise acquired covered securities during the class period.$q$,
  $q$Settlement for eligible investors who purchased or otherwise acquired covered securities during the class period.$q$,
  75,
  $q$Securities$q$,
  $q$Pro rata payment from net settlement fund based on recognized loss formula.$q$,
  $q$Purchased eligible securities during class period; suffered recognized loss under plan of allocation; submit claim and transaction documentation.$q$,
  $q$No covered securities; no recognized loss; excluded person/entity; missed deadline.$q$,
  $q$Brokerage statements, trade confirmations, account records, tax lots.$q$,
  $q$Claim deadline: July 10, 2026.$q$,
  ARRAY[$q$https://www.claimdepot.com/settlements/mylan-2026-securities-settlement$q$]::text[],
  $q$Attorney/admin review recommended before publishing. Do not present as legal advice or guaranteed eligibility.$q$,
  $q$High$q$,
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


-- ----- 3. Reusable global questions (shared across all 30 cases) -----
INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$exposure_timing$q$,
  $q$Did the exposure happen before the injury, loss, or diagnosis?$q$,
  $q$yes_no$q$,
  '[]'::jsonb,
  $q$For most claims, the harmful event must come before the injury or loss it caused.$q$,
  $q$case_specific$q$,
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  question_type = EXCLUDED.question_type,
  answer_options = EXCLUDED.answer_options,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$date_exposure$q$,
  $q$What approximate date range did the exposure, purchase, employment, or event occur?$q$,
  $q$date_range$q$,
  '[]'::jsonb,
  $q$Approximate is fine — best guess of the start and end date.$q$,
  $q$case_specific$q$,
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  question_type = EXCLUDED.question_type,
  answer_options = EXCLUDED.answer_options,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$date_injury_loss$q$,
  $q$When were you diagnosed, injured, notified, charged, employed, or financially impacted?$q$,
  $q$date$q$,
  '[]'::jsonb,
  $q$Approximate date is fine if you do not remember the exact one.$q$,
  $q$case_specific$q$,
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  question_type = EXCLUDED.question_type,
  answer_options = EXCLUDED.answer_options,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$state_of_event$q$,
  $q$What state did this happen in, or what state did you live in at the time?$q$,
  $q$dropdown$q$,
  '["AL","AK","AZ","AR","CA","CO","CT","DE","FL","GA","HI","ID","IL","IN","IA","KS","KY","LA","ME","MD","MA","MI","MN","MS","MO","MT","NE","NV","NH","NJ","NM","NY","NC","ND","OH","OK","OR","PA","RI","SC","SD","TN","TX","UT","VT","VA","WA","WV","WI","WY","DC"]'::jsonb,
  $q$Some claims have state-specific eligibility rules.$q$,
  $q$case_specific$q$,
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  question_type = EXCLUDED.question_type,
  answer_options = EXCLUDED.answer_options,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$contact_permission$q$,
  $q$Are you open to being contacted by an attorney about this case?$q$,
  $q$yes_no$q$,
  '[]'::jsonb,
  $q$You can change your mind anytime. Attorneys in these cases work on contingency — no fees unless you win.$q$,
  $q$case_specific$q$,
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  question_type = EXCLUDED.question_type,
  answer_options = EXCLUDED.answer_options,
  help_text = EXCLUDED.help_text,
  updated_at = now();


-- ----- 4. Per-case questions (case-specific exposure, injury, and records prompts) -----
INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$confirm_exposure__depo_provera_meningioma$q$,
  $q$Did you have the exposure/event listed for this case: Received Depo-Provera / depot medroxyprogesterone acetate injections, especially repeated or long-term use.$q$,
  'yes_no',
  '[]'::jsonb,
  $q$Received Depo-Provera / depot medroxyprogesterone acetate injections, especially repeated or long-term use.$q$,
  'case_specific',
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$confirm_injury_or_loss__depo_provera_meningioma$q$,
  $q$Did you experience this injury/loss: Diagnosed meningioma brain tumor; stronger if surgery, radiation, seizures, vision loss, headaches, neurologic deficits, disability, or ongoing monitoring.$q$,
  'yes_no',
  '[]'::jsonb,
  $q$Diagnosed meningioma brain tumor; stronger if surgery, radiation, seizures, vision loss, headaches, neurologic deficits, disability, or ongoing monitoring.$q$,
  'case_specific',
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$records_available__depo_provera_meningioma$q$,
  $q$Do you have any supporting records such as: Pharmacy records, OB/GYN records, injection records, MRI/CT reports, pathology, neurosurgery records.$q$,
  'multi_select',
  '["Pharmacy records","OB/GYN records","injection records","MRI/CT reports","pathology","neurosurgery records","Other / Not sure","I do not have records yet"]'::jsonb,
  $q$You can submit a claim without records — they just help speed up review.$q$,
  'case_specific',
  false
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  answer_options = EXCLUDED.answer_options,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$confirm_exposure__afff_firefighting_foam_cancer$q$,
  $q$Did you have the exposure/event listed for this case: Firefighter, military, airport, industrial, refinery, or training-site exposure to AFFF foam; or contaminated water exposure near AFFF sites.$q$,
  'yes_no',
  '[]'::jsonb,
  $q$Firefighter, military, airport, industrial, refinery, or training-site exposure to AFFF foam; or contaminated water exposure near AFFF sites.$q$,
  'case_specific',
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$confirm_injury_or_loss__afff_firefighting_foam_cancer$q$,
  $q$Did you experience this injury/loss: Kidney cancer, testicular cancer, thyroid disease/cancer, ulcerative colitis, liver cancer, pancreatic cancer, prostate cancer, and other PFAS-linked conditions may be screened by firms.$q$,
  'yes_no',
  '[]'::jsonb,
  $q$Kidney cancer, testicular cancer, thyroid disease/cancer, ulcerative colitis, liver cancer, pancreatic cancer, prostate cancer, and other PFAS-linked conditions may be screened by firms.$q$,
  'case_specific',
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$records_available__afff_firefighting_foam_cancer$q$,
  $q$Do you have any supporting records such as: Employment/military/fire department records, exposure history, medical diagnosis records, pathology, cancer treatment records.$q$,
  'multi_select',
  '["Employment/military/fire department records","exposure history","medical diagnosis records","pathology","cancer treatment records","Other / Not sure","I do not have records yet"]'::jsonb,
  $q$You can submit a claim without records — they just help speed up review.$q$,
  'case_specific',
  false
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  answer_options = EXCLUDED.answer_options,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$confirm_exposure__hair_relaxer_cancer$q$,
  $q$Did you have the exposure/event listed for this case: Used chemical hair relaxers, straighteners, texturizers, or perms, typically multiple times per year over multiple years.$q$,
  'yes_no',
  '[]'::jsonb,
  $q$Used chemical hair relaxers, straighteners, texturizers, or perms, typically multiple times per year over multiple years.$q$,
  'case_specific',
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$confirm_injury_or_loss__hair_relaxer_cancer$q$,
  $q$Did you experience this injury/loss: Uterine cancer, endometrial cancer, ovarian cancer; some intake programs may also screen uterine fibroids, hysterectomy, endometriosis, or infertility.$q$,
  'yes_no',
  '[]'::jsonb,
  $q$Uterine cancer, endometrial cancer, ovarian cancer; some intake programs may also screen uterine fibroids, hysterectomy, endometriosis, or infertility.$q$,
  'case_specific',
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$records_available__hair_relaxer_cancer$q$,
  $q$Do you have any supporting records such as: Medical diagnosis records, pathology, hysterectomy records, purchase/product history, photos, salon records if available.$q$,
  'multi_select',
  '["Medical diagnosis records","pathology","hysterectomy records","purchase/product history","photos","salon records if available","Other / Not sure","I do not have records yet"]'::jsonb,
  $q$You can submit a claim without records — they just help speed up review.$q$,
  'case_specific',
  false
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  answer_options = EXCLUDED.answer_options,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$confirm_exposure__paraquat_parkinsons$q$,
  $q$Did you have the exposure/event listed for this case: Mixed, sprayed, handled, applied, or worked near paraquat in agriculture, landscaping, vegetation control, or pesticide application.$q$,
  'yes_no',
  '[]'::jsonb,
  $q$Mixed, sprayed, handled, applied, or worked near paraquat in agriculture, landscaping, vegetation control, or pesticide application.$q$,
  'case_specific',
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$confirm_injury_or_loss__paraquat_parkinsons$q$,
  $q$Did you experience this injury/loss: Diagnosed Parkinson’s disease or Parkinsonian syndrome after exposure.$q$,
  'yes_no',
  '[]'::jsonb,
  $q$Diagnosed Parkinson’s disease or Parkinsonian syndrome after exposure.$q$,
  'case_specific',
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$records_available__paraquat_parkinsons$q$,
  $q$Do you have any supporting records such as: Work records, pesticide applicator records, farm records, diagnosis records, neurology records, medication history.$q$,
  'multi_select',
  '["Work records","pesticide applicator records","farm records","diagnosis records","neurology records","medication history","Other / Not sure","I do not have records yet"]'::jsonb,
  $q$You can submit a claim without records — they just help speed up review.$q$,
  'case_specific',
  false
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  answer_options = EXCLUDED.answer_options,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$confirm_exposure__glp1_gastrointestinal_injury$q$,
  $q$Did you have the exposure/event listed for this case: Used GLP-1 medications such as semaglutide, liraglutide, tirzepatide, dulaglutide, or similar injections/tablets.$q$,
  'yes_no',
  '[]'::jsonb,
  $q$Used GLP-1 medications such as semaglutide, liraglutide, tirzepatide, dulaglutide, or similar injections/tablets.$q$,
  'case_specific',
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$confirm_injury_or_loss__glp1_gastrointestinal_injury$q$,
  $q$Did you experience this injury/loss: Gastroparesis, stomach paralysis, ileus, bowel obstruction, severe vomiting requiring ER/hospitalization, gallbladder removal, or similar serious GI complications.$q$,
  'yes_no',
  '[]'::jsonb,
  $q$Gastroparesis, stomach paralysis, ileus, bowel obstruction, severe vomiting requiring ER/hospitalization, gallbladder removal, or similar serious GI complications.$q$,
  'case_specific',
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$records_available__glp1_gastrointestinal_injury$q$,
  $q$Do you have any supporting records such as: Prescription records, pharmacy records, ER/hospital records, GI specialist notes, imaging, surgery records.$q$,
  'multi_select',
  '["Prescription records","pharmacy records","ER/hospital records","GI specialist notes","imaging","surgery records","Other / Not sure","I do not have records yet"]'::jsonb,
  $q$You can submit a claim without records — they just help speed up review.$q$,
  'case_specific',
  false
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  answer_options = EXCLUDED.answer_options,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$confirm_exposure__glp1_naion_vision_loss$q$,
  $q$Did you have the exposure/event listed for this case: Used GLP-1 receptor agonists for diabetes or weight loss before vision injury.$q$,
  'yes_no',
  '[]'::jsonb,
  $q$Used GLP-1 receptor agonists for diabetes or weight loss before vision injury.$q$,
  'case_specific',
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$confirm_injury_or_loss__glp1_naion_vision_loss$q$,
  $q$Did you experience this injury/loss: Diagnosed NAION, optic nerve stroke, or sudden permanent vision loss.$q$,
  'yes_no',
  '[]'::jsonb,
  $q$Diagnosed NAION, optic nerve stroke, or sudden permanent vision loss.$q$,
  'case_specific',
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$records_available__glp1_naion_vision_loss$q$,
  $q$Do you have any supporting records such as: Prescription records, ophthalmology records, visual field testing, diagnosis records.$q$,
  'multi_select',
  '["Prescription records","ophthalmology records","visual field testing","diagnosis records","Other / Not sure","I do not have records yet"]'::jsonb,
  $q$You can submit a claim without records — they just help speed up review.$q$,
  'case_specific',
  false
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  answer_options = EXCLUDED.answer_options,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$confirm_exposure__suboxone_dental_injury$q$,
  $q$Did you have the exposure/event listed for this case: Used Suboxone or generic buprenorphine/naloxone film that dissolves in the mouth.$q$,
  'yes_no',
  '[]'::jsonb,
  $q$Used Suboxone or generic buprenorphine/naloxone film that dissolves in the mouth.$q$,
  'case_specific',
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$confirm_injury_or_loss__suboxone_dental_injury$q$,
  $q$Did you experience this injury/loss: Severe tooth decay, cavities, dental erosion, tooth loss, extractions, crowns, implants, dentures, or major dental repair.$q$,
  'yes_no',
  '[]'::jsonb,
  $q$Severe tooth decay, cavities, dental erosion, tooth loss, extractions, crowns, implants, dentures, or major dental repair.$q$,
  'case_specific',
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$records_available__suboxone_dental_injury$q$,
  $q$Do you have any supporting records such as: Prescription records, dental charts, treatment plans, extraction/crown/implant invoices, photos.$q$,
  'multi_select',
  '["Prescription records","dental charts","treatment plans","extraction/crown/implant invoices","photos","Other / Not sure","I do not have records yet"]'::jsonb,
  $q$You can submit a claim without records — they just help speed up review.$q$,
  'case_specific',
  false
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  answer_options = EXCLUDED.answer_options,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$confirm_exposure__bard_powerport_injury$q$,
  $q$Did you have the exposure/event listed for this case: Had an implanted port catheter or port-a-cath device, including power-injectable ports.$q$,
  'yes_no',
  '[]'::jsonb,
  $q$Had an implanted port catheter or port-a-cath device, including power-injectable ports.$q$,
  'case_specific',
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$confirm_injury_or_loss__bard_powerport_injury$q$,
  $q$Did you experience this injury/loss: Device fracture, migration, catheter breakage, blood clot, infection, perforation, embolism, revision surgery, or emergency removal.$q$,
  'yes_no',
  '[]'::jsonb,
  $q$Device fracture, migration, catheter breakage, blood clot, infection, perforation, embolism, revision surgery, or emergency removal.$q$,
  'case_specific',
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$records_available__bard_powerport_injury$q$,
  $q$Do you have any supporting records such as: Implant card, operative report, radiology, revision/removal report, ER/hospital records.$q$,
  'multi_select',
  '["Implant card","operative report","radiology","revision/removal report","ER/hospital records","Other / Not sure","I do not have records yet"]'::jsonb,
  $q$You can submit a claim without records — they just help speed up review.$q$,
  'case_specific',
  false
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  answer_options = EXCLUDED.answer_options,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$confirm_exposure__tepezza_hearing_loss$q$,
  $q$Did you have the exposure/event listed for this case: Received Tepezza infusions.$q$,
  'yes_no',
  '[]'::jsonb,
  $q$Received Tepezza infusions.$q$,
  'case_specific',
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$confirm_injury_or_loss__tepezza_hearing_loss$q$,
  $q$Did you experience this injury/loss: Permanent or significant hearing loss, tinnitus, ear fullness, autophony, hyperacusis, or need for hearing aids.$q$,
  'yes_no',
  '[]'::jsonb,
  $q$Permanent or significant hearing loss, tinnitus, ear fullness, autophony, hyperacusis, or need for hearing aids.$q$,
  'case_specific',
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$records_available__tepezza_hearing_loss$q$,
  $q$Do you have any supporting records such as: Infusion records, ENT/audiology records, audiograms, hearing aid records.$q$,
  'multi_select',
  '["Infusion records","ENT/audiology records","audiograms","hearing aid records","Other / Not sure","I do not have records yet"]'::jsonb,
  $q$You can submit a claim without records — they just help speed up review.$q$,
  'case_specific',
  false
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  answer_options = EXCLUDED.answer_options,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$confirm_exposure__philips_cpap_recall_injury$q$,
  $q$Did you have the exposure/event listed for this case: Used a recalled Philips sleep apnea or ventilator device, especially before or after visible black particles, odor, or ozone cleaner use.$q$,
  'yes_no',
  '[]'::jsonb,
  $q$Used a recalled Philips sleep apnea or ventilator device, especially before or after visible black particles, odor, or ozone cleaner use.$q$,
  'case_specific',
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$confirm_injury_or_loss__philips_cpap_recall_injury$q$,
  $q$Did you experience this injury/loss: Cancer, respiratory injury, asthma, COPD worsening, lung nodules, sinus issues, organ injury, or significant symptoms requiring treatment.$q$,
  'yes_no',
  '[]'::jsonb,
  $q$Cancer, respiratory injury, asthma, COPD worsening, lung nodules, sinus issues, organ injury, or significant symptoms requiring treatment.$q$,
  'case_specific',
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$records_available__philips_cpap_recall_injury$q$,
  $q$Do you have any supporting records such as: Device model/serial, recall registration, purchase records, sleep doctor records, pulmonary/oncology records.$q$,
  'multi_select',
  '["Device model/serial","recall registration","purchase records","sleep doctor records","pulmonary/oncology records","Other / Not sure","I do not have records yet"]'::jsonb,
  $q$You can submit a claim without records — they just help speed up review.$q$,
  'case_specific',
  false
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  answer_options = EXCLUDED.answer_options,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$confirm_exposure__exactech_joint_replacement_failure$q$,
  $q$Did you have the exposure/event listed for this case: Received an Exactech knee, hip, ankle, or related polyethylene component subject to recall/defective packaging concerns.$q$,
  'yes_no',
  '[]'::jsonb,
  $q$Received an Exactech knee, hip, ankle, or related polyethylene component subject to recall/defective packaging concerns.$q$,
  'case_specific',
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$confirm_injury_or_loss__exactech_joint_replacement_failure$q$,
  $q$Did you experience this injury/loss: Premature implant failure, excessive wear, pain, swelling, instability, bone loss, revision surgery or recommendation for revision.$q$,
  'yes_no',
  '[]'::jsonb,
  $q$Premature implant failure, excessive wear, pain, swelling, instability, bone loss, revision surgery or recommendation for revision.$q$,
  'case_specific',
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$records_available__exactech_joint_replacement_failure$q$,
  $q$Do you have any supporting records such as: Operative report, implant stickers, recall notice, orthopedic records, imaging, revision records.$q$,
  'multi_select',
  '["Operative report","implant stickers","recall notice","orthopedic records","imaging","revision records","Other / Not sure","I do not have records yet"]'::jsonb,
  $q$You can submit a claim without records — they just help speed up review.$q$,
  'case_specific',
  false
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  answer_options = EXCLUDED.answer_options,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$confirm_exposure__paragard_iud_breakage$q$,
  $q$Did you have the exposure/event listed for this case: Had a Paragard copper IUD implanted.$q$,
  'yes_no',
  '[]'::jsonb,
  $q$Had a Paragard copper IUD implanted.$q$,
  'case_specific',
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$confirm_injury_or_loss__paragard_iud_breakage$q$,
  $q$Did you experience this injury/loss: Device broke during removal; retained fragments; perforation; surgery/hysteroscopy/laparoscopy; pain, bleeding, infection, fertility impact.$q$,
  'yes_no',
  '[]'::jsonb,
  $q$Device broke during removal; retained fragments; perforation; surgery/hysteroscopy/laparoscopy; pain, bleeding, infection, fertility impact.$q$,
  'case_specific',
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$records_available__paragard_iud_breakage$q$,
  $q$Do you have any supporting records such as: IUD insertion/removal records, operative report, ultrasound/X-ray, retained-fragment records.$q$,
  'multi_select',
  '["IUD insertion/removal records","operative report","ultrasound/X-ray","retained-fragment records","Other / Not sure","I do not have records yet"]'::jsonb,
  $q$You can submit a claim without records — they just help speed up review.$q$,
  'case_specific',
  false
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  answer_options = EXCLUDED.answer_options,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$confirm_exposure__talcum_powder_ovarian_cancer_mesothelioma$q$,
  $q$Did you have the exposure/event listed for this case: Used talcum powder/body powder for personal hygiene, genital use, baby powder, or occupational talc exposure.$q$,
  'yes_no',
  '[]'::jsonb,
  $q$Used talcum powder/body powder for personal hygiene, genital use, baby powder, or occupational talc exposure.$q$,
  'case_specific',
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$confirm_injury_or_loss__talcum_powder_ovarian_cancer_mesothelioma$q$,
  $q$Did you experience this injury/loss: Ovarian cancer, fallopian tube cancer, primary peritoneal cancer, or mesothelioma.$q$,
  'yes_no',
  '[]'::jsonb,
  $q$Ovarian cancer, fallopian tube cancer, primary peritoneal cancer, or mesothelioma.$q$,
  'case_specific',
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$records_available__talcum_powder_ovarian_cancer_mesothelioma$q$,
  $q$Do you have any supporting records such as: Oncology records, pathology, product history/photos, purchase records, witness statements.$q$,
  'multi_select',
  '["Oncology records","pathology","product history/photos","purchase records","witness statements","Other / Not sure","I do not have records yet"]'::jsonb,
  $q$You can submit a claim without records — they just help speed up review.$q$,
  'case_specific',
  false
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  answer_options = EXCLUDED.answer_options,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$confirm_exposure__nec_premature_infant_formula$q$,
  $q$Did you have the exposure/event listed for this case: Premature or low-birth-weight infant received cow’s milk-based formula or human milk fortifier in NICU.$q$,
  'yes_no',
  '[]'::jsonb,
  $q$Premature or low-birth-weight infant received cow’s milk-based formula or human milk fortifier in NICU.$q$,
  'case_specific',
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$confirm_injury_or_loss__nec_premature_infant_formula$q$,
  $q$Did you experience this injury/loss: Necrotizing enterocolitis (NEC), bowel surgery, short bowel syndrome, sepsis, long-term disability, or death.$q$,
  'yes_no',
  '[]'::jsonb,
  $q$Necrotizing enterocolitis (NEC), bowel surgery, short bowel syndrome, sepsis, long-term disability, or death.$q$,
  'case_specific',
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$records_available__nec_premature_infant_formula$q$,
  $q$Do you have any supporting records such as: Birth/NICU records, feeding logs, NEC diagnosis, surgery records, death certificate if applicable.$q$,
  'multi_select',
  '["Birth/NICU records","feeding logs","NEC diagnosis","surgery records","death certificate if applicable","Other / Not sure","I do not have records yet"]'::jsonb,
  $q$You can submit a claim without records — they just help speed up review.$q$,
  'case_specific',
  false
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  answer_options = EXCLUDED.answer_options,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$confirm_exposure__social_media_minor_addiction_injury$q$,
  $q$Did you have the exposure/event listed for this case: Minor used major social media platforms frequently, especially before age 18.$q$,
  'yes_no',
  '[]'::jsonb,
  $q$Minor used major social media platforms frequently, especially before age 18.$q$,
  'case_specific',
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$confirm_injury_or_loss__social_media_minor_addiction_injury$q$,
  $q$Did you experience this injury/loss: Diagnosed depression, anxiety, eating disorder, self-harm, suicidal ideation/attempt, hospitalization, therapy, or school/social impairment.$q$,
  'yes_no',
  '[]'::jsonb,
  $q$Diagnosed depression, anxiety, eating disorder, self-harm, suicidal ideation/attempt, hospitalization, therapy, or school/social impairment.$q$,
  'case_specific',
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$records_available__social_media_minor_addiction_injury$q$,
  $q$Do you have any supporting records such as: Medical/therapy records, school records, parental records, screen-time/device records, platform account history.$q$,
  'multi_select',
  '["Medical/therapy records","school records","parental records","screen-time/device records","platform account history","Other / Not sure","I do not have records yet"]'::jsonb,
  $q$You can submit a claim without records — they just help speed up review.$q$,
  'case_specific',
  false
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  answer_options = EXCLUDED.answer_options,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$confirm_exposure__baby_food_heavy_metals_neurodevelopment$q$,
  $q$Did you have the exposure/event listed for this case: Child consumed packaged baby foods, cereals, pouches, snacks, or purees alleged to contain heavy metals during infancy/toddler years.$q$,
  'yes_no',
  '[]'::jsonb,
  $q$Child consumed packaged baby foods, cereals, pouches, snacks, or purees alleged to contain heavy metals during infancy/toddler years.$q$,
  'case_specific',
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$confirm_injury_or_loss__baby_food_heavy_metals_neurodevelopment$q$,
  $q$Did you experience this injury/loss: Autism spectrum disorder, ADHD, developmental delay, speech delay, intellectual disability, or behavioral/neurodevelopmental diagnosis.$q$,
  'yes_no',
  '[]'::jsonb,
  $q$Autism spectrum disorder, ADHD, developmental delay, speech delay, intellectual disability, or behavioral/neurodevelopmental diagnosis.$q$,
  'case_specific',
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$records_available__baby_food_heavy_metals_neurodevelopment$q$,
  $q$Do you have any supporting records such as: Pediatric records, diagnostic evaluations, IEP/therapy records, product purchase history, photos, feeding history.$q$,
  'multi_select',
  '["Pediatric records","diagnostic evaluations","IEP/therapy records","product purchase history","photos","feeding history","Other / Not sure","I do not have records yet"]'::jsonb,
  $q$You can submit a claim without records — they just help speed up review.$q$,
  'case_specific',
  false
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  answer_options = EXCLUDED.answer_options,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$confirm_exposure__uber_passenger_sexual_assault$q$,
  $q$Did you have the exposure/event listed for this case: Passenger used rideshare service and was assaulted, abused, or subjected to serious sexual misconduct by driver.$q$,
  'yes_no',
  '[]'::jsonb,
  $q$Passenger used rideshare service and was assaulted, abused, or subjected to serious sexual misconduct by driver.$q$,
  'case_specific',
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$confirm_injury_or_loss__uber_passenger_sexual_assault$q$,
  $q$Did you experience this injury/loss: Sexual assault, sexual battery, PTSD, emotional distress, physical injury, medical treatment, therapy, or police report.$q$,
  'yes_no',
  '[]'::jsonb,
  $q$Sexual assault, sexual battery, PTSD, emotional distress, physical injury, medical treatment, therapy, or police report.$q$,
  'case_specific',
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$records_available__uber_passenger_sexual_assault$q$,
  $q$Do you have any supporting records such as: Trip receipt, app records, screenshots, police report, medical/SANE exam, therapy records.$q$,
  'multi_select',
  '["Trip receipt","app records","screenshots","police report","medical/SANE exam","therapy records","Other / Not sure","I do not have records yet"]'::jsonb,
  $q$You can submit a claim without records — they just help speed up review.$q$,
  'case_specific',
  false
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  answer_options = EXCLUDED.answer_options,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$confirm_exposure__cartiva_synthetic_cartilage_implant$q$,
  $q$Did you have the exposure/event listed for this case: Received Cartiva synthetic cartilage implant, usually for big toe arthritis/hallux rigidus.$q$,
  'yes_no',
  '[]'::jsonb,
  $q$Received Cartiva synthetic cartilage implant, usually for big toe arthritis/hallux rigidus.$q$,
  'case_specific',
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$confirm_injury_or_loss__cartiva_synthetic_cartilage_implant$q$,
  $q$Did you experience this injury/loss: Persistent/worsening pain, implant failure, subsidence, loosening, revision surgery, fusion, or removal.$q$,
  'yes_no',
  '[]'::jsonb,
  $q$Persistent/worsening pain, implant failure, subsidence, loosening, revision surgery, fusion, or removal.$q$,
  'case_specific',
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$records_available__cartiva_synthetic_cartilage_implant$q$,
  $q$Do you have any supporting records such as: Operative report, implant record, imaging, orthopedic notes, revision/fusion records.$q$,
  'multi_select',
  '["Operative report","implant record","imaging","orthopedic notes","revision/fusion records","Other / Not sure","I do not have records yet"]'::jsonb,
  $q$You can submit a claim without records — they just help speed up review.$q$,
  'case_specific',
  false
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  answer_options = EXCLUDED.answer_options,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$confirm_exposure__gardasil_autoimmune_neuro_injury$q$,
  $q$Did you have the exposure/event listed for this case: Received Gardasil HPV vaccine before onset of symptoms.$q$,
  'yes_no',
  '[]'::jsonb,
  $q$Received Gardasil HPV vaccine before onset of symptoms.$q$,
  'case_specific',
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$confirm_injury_or_loss__gardasil_autoimmune_neuro_injury$q$,
  $q$Did you experience this injury/loss: POTS, autoimmune disorder, chronic neurologic symptoms, fainting, chronic pain, fatigue syndrome-like injury, or other serious diagnosed condition.$q$,
  'yes_no',
  '[]'::jsonb,
  $q$POTS, autoimmune disorder, chronic neurologic symptoms, fainting, chronic pain, fatigue syndrome-like injury, or other serious diagnosed condition.$q$,
  'case_specific',
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$records_available__gardasil_autoimmune_neuro_injury$q$,
  $q$Do you have any supporting records such as: Immunization records, medical diagnosis records, specialist notes, ER/hospital records.$q$,
  'multi_select',
  '["Immunization records","medical diagnosis records","specialist notes","ER/hospital records","Other / Not sure","I do not have records yet"]'::jsonb,
  $q$You can submit a claim without records — they just help speed up review.$q$,
  'case_specific',
  false
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  answer_options = EXCLUDED.answer_options,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$confirm_exposure__allergan_biocell_bia_alcl$q$,
  $q$Did you have the exposure/event listed for this case: Received textured breast implants or tissue expanders, especially Allergan BIOCELL textured products.$q$,
  'yes_no',
  '[]'::jsonb,
  $q$Received textured breast implants or tissue expanders, especially Allergan BIOCELL textured products.$q$,
  'case_specific',
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$confirm_injury_or_loss__allergan_biocell_bia_alcl$q$,
  $q$Did you experience this injury/loss: Breast implant-associated anaplastic large cell lymphoma (BIA-ALCL), seroma, swelling, mass, implant removal, chemotherapy/radiation.$q$,
  'yes_no',
  '[]'::jsonb,
  $q$Breast implant-associated anaplastic large cell lymphoma (BIA-ALCL), seroma, swelling, mass, implant removal, chemotherapy/radiation.$q$,
  'case_specific',
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$records_available__allergan_biocell_bia_alcl$q$,
  $q$Do you have any supporting records such as: Implant card, operative report, pathology, oncology records, explant records.$q$,
  'multi_select',
  '["Implant card","operative report","pathology","oncology records","explant records","Other / Not sure","I do not have records yet"]'::jsonb,
  $q$You can submit a claim without records — they just help speed up review.$q$,
  'case_specific',
  false
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  answer_options = EXCLUDED.answer_options,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$confirm_exposure__krispy_kreme_data_breach$q$,
  $q$Did you have the exposure/event listed for this case: Received notice that personal information was potentially affected by the data incident.$q$,
  'yes_no',
  '[]'::jsonb,
  $q$Received notice that personal information was potentially affected by the data incident.$q$,
  'case_specific',
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$confirm_injury_or_loss__krispy_kreme_data_breach$q$,
  $q$Did you experience this injury/loss: Documented fraud/identity-theft losses, out-of-pocket expenses, time spent, or eligibility for alternative cash payment/credit monitoring depending on claim rules.$q$,
  'yes_no',
  '[]'::jsonb,
  $q$Documented fraud/identity-theft losses, out-of-pocket expenses, time spent, or eligibility for alternative cash payment/credit monitoring depending on claim rules.$q$,
  'case_specific',
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$records_available__krispy_kreme_data_breach$q$,
  $q$Do you have any supporting records such as: Notice ID, proof of address/name, receipts, bank/credit statements, fraud reports, credit monitoring receipts.$q$,
  'multi_select',
  '["Notice ID","proof of address/name","receipts","bank/credit statements","fraud reports","credit monitoring receipts","Other / Not sure","I do not have records yet"]'::jsonb,
  $q$You can submit a claim without records — they just help speed up review.$q$,
  'case_specific',
  false
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  answer_options = EXCLUDED.answer_options,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$confirm_exposure__fidelity_data_breach$q$,
  $q$Did you have the exposure/event listed for this case: Received notice that personal information was involved in the August 2024 incident.$q$,
  'yes_no',
  '[]'::jsonb,
  $q$Received notice that personal information was involved in the August 2024 incident.$q$,
  'case_specific',
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$confirm_injury_or_loss__fidelity_data_breach$q$,
  $q$Did you experience this injury/loss: Documented monetary losses, out-of-pocket expenses, lost time, CCPA-related payment if applicable, or pro rata cash payment under settlement terms.$q$,
  'yes_no',
  '[]'::jsonb,
  $q$Documented monetary losses, out-of-pocket expenses, lost time, CCPA-related payment if applicable, or pro rata cash payment under settlement terms.$q$,
  'case_specific',
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$records_available__fidelity_data_breach$q$,
  $q$Do you have any supporting records such as: Notice ID, claim form, receipts, credit monitoring costs, fraud/identity theft documentation, bank/credit reports.$q$,
  'multi_select',
  '["Notice ID","claim form","receipts","credit monitoring costs","fraud/identity theft documentation","bank/credit reports","Other / Not sure","I do not have records yet"]'::jsonb,
  $q$You can submit a claim without records — they just help speed up review.$q$,
  'case_specific',
  false
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  answer_options = EXCLUDED.answer_options,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$confirm_exposure__alera_group_data_breach$q$,
  $q$Did you have the exposure/event listed for this case: Received notice that personal information was potentially compromised.$q$,
  'yes_no',
  '[]'::jsonb,
  $q$Received notice that personal information was potentially compromised.$q$,
  'case_specific',
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$confirm_injury_or_loss__alera_group_data_breach$q$,
  $q$Did you experience this injury/loss: Documented out-of-pocket losses, fraud/identity theft, credit monitoring costs, lost time, or alternative cash payment under terms.$q$,
  'yes_no',
  '[]'::jsonb,
  $q$Documented out-of-pocket losses, fraud/identity theft, credit monitoring costs, lost time, or alternative cash payment under terms.$q$,
  'case_specific',
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$records_available__alera_group_data_breach$q$,
  $q$Do you have any supporting records such as: Notice ID, receipts, bank statements, credit reports, fraud reports, identity protection receipts.$q$,
  'multi_select',
  '["Notice ID","receipts","bank statements","credit reports","fraud reports","identity protection receipts","Other / Not sure","I do not have records yet"]'::jsonb,
  $q$You can submit a claim without records — they just help speed up review.$q$,
  'case_specific',
  false
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  answer_options = EXCLUDED.answer_options,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$confirm_exposure__consumer_beef_antitrust$q$,
  $q$Did you have the exposure/event listed for this case: Purchased covered fresh or frozen beef products for personal consumption during the class period.$q$,
  'yes_no',
  '[]'::jsonb,
  $q$Purchased covered fresh or frozen beef products for personal consumption during the class period.$q$,
  'case_specific',
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$confirm_injury_or_loss__consumer_beef_antitrust$q$,
  $q$Did you experience this injury/loss: Alleged overpayment from beef price-fixing; no personal injury required.$q$,
  'yes_no',
  '[]'::jsonb,
  $q$Alleged overpayment from beef price-fixing; no personal injury required.$q$,
  'case_specific',
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$records_available__consumer_beef_antitrust$q$,
  $q$Do you have any supporting records such as: Receipts helpful if available, but claim rules may not require itemized proof for all claimants; authority docs if filing for someone else.$q$,
  'multi_select',
  '["Receipts helpful if available","Other / Not sure","I do not have records yet"]'::jsonb,
  $q$You can submit a claim without records — they just help speed up review.$q$,
  'case_specific',
  false
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  answer_options = EXCLUDED.answer_options,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$confirm_exposure__metformin_ndma_antitrust_marketing$q$,
  $q$Did you have the exposure/event listed for this case: Purchased or paid for covered metformin-containing prescription drugs.$q$,
  'yes_no',
  '[]'::jsonb,
  $q$Purchased or paid for covered metformin-containing prescription drugs.$q$,
  'case_specific',
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$confirm_injury_or_loss__metformin_ndma_antitrust_marketing$q$,
  $q$Did you experience this injury/loss: Economic claim relating to alleged NDMA contamination/marketing practices; no physical injury required for settlement claim.$q$,
  'yes_no',
  '[]'::jsonb,
  $q$Economic claim relating to alleged NDMA contamination/marketing practices; no physical injury required for settlement claim.$q$,
  'case_specific',
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$records_available__metformin_ndma_antitrust_marketing$q$,
  $q$Do you have any supporting records such as: Pharmacy records, prescription records, receipts, insurance EOBs, payment records.$q$,
  'multi_select',
  '["Pharmacy records","prescription records","receipts","insurance EOBs","payment records","Other / Not sure","I do not have records yet"]'::jsonb,
  $q$You can submit a claim without records — they just help speed up review.$q$,
  'case_specific',
  false
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  answer_options = EXCLUDED.answer_options,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$confirm_exposure__hyundai_kia_airbag_acu$q$,
  $q$Did you have the exposure/event listed for this case: Owned or leased a covered vehicle with qualifying VIN/model.$q$,
  'yes_no',
  '[]'::jsonb,
  $q$Owned or leased a covered vehicle with qualifying VIN/model.$q$,
  'case_specific',
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$confirm_injury_or_loss__hyundai_kia_airbag_acu$q$,
  $q$Did you experience this injury/loss: Economic loss/out-of-pocket expenses, recall-related costs, or settlement benefit eligibility; no crash injury required for settlement benefits.$q$,
  'yes_no',
  '[]'::jsonb,
  $q$Economic loss/out-of-pocket expenses, recall-related costs, or settlement benefit eligibility; no crash injury required for settlement benefits.$q$,
  'case_specific',
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$records_available__hyundai_kia_airbag_acu$q$,
  $q$Do you have any supporting records such as: VIN, registration/title, lease/sale documents, repair receipts, towing/rental/out-of-pocket records.$q$,
  'multi_select',
  '["VIN","registration/title","lease/sale documents","repair receipts","towing/rental/out-of-pocket records","Other / Not sure","I do not have records yet"]'::jsonb,
  $q$You can submit a claim without records — they just help speed up review.$q$,
  'case_specific',
  false
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  answer_options = EXCLUDED.answer_options,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$confirm_exposure__fca_hourly_wage_hour$q$,
  $q$Did you have the exposure/event listed for this case: Worked as hourly production employee for FCA US during the class period.$q$,
  'yes_no',
  '[]'::jsonb,
  $q$Worked as hourly production employee for FCA US during the class period.$q$,
  'case_specific',
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$confirm_injury_or_loss__fca_hourly_wage_hour$q$,
  $q$Did you experience this injury/loss: Alleged wage/hour or employment-related loss; no physical injury required.$q$,
  'yes_no',
  '[]'::jsonb,
  $q$Alleged wage/hour or employment-related loss; no physical injury required.$q$,
  'case_specific',
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$records_available__fca_hourly_wage_hour$q$,
  $q$Do you have any supporting records such as: Employment records, paystubs, W-2s, notice ID, dates worked.$q$,
  'multi_select',
  '["Employment records","paystubs","W-2s","notice ID","dates worked","Other / Not sure","I do not have records yet"]'::jsonb,
  $q$You can submit a claim without records — they just help speed up review.$q$,
  'case_specific',
  false
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  answer_options = EXCLUDED.answer_options,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$confirm_exposure__tinder_age_discrimination_subscription$q$,
  $q$Did you have the exposure/event listed for this case: Paid for Tinder Plus or Gold during applicable class period and age group covered by settlement.$q$,
  'yes_no',
  '[]'::jsonb,
  $q$Paid for Tinder Plus or Gold during applicable class period and age group covered by settlement.$q$,
  'case_specific',
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$confirm_injury_or_loss__tinder_age_discrimination_subscription$q$,
  $q$Did you experience this injury/loss: Economic overpayment/subscription charge; no physical injury required.$q$,
  'yes_no',
  '[]'::jsonb,
  $q$Economic overpayment/subscription charge; no physical injury required.$q$,
  'case_specific',
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$records_available__tinder_age_discrimination_subscription$q$,
  $q$Do you have any supporting records such as: Account email/phone, subscription receipts, app store purchase history, payment records.$q$,
  'multi_select',
  '["Account email/phone","subscription receipts","app store purchase history","payment records","Other / Not sure","I do not have records yet"]'::jsonb,
  $q$You can submit a claim without records — they just help speed up review.$q$,
  'case_specific',
  false
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  answer_options = EXCLUDED.answer_options,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$confirm_exposure__comcast_cable_data_breach$q$,
  $q$Did you have the exposure/event listed for this case: Received notification of the data breach.$q$,
  'yes_no',
  '[]'::jsonb,
  $q$Received notification of the data breach.$q$,
  'case_specific',
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$confirm_injury_or_loss__comcast_cable_data_breach$q$,
  $q$Did you experience this injury/loss: Potential documented losses, time spent, credit monitoring/identity theft impacts depending on final claim benefits.$q$,
  'yes_no',
  '[]'::jsonb,
  $q$Potential documented losses, time spent, credit monitoring/identity theft impacts depending on final claim benefits.$q$,
  'case_specific',
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$records_available__comcast_cable_data_breach$q$,
  $q$Do you have any supporting records such as: Notice ID, claim form, fraud/loss receipts, credit monitoring docs, bank/credit records.$q$,
  'multi_select',
  '["Notice ID","claim form","fraud/loss receipts","credit monitoring docs","bank/credit records","Other / Not sure","I do not have records yet"]'::jsonb,
  $q$You can submit a claim without records — they just help speed up review.$q$,
  'case_specific',
  false
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  answer_options = EXCLUDED.answer_options,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$confirm_exposure__mylan_securities_settlement$q$,
  $q$Did you have the exposure/event listed for this case: Purchased/acquired covered securities during the class period.$q$,
  'yes_no',
  '[]'::jsonb,
  $q$Purchased/acquired covered securities during the class period.$q$,
  'case_specific',
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$confirm_injury_or_loss__mylan_securities_settlement$q$,
  $q$Did you experience this injury/loss: Investment loss tied to alleged securities-law violations.$q$,
  'yes_no',
  '[]'::jsonb,
  $q$Investment loss tied to alleged securities-law violations.$q$,
  'case_specific',
  true
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  help_text = EXCLUDED.help_text,
  updated_at = now();

INSERT INTO public.questions (
  field_key, question_text, question_type, answer_options, help_text, category, required
) VALUES (
  $q$records_available__mylan_securities_settlement$q$,
  $q$Do you have any supporting records such as: Brokerage statements, trade confirmations, account records, tax lots.$q$,
  'multi_select',
  '["Brokerage statements","trade confirmations","account records","tax lots","Other / Not sure","I do not have records yet"]'::jsonb,
  $q$You can submit a claim without records — they just help speed up review.$q$,
  'case_specific',
  false
)
ON CONFLICT (field_key) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  answer_options = EXCLUDED.answer_options,
  help_text = EXCLUDED.help_text,
  updated_at = now();


-- ----- 5. Wire each case to its 8 questions in the documented order -----
INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 1, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$depo-provera-meningioma$q$ AND q.field_key = $q$confirm_exposure__depo_provera_meningioma$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 2, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$depo-provera-meningioma$q$ AND q.field_key = $q$exposure_timing$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 3, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$depo-provera-meningioma$q$ AND q.field_key = $q$confirm_injury_or_loss__depo_provera_meningioma$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 4, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$depo-provera-meningioma$q$ AND q.field_key = $q$date_exposure$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 5, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$depo-provera-meningioma$q$ AND q.field_key = $q$date_injury_loss$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 6, false
FROM public.cases c, public.questions q
WHERE c.slug = $q$depo-provera-meningioma$q$ AND q.field_key = $q$records_available__depo_provera_meningioma$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 7, false
FROM public.cases c, public.questions q
WHERE c.slug = $q$depo-provera-meningioma$q$ AND q.field_key = $q$state_of_event$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 8, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$depo-provera-meningioma$q$ AND q.field_key = $q$contact_permission$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 1, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$afff-firefighting-foam-cancer$q$ AND q.field_key = $q$confirm_exposure__afff_firefighting_foam_cancer$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 2, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$afff-firefighting-foam-cancer$q$ AND q.field_key = $q$exposure_timing$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 3, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$afff-firefighting-foam-cancer$q$ AND q.field_key = $q$confirm_injury_or_loss__afff_firefighting_foam_cancer$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 4, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$afff-firefighting-foam-cancer$q$ AND q.field_key = $q$date_exposure$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 5, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$afff-firefighting-foam-cancer$q$ AND q.field_key = $q$date_injury_loss$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 6, false
FROM public.cases c, public.questions q
WHERE c.slug = $q$afff-firefighting-foam-cancer$q$ AND q.field_key = $q$records_available__afff_firefighting_foam_cancer$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 7, false
FROM public.cases c, public.questions q
WHERE c.slug = $q$afff-firefighting-foam-cancer$q$ AND q.field_key = $q$state_of_event$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 8, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$afff-firefighting-foam-cancer$q$ AND q.field_key = $q$contact_permission$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 1, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$hair-relaxer-cancer$q$ AND q.field_key = $q$confirm_exposure__hair_relaxer_cancer$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 2, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$hair-relaxer-cancer$q$ AND q.field_key = $q$exposure_timing$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 3, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$hair-relaxer-cancer$q$ AND q.field_key = $q$confirm_injury_or_loss__hair_relaxer_cancer$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 4, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$hair-relaxer-cancer$q$ AND q.field_key = $q$date_exposure$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 5, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$hair-relaxer-cancer$q$ AND q.field_key = $q$date_injury_loss$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 6, false
FROM public.cases c, public.questions q
WHERE c.slug = $q$hair-relaxer-cancer$q$ AND q.field_key = $q$records_available__hair_relaxer_cancer$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 7, false
FROM public.cases c, public.questions q
WHERE c.slug = $q$hair-relaxer-cancer$q$ AND q.field_key = $q$state_of_event$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 8, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$hair-relaxer-cancer$q$ AND q.field_key = $q$contact_permission$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 1, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$paraquat-parkinsons$q$ AND q.field_key = $q$confirm_exposure__paraquat_parkinsons$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 2, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$paraquat-parkinsons$q$ AND q.field_key = $q$exposure_timing$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 3, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$paraquat-parkinsons$q$ AND q.field_key = $q$confirm_injury_or_loss__paraquat_parkinsons$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 4, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$paraquat-parkinsons$q$ AND q.field_key = $q$date_exposure$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 5, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$paraquat-parkinsons$q$ AND q.field_key = $q$date_injury_loss$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 6, false
FROM public.cases c, public.questions q
WHERE c.slug = $q$paraquat-parkinsons$q$ AND q.field_key = $q$records_available__paraquat_parkinsons$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 7, false
FROM public.cases c, public.questions q
WHERE c.slug = $q$paraquat-parkinsons$q$ AND q.field_key = $q$state_of_event$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 8, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$paraquat-parkinsons$q$ AND q.field_key = $q$contact_permission$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 1, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$glp1-gastrointestinal-injury$q$ AND q.field_key = $q$confirm_exposure__glp1_gastrointestinal_injury$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 2, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$glp1-gastrointestinal-injury$q$ AND q.field_key = $q$exposure_timing$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 3, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$glp1-gastrointestinal-injury$q$ AND q.field_key = $q$confirm_injury_or_loss__glp1_gastrointestinal_injury$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 4, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$glp1-gastrointestinal-injury$q$ AND q.field_key = $q$date_exposure$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 5, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$glp1-gastrointestinal-injury$q$ AND q.field_key = $q$date_injury_loss$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 6, false
FROM public.cases c, public.questions q
WHERE c.slug = $q$glp1-gastrointestinal-injury$q$ AND q.field_key = $q$records_available__glp1_gastrointestinal_injury$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 7, false
FROM public.cases c, public.questions q
WHERE c.slug = $q$glp1-gastrointestinal-injury$q$ AND q.field_key = $q$state_of_event$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 8, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$glp1-gastrointestinal-injury$q$ AND q.field_key = $q$contact_permission$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 1, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$glp1-naion-vision-loss$q$ AND q.field_key = $q$confirm_exposure__glp1_naion_vision_loss$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 2, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$glp1-naion-vision-loss$q$ AND q.field_key = $q$exposure_timing$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 3, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$glp1-naion-vision-loss$q$ AND q.field_key = $q$confirm_injury_or_loss__glp1_naion_vision_loss$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 4, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$glp1-naion-vision-loss$q$ AND q.field_key = $q$date_exposure$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 5, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$glp1-naion-vision-loss$q$ AND q.field_key = $q$date_injury_loss$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 6, false
FROM public.cases c, public.questions q
WHERE c.slug = $q$glp1-naion-vision-loss$q$ AND q.field_key = $q$records_available__glp1_naion_vision_loss$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 7, false
FROM public.cases c, public.questions q
WHERE c.slug = $q$glp1-naion-vision-loss$q$ AND q.field_key = $q$state_of_event$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 8, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$glp1-naion-vision-loss$q$ AND q.field_key = $q$contact_permission$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 1, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$suboxone-dental-injury$q$ AND q.field_key = $q$confirm_exposure__suboxone_dental_injury$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 2, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$suboxone-dental-injury$q$ AND q.field_key = $q$exposure_timing$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 3, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$suboxone-dental-injury$q$ AND q.field_key = $q$confirm_injury_or_loss__suboxone_dental_injury$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 4, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$suboxone-dental-injury$q$ AND q.field_key = $q$date_exposure$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 5, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$suboxone-dental-injury$q$ AND q.field_key = $q$date_injury_loss$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 6, false
FROM public.cases c, public.questions q
WHERE c.slug = $q$suboxone-dental-injury$q$ AND q.field_key = $q$records_available__suboxone_dental_injury$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 7, false
FROM public.cases c, public.questions q
WHERE c.slug = $q$suboxone-dental-injury$q$ AND q.field_key = $q$state_of_event$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 8, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$suboxone-dental-injury$q$ AND q.field_key = $q$contact_permission$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 1, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$bard-powerport-injury$q$ AND q.field_key = $q$confirm_exposure__bard_powerport_injury$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 2, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$bard-powerport-injury$q$ AND q.field_key = $q$exposure_timing$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 3, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$bard-powerport-injury$q$ AND q.field_key = $q$confirm_injury_or_loss__bard_powerport_injury$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 4, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$bard-powerport-injury$q$ AND q.field_key = $q$date_exposure$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 5, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$bard-powerport-injury$q$ AND q.field_key = $q$date_injury_loss$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 6, false
FROM public.cases c, public.questions q
WHERE c.slug = $q$bard-powerport-injury$q$ AND q.field_key = $q$records_available__bard_powerport_injury$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 7, false
FROM public.cases c, public.questions q
WHERE c.slug = $q$bard-powerport-injury$q$ AND q.field_key = $q$state_of_event$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 8, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$bard-powerport-injury$q$ AND q.field_key = $q$contact_permission$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 1, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$tepezza-hearing-loss$q$ AND q.field_key = $q$confirm_exposure__tepezza_hearing_loss$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 2, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$tepezza-hearing-loss$q$ AND q.field_key = $q$exposure_timing$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 3, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$tepezza-hearing-loss$q$ AND q.field_key = $q$confirm_injury_or_loss__tepezza_hearing_loss$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 4, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$tepezza-hearing-loss$q$ AND q.field_key = $q$date_exposure$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 5, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$tepezza-hearing-loss$q$ AND q.field_key = $q$date_injury_loss$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 6, false
FROM public.cases c, public.questions q
WHERE c.slug = $q$tepezza-hearing-loss$q$ AND q.field_key = $q$records_available__tepezza_hearing_loss$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 7, false
FROM public.cases c, public.questions q
WHERE c.slug = $q$tepezza-hearing-loss$q$ AND q.field_key = $q$state_of_event$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 8, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$tepezza-hearing-loss$q$ AND q.field_key = $q$contact_permission$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 1, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$philips-cpap-recall-injury$q$ AND q.field_key = $q$confirm_exposure__philips_cpap_recall_injury$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 2, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$philips-cpap-recall-injury$q$ AND q.field_key = $q$exposure_timing$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 3, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$philips-cpap-recall-injury$q$ AND q.field_key = $q$confirm_injury_or_loss__philips_cpap_recall_injury$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 4, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$philips-cpap-recall-injury$q$ AND q.field_key = $q$date_exposure$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 5, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$philips-cpap-recall-injury$q$ AND q.field_key = $q$date_injury_loss$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 6, false
FROM public.cases c, public.questions q
WHERE c.slug = $q$philips-cpap-recall-injury$q$ AND q.field_key = $q$records_available__philips_cpap_recall_injury$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 7, false
FROM public.cases c, public.questions q
WHERE c.slug = $q$philips-cpap-recall-injury$q$ AND q.field_key = $q$state_of_event$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 8, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$philips-cpap-recall-injury$q$ AND q.field_key = $q$contact_permission$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 1, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$exactech-joint-replacement-failure$q$ AND q.field_key = $q$confirm_exposure__exactech_joint_replacement_failure$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 2, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$exactech-joint-replacement-failure$q$ AND q.field_key = $q$exposure_timing$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 3, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$exactech-joint-replacement-failure$q$ AND q.field_key = $q$confirm_injury_or_loss__exactech_joint_replacement_failure$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 4, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$exactech-joint-replacement-failure$q$ AND q.field_key = $q$date_exposure$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 5, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$exactech-joint-replacement-failure$q$ AND q.field_key = $q$date_injury_loss$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 6, false
FROM public.cases c, public.questions q
WHERE c.slug = $q$exactech-joint-replacement-failure$q$ AND q.field_key = $q$records_available__exactech_joint_replacement_failure$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 7, false
FROM public.cases c, public.questions q
WHERE c.slug = $q$exactech-joint-replacement-failure$q$ AND q.field_key = $q$state_of_event$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 8, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$exactech-joint-replacement-failure$q$ AND q.field_key = $q$contact_permission$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 1, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$paragard-iud-breakage$q$ AND q.field_key = $q$confirm_exposure__paragard_iud_breakage$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 2, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$paragard-iud-breakage$q$ AND q.field_key = $q$exposure_timing$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 3, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$paragard-iud-breakage$q$ AND q.field_key = $q$confirm_injury_or_loss__paragard_iud_breakage$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 4, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$paragard-iud-breakage$q$ AND q.field_key = $q$date_exposure$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 5, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$paragard-iud-breakage$q$ AND q.field_key = $q$date_injury_loss$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 6, false
FROM public.cases c, public.questions q
WHERE c.slug = $q$paragard-iud-breakage$q$ AND q.field_key = $q$records_available__paragard_iud_breakage$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 7, false
FROM public.cases c, public.questions q
WHERE c.slug = $q$paragard-iud-breakage$q$ AND q.field_key = $q$state_of_event$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 8, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$paragard-iud-breakage$q$ AND q.field_key = $q$contact_permission$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 1, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$talcum-powder-ovarian-cancer-mesothelioma$q$ AND q.field_key = $q$confirm_exposure__talcum_powder_ovarian_cancer_mesothelioma$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 2, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$talcum-powder-ovarian-cancer-mesothelioma$q$ AND q.field_key = $q$exposure_timing$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 3, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$talcum-powder-ovarian-cancer-mesothelioma$q$ AND q.field_key = $q$confirm_injury_or_loss__talcum_powder_ovarian_cancer_mesothelioma$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 4, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$talcum-powder-ovarian-cancer-mesothelioma$q$ AND q.field_key = $q$date_exposure$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 5, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$talcum-powder-ovarian-cancer-mesothelioma$q$ AND q.field_key = $q$date_injury_loss$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 6, false
FROM public.cases c, public.questions q
WHERE c.slug = $q$talcum-powder-ovarian-cancer-mesothelioma$q$ AND q.field_key = $q$records_available__talcum_powder_ovarian_cancer_mesothelioma$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 7, false
FROM public.cases c, public.questions q
WHERE c.slug = $q$talcum-powder-ovarian-cancer-mesothelioma$q$ AND q.field_key = $q$state_of_event$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 8, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$talcum-powder-ovarian-cancer-mesothelioma$q$ AND q.field_key = $q$contact_permission$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 1, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$nec-premature-infant-formula$q$ AND q.field_key = $q$confirm_exposure__nec_premature_infant_formula$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 2, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$nec-premature-infant-formula$q$ AND q.field_key = $q$exposure_timing$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 3, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$nec-premature-infant-formula$q$ AND q.field_key = $q$confirm_injury_or_loss__nec_premature_infant_formula$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 4, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$nec-premature-infant-formula$q$ AND q.field_key = $q$date_exposure$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 5, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$nec-premature-infant-formula$q$ AND q.field_key = $q$date_injury_loss$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 6, false
FROM public.cases c, public.questions q
WHERE c.slug = $q$nec-premature-infant-formula$q$ AND q.field_key = $q$records_available__nec_premature_infant_formula$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 7, false
FROM public.cases c, public.questions q
WHERE c.slug = $q$nec-premature-infant-formula$q$ AND q.field_key = $q$state_of_event$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 8, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$nec-premature-infant-formula$q$ AND q.field_key = $q$contact_permission$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 1, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$social-media-minor-addiction-injury$q$ AND q.field_key = $q$confirm_exposure__social_media_minor_addiction_injury$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 2, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$social-media-minor-addiction-injury$q$ AND q.field_key = $q$exposure_timing$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 3, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$social-media-minor-addiction-injury$q$ AND q.field_key = $q$confirm_injury_or_loss__social_media_minor_addiction_injury$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 4, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$social-media-minor-addiction-injury$q$ AND q.field_key = $q$date_exposure$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 5, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$social-media-minor-addiction-injury$q$ AND q.field_key = $q$date_injury_loss$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 6, false
FROM public.cases c, public.questions q
WHERE c.slug = $q$social-media-minor-addiction-injury$q$ AND q.field_key = $q$records_available__social_media_minor_addiction_injury$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 7, false
FROM public.cases c, public.questions q
WHERE c.slug = $q$social-media-minor-addiction-injury$q$ AND q.field_key = $q$state_of_event$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 8, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$social-media-minor-addiction-injury$q$ AND q.field_key = $q$contact_permission$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 1, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$baby-food-heavy-metals-neurodevelopment$q$ AND q.field_key = $q$confirm_exposure__baby_food_heavy_metals_neurodevelopment$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 2, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$baby-food-heavy-metals-neurodevelopment$q$ AND q.field_key = $q$exposure_timing$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 3, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$baby-food-heavy-metals-neurodevelopment$q$ AND q.field_key = $q$confirm_injury_or_loss__baby_food_heavy_metals_neurodevelopment$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 4, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$baby-food-heavy-metals-neurodevelopment$q$ AND q.field_key = $q$date_exposure$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 5, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$baby-food-heavy-metals-neurodevelopment$q$ AND q.field_key = $q$date_injury_loss$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 6, false
FROM public.cases c, public.questions q
WHERE c.slug = $q$baby-food-heavy-metals-neurodevelopment$q$ AND q.field_key = $q$records_available__baby_food_heavy_metals_neurodevelopment$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 7, false
FROM public.cases c, public.questions q
WHERE c.slug = $q$baby-food-heavy-metals-neurodevelopment$q$ AND q.field_key = $q$state_of_event$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 8, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$baby-food-heavy-metals-neurodevelopment$q$ AND q.field_key = $q$contact_permission$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 1, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$uber-passenger-sexual-assault$q$ AND q.field_key = $q$confirm_exposure__uber_passenger_sexual_assault$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 2, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$uber-passenger-sexual-assault$q$ AND q.field_key = $q$exposure_timing$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 3, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$uber-passenger-sexual-assault$q$ AND q.field_key = $q$confirm_injury_or_loss__uber_passenger_sexual_assault$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 4, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$uber-passenger-sexual-assault$q$ AND q.field_key = $q$date_exposure$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 5, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$uber-passenger-sexual-assault$q$ AND q.field_key = $q$date_injury_loss$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 6, false
FROM public.cases c, public.questions q
WHERE c.slug = $q$uber-passenger-sexual-assault$q$ AND q.field_key = $q$records_available__uber_passenger_sexual_assault$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 7, false
FROM public.cases c, public.questions q
WHERE c.slug = $q$uber-passenger-sexual-assault$q$ AND q.field_key = $q$state_of_event$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 8, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$uber-passenger-sexual-assault$q$ AND q.field_key = $q$contact_permission$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 1, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$cartiva-synthetic-cartilage-implant$q$ AND q.field_key = $q$confirm_exposure__cartiva_synthetic_cartilage_implant$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 2, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$cartiva-synthetic-cartilage-implant$q$ AND q.field_key = $q$exposure_timing$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 3, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$cartiva-synthetic-cartilage-implant$q$ AND q.field_key = $q$confirm_injury_or_loss__cartiva_synthetic_cartilage_implant$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 4, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$cartiva-synthetic-cartilage-implant$q$ AND q.field_key = $q$date_exposure$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 5, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$cartiva-synthetic-cartilage-implant$q$ AND q.field_key = $q$date_injury_loss$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 6, false
FROM public.cases c, public.questions q
WHERE c.slug = $q$cartiva-synthetic-cartilage-implant$q$ AND q.field_key = $q$records_available__cartiva_synthetic_cartilage_implant$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 7, false
FROM public.cases c, public.questions q
WHERE c.slug = $q$cartiva-synthetic-cartilage-implant$q$ AND q.field_key = $q$state_of_event$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 8, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$cartiva-synthetic-cartilage-implant$q$ AND q.field_key = $q$contact_permission$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 1, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$gardasil-autoimmune-neuro-injury$q$ AND q.field_key = $q$confirm_exposure__gardasil_autoimmune_neuro_injury$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 2, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$gardasil-autoimmune-neuro-injury$q$ AND q.field_key = $q$exposure_timing$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 3, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$gardasil-autoimmune-neuro-injury$q$ AND q.field_key = $q$confirm_injury_or_loss__gardasil_autoimmune_neuro_injury$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 4, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$gardasil-autoimmune-neuro-injury$q$ AND q.field_key = $q$date_exposure$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 5, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$gardasil-autoimmune-neuro-injury$q$ AND q.field_key = $q$date_injury_loss$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 6, false
FROM public.cases c, public.questions q
WHERE c.slug = $q$gardasil-autoimmune-neuro-injury$q$ AND q.field_key = $q$records_available__gardasil_autoimmune_neuro_injury$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 7, false
FROM public.cases c, public.questions q
WHERE c.slug = $q$gardasil-autoimmune-neuro-injury$q$ AND q.field_key = $q$state_of_event$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 8, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$gardasil-autoimmune-neuro-injury$q$ AND q.field_key = $q$contact_permission$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 1, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$allergan-biocell-bia-alcl$q$ AND q.field_key = $q$confirm_exposure__allergan_biocell_bia_alcl$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 2, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$allergan-biocell-bia-alcl$q$ AND q.field_key = $q$exposure_timing$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 3, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$allergan-biocell-bia-alcl$q$ AND q.field_key = $q$confirm_injury_or_loss__allergan_biocell_bia_alcl$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 4, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$allergan-biocell-bia-alcl$q$ AND q.field_key = $q$date_exposure$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 5, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$allergan-biocell-bia-alcl$q$ AND q.field_key = $q$date_injury_loss$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 6, false
FROM public.cases c, public.questions q
WHERE c.slug = $q$allergan-biocell-bia-alcl$q$ AND q.field_key = $q$records_available__allergan_biocell_bia_alcl$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 7, false
FROM public.cases c, public.questions q
WHERE c.slug = $q$allergan-biocell-bia-alcl$q$ AND q.field_key = $q$state_of_event$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 8, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$allergan-biocell-bia-alcl$q$ AND q.field_key = $q$contact_permission$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 1, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$krispy-kreme-data-breach$q$ AND q.field_key = $q$confirm_exposure__krispy_kreme_data_breach$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 2, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$krispy-kreme-data-breach$q$ AND q.field_key = $q$exposure_timing$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 3, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$krispy-kreme-data-breach$q$ AND q.field_key = $q$confirm_injury_or_loss__krispy_kreme_data_breach$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 4, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$krispy-kreme-data-breach$q$ AND q.field_key = $q$date_exposure$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 5, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$krispy-kreme-data-breach$q$ AND q.field_key = $q$date_injury_loss$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 6, false
FROM public.cases c, public.questions q
WHERE c.slug = $q$krispy-kreme-data-breach$q$ AND q.field_key = $q$records_available__krispy_kreme_data_breach$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 7, false
FROM public.cases c, public.questions q
WHERE c.slug = $q$krispy-kreme-data-breach$q$ AND q.field_key = $q$state_of_event$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 8, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$krispy-kreme-data-breach$q$ AND q.field_key = $q$contact_permission$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 1, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$fidelity-data-breach$q$ AND q.field_key = $q$confirm_exposure__fidelity_data_breach$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 2, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$fidelity-data-breach$q$ AND q.field_key = $q$exposure_timing$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 3, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$fidelity-data-breach$q$ AND q.field_key = $q$confirm_injury_or_loss__fidelity_data_breach$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 4, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$fidelity-data-breach$q$ AND q.field_key = $q$date_exposure$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 5, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$fidelity-data-breach$q$ AND q.field_key = $q$date_injury_loss$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 6, false
FROM public.cases c, public.questions q
WHERE c.slug = $q$fidelity-data-breach$q$ AND q.field_key = $q$records_available__fidelity_data_breach$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 7, false
FROM public.cases c, public.questions q
WHERE c.slug = $q$fidelity-data-breach$q$ AND q.field_key = $q$state_of_event$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 8, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$fidelity-data-breach$q$ AND q.field_key = $q$contact_permission$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 1, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$alera-group-data-breach$q$ AND q.field_key = $q$confirm_exposure__alera_group_data_breach$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 2, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$alera-group-data-breach$q$ AND q.field_key = $q$exposure_timing$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 3, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$alera-group-data-breach$q$ AND q.field_key = $q$confirm_injury_or_loss__alera_group_data_breach$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 4, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$alera-group-data-breach$q$ AND q.field_key = $q$date_exposure$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 5, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$alera-group-data-breach$q$ AND q.field_key = $q$date_injury_loss$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 6, false
FROM public.cases c, public.questions q
WHERE c.slug = $q$alera-group-data-breach$q$ AND q.field_key = $q$records_available__alera_group_data_breach$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 7, false
FROM public.cases c, public.questions q
WHERE c.slug = $q$alera-group-data-breach$q$ AND q.field_key = $q$state_of_event$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 8, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$alera-group-data-breach$q$ AND q.field_key = $q$contact_permission$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 1, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$consumer-beef-antitrust$q$ AND q.field_key = $q$confirm_exposure__consumer_beef_antitrust$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 2, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$consumer-beef-antitrust$q$ AND q.field_key = $q$exposure_timing$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 3, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$consumer-beef-antitrust$q$ AND q.field_key = $q$confirm_injury_or_loss__consumer_beef_antitrust$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 4, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$consumer-beef-antitrust$q$ AND q.field_key = $q$date_exposure$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 5, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$consumer-beef-antitrust$q$ AND q.field_key = $q$date_injury_loss$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 6, false
FROM public.cases c, public.questions q
WHERE c.slug = $q$consumer-beef-antitrust$q$ AND q.field_key = $q$records_available__consumer_beef_antitrust$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 7, false
FROM public.cases c, public.questions q
WHERE c.slug = $q$consumer-beef-antitrust$q$ AND q.field_key = $q$state_of_event$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 8, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$consumer-beef-antitrust$q$ AND q.field_key = $q$contact_permission$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 1, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$metformin-ndma-antitrust-marketing$q$ AND q.field_key = $q$confirm_exposure__metformin_ndma_antitrust_marketing$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 2, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$metformin-ndma-antitrust-marketing$q$ AND q.field_key = $q$exposure_timing$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 3, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$metformin-ndma-antitrust-marketing$q$ AND q.field_key = $q$confirm_injury_or_loss__metformin_ndma_antitrust_marketing$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 4, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$metformin-ndma-antitrust-marketing$q$ AND q.field_key = $q$date_exposure$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 5, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$metformin-ndma-antitrust-marketing$q$ AND q.field_key = $q$date_injury_loss$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 6, false
FROM public.cases c, public.questions q
WHERE c.slug = $q$metformin-ndma-antitrust-marketing$q$ AND q.field_key = $q$records_available__metformin_ndma_antitrust_marketing$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 7, false
FROM public.cases c, public.questions q
WHERE c.slug = $q$metformin-ndma-antitrust-marketing$q$ AND q.field_key = $q$state_of_event$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 8, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$metformin-ndma-antitrust-marketing$q$ AND q.field_key = $q$contact_permission$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 1, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$hyundai-kia-airbag-acu$q$ AND q.field_key = $q$confirm_exposure__hyundai_kia_airbag_acu$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 2, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$hyundai-kia-airbag-acu$q$ AND q.field_key = $q$exposure_timing$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 3, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$hyundai-kia-airbag-acu$q$ AND q.field_key = $q$confirm_injury_or_loss__hyundai_kia_airbag_acu$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 4, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$hyundai-kia-airbag-acu$q$ AND q.field_key = $q$date_exposure$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 5, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$hyundai-kia-airbag-acu$q$ AND q.field_key = $q$date_injury_loss$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 6, false
FROM public.cases c, public.questions q
WHERE c.slug = $q$hyundai-kia-airbag-acu$q$ AND q.field_key = $q$records_available__hyundai_kia_airbag_acu$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 7, false
FROM public.cases c, public.questions q
WHERE c.slug = $q$hyundai-kia-airbag-acu$q$ AND q.field_key = $q$state_of_event$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 8, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$hyundai-kia-airbag-acu$q$ AND q.field_key = $q$contact_permission$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 1, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$fca-hourly-wage-hour$q$ AND q.field_key = $q$confirm_exposure__fca_hourly_wage_hour$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 2, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$fca-hourly-wage-hour$q$ AND q.field_key = $q$exposure_timing$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 3, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$fca-hourly-wage-hour$q$ AND q.field_key = $q$confirm_injury_or_loss__fca_hourly_wage_hour$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 4, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$fca-hourly-wage-hour$q$ AND q.field_key = $q$date_exposure$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 5, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$fca-hourly-wage-hour$q$ AND q.field_key = $q$date_injury_loss$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 6, false
FROM public.cases c, public.questions q
WHERE c.slug = $q$fca-hourly-wage-hour$q$ AND q.field_key = $q$records_available__fca_hourly_wage_hour$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 7, false
FROM public.cases c, public.questions q
WHERE c.slug = $q$fca-hourly-wage-hour$q$ AND q.field_key = $q$state_of_event$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 8, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$fca-hourly-wage-hour$q$ AND q.field_key = $q$contact_permission$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 1, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$tinder-age-discrimination-subscription$q$ AND q.field_key = $q$confirm_exposure__tinder_age_discrimination_subscription$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 2, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$tinder-age-discrimination-subscription$q$ AND q.field_key = $q$exposure_timing$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 3, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$tinder-age-discrimination-subscription$q$ AND q.field_key = $q$confirm_injury_or_loss__tinder_age_discrimination_subscription$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 4, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$tinder-age-discrimination-subscription$q$ AND q.field_key = $q$date_exposure$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 5, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$tinder-age-discrimination-subscription$q$ AND q.field_key = $q$date_injury_loss$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 6, false
FROM public.cases c, public.questions q
WHERE c.slug = $q$tinder-age-discrimination-subscription$q$ AND q.field_key = $q$records_available__tinder_age_discrimination_subscription$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 7, false
FROM public.cases c, public.questions q
WHERE c.slug = $q$tinder-age-discrimination-subscription$q$ AND q.field_key = $q$state_of_event$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 8, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$tinder-age-discrimination-subscription$q$ AND q.field_key = $q$contact_permission$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 1, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$comcast-cable-data-breach$q$ AND q.field_key = $q$confirm_exposure__comcast_cable_data_breach$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 2, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$comcast-cable-data-breach$q$ AND q.field_key = $q$exposure_timing$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 3, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$comcast-cable-data-breach$q$ AND q.field_key = $q$confirm_injury_or_loss__comcast_cable_data_breach$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 4, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$comcast-cable-data-breach$q$ AND q.field_key = $q$date_exposure$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 5, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$comcast-cable-data-breach$q$ AND q.field_key = $q$date_injury_loss$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 6, false
FROM public.cases c, public.questions q
WHERE c.slug = $q$comcast-cable-data-breach$q$ AND q.field_key = $q$records_available__comcast_cable_data_breach$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 7, false
FROM public.cases c, public.questions q
WHERE c.slug = $q$comcast-cable-data-breach$q$ AND q.field_key = $q$state_of_event$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 8, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$comcast-cable-data-breach$q$ AND q.field_key = $q$contact_permission$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 1, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$mylan-securities-settlement$q$ AND q.field_key = $q$confirm_exposure__mylan_securities_settlement$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 2, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$mylan-securities-settlement$q$ AND q.field_key = $q$exposure_timing$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 3, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$mylan-securities-settlement$q$ AND q.field_key = $q$confirm_injury_or_loss__mylan_securities_settlement$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 4, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$mylan-securities-settlement$q$ AND q.field_key = $q$date_exposure$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 5, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$mylan-securities-settlement$q$ AND q.field_key = $q$date_injury_loss$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 6, false
FROM public.cases c, public.questions q
WHERE c.slug = $q$mylan-securities-settlement$q$ AND q.field_key = $q$records_available__mylan_securities_settlement$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 7, false
FROM public.cases c, public.questions q
WHERE c.slug = $q$mylan-securities-settlement$q$ AND q.field_key = $q$state_of_event$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;

INSERT INTO public.case_questions (case_id, question_id, display_order, required_for_case)
SELECT c.id, q.id, 8, true
FROM public.cases c, public.questions q
WHERE c.slug = $q$mylan-securities-settlement$q$ AND q.field_key = $q$contact_permission$q$
ON CONFLICT (case_id, question_id) DO UPDATE SET
  display_order = EXCLUDED.display_order,
  required_for_case = EXCLUDED.required_for_case;


-- ----- 6. Matching rules — clear & rewrite all rules tagged [seed:2026-05-25] -----
DELETE FROM public.matching_rules
WHERE description LIKE $q$[seed:2026-05-25]%$q$
  AND case_id IN (
    SELECT id FROM public.cases WHERE slug IN (
      $q$depo-provera-meningioma$q$,
      $q$afff-firefighting-foam-cancer$q$,
      $q$hair-relaxer-cancer$q$,
      $q$paraquat-parkinsons$q$,
      $q$glp1-gastrointestinal-injury$q$,
      $q$glp1-naion-vision-loss$q$,
      $q$suboxone-dental-injury$q$,
      $q$bard-powerport-injury$q$,
      $q$tepezza-hearing-loss$q$,
      $q$philips-cpap-recall-injury$q$,
      $q$exactech-joint-replacement-failure$q$,
      $q$paragard-iud-breakage$q$,
      $q$talcum-powder-ovarian-cancer-mesothelioma$q$,
      $q$nec-premature-infant-formula$q$,
      $q$social-media-minor-addiction-injury$q$,
      $q$baby-food-heavy-metals-neurodevelopment$q$,
      $q$uber-passenger-sexual-assault$q$,
      $q$cartiva-synthetic-cartilage-implant$q$,
      $q$gardasil-autoimmune-neuro-injury$q$,
      $q$allergan-biocell-bia-alcl$q$,
      $q$krispy-kreme-data-breach$q$,
      $q$fidelity-data-breach$q$,
      $q$alera-group-data-breach$q$,
      $q$consumer-beef-antitrust$q$,
      $q$metformin-ndma-antitrust-marketing$q$,
      $q$hyundai-kia-airbag-acu$q$,
      $q$fca-hourly-wage-hour$q$,
      $q$tinder-age-discrimination-subscription$q$,
      $q$comcast-cable-data-breach$q$,
      $q$mylan-securities-settlement$q$
    )
  );

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_exposure__depo_provera_meningioma$q$, $q$equals$q$,
       $q$yes$q$, 30, false, $q$[seed:2026-05-25] Confirmed exposure → strong qualifier (+30)$q$
FROM public.cases c WHERE c.slug = $q$depo-provera-meningioma$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_exposure__depo_provera_meningioma$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] No qualifying exposure → not eligible$q$
FROM public.cases c WHERE c.slug = $q$depo-provera-meningioma$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_injury_or_loss__depo_provera_meningioma$q$, $q$equals$q$,
       $q$yes$q$, 30, false, $q$[seed:2026-05-25] Confirmed injury/loss → strong qualifier (+30)$q$
FROM public.cases c WHERE c.slug = $q$depo-provera-meningioma$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_injury_or_loss__depo_provera_meningioma$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] No qualifying injury/loss → not eligible$q$
FROM public.cases c WHERE c.slug = $q$depo-provera-meningioma$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$exposure_timing$q$, $q$equals$q$,
       $q$yes$q$, 20, false, $q$[seed:2026-05-25] Exposure preceded injury → causation signal (+20)$q$
FROM public.cases c WHERE c.slug = $q$depo-provera-meningioma$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$contact_permission$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] User declined attorney contact → not routable$q$
FROM public.cases c WHERE c.slug = $q$depo-provera-meningioma$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_exposure__afff_firefighting_foam_cancer$q$, $q$equals$q$,
       $q$yes$q$, 30, false, $q$[seed:2026-05-25] Confirmed exposure → strong qualifier (+30)$q$
FROM public.cases c WHERE c.slug = $q$afff-firefighting-foam-cancer$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_exposure__afff_firefighting_foam_cancer$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] No qualifying exposure → not eligible$q$
FROM public.cases c WHERE c.slug = $q$afff-firefighting-foam-cancer$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_injury_or_loss__afff_firefighting_foam_cancer$q$, $q$equals$q$,
       $q$yes$q$, 30, false, $q$[seed:2026-05-25] Confirmed injury/loss → strong qualifier (+30)$q$
FROM public.cases c WHERE c.slug = $q$afff-firefighting-foam-cancer$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_injury_or_loss__afff_firefighting_foam_cancer$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] No qualifying injury/loss → not eligible$q$
FROM public.cases c WHERE c.slug = $q$afff-firefighting-foam-cancer$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$exposure_timing$q$, $q$equals$q$,
       $q$yes$q$, 20, false, $q$[seed:2026-05-25] Exposure preceded injury → causation signal (+20)$q$
FROM public.cases c WHERE c.slug = $q$afff-firefighting-foam-cancer$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$contact_permission$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] User declined attorney contact → not routable$q$
FROM public.cases c WHERE c.slug = $q$afff-firefighting-foam-cancer$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_exposure__hair_relaxer_cancer$q$, $q$equals$q$,
       $q$yes$q$, 30, false, $q$[seed:2026-05-25] Confirmed exposure → strong qualifier (+30)$q$
FROM public.cases c WHERE c.slug = $q$hair-relaxer-cancer$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_exposure__hair_relaxer_cancer$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] No qualifying exposure → not eligible$q$
FROM public.cases c WHERE c.slug = $q$hair-relaxer-cancer$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_injury_or_loss__hair_relaxer_cancer$q$, $q$equals$q$,
       $q$yes$q$, 30, false, $q$[seed:2026-05-25] Confirmed injury/loss → strong qualifier (+30)$q$
FROM public.cases c WHERE c.slug = $q$hair-relaxer-cancer$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_injury_or_loss__hair_relaxer_cancer$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] No qualifying injury/loss → not eligible$q$
FROM public.cases c WHERE c.slug = $q$hair-relaxer-cancer$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$exposure_timing$q$, $q$equals$q$,
       $q$yes$q$, 20, false, $q$[seed:2026-05-25] Exposure preceded injury → causation signal (+20)$q$
FROM public.cases c WHERE c.slug = $q$hair-relaxer-cancer$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$contact_permission$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] User declined attorney contact → not routable$q$
FROM public.cases c WHERE c.slug = $q$hair-relaxer-cancer$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_exposure__paraquat_parkinsons$q$, $q$equals$q$,
       $q$yes$q$, 30, false, $q$[seed:2026-05-25] Confirmed exposure → strong qualifier (+30)$q$
FROM public.cases c WHERE c.slug = $q$paraquat-parkinsons$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_exposure__paraquat_parkinsons$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] No qualifying exposure → not eligible$q$
FROM public.cases c WHERE c.slug = $q$paraquat-parkinsons$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_injury_or_loss__paraquat_parkinsons$q$, $q$equals$q$,
       $q$yes$q$, 30, false, $q$[seed:2026-05-25] Confirmed injury/loss → strong qualifier (+30)$q$
FROM public.cases c WHERE c.slug = $q$paraquat-parkinsons$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_injury_or_loss__paraquat_parkinsons$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] No qualifying injury/loss → not eligible$q$
FROM public.cases c WHERE c.slug = $q$paraquat-parkinsons$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$exposure_timing$q$, $q$equals$q$,
       $q$yes$q$, 20, false, $q$[seed:2026-05-25] Exposure preceded injury → causation signal (+20)$q$
FROM public.cases c WHERE c.slug = $q$paraquat-parkinsons$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$contact_permission$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] User declined attorney contact → not routable$q$
FROM public.cases c WHERE c.slug = $q$paraquat-parkinsons$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_exposure__glp1_gastrointestinal_injury$q$, $q$equals$q$,
       $q$yes$q$, 30, false, $q$[seed:2026-05-25] Confirmed exposure → strong qualifier (+30)$q$
FROM public.cases c WHERE c.slug = $q$glp1-gastrointestinal-injury$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_exposure__glp1_gastrointestinal_injury$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] No qualifying exposure → not eligible$q$
FROM public.cases c WHERE c.slug = $q$glp1-gastrointestinal-injury$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_injury_or_loss__glp1_gastrointestinal_injury$q$, $q$equals$q$,
       $q$yes$q$, 30, false, $q$[seed:2026-05-25] Confirmed injury/loss → strong qualifier (+30)$q$
FROM public.cases c WHERE c.slug = $q$glp1-gastrointestinal-injury$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_injury_or_loss__glp1_gastrointestinal_injury$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] No qualifying injury/loss → not eligible$q$
FROM public.cases c WHERE c.slug = $q$glp1-gastrointestinal-injury$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$exposure_timing$q$, $q$equals$q$,
       $q$yes$q$, 20, false, $q$[seed:2026-05-25] Exposure preceded injury → causation signal (+20)$q$
FROM public.cases c WHERE c.slug = $q$glp1-gastrointestinal-injury$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$contact_permission$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] User declined attorney contact → not routable$q$
FROM public.cases c WHERE c.slug = $q$glp1-gastrointestinal-injury$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_exposure__glp1_naion_vision_loss$q$, $q$equals$q$,
       $q$yes$q$, 30, false, $q$[seed:2026-05-25] Confirmed exposure → strong qualifier (+30)$q$
FROM public.cases c WHERE c.slug = $q$glp1-naion-vision-loss$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_exposure__glp1_naion_vision_loss$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] No qualifying exposure → not eligible$q$
FROM public.cases c WHERE c.slug = $q$glp1-naion-vision-loss$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_injury_or_loss__glp1_naion_vision_loss$q$, $q$equals$q$,
       $q$yes$q$, 30, false, $q$[seed:2026-05-25] Confirmed injury/loss → strong qualifier (+30)$q$
FROM public.cases c WHERE c.slug = $q$glp1-naion-vision-loss$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_injury_or_loss__glp1_naion_vision_loss$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] No qualifying injury/loss → not eligible$q$
FROM public.cases c WHERE c.slug = $q$glp1-naion-vision-loss$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$exposure_timing$q$, $q$equals$q$,
       $q$yes$q$, 20, false, $q$[seed:2026-05-25] Exposure preceded injury → causation signal (+20)$q$
FROM public.cases c WHERE c.slug = $q$glp1-naion-vision-loss$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$contact_permission$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] User declined attorney contact → not routable$q$
FROM public.cases c WHERE c.slug = $q$glp1-naion-vision-loss$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_exposure__suboxone_dental_injury$q$, $q$equals$q$,
       $q$yes$q$, 30, false, $q$[seed:2026-05-25] Confirmed exposure → strong qualifier (+30)$q$
FROM public.cases c WHERE c.slug = $q$suboxone-dental-injury$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_exposure__suboxone_dental_injury$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] No qualifying exposure → not eligible$q$
FROM public.cases c WHERE c.slug = $q$suboxone-dental-injury$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_injury_or_loss__suboxone_dental_injury$q$, $q$equals$q$,
       $q$yes$q$, 30, false, $q$[seed:2026-05-25] Confirmed injury/loss → strong qualifier (+30)$q$
FROM public.cases c WHERE c.slug = $q$suboxone-dental-injury$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_injury_or_loss__suboxone_dental_injury$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] No qualifying injury/loss → not eligible$q$
FROM public.cases c WHERE c.slug = $q$suboxone-dental-injury$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$exposure_timing$q$, $q$equals$q$,
       $q$yes$q$, 20, false, $q$[seed:2026-05-25] Exposure preceded injury → causation signal (+20)$q$
FROM public.cases c WHERE c.slug = $q$suboxone-dental-injury$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$contact_permission$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] User declined attorney contact → not routable$q$
FROM public.cases c WHERE c.slug = $q$suboxone-dental-injury$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_exposure__bard_powerport_injury$q$, $q$equals$q$,
       $q$yes$q$, 30, false, $q$[seed:2026-05-25] Confirmed exposure → strong qualifier (+30)$q$
FROM public.cases c WHERE c.slug = $q$bard-powerport-injury$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_exposure__bard_powerport_injury$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] No qualifying exposure → not eligible$q$
FROM public.cases c WHERE c.slug = $q$bard-powerport-injury$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_injury_or_loss__bard_powerport_injury$q$, $q$equals$q$,
       $q$yes$q$, 30, false, $q$[seed:2026-05-25] Confirmed injury/loss → strong qualifier (+30)$q$
FROM public.cases c WHERE c.slug = $q$bard-powerport-injury$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_injury_or_loss__bard_powerport_injury$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] No qualifying injury/loss → not eligible$q$
FROM public.cases c WHERE c.slug = $q$bard-powerport-injury$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$exposure_timing$q$, $q$equals$q$,
       $q$yes$q$, 20, false, $q$[seed:2026-05-25] Exposure preceded injury → causation signal (+20)$q$
FROM public.cases c WHERE c.slug = $q$bard-powerport-injury$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$contact_permission$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] User declined attorney contact → not routable$q$
FROM public.cases c WHERE c.slug = $q$bard-powerport-injury$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_exposure__tepezza_hearing_loss$q$, $q$equals$q$,
       $q$yes$q$, 30, false, $q$[seed:2026-05-25] Confirmed exposure → strong qualifier (+30)$q$
FROM public.cases c WHERE c.slug = $q$tepezza-hearing-loss$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_exposure__tepezza_hearing_loss$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] No qualifying exposure → not eligible$q$
FROM public.cases c WHERE c.slug = $q$tepezza-hearing-loss$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_injury_or_loss__tepezza_hearing_loss$q$, $q$equals$q$,
       $q$yes$q$, 30, false, $q$[seed:2026-05-25] Confirmed injury/loss → strong qualifier (+30)$q$
FROM public.cases c WHERE c.slug = $q$tepezza-hearing-loss$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_injury_or_loss__tepezza_hearing_loss$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] No qualifying injury/loss → not eligible$q$
FROM public.cases c WHERE c.slug = $q$tepezza-hearing-loss$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$exposure_timing$q$, $q$equals$q$,
       $q$yes$q$, 20, false, $q$[seed:2026-05-25] Exposure preceded injury → causation signal (+20)$q$
FROM public.cases c WHERE c.slug = $q$tepezza-hearing-loss$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$contact_permission$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] User declined attorney contact → not routable$q$
FROM public.cases c WHERE c.slug = $q$tepezza-hearing-loss$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_exposure__philips_cpap_recall_injury$q$, $q$equals$q$,
       $q$yes$q$, 30, false, $q$[seed:2026-05-25] Confirmed exposure → strong qualifier (+30)$q$
FROM public.cases c WHERE c.slug = $q$philips-cpap-recall-injury$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_exposure__philips_cpap_recall_injury$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] No qualifying exposure → not eligible$q$
FROM public.cases c WHERE c.slug = $q$philips-cpap-recall-injury$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_injury_or_loss__philips_cpap_recall_injury$q$, $q$equals$q$,
       $q$yes$q$, 30, false, $q$[seed:2026-05-25] Confirmed injury/loss → strong qualifier (+30)$q$
FROM public.cases c WHERE c.slug = $q$philips-cpap-recall-injury$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_injury_or_loss__philips_cpap_recall_injury$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] No qualifying injury/loss → not eligible$q$
FROM public.cases c WHERE c.slug = $q$philips-cpap-recall-injury$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$exposure_timing$q$, $q$equals$q$,
       $q$yes$q$, 20, false, $q$[seed:2026-05-25] Exposure preceded injury → causation signal (+20)$q$
FROM public.cases c WHERE c.slug = $q$philips-cpap-recall-injury$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$contact_permission$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] User declined attorney contact → not routable$q$
FROM public.cases c WHERE c.slug = $q$philips-cpap-recall-injury$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_exposure__exactech_joint_replacement_failure$q$, $q$equals$q$,
       $q$yes$q$, 30, false, $q$[seed:2026-05-25] Confirmed exposure → strong qualifier (+30)$q$
FROM public.cases c WHERE c.slug = $q$exactech-joint-replacement-failure$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_exposure__exactech_joint_replacement_failure$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] No qualifying exposure → not eligible$q$
FROM public.cases c WHERE c.slug = $q$exactech-joint-replacement-failure$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_injury_or_loss__exactech_joint_replacement_failure$q$, $q$equals$q$,
       $q$yes$q$, 30, false, $q$[seed:2026-05-25] Confirmed injury/loss → strong qualifier (+30)$q$
FROM public.cases c WHERE c.slug = $q$exactech-joint-replacement-failure$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_injury_or_loss__exactech_joint_replacement_failure$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] No qualifying injury/loss → not eligible$q$
FROM public.cases c WHERE c.slug = $q$exactech-joint-replacement-failure$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$exposure_timing$q$, $q$equals$q$,
       $q$yes$q$, 20, false, $q$[seed:2026-05-25] Exposure preceded injury → causation signal (+20)$q$
FROM public.cases c WHERE c.slug = $q$exactech-joint-replacement-failure$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$contact_permission$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] User declined attorney contact → not routable$q$
FROM public.cases c WHERE c.slug = $q$exactech-joint-replacement-failure$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_exposure__paragard_iud_breakage$q$, $q$equals$q$,
       $q$yes$q$, 30, false, $q$[seed:2026-05-25] Confirmed exposure → strong qualifier (+30)$q$
FROM public.cases c WHERE c.slug = $q$paragard-iud-breakage$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_exposure__paragard_iud_breakage$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] No qualifying exposure → not eligible$q$
FROM public.cases c WHERE c.slug = $q$paragard-iud-breakage$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_injury_or_loss__paragard_iud_breakage$q$, $q$equals$q$,
       $q$yes$q$, 30, false, $q$[seed:2026-05-25] Confirmed injury/loss → strong qualifier (+30)$q$
FROM public.cases c WHERE c.slug = $q$paragard-iud-breakage$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_injury_or_loss__paragard_iud_breakage$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] No qualifying injury/loss → not eligible$q$
FROM public.cases c WHERE c.slug = $q$paragard-iud-breakage$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$exposure_timing$q$, $q$equals$q$,
       $q$yes$q$, 20, false, $q$[seed:2026-05-25] Exposure preceded injury → causation signal (+20)$q$
FROM public.cases c WHERE c.slug = $q$paragard-iud-breakage$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$contact_permission$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] User declined attorney contact → not routable$q$
FROM public.cases c WHERE c.slug = $q$paragard-iud-breakage$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_exposure__talcum_powder_ovarian_cancer_mesothelioma$q$, $q$equals$q$,
       $q$yes$q$, 30, false, $q$[seed:2026-05-25] Confirmed exposure → strong qualifier (+30)$q$
FROM public.cases c WHERE c.slug = $q$talcum-powder-ovarian-cancer-mesothelioma$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_exposure__talcum_powder_ovarian_cancer_mesothelioma$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] No qualifying exposure → not eligible$q$
FROM public.cases c WHERE c.slug = $q$talcum-powder-ovarian-cancer-mesothelioma$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_injury_or_loss__talcum_powder_ovarian_cancer_mesothelioma$q$, $q$equals$q$,
       $q$yes$q$, 30, false, $q$[seed:2026-05-25] Confirmed injury/loss → strong qualifier (+30)$q$
FROM public.cases c WHERE c.slug = $q$talcum-powder-ovarian-cancer-mesothelioma$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_injury_or_loss__talcum_powder_ovarian_cancer_mesothelioma$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] No qualifying injury/loss → not eligible$q$
FROM public.cases c WHERE c.slug = $q$talcum-powder-ovarian-cancer-mesothelioma$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$exposure_timing$q$, $q$equals$q$,
       $q$yes$q$, 20, false, $q$[seed:2026-05-25] Exposure preceded injury → causation signal (+20)$q$
FROM public.cases c WHERE c.slug = $q$talcum-powder-ovarian-cancer-mesothelioma$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$contact_permission$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] User declined attorney contact → not routable$q$
FROM public.cases c WHERE c.slug = $q$talcum-powder-ovarian-cancer-mesothelioma$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_exposure__nec_premature_infant_formula$q$, $q$equals$q$,
       $q$yes$q$, 30, false, $q$[seed:2026-05-25] Confirmed exposure → strong qualifier (+30)$q$
FROM public.cases c WHERE c.slug = $q$nec-premature-infant-formula$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_exposure__nec_premature_infant_formula$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] No qualifying exposure → not eligible$q$
FROM public.cases c WHERE c.slug = $q$nec-premature-infant-formula$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_injury_or_loss__nec_premature_infant_formula$q$, $q$equals$q$,
       $q$yes$q$, 30, false, $q$[seed:2026-05-25] Confirmed injury/loss → strong qualifier (+30)$q$
FROM public.cases c WHERE c.slug = $q$nec-premature-infant-formula$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_injury_or_loss__nec_premature_infant_formula$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] No qualifying injury/loss → not eligible$q$
FROM public.cases c WHERE c.slug = $q$nec-premature-infant-formula$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$exposure_timing$q$, $q$equals$q$,
       $q$yes$q$, 20, false, $q$[seed:2026-05-25] Exposure preceded injury → causation signal (+20)$q$
FROM public.cases c WHERE c.slug = $q$nec-premature-infant-formula$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$contact_permission$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] User declined attorney contact → not routable$q$
FROM public.cases c WHERE c.slug = $q$nec-premature-infant-formula$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_exposure__social_media_minor_addiction_injury$q$, $q$equals$q$,
       $q$yes$q$, 30, false, $q$[seed:2026-05-25] Confirmed exposure → strong qualifier (+30)$q$
FROM public.cases c WHERE c.slug = $q$social-media-minor-addiction-injury$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_exposure__social_media_minor_addiction_injury$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] No qualifying exposure → not eligible$q$
FROM public.cases c WHERE c.slug = $q$social-media-minor-addiction-injury$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_injury_or_loss__social_media_minor_addiction_injury$q$, $q$equals$q$,
       $q$yes$q$, 30, false, $q$[seed:2026-05-25] Confirmed injury/loss → strong qualifier (+30)$q$
FROM public.cases c WHERE c.slug = $q$social-media-minor-addiction-injury$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_injury_or_loss__social_media_minor_addiction_injury$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] No qualifying injury/loss → not eligible$q$
FROM public.cases c WHERE c.slug = $q$social-media-minor-addiction-injury$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$exposure_timing$q$, $q$equals$q$,
       $q$yes$q$, 20, false, $q$[seed:2026-05-25] Exposure preceded injury → causation signal (+20)$q$
FROM public.cases c WHERE c.slug = $q$social-media-minor-addiction-injury$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$contact_permission$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] User declined attorney contact → not routable$q$
FROM public.cases c WHERE c.slug = $q$social-media-minor-addiction-injury$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_exposure__baby_food_heavy_metals_neurodevelopment$q$, $q$equals$q$,
       $q$yes$q$, 30, false, $q$[seed:2026-05-25] Confirmed exposure → strong qualifier (+30)$q$
FROM public.cases c WHERE c.slug = $q$baby-food-heavy-metals-neurodevelopment$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_exposure__baby_food_heavy_metals_neurodevelopment$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] No qualifying exposure → not eligible$q$
FROM public.cases c WHERE c.slug = $q$baby-food-heavy-metals-neurodevelopment$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_injury_or_loss__baby_food_heavy_metals_neurodevelopment$q$, $q$equals$q$,
       $q$yes$q$, 30, false, $q$[seed:2026-05-25] Confirmed injury/loss → strong qualifier (+30)$q$
FROM public.cases c WHERE c.slug = $q$baby-food-heavy-metals-neurodevelopment$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_injury_or_loss__baby_food_heavy_metals_neurodevelopment$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] No qualifying injury/loss → not eligible$q$
FROM public.cases c WHERE c.slug = $q$baby-food-heavy-metals-neurodevelopment$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$exposure_timing$q$, $q$equals$q$,
       $q$yes$q$, 20, false, $q$[seed:2026-05-25] Exposure preceded injury → causation signal (+20)$q$
FROM public.cases c WHERE c.slug = $q$baby-food-heavy-metals-neurodevelopment$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$contact_permission$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] User declined attorney contact → not routable$q$
FROM public.cases c WHERE c.slug = $q$baby-food-heavy-metals-neurodevelopment$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_exposure__uber_passenger_sexual_assault$q$, $q$equals$q$,
       $q$yes$q$, 30, false, $q$[seed:2026-05-25] Confirmed exposure → strong qualifier (+30)$q$
FROM public.cases c WHERE c.slug = $q$uber-passenger-sexual-assault$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_exposure__uber_passenger_sexual_assault$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] No qualifying exposure → not eligible$q$
FROM public.cases c WHERE c.slug = $q$uber-passenger-sexual-assault$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_injury_or_loss__uber_passenger_sexual_assault$q$, $q$equals$q$,
       $q$yes$q$, 30, false, $q$[seed:2026-05-25] Confirmed injury/loss → strong qualifier (+30)$q$
FROM public.cases c WHERE c.slug = $q$uber-passenger-sexual-assault$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_injury_or_loss__uber_passenger_sexual_assault$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] No qualifying injury/loss → not eligible$q$
FROM public.cases c WHERE c.slug = $q$uber-passenger-sexual-assault$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$exposure_timing$q$, $q$equals$q$,
       $q$yes$q$, 20, false, $q$[seed:2026-05-25] Exposure preceded injury → causation signal (+20)$q$
FROM public.cases c WHERE c.slug = $q$uber-passenger-sexual-assault$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$contact_permission$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] User declined attorney contact → not routable$q$
FROM public.cases c WHERE c.slug = $q$uber-passenger-sexual-assault$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_exposure__cartiva_synthetic_cartilage_implant$q$, $q$equals$q$,
       $q$yes$q$, 30, false, $q$[seed:2026-05-25] Confirmed exposure → strong qualifier (+30)$q$
FROM public.cases c WHERE c.slug = $q$cartiva-synthetic-cartilage-implant$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_exposure__cartiva_synthetic_cartilage_implant$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] No qualifying exposure → not eligible$q$
FROM public.cases c WHERE c.slug = $q$cartiva-synthetic-cartilage-implant$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_injury_or_loss__cartiva_synthetic_cartilage_implant$q$, $q$equals$q$,
       $q$yes$q$, 30, false, $q$[seed:2026-05-25] Confirmed injury/loss → strong qualifier (+30)$q$
FROM public.cases c WHERE c.slug = $q$cartiva-synthetic-cartilage-implant$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_injury_or_loss__cartiva_synthetic_cartilage_implant$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] No qualifying injury/loss → not eligible$q$
FROM public.cases c WHERE c.slug = $q$cartiva-synthetic-cartilage-implant$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$exposure_timing$q$, $q$equals$q$,
       $q$yes$q$, 20, false, $q$[seed:2026-05-25] Exposure preceded injury → causation signal (+20)$q$
FROM public.cases c WHERE c.slug = $q$cartiva-synthetic-cartilage-implant$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$contact_permission$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] User declined attorney contact → not routable$q$
FROM public.cases c WHERE c.slug = $q$cartiva-synthetic-cartilage-implant$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_exposure__gardasil_autoimmune_neuro_injury$q$, $q$equals$q$,
       $q$yes$q$, 30, false, $q$[seed:2026-05-25] Confirmed exposure → strong qualifier (+30)$q$
FROM public.cases c WHERE c.slug = $q$gardasil-autoimmune-neuro-injury$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_exposure__gardasil_autoimmune_neuro_injury$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] No qualifying exposure → not eligible$q$
FROM public.cases c WHERE c.slug = $q$gardasil-autoimmune-neuro-injury$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_injury_or_loss__gardasil_autoimmune_neuro_injury$q$, $q$equals$q$,
       $q$yes$q$, 30, false, $q$[seed:2026-05-25] Confirmed injury/loss → strong qualifier (+30)$q$
FROM public.cases c WHERE c.slug = $q$gardasil-autoimmune-neuro-injury$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_injury_or_loss__gardasil_autoimmune_neuro_injury$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] No qualifying injury/loss → not eligible$q$
FROM public.cases c WHERE c.slug = $q$gardasil-autoimmune-neuro-injury$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$exposure_timing$q$, $q$equals$q$,
       $q$yes$q$, 20, false, $q$[seed:2026-05-25] Exposure preceded injury → causation signal (+20)$q$
FROM public.cases c WHERE c.slug = $q$gardasil-autoimmune-neuro-injury$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$contact_permission$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] User declined attorney contact → not routable$q$
FROM public.cases c WHERE c.slug = $q$gardasil-autoimmune-neuro-injury$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_exposure__allergan_biocell_bia_alcl$q$, $q$equals$q$,
       $q$yes$q$, 30, false, $q$[seed:2026-05-25] Confirmed exposure → strong qualifier (+30)$q$
FROM public.cases c WHERE c.slug = $q$allergan-biocell-bia-alcl$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_exposure__allergan_biocell_bia_alcl$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] No qualifying exposure → not eligible$q$
FROM public.cases c WHERE c.slug = $q$allergan-biocell-bia-alcl$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_injury_or_loss__allergan_biocell_bia_alcl$q$, $q$equals$q$,
       $q$yes$q$, 30, false, $q$[seed:2026-05-25] Confirmed injury/loss → strong qualifier (+30)$q$
FROM public.cases c WHERE c.slug = $q$allergan-biocell-bia-alcl$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_injury_or_loss__allergan_biocell_bia_alcl$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] No qualifying injury/loss → not eligible$q$
FROM public.cases c WHERE c.slug = $q$allergan-biocell-bia-alcl$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$exposure_timing$q$, $q$equals$q$,
       $q$yes$q$, 20, false, $q$[seed:2026-05-25] Exposure preceded injury → causation signal (+20)$q$
FROM public.cases c WHERE c.slug = $q$allergan-biocell-bia-alcl$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$contact_permission$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] User declined attorney contact → not routable$q$
FROM public.cases c WHERE c.slug = $q$allergan-biocell-bia-alcl$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_exposure__krispy_kreme_data_breach$q$, $q$equals$q$,
       $q$yes$q$, 30, false, $q$[seed:2026-05-25] Confirmed exposure → strong qualifier (+30)$q$
FROM public.cases c WHERE c.slug = $q$krispy-kreme-data-breach$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_exposure__krispy_kreme_data_breach$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] No qualifying exposure → not eligible$q$
FROM public.cases c WHERE c.slug = $q$krispy-kreme-data-breach$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_injury_or_loss__krispy_kreme_data_breach$q$, $q$equals$q$,
       $q$yes$q$, 30, false, $q$[seed:2026-05-25] Confirmed injury/loss → strong qualifier (+30)$q$
FROM public.cases c WHERE c.slug = $q$krispy-kreme-data-breach$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_injury_or_loss__krispy_kreme_data_breach$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] No qualifying injury/loss → not eligible$q$
FROM public.cases c WHERE c.slug = $q$krispy-kreme-data-breach$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$exposure_timing$q$, $q$equals$q$,
       $q$yes$q$, 20, false, $q$[seed:2026-05-25] Exposure preceded injury → causation signal (+20)$q$
FROM public.cases c WHERE c.slug = $q$krispy-kreme-data-breach$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$contact_permission$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] User declined attorney contact → not routable$q$
FROM public.cases c WHERE c.slug = $q$krispy-kreme-data-breach$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_exposure__fidelity_data_breach$q$, $q$equals$q$,
       $q$yes$q$, 30, false, $q$[seed:2026-05-25] Confirmed exposure → strong qualifier (+30)$q$
FROM public.cases c WHERE c.slug = $q$fidelity-data-breach$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_exposure__fidelity_data_breach$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] No qualifying exposure → not eligible$q$
FROM public.cases c WHERE c.slug = $q$fidelity-data-breach$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_injury_or_loss__fidelity_data_breach$q$, $q$equals$q$,
       $q$yes$q$, 30, false, $q$[seed:2026-05-25] Confirmed injury/loss → strong qualifier (+30)$q$
FROM public.cases c WHERE c.slug = $q$fidelity-data-breach$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_injury_or_loss__fidelity_data_breach$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] No qualifying injury/loss → not eligible$q$
FROM public.cases c WHERE c.slug = $q$fidelity-data-breach$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$exposure_timing$q$, $q$equals$q$,
       $q$yes$q$, 20, false, $q$[seed:2026-05-25] Exposure preceded injury → causation signal (+20)$q$
FROM public.cases c WHERE c.slug = $q$fidelity-data-breach$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$contact_permission$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] User declined attorney contact → not routable$q$
FROM public.cases c WHERE c.slug = $q$fidelity-data-breach$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_exposure__alera_group_data_breach$q$, $q$equals$q$,
       $q$yes$q$, 30, false, $q$[seed:2026-05-25] Confirmed exposure → strong qualifier (+30)$q$
FROM public.cases c WHERE c.slug = $q$alera-group-data-breach$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_exposure__alera_group_data_breach$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] No qualifying exposure → not eligible$q$
FROM public.cases c WHERE c.slug = $q$alera-group-data-breach$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_injury_or_loss__alera_group_data_breach$q$, $q$equals$q$,
       $q$yes$q$, 30, false, $q$[seed:2026-05-25] Confirmed injury/loss → strong qualifier (+30)$q$
FROM public.cases c WHERE c.slug = $q$alera-group-data-breach$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_injury_or_loss__alera_group_data_breach$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] No qualifying injury/loss → not eligible$q$
FROM public.cases c WHERE c.slug = $q$alera-group-data-breach$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$exposure_timing$q$, $q$equals$q$,
       $q$yes$q$, 20, false, $q$[seed:2026-05-25] Exposure preceded injury → causation signal (+20)$q$
FROM public.cases c WHERE c.slug = $q$alera-group-data-breach$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$contact_permission$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] User declined attorney contact → not routable$q$
FROM public.cases c WHERE c.slug = $q$alera-group-data-breach$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_exposure__consumer_beef_antitrust$q$, $q$equals$q$,
       $q$yes$q$, 30, false, $q$[seed:2026-05-25] Confirmed exposure → strong qualifier (+30)$q$
FROM public.cases c WHERE c.slug = $q$consumer-beef-antitrust$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_exposure__consumer_beef_antitrust$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] No qualifying exposure → not eligible$q$
FROM public.cases c WHERE c.slug = $q$consumer-beef-antitrust$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_injury_or_loss__consumer_beef_antitrust$q$, $q$equals$q$,
       $q$yes$q$, 30, false, $q$[seed:2026-05-25] Confirmed injury/loss → strong qualifier (+30)$q$
FROM public.cases c WHERE c.slug = $q$consumer-beef-antitrust$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_injury_or_loss__consumer_beef_antitrust$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] No qualifying injury/loss → not eligible$q$
FROM public.cases c WHERE c.slug = $q$consumer-beef-antitrust$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$exposure_timing$q$, $q$equals$q$,
       $q$yes$q$, 20, false, $q$[seed:2026-05-25] Exposure preceded injury → causation signal (+20)$q$
FROM public.cases c WHERE c.slug = $q$consumer-beef-antitrust$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$contact_permission$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] User declined attorney contact → not routable$q$
FROM public.cases c WHERE c.slug = $q$consumer-beef-antitrust$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_exposure__metformin_ndma_antitrust_marketing$q$, $q$equals$q$,
       $q$yes$q$, 30, false, $q$[seed:2026-05-25] Confirmed exposure → strong qualifier (+30)$q$
FROM public.cases c WHERE c.slug = $q$metformin-ndma-antitrust-marketing$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_exposure__metformin_ndma_antitrust_marketing$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] No qualifying exposure → not eligible$q$
FROM public.cases c WHERE c.slug = $q$metformin-ndma-antitrust-marketing$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_injury_or_loss__metformin_ndma_antitrust_marketing$q$, $q$equals$q$,
       $q$yes$q$, 30, false, $q$[seed:2026-05-25] Confirmed injury/loss → strong qualifier (+30)$q$
FROM public.cases c WHERE c.slug = $q$metformin-ndma-antitrust-marketing$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_injury_or_loss__metformin_ndma_antitrust_marketing$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] No qualifying injury/loss → not eligible$q$
FROM public.cases c WHERE c.slug = $q$metformin-ndma-antitrust-marketing$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$exposure_timing$q$, $q$equals$q$,
       $q$yes$q$, 20, false, $q$[seed:2026-05-25] Exposure preceded injury → causation signal (+20)$q$
FROM public.cases c WHERE c.slug = $q$metformin-ndma-antitrust-marketing$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$contact_permission$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] User declined attorney contact → not routable$q$
FROM public.cases c WHERE c.slug = $q$metformin-ndma-antitrust-marketing$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_exposure__hyundai_kia_airbag_acu$q$, $q$equals$q$,
       $q$yes$q$, 30, false, $q$[seed:2026-05-25] Confirmed exposure → strong qualifier (+30)$q$
FROM public.cases c WHERE c.slug = $q$hyundai-kia-airbag-acu$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_exposure__hyundai_kia_airbag_acu$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] No qualifying exposure → not eligible$q$
FROM public.cases c WHERE c.slug = $q$hyundai-kia-airbag-acu$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_injury_or_loss__hyundai_kia_airbag_acu$q$, $q$equals$q$,
       $q$yes$q$, 30, false, $q$[seed:2026-05-25] Confirmed injury/loss → strong qualifier (+30)$q$
FROM public.cases c WHERE c.slug = $q$hyundai-kia-airbag-acu$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_injury_or_loss__hyundai_kia_airbag_acu$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] No qualifying injury/loss → not eligible$q$
FROM public.cases c WHERE c.slug = $q$hyundai-kia-airbag-acu$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$exposure_timing$q$, $q$equals$q$,
       $q$yes$q$, 20, false, $q$[seed:2026-05-25] Exposure preceded injury → causation signal (+20)$q$
FROM public.cases c WHERE c.slug = $q$hyundai-kia-airbag-acu$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$contact_permission$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] User declined attorney contact → not routable$q$
FROM public.cases c WHERE c.slug = $q$hyundai-kia-airbag-acu$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_exposure__fca_hourly_wage_hour$q$, $q$equals$q$,
       $q$yes$q$, 30, false, $q$[seed:2026-05-25] Confirmed exposure → strong qualifier (+30)$q$
FROM public.cases c WHERE c.slug = $q$fca-hourly-wage-hour$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_exposure__fca_hourly_wage_hour$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] No qualifying exposure → not eligible$q$
FROM public.cases c WHERE c.slug = $q$fca-hourly-wage-hour$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_injury_or_loss__fca_hourly_wage_hour$q$, $q$equals$q$,
       $q$yes$q$, 30, false, $q$[seed:2026-05-25] Confirmed injury/loss → strong qualifier (+30)$q$
FROM public.cases c WHERE c.slug = $q$fca-hourly-wage-hour$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_injury_or_loss__fca_hourly_wage_hour$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] No qualifying injury/loss → not eligible$q$
FROM public.cases c WHERE c.slug = $q$fca-hourly-wage-hour$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$exposure_timing$q$, $q$equals$q$,
       $q$yes$q$, 20, false, $q$[seed:2026-05-25] Exposure preceded injury → causation signal (+20)$q$
FROM public.cases c WHERE c.slug = $q$fca-hourly-wage-hour$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$contact_permission$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] User declined attorney contact → not routable$q$
FROM public.cases c WHERE c.slug = $q$fca-hourly-wage-hour$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_exposure__tinder_age_discrimination_subscription$q$, $q$equals$q$,
       $q$yes$q$, 30, false, $q$[seed:2026-05-25] Confirmed exposure → strong qualifier (+30)$q$
FROM public.cases c WHERE c.slug = $q$tinder-age-discrimination-subscription$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_exposure__tinder_age_discrimination_subscription$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] No qualifying exposure → not eligible$q$
FROM public.cases c WHERE c.slug = $q$tinder-age-discrimination-subscription$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_injury_or_loss__tinder_age_discrimination_subscription$q$, $q$equals$q$,
       $q$yes$q$, 30, false, $q$[seed:2026-05-25] Confirmed injury/loss → strong qualifier (+30)$q$
FROM public.cases c WHERE c.slug = $q$tinder-age-discrimination-subscription$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_injury_or_loss__tinder_age_discrimination_subscription$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] No qualifying injury/loss → not eligible$q$
FROM public.cases c WHERE c.slug = $q$tinder-age-discrimination-subscription$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$exposure_timing$q$, $q$equals$q$,
       $q$yes$q$, 20, false, $q$[seed:2026-05-25] Exposure preceded injury → causation signal (+20)$q$
FROM public.cases c WHERE c.slug = $q$tinder-age-discrimination-subscription$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$contact_permission$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] User declined attorney contact → not routable$q$
FROM public.cases c WHERE c.slug = $q$tinder-age-discrimination-subscription$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_exposure__comcast_cable_data_breach$q$, $q$equals$q$,
       $q$yes$q$, 30, false, $q$[seed:2026-05-25] Confirmed exposure → strong qualifier (+30)$q$
FROM public.cases c WHERE c.slug = $q$comcast-cable-data-breach$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_exposure__comcast_cable_data_breach$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] No qualifying exposure → not eligible$q$
FROM public.cases c WHERE c.slug = $q$comcast-cable-data-breach$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_injury_or_loss__comcast_cable_data_breach$q$, $q$equals$q$,
       $q$yes$q$, 30, false, $q$[seed:2026-05-25] Confirmed injury/loss → strong qualifier (+30)$q$
FROM public.cases c WHERE c.slug = $q$comcast-cable-data-breach$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_injury_or_loss__comcast_cable_data_breach$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] No qualifying injury/loss → not eligible$q$
FROM public.cases c WHERE c.slug = $q$comcast-cable-data-breach$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$exposure_timing$q$, $q$equals$q$,
       $q$yes$q$, 20, false, $q$[seed:2026-05-25] Exposure preceded injury → causation signal (+20)$q$
FROM public.cases c WHERE c.slug = $q$comcast-cable-data-breach$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$contact_permission$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] User declined attorney contact → not routable$q$
FROM public.cases c WHERE c.slug = $q$comcast-cable-data-breach$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_exposure__mylan_securities_settlement$q$, $q$equals$q$,
       $q$yes$q$, 30, false, $q$[seed:2026-05-25] Confirmed exposure → strong qualifier (+30)$q$
FROM public.cases c WHERE c.slug = $q$mylan-securities-settlement$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_exposure__mylan_securities_settlement$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] No qualifying exposure → not eligible$q$
FROM public.cases c WHERE c.slug = $q$mylan-securities-settlement$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_injury_or_loss__mylan_securities_settlement$q$, $q$equals$q$,
       $q$yes$q$, 30, false, $q$[seed:2026-05-25] Confirmed injury/loss → strong qualifier (+30)$q$
FROM public.cases c WHERE c.slug = $q$mylan-securities-settlement$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$confirm_injury_or_loss__mylan_securities_settlement$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] No qualifying injury/loss → not eligible$q$
FROM public.cases c WHERE c.slug = $q$mylan-securities-settlement$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$exposure_timing$q$, $q$equals$q$,
       $q$yes$q$, 20, false, $q$[seed:2026-05-25] Exposure preceded injury → causation signal (+20)$q$
FROM public.cases c WHERE c.slug = $q$mylan-securities-settlement$q$;

INSERT INTO public.matching_rules (
  case_id, rule_type, field_key, operator, value, points, is_disqualifying, description
)
SELECT c.id, 'field_match', $q$contact_permission$q$, $q$equals$q$,
       $q$no$q$, 0, true, $q$[seed:2026-05-25] User declined attorney contact → not routable$q$
FROM public.cases c WHERE c.slug = $q$mylan-securities-settlement$q$;


-- ==========================================================================
-- End of seed migration
-- ==========================================================================