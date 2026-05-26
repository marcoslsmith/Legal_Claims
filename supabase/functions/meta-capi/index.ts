import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.49.4";

const PIXEL_ID = Deno.env.get("META_PIXEL_ID")?.trim() || "961689956497983";
const ACCESS_TOKEN = Deno.env.get("META_CAPI_ACCESS_TOKEN")?.trim();
const TEST_EVENT_CODE = Deno.env.get("META_TEST_EVENT_CODE")?.trim();

const GRAPH_API = "https://graph.facebook.com/v21.0";

const PUBLIC_EVENTS = new Set([
  "PageView",
  "ViewContent",
  "Search",
]);

const AUTH_REQUIRED_EVENTS = new Set([
  "Lead",
  "CompleteRegistration",
  "SubmitApplication",
  "InitiateCheckout",
  "EligibilityQuizComplete",
]);

const ALLOWED_EVENTS = new Set([...PUBLIC_EVENTS, ...AUTH_REQUIRED_EVENTS]);

type IncomingBody = {
  event_name: string;
  event_id: string;
  event_time?: number;
  event_source_url?: string;
  custom_data?: Record<string, unknown>;
  user_data?: {
    email?: string;
    phone?: string;
    first_name?: string;
    last_name?: string;
    external_id?: string;
  };
  fbp?: string;
  fbc?: string;
};

function buildCorsHeaders(req: Request): Record<string, string> {
  const list = Deno.env.get("ALLOWED_ORIGINS")?.split(",").map((s) => s.trim()).filter(Boolean) ?? [];
  const origin = req.headers.get("Origin");
  const allow =
    list.length === 0
      ? "*"
      : (origin && list.includes(origin) ? origin : (list[0] ?? "*"));
  return {
    "Access-Control-Allow-Origin": allow,
    "Access-Control-Allow-Methods": "POST, OPTIONS",
    "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
    "Access-Control-Max-Age": "86400",
  };
}

function normalizeEmail(email: string): string {
  return email.trim().toLowerCase();
}

function normalizePhone(phone: string): string {
  const digits = phone.replace(/\D/g, "");
  if (digits.length === 10) return `1${digits}`;
  if (digits.length === 11 && digits.startsWith("1")) return digits;
  return digits;
}

function normalizeName(name: string): string {
  return name.trim().toLowerCase();
}

async function sha256(value: string): Promise<string> {
  const data = new TextEncoder().encode(value);
  const hash = await crypto.subtle.digest("SHA-256", data);
  return [...new Uint8Array(hash)].map((b) => b.toString(16).padStart(2, "0")).join("");
}

async function hashField(value: string, normalizer: (v: string) => string): Promise<string> {
  return sha256(normalizer(value));
}

function clientIp(req: Request): string | undefined {
  const forwarded = req.headers.get("x-forwarded-for");
  if (forwarded) return forwarded.split(",")[0]?.trim();
  return req.headers.get("cf-connecting-ip") ?? req.headers.get("x-real-ip") ?? undefined;
}

