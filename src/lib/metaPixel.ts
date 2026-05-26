/**
 * Meta (Facebook) Pixel helpers for ClaimFinder.
 *
 * Practices applied (Meta docs + SPA guidance):
 * - Single init; PageView fired on each client route change (React Router)
 * - Standard events for funnel optimization (Lead, SubmitApplication, etc.)
 * - eventID on conversions for future CAPI deduplication
 * - Advanced matching (email, phone, external_id) when profile is known
 * - Admin routes excluded from tracking
 */

export const META_PIXEL_ID =
  import.meta.env.VITE_META_PIXEL_ID?.trim() || '961689956497983';

declare global {
  interface Window {
    fbq?: Fbq;
    _fbq?: Fbq;
  }
}

type Fbq = {
  (...args: unknown[]): void;
  callMethod?: (...args: unknown[]) => void;
  queue?: unknown[][];
  loaded?: boolean;
  version?: string;
  push?: Fbq;
};

export type MetaStandardEvent =
  | 'PageView'
  | 'ViewContent'
  | 'Search'
  | 'Lead'
  | 'CompleteRegistration'
  | 'InitiateCheckout'
  | 'SubmitApplication'
  | 'Contact';

export type MetaUserData = {
  email?: string | null;
  phone?: string | null;
  firstName?: string | null;
  lastName?: string | null;
  externalId?: string | null;
};

export function isMetaPixelEnabled(): boolean {
  if (import.meta.env.VITE_META_PIXEL_DISABLED === 'true') return false;
  return Boolean(META_PIXEL_ID);
}

export function isExcludedMetaPath(pathname: string): boolean {
  return pathname.startsWith('/admin');
}

/** US-focused normalization; Meta expects country code + digits for ph. */
export function normalizePhoneForMeta(phone: string): string {
  const digits = phone.replace(/\D/g, '');
  if (digits.length === 10) return `1${digits}`;
  if (digits.length === 11 && digits.startsWith('1')) return digits;
  return digits;
}

function splitName(fullName?: string | null): { fn?: string; ln?: string } {
  if (!fullName?.trim()) return {};
  const parts = fullName.trim().split(/\s+/);
  if (parts.length === 1) return { fn: parts[0] };
  return { fn: parts[0], ln: parts.slice(1).join(' ') };
}

export function buildAdvancedMatchingParams(data: MetaUserData): Record<string, string> {
  const params: Record<string, string> = {};
  const email = data.email?.trim().toLowerCase();
  if (email) params.em = email;

  const phone = data.phone ? normalizePhoneForMeta(data.phone) : '';
  if (phone) params.ph = phone;

  if (data.firstName) params.fn = data.firstName.trim().toLowerCase();
  if (data.lastName) params.ln = data.lastName.trim().toLowerCase();

  if (data.externalId) params.external_id = data.externalId;

  return params;
}

export function buildAdvancedMatchingFromProfile(profile: {
  email?: string | null;
  phone?: string | null;
  full_name?: string | null;
  id?: string;
}): Record<string, string> {
  const { fn, ln } = splitName(profile.full_name);
  return buildAdvancedMatchingParams({
    email: profile.email,
    phone: profile.phone,
    firstName: fn,
    lastName: ln,
    externalId: profile.id,
  });
}

export function createMetaEventId(): string {
  if (typeof crypto !== 'undefined' && crypto.randomUUID) {
    return crypto.randomUUID();
  }
  return `${Date.now()}-${Math.random().toString(36).slice(2, 11)}`;
}

let scriptInitPromise: Promise<void> | null = null;

