/**
 * Multi-select helpers. Option labels often contain commas, so we must not
 * join/split on "," for storage or form state.
 */

/** Unlikely to appear in user-facing option text. */
export const MULTI_SELECT_DELIMITER = '\x1e';

export function parseQuestionOptions(answer_options: unknown): string[] {
  if (Array.isArray(answer_options)) {
    return answer_options.map(String);
  }
  if (typeof answer_options === 'string') {
    try {
      const parsed = JSON.parse(answer_options);
      if (Array.isArray(parsed)) return parsed.map(String);
    } catch {
      /* not JSON */
    }
  }
  return [];
}

export function serializeMultiSelect(values: string[]): string {
  return values.join(MULTI_SELECT_DELIMITER);
}

/** Rebuild selections from legacy comma-joined blobs using known option labels. */
export function reconstructMultiSelectFromLegacy(
  stored: string,
  knownOptions: string[],
): string[] {
  if (!stored) return [];
  if (knownOptions.includes(stored)) return [stored];

  const selected: string[] = [];
  let work = stored;
  const sorted = [...knownOptions].sort((a, b) => b.length - a.length);

  for (const opt of sorted) {
    if (work.includes(opt)) {
      selected.push(opt);
      work = work.split(opt).join('');
    }
  }

  if (selected.length > 0) return selected;

  return stored ? [stored] : [];
}

export function parseMultiSelectStored(
  stored: string,
  knownOptions: string[] = [],
): string[] {
  if (!stored) return [];
  if (stored.includes(MULTI_SELECT_DELIMITER)) {
    return stored.split(MULTI_SELECT_DELIMITER).filter(Boolean);
  }
  if (knownOptions.length) {
    return reconstructMultiSelectFromLegacy(stored, knownOptions);
  }
  if (!stored.includes(',')) return [stored];
  return [stored];
}

export function formatMultiSelectForDisplay(
  stored: string,
  knownOptions: string[] = [],
): string {
  return parseMultiSelectStored(stored, knownOptions).join(', ');
}

export function multiSelectValuesForSave(
  stored: string,
  knownOptions: string[] = [],
): string[] {
  return parseMultiSelectStored(stored, knownOptions);
}
