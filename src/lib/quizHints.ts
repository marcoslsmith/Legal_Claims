/**
 * Quiz-answer → case-slug discovery layer.
 *
 * The general quiz captures broad signals (e.g. "Hair relaxer / chemical
 * straightener") that don't map to per-case matching rules directly, but
 * strongly suggest the user should at least look at certain cases.
 *
 * Each broad-quiz answer option maps to a list of case slugs we should
 * surface as "Recommended Based on Your Answers" on the Results page.
 */

export const QUIZ_HINTS: Record<string, string[]> = {
  // ===== serious_diagnoses =====
  'Cancer (any type)': [
    'hair-relaxer-cancer',
    'afff-firefighting-foam-cancer',
    'talcum-powder-ovarian-cancer-mesothelioma',
    'allergan-biocell-bia-alcl',
  ],
  'Brain tumor or meningioma': ['depo-provera-meningioma'],
  "Parkinson's disease": ['paraquat-parkinsons'],
  'Hearing loss or persistent ringing (tinnitus)': ['tepezza-hearing-loss'],
  'Sudden vision loss (NAION)': ['glp1-naion-vision-loss'],
  'Severe stomach or GI problems (gastroparesis)': ['glp1-gastrointestinal-injury'],
  'Dental injury — tooth decay, loss, or damage': ['suboxone-dental-injury'],
  'Hair loss, fibroids, or uterine cancer': ['hair-relaxer-cancer'],
  'Lymphoma near a breast implant (BIA-ALCL)': ['allergan-biocell-bia-alcl'],
  'Autoimmune or neurological condition': ['gardasil-autoimmune-neuro-injury'],
  'Necrotizing enterocolitis (NEC) in a baby': ['nec-premature-infant-formula'],
  'Autism, ADHD, or developmental delay in a child': ['baby-food-heavy-metals-neurodevelopment'],
  'Severe mental health diagnosis in a teen': ['social-media-minor-addiction-injury'],

  // ===== products_or_meds_used =====
  'Hair relaxer or chemical straightener': ['hair-relaxer-cancer'],
  'Talcum powder or baby powder': ['talcum-powder-ovarian-cancer-mesothelioma'],
  'Depo-Provera birth control shot': ['depo-provera-meningioma'],
  'Ozempic, Wegovy, Mounjaro, or other GLP-1 drug': [
    'glp1-gastrointestinal-injury',
    'glp1-naion-vision-loss',
  ],
  'Tepezza (eye disease drug)': ['tepezza-hearing-loss'],
  'Suboxone film (orally dissolving strips)': ['suboxone-dental-injury'],
  'Gardasil HPV vaccine': ['gardasil-autoimmune-neuro-injury'],
  'Paragard IUD': ['paragard-iud-breakage'],
  'Recalled CPAP, BiPAP, or ventilator (Philips)': ['philips-cpap-recall-injury'],
  'Premature infant formula (Similac, Enfamil)': ['nec-premature-infant-formula'],
  'Major-brand baby food (Gerber, Beech-Nut, Plum, etc.)': ['baby-food-heavy-metals-neurodevelopment'],
  'Paraquat herbicide': ['paraquat-parkinsons'],
  'AFFF firefighting foam (used or exposed to it)': ['afff-firefighting-foam-cancer'],
  'Generic metformin (since 2014)': ['metformin-ndma-antitrust-marketing'],

  // ===== surgeries_implants =====
  'Joint replacement (knee, hip, ankle, or shoulder)': ['exactech-joint-replacement-failure'],
  'Implanted port catheter (PowerPort) for chemo or IV': ['bard-powerport-injury'],
  'Textured breast implants': ['allergan-biocell-bia-alcl'],
  'Synthetic cartilage implant in a foot or toe (Cartiva)': ['cartiva-synthetic-cartilage-implant'],

  // ===== toxic_exposure_setting =====
  'Firefighter or fire training site (any era)': ['afff-firefighting-foam-cancer'],
  'Airport, refinery, or industrial site with foam or chemical exposure': ['afff-firefighting-foam-cancer'],
  'Lived near contaminated water, soil, or industrial pollution': ['afff-firefighting-foam-cancer'],
  'Worked closely with herbicides, pesticides, or industrial chemicals': ['paraquat-parkinsons'],

  // ===== recent_consumer_legal_events =====
  'Received a data breach notification (Krispy Kreme, Fidelity, Comcast, Alera, or others)': [
    'krispy-kreme-data-breach',
    'fidelity-data-breach',
    'alera-group-data-breach',
    'comcast-cable-data-breach',
  ],
  'Bought a Hyundai or Kia (model years 2011–2018)': ['hyundai-kia-airbag-acu'],
  'Used Tinder Plus or Tinder Gold subscription before 2019': ['tinder-age-discrimination-subscription'],
  'Worked unpaid overtime as an hourly worker for FCA / Stellantis / Chrysler': ['fca-hourly-wage-hour'],
  'Was sexually assaulted by an Uber or Lyft driver': ['uber-passenger-sexual-assault'],
  'Bought generic metformin (any pharmacy, since 2014)': ['metformin-ndma-antitrust-marketing'],
  'Owned Mylan / Viatris stock 2014–2019': ['mylan-securities-settlement'],
};

/**
 * yes/no broad-quiz answers that hint at cases.
 * Key format: `${field_key}:yes` or `${field_key}:no`.
 */
export const QUIZ_YESNO_HINTS: Record<string, string[]> = {
  'family_youth_harm:yes': [
    'social-media-minor-addiction-injury',
    'baby-food-heavy-metals-neurodevelopment',
  ],
};

/**
 * Given a map of broad-quiz answers, return the de-duplicated list of
 * suggested case slugs. Multi-select values may arrive as arrays or as
 * comma-separated strings (Quiz writes them as arrays into answer_values).
 */
export function suggestedSlugsFromQuiz(
  answers: Record<string, string | string[] | undefined | null>,
): Set<string> {
  const slugs = new Set<string>();

  for (const [fieldKey, raw] of Object.entries(answers)) {
    if (raw == null) continue;
    const values = Array.isArray(raw)
      ? raw
      : String(raw).split(',').map(v => v.trim()).filter(Boolean);

    for (const v of values) {
      // Multi-select / dropdown options
      const matched = QUIZ_HINTS[v];
      if (matched) matched.forEach(s => slugs.add(s));
    }

    // yes_no — collapse first value
    const single = values[0];
    if (single === 'yes' || single === 'no') {
      const matched = QUIZ_YESNO_HINTS[`${fieldKey}:${single}`];
      if (matched) matched.forEach(s => slugs.add(s));
    }
  }

  return slugs;
}
