/*
  # Seed Missing Cases and Set Payout Ranges

  1. New Cases Added
    - `Camp Lejeune Water Contamination` (mass_tort) — toxic water exposure at Camp Lejeune 1953–1987
    - `Hernia Mesh` (mass_tort) — defective surgical mesh complications
    - `Ozempic / GLP-1 Injuries` (mass_tort) — gastroparesis and serious injuries from GLP-1 medications

  2. Updated Cases
    - All existing and new cases get a `payout_range` using compliant language

  3. Notes
    - Uses ON CONFLICT DO NOTHING so existing cases are not duplicated
    - Payout ranges are then applied via UPDATE using the slug as the key
*/

-- Insert new cases if they don't exist yet
INSERT INTO cases (id, name, slug, case_type, status, short_description, long_description, priority_score, estimated_lead_value)
VALUES
  (
    gen_random_uuid(),
    'Camp Lejeune Water Contamination',
    'camp-lejeune-water-contamination',
    'mass_tort',
    'active',
    'Veterans and civilians exposed to contaminated drinking water at Camp Lejeune between 1953 and 1987 may qualify for compensation under the Camp Lejeune Justice Act.',
    'For decades, the drinking water at Marine Corps Base Camp Lejeune in North Carolina was contaminated with toxic chemicals including trichloroethylene (TCE), perchloroethylene (PCE), benzene, and vinyl chloride. These chemicals have been linked to serious illnesses including various cancers, neurological disorders, and other conditions. The Camp Lejeune Justice Act of 2022 allows veterans, their families, and civilian workers who lived or worked at the base for at least 30 days between August 1, 1953 and December 31, 1987 to file claims for compensation.',
    88,
    5500
  ),
  (
    gen_random_uuid(),
    'Hernia Mesh',
    'hernia-mesh',
    'mass_tort',
    'active',
    'Patients who received hernia mesh implants and experienced serious complications such as mesh migration, infection, bowel obstruction, or chronic pain may qualify for compensation.',
    'Thousands of patients have reported serious complications from defective hernia mesh devices, including mesh migration, organ perforation, chronic pain, infection, recurrence, and bowel obstruction. Several manufacturers have faced significant litigation over design defects and failure to adequately warn patients and physicians. If you had hernia mesh surgery and experienced complications requiring revision surgery or ongoing medical treatment, you may be eligible to file a claim.',
    82,
    4200
  ),
  (
    gen_random_uuid(),
    'Ozempic / GLP-1 Injuries',
    'ozempic-glp1-injuries',
    'mass_tort',
    'active',
    'Patients who took Ozempic, Wegovy, Mounjaro, or other GLP-1 medications and developed serious gastrointestinal complications such as gastroparesis, bowel obstruction, or severe vomiting may qualify for compensation.',
    'GLP-1 receptor agonist medications including semaglutide (Ozempic, Wegovy) and tirzepatide (Mounjaro) have been linked to serious gastrointestinal injuries including gastroparesis (stomach paralysis), ileus, bowel obstruction, and severe persistent vomiting requiring hospitalization. Plaintiffs allege that drug manufacturers failed to adequately warn about these risks. If you experienced serious gastrointestinal complications after taking a GLP-1 medication, you may be eligible to participate in this litigation.',
    85,
    3800
  )
ON CONFLICT (slug) DO NOTHING;

-- Update payout ranges for all cases using compliant language
UPDATE cases SET payout_range = '$20,000 – $250,000+' WHERE slug = 'roundup-weedkiller';
UPDATE cases SET payout_range = '$30,000 – $300,000+' WHERE slug = 'afff-firefighting-foam';
UPDATE cases SET payout_range = '$20,000 – $500,000+' WHERE slug = 'hair-relaxer-lawsuit';
UPDATE cases SET payout_range = '$25,000 – $400,000+' WHERE slug = 'depo-provera-lawsuit';
UPDATE cases SET payout_range = '$25,000 – $550,000+' WHERE slug = 'camp-lejeune-water-contamination';
UPDATE cases SET payout_range = '$50,000 – $250,000+' WHERE slug = 'hernia-mesh';
UPDATE cases SET payout_range = '$10,000 – $200,000+' WHERE slug = 'ozempic-glp1-injuries';
UPDATE cases SET payout_range = '$50 – $10,000+'      WHERE slug = 'data-breach-class-action';
UPDATE cases SET payout_range = 'Varies by employer, wages, and claim details' WHERE slug = 'wage-hour-class-action';
