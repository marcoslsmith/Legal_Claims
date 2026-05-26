import { useEffect, useState } from 'react';
import { useLocation } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext';
import {
  META_PIXEL_ID,
  initMetaPixelScript,
  isExcludedMetaPath,
  isMetaPixelEnabled,
  trackMetaPageView,
  updateMetaAdvancedMatching,
} from '../lib/metaPixel';

/**
 * Loads Meta Pixel once, syncs advanced matching when profile loads,
 * and fires PageView on every client-side route change (SPA requirement).
 */
export function MetaPixel() {
  const location = useLocation();
  const { profile } = useAuth();
  const [ready, setReady] = useState(false);

  useEffect(() => {
    if (!isMetaPixelEnabled()) return;
    let cancelled = false;
    initMetaPixelScript().then(() => {
      if (!cancelled) setReady(true);
    });
    return () => { cancelled = true; };
  }, []);

  useEffect(() => {
    if (!ready || !profile) return;
    updateMetaAdvancedMatching({
      email: profile.email,
      phone: profile.phone,
      firstName: profile.full_name?.split(/\s+/)[0],
      lastName: profile.full_name?.split(/\s+/).slice(1).join(' '),
      externalId: profile.id,
    });
  }, [ready, profile?.id, profile?.email, profile?.phone, profile?.full_name]);

  useEffect(() => {
    if (!ready) return;
    if (isExcludedMetaPath(location.pathname)) return;
    trackMetaPageView();
  }, [ready, location.pathname]);

  if (!isMetaPixelEnabled()) return null;

  return (
    <noscript>
      <img
        height="1"
        width="1"
        style={{ display: 'none' }}
        alt=""
        src={`https://www.facebook.com/tr?id=${META_PIXEL_ID}&ev=PageView&noscript=1`}
      />
    </noscript>
  );
}