/** Load official fbevents.js and init pixel (no automatic PageView). */
export function initMetaPixelScript(): Promise<void> {
  if (typeof window === 'undefined' || !isMetaPixelEnabled()) {
    return Promise.resolve();
  }
  if (window.fbq?.loaded) return Promise.resolve();
  if (scriptInitPromise) return scriptInitPromise;

  scriptInitPromise = new Promise((resolve) => {
    const f = window;
    const b = document;
    const e = 'script';
    const v = 'https://connect.facebook.net/en_US/fbevents.js';

    if (!f.fbq) {
      const n: Fbq = function (...args: unknown[]) {
        if (n.callMethod) {
          n.callMethod(...args);
        } else {
          n.queue?.push(args);
        }
      } as Fbq;
      if (!f._fbq) f._fbq = n;
      f.fbq = n;
      n.push = n;
      n.loaded = true;
      n.version = '2.0';
      n.queue = [];
    }

    const existing = b.querySelector('script[data-meta-pixel="claimfinder"]');
    if (!existing) {
      const t = b.createElement(e) as HTMLScriptElement;
      t.async = true;
      t.src = v;
      t.dataset.metaPixel = 'claimfinder';
      const s = b.getElementsByTagName(e)[0];
      s.parentNode?.insertBefore(t, s);
      t.onload = () => {
        window.fbq?.('init', META_PIXEL_ID);
        resolve();
      };
      t.onerror = () => resolve();
    } else {
      window.fbq?.('init', META_PIXEL_ID);
      resolve();
    }
  });

  return scriptInitPromise;
}

export function updateMetaAdvancedMatching(userData: MetaUserData): void {
  if (!isMetaPixelEnabled() || typeof window.fbq !== 'function') return;
  const params = buildAdvancedMatchingParams(userData);
  if (Object.keys(params).length === 0) return;
  window.fbq('init', META_PIXEL_ID, params);
}

export function trackMetaPageView(): void {
  if (!isMetaPixelEnabled() || typeof window.fbq !== 'function') return;
  const path = window.location.pathname;
  if (isExcludedMetaPath(path)) return;
  window.fbq('track', 'PageView');
}

export function trackMetaStandard(
  event: MetaStandardEvent,
  params?: Record<string, unknown>,
  options?: { eventID?: string },
): string | undefined {
  if (!isMetaPixelEnabled() || typeof window.fbq !== 'function') return undefined;
  const eventID = options?.eventID ?? createMetaEventId();
  const opts = { eventID };
  if (params && Object.keys(params).length > 0) {
    window.fbq('track', event, params, opts);
  } else {
    window.fbq('track', event, {}, opts);
  }
  return eventID;
}

export function trackMetaCustom(
  eventName: string,
  params?: Record<string, unknown>,
  options?: { eventID?: string },
): string | undefined {
  if (!isMetaPixelEnabled() || typeof window.fbq !== 'function') return undefined;
  const eventID = options?.eventID ?? createMetaEventId();
  const opts = { eventID };
  if (params && Object.keys(params).length > 0) {
    window.fbq('trackCustom', eventName, params, opts);
  } else {
    window.fbq('trackCustom', eventName, {}, opts);
  }
  return eventID;
}

// --- Funnel events (use in pages) ---

export function trackRegistrationComplete(method: 'email' = 'email') {
  trackMetaStandard('CompleteRegistration', {
    status: true,
    content_name: 'ClaimFinder Account',
    registration_method: method,
  });
}

export function trackEligibilityQuizComplete() {
  trackMetaCustom('EligibilityQuizComplete', {
    content_name: 'General Eligibility Quiz',
  });
}

export function trackLeadCaptured() {
  trackMetaStandard('Lead', {
    content_name: 'Contact Information',
    content_category: 'Legal Lead',
  });
}

export function trackIntakeStarted(caseSlug: string, caseName?: string) {
  trackMetaStandard('InitiateCheckout', {
    content_name: caseName || caseSlug,
    content_ids: [caseSlug],
    content_type: 'legal_claim',
    content_category: 'Case Intake',
  });
}

export function trackCaseViewed(caseSlug: string, caseName?: string) {
  trackMetaStandard('ViewContent', {
    content_name: caseName || caseSlug,
    content_ids: [caseSlug],
    content_type: 'legal_claim',
    content_category: 'Case Detail',
  });
}

export function trackBrowseCases() {
  trackMetaStandard('Search', {
    content_name: 'Browse Active Claims',
    content_category: 'Legal Claims',
  });
}

export function trackClaimSubmitted(caseSlug: string, caseName?: string) {
  trackMetaStandard('SubmitApplication', {
    content_name: caseName || caseSlug,
    content_ids: [caseSlug],
    content_type: 'legal_claim',
    content_category: 'Claim Submission',
    status: true,
  });
}
