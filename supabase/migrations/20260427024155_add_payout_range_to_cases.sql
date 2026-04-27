/*
  # Add payout_range column to cases table

  1. Changes
    - Adds `payout_range` (text) to `cases` table to store compliant compensation range text
      e.g. "$20,000 – $250,000+" or "Varies based on employer and claim details"

  2. Notes
    - Nullable text column; existing rows default to NULL until updated
*/

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'cases' AND column_name = 'payout_range'
  ) THEN
    ALTER TABLE cases ADD COLUMN payout_range text;
  END IF;
END $$;
