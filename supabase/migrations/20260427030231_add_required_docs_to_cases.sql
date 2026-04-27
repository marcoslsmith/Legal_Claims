/*
  # Add required document configuration to cases

  ## Changes
  - `require_medical_docs` (boolean, DEFAULT false) — when true, users cannot skip the document upload step
  - `required_doc_types` (text[], DEFAULT '{}') — list of document type keys that must be uploaded
    Possible values match DOC_TYPES in Documents.tsx:
      diagnosis_proof, prescription_records, proof_of_purchase,
      employment_docs, data_breach_notice, other

  ## Notes
  - Existing cases default to false / empty array (no change in behavior)
  - The Documents page will check these flags and block the "Skip for Now" button when require_medical_docs is true
  - If required_doc_types is non-empty, the user must upload at least one file of each required type
*/

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'cases' AND column_name = 'require_medical_docs'
  ) THEN
    ALTER TABLE cases ADD COLUMN require_medical_docs boolean NOT NULL DEFAULT false;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'cases' AND column_name = 'required_doc_types'
  ) THEN
    ALTER TABLE cases ADD COLUMN required_doc_types text[] NOT NULL DEFAULT '{}';
  END IF;
END $$;
