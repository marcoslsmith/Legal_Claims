import type { MatchingRule, MatchTier } from '../types/database';

export const DEFAULT_STRONG_MIN = 80;
export const DEFAULT_POSSIBLE_MIN = 50;

export type MatchThresholds = {
  strongMatchMin: number;
  possibleMatchMin: number;
};

/** True if the user’s answer satisfies the rule (before disqualify / points). */
export function ruleMatchesAnswer(rule: MatchingRule, userVal: string | string[] | undefined): boolean {
  if (userVal === undefined || userVal === '') return false;
  const strVal = Array.isArray(userVal) ? userVal.join(',') : userVal;

  switch (rule.operator) {
    case 'equals':
      return normalizedEquals(strVal, rule.value || '');
    case 'not_equals':
      return !normalizedEquals(strVal, rule.value || '');
    case 'contains':
      return strVal.toLowerCase().includes((rule.value || '').toLowerCase());
    case 'in_list':
      if (Array.isArray(userVal)) {
        return userVal.some((v) => (rule.value_list || []).some((expected) => normalizedEquals(v, expected)));
      }
      return (rule.value_list || []).some((v) => strVal.toLowerCase().includes(v.toLowerCase()));
    case 'greater_than': {
      const n = numOrDateMs(strVal);
      const c = numOrDateMs(rule.value);
      return n !== null && c !== null && n > c;
    }
    case 'less_than': {
      const n = numOrDateMs(strVal);
      const c = numOrDateMs(rule.value);
      return n !== null && c !== null && n < c;
    }
    case 'between': {
      const n = numOrDateMs(strVal);
      const lo = numOrDateMs(rule.value_min);
      const hi = numOrDateMs(rule.value_max);
      return n !== null && lo !== null && hi !== null && n >= lo && n <= hi;
    }
    default:
      return false;
  }
}

function normalizedEquals(actual: string, expected: string): boolean {
  const boolA = asBoolLike(actual);
  const boolB = asBoolLike(expected);
  if (boolA !== null && boolB !== null) return boolA === boolB;
  return actual.toLowerCase() === expected.toLowerCase();
}

function asBoolLike(v: string | null | undefined): boolean | null {
  if (v == null) return null;
  const s = v.trim().toLowerCase();
  if (['true', 'yes', 'y', '1'].includes(s)) return true;
  if (['false', 'no', 'n', '0'].includes(s)) return false;
  return null;
}

function numOrDateMs(s: string | null | undefined): number | null {
  if (s == null || s === '') return null;
  const t = Date.parse(s);
  if (!Number.isNaN(t)) return t;
  const n = parseFloat(s);
  if (!Number.isNaN(n)) return n;
  return null;
}

export function scoreCaseMatch(
  caseRules: MatchingRule[],
  answerMap: Record<string, string | string[]>,
): { score: number; disqualified: boolean } {
  let score = 0;
  let disqualified = false;

  for (const rule of caseRules) {
    const userVal = answerMap[rule.field_key];
    if (!ruleMatchesAnswer(rule, userVal)) continue;
    if (rule.is_disqualifying) {
      disqualified = true;
      break;
    }
    score += rule.points || 0;
  }

  return { score, disqualified };
}

export function tierFromScore(
  score: number,
  disqualified: boolean,
  thresholds: MatchThresholds,
): MatchTier {
  if (disqualified) return 'not_eligible';
  if (score >= thresholds.strongMatchMin) return 'strong_match';
  if (score >= thresholds.possibleMatchMin) return 'possible_match';
  return 'more_info_needed';
}
