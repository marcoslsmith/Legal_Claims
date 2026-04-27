import { createClient } from '@supabase/supabase-js';
import type { Database } from '../types/database';

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL;
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY;

if (!supabaseUrl?.trim() || !supabaseAnonKey?.trim()) {
  throw new Error(
    'Supabase env is missing. Set VITE_SUPABASE_URL and VITE_SUPABASE_ANON_KEY in Netlify (Site → Environment variables), then trigger a new deploy. Locally, copy .env.example to .env and fill the values.',
  );
}

export const supabase = createClient<Database>(supabaseUrl, supabaseAnonKey);
