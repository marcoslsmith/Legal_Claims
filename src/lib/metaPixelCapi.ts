import { supabase } from './supabase';
import {
  createMetaEventId,
  isMetaPixelEnabled,
  type MetaUserData,
} from './metaPixel';

export type MetaCapiPayload = {
  event_name: string;
  event_id: string;
  custom_data?: Record<string, unknown>;
  user_data?: MetaUserData;
};

function getCookie(name: string): string | undefined {
  if (typeof document === 'undefined') return undefined;
  const match = document.cookie.match(new RegExp(`(?:^|; )${name.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')}=([^;]*)`));
  return match ? decodeURIComponent(match[1]) : undefined;
}

/** Read _fbp / _fbc; derive fbc from fbclid if needed. */
export function getMetaBrowserIds(): { fbp?: string; fbc?: string } {
  let fbp = getCookie('_fbp');
  let fbc = getCookie('_fbc');

  if (!fbc && typeof window !== 'undefined') {
    const fbclid = new URLSearchParams(window.location.search).get('fbclid');
    if (fbclid) {
      fbc = `fb.1.${Date.now()}.${fbclid}`;
    }
  }

  return { fbp, fbc };
}

/**
 * Server-side Conversions API — uses same event_id as browser pixel for deduplication.
 * Fire-and-forget; never blocks UX.
 */
export function sendMetaCapiEvent(payload: MetaCapiPayload): void {
  if (!isMetaPixelEnabled()) return;

  const { fbp, fbc } = getMetaBrowserIds();
  const event_source_url =
    typeof window !== 'undefined'
      ? `${window.location.origin}${window.location.pathname}`
      : undefined;

  void supabase.functions
    .invoke('meta-capi', {
      body: {
        ...payload,
        event_time: Math.floor(Date.now() / 1000),
        event_source_url,
        fbp,
        fbc,
        user_data: payload.user_data
          ? {
              email: payload.user_data.email ?? undefined,
              phone: payload.user_data.phone ?? undefined,
              first_name: payload.user_data.firstName ?? undefined,
              last_name: payload.user_data.lastName ?? undefined,
              external_id: payload.user_data.externalId ?? undefined,
            }
          : undefined,
      },
    })
    .then(({ error }) => {
      if (error && import.meta.env.DEV) {
        console.warn('[meta-capi]', error.message);
      }
    });
}

export function trackBrowserAndCapi(
  kind: 'standard' | 'custom',
  eventName: string,
  browserTrack: (eventId: string) => void,
  options?: {
    custom_data?: Record<string, unknown>;
    user_data?: MetaUserData;
  },
): string {
  const eventId = createMetaEventId();
  browserTrack(eventId);
  sendMetaCapiEvent({
    event_name: eventName,
    event_id: eventId,
    custom_data: options?.custom_data,
    user_data: options?.user_data,
  });
  return eventId;
}