Deno.serve(async (req: Request) => {
  const cors = buildCorsHeaders(req);

  if (req.method === "OPTIONS") {
    return new Response(null, { status: 204, headers: cors });
  }

  if (req.method !== "POST") {
    return new Response(JSON.stringify({ error: "Method not allowed" }), {
      status: 405,
      headers: { ...cors, "Content-Type": "application/json" },
    });
  }

  if (!ACCESS_TOKEN) {
    return new Response(
      JSON.stringify({ error: "META_CAPI_ACCESS_TOKEN is not configured" }),
      { status: 500, headers: { ...cors, "Content-Type": "application/json" } },
    );
  }

  const authHeader = req.headers.get("Authorization");
  const supabaseUrl = Deno.env.get("SUPABASE_URL");
  const supabaseAnonKey = Deno.env.get("SUPABASE_ANON_KEY");
  if (!supabaseUrl || !supabaseAnonKey) {
    return new Response(JSON.stringify({ error: "Server configuration error" }), {
      status: 500,
      headers: { ...cors, "Content-Type": "application/json" },
    });
  }

  let user: { id: string } | null = null;
  let supabase = createClient(supabaseUrl, supabaseAnonKey);
  if (authHeader?.startsWith("Bearer ")) {
    supabase = createClient(supabaseUrl, supabaseAnonKey, {
      global: { headers: { Authorization: authHeader } },
    });
    const { data: { user: authUser } } = await supabase.auth.getUser();
    user = authUser;
  }

  let body: IncomingBody;
  try {
    body = await req.json();
  } catch {
    return new Response(JSON.stringify({ error: "Invalid JSON" }), {
      status: 400,
      headers: { ...cors, "Content-Type": "application/json" },
    });
  }

  const eventName = body.event_name?.trim();
  const eventId = body.event_id?.trim();
  if (!eventName || !eventId || !ALLOWED_EVENTS.has(eventName)) {
    return new Response(JSON.stringify({ error: "Invalid event" }), {
      status: 400,
      headers: { ...cors, "Content-Type": "application/json" },
    });
  }

  if (AUTH_REQUIRED_EVENTS.has(eventName) && !user) {
    return new Response(JSON.stringify({ error: "Authentication required" }), {
      status: 401,
      headers: { ...cors, "Content-Type": "application/json" },
    });
  }

  const userData: Record<string, string | string[]> = {};
  const incoming = body.user_data ?? {};

  if (user) {
    const { data: profile } = await supabase
      .from("profiles")
      .select("email, phone, full_name")
      .eq("id", user.id)
      .maybeSingle();

    if (profile?.email || incoming.email) {
      userData.em = [await hashField(profile?.email || incoming.email!, normalizeEmail)];
    }
    if (profile?.phone || incoming.phone) {
      userData.ph = [await hashField(profile?.phone || incoming.phone!, normalizePhone)];
    }
    const fullName = profile?.full_name?.trim();
    const fn = incoming.first_name || fullName?.split(/\s+/)[0];
    const ln = incoming.last_name || fullName?.split(/\s+/).slice(1).join(" ");
    if (fn) userData.fn = [await hashField(fn, normalizeName)];
    if (ln) userData.ln = [await hashField(ln, normalizeName)];
    userData.external_id = [await sha256(user.id)];
  } else {
    if (incoming.email) userData.em = [await hashField(incoming.email, normalizeEmail)];
    if (incoming.phone) userData.ph = [await hashField(incoming.phone, normalizePhone)];
    if (incoming.first_name) userData.fn = [await hashField(incoming.first_name, normalizeName)];
    if (incoming.last_name) userData.ln = [await hashField(incoming.last_name, normalizeName)];
    if (incoming.external_id) userData.external_id = [await sha256(incoming.external_id)];
  }

  const ip = clientIp(req);
  if (ip) userData.client_ip_address = ip;

  const ua = req.headers.get("user-agent");
  if (ua) userData.client_user_agent = ua;

  if (body.fbp) userData.fbp = body.fbp;
  if (body.fbc) userData.fbc = body.fbc;

  const eventPayload: Record<string, unknown> = {
    event_name: eventName,
    event_time: body.event_time ?? Math.floor(Date.now() / 1000),
    event_id: eventId,
    action_source: "website",
    user_data: userData,
  };

  if (body.event_source_url) {
    eventPayload.event_source_url = body.event_source_url;
  }

  if (body.custom_data && Object.keys(body.custom_data).length > 0) {
    eventPayload.custom_data = body.custom_data;
  }

  const graphBody: Record<string, unknown> = {
    data: [eventPayload],
    access_token: ACCESS_TOKEN,
  };
  if (TEST_EVENT_CODE) graphBody.test_event_code = TEST_EVENT_CODE;

  const graphRes = await fetch(`${GRAPH_API}/${PIXEL_ID}/events`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(graphBody),
  });

  const graphJson = await graphRes.json().catch(() => ({}));

  if (!graphRes.ok) {
    console.error("[meta-capi] Graph API error", graphRes.status, graphJson);
    return new Response(JSON.stringify({ error: "Failed to send event" }), {
      status: 502,
      headers: { ...cors, "Content-Type": "application/json" },
    });
  }

  return new Response(JSON.stringify({ ok: true, events_received: graphJson.events_received }), {
    headers: { ...cors, "Content-Type": "application/json" },
  });
});
