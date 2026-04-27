export type Json = string | number | boolean | null | { [key: string]: Json | undefined } | Json[];

export interface Database {
  public: {
    Tables: {
      profiles: {
        Row: {
          id: string;
          email: string | null;
          full_name: string | null;
          date_of_birth: string | null;
          phone: string | null;
          address: string | null;
          city: string | null;
          state: string | null;
          zip_code: string | null;
          preferred_contact: string | null;
          consent_to_contact: boolean | null;
          prior_attorney: boolean | null;
          is_admin: boolean | null;
          created_at: string | null;
          updated_at: string | null;
        };
        Insert: Omit<Database['public']['Tables']['profiles']['Row'], 'created_at' | 'updated_at'>;
        Update: Partial<Database['public']['Tables']['profiles']['Insert']>;
      };
      cases: {
        Row: {
          id: string;
          name: string;
          slug: string;
          case_type: string;
          status: string;
          short_description: string | null;
          long_description: string | null;
          priority_score: number | null;
          allowed_states: string[] | null;
          disqualifying_states: string[] | null;
          required_diagnosis: string[] | null;
          required_exposure: string[] | null;
          exposure_date_start: string | null;
          exposure_date_end: string | null;
          diagnosis_date_start: string | null;
          diagnosis_date_end: string | null;
          buyer_destination_id: string | null;
          estimated_lead_value: number | null;
          payout_range: string | null;
          require_medical_docs: boolean;
          required_doc_types: string[];
          internal_notes: string | null;
          created_at: string | null;
          updated_at: string | null;
        };
        Insert: Omit<Database['public']['Tables']['cases']['Row'], 'created_at' | 'updated_at'> & { id?: string };
        Update: Partial<Database['public']['Tables']['cases']['Insert']>;
      };
      questions: {
        Row: {
          id: string;
          question_text: string;
          field_key: string;
          question_type: string;
          answer_options: Json;
          required: boolean | null;
          is_profile_field: boolean | null;
          category: string | null;
          help_text: string | null;
          created_at: string | null;
          updated_at: string | null;
        };
        Insert: Omit<Database['public']['Tables']['questions']['Row'], 'created_at' | 'updated_at'> & { id?: string };
        Update: Partial<Database['public']['Tables']['questions']['Insert']>;
      };
      case_questions: {
        Row: {
          id: string;
          case_id: string;
          question_id: string;
          display_order: number | null;
          required_for_case: boolean | null;
          condition_question_id: string | null;
          condition_answer: string | null;
          created_at: string | null;
        };
        Insert: Omit<Database['public']['Tables']['case_questions']['Row'], 'created_at'> & { id?: string };
        Update: Partial<Database['public']['Tables']['case_questions']['Insert']>;
      };
      matching_rules: {
        Row: {
          id: string;
          case_id: string;
          rule_type: string;
          field_key: string;
          operator: string;
          value: string | null;
          value_list: string[] | null;
          value_min: string | null;
          value_max: string | null;
          points: number | null;
          is_disqualifying: boolean | null;
          description: string | null;
          created_at: string | null;
        };
        Insert: Omit<Database['public']['Tables']['matching_rules']['Row'], 'created_at'> & { id?: string };
        Update: Partial<Database['public']['Tables']['matching_rules']['Insert']>;
      };
      submissions: {
        Row: {
          id: string;
          user_id: string;
          case_id: string;
          status: string;
          match_score: number | null;
          match_tier: string | null;
          source: string | null;
          buyer_destination_id: string | null;
          estimated_value: number | null;
          submitted_at: string | null;
          created_at: string | null;
          updated_at: string | null;
        };
        Insert: Omit<Database['public']['Tables']['submissions']['Row'], 'created_at' | 'updated_at'> & { id?: string };
        Update: Partial<Database['public']['Tables']['submissions']['Insert']>;
      };
      answers: {
        Row: {
          id: string;
          user_id: string;
          submission_id: string | null;
          question_id: string;
          field_key: string;
          answer_value: string | null;
          answer_values: string[] | null;
          created_at: string | null;
          updated_at: string | null;
        };
        Insert: Omit<Database['public']['Tables']['answers']['Row'], 'created_at' | 'updated_at'> & { id?: string };
        Update: Partial<Database['public']['Tables']['answers']['Insert']>;
      };
      uploaded_documents: {
        Row: {
          id: string;
          user_id: string;
          submission_id: string | null;
          document_type: string;
          file_name: string;
          file_path: string;
          file_size: number | null;
          mime_type: string | null;
          created_at: string | null;
        };
        Insert: Omit<Database['public']['Tables']['uploaded_documents']['Row'], 'created_at'> & { id?: string };
        Update: Partial<Database['public']['Tables']['uploaded_documents']['Insert']>;
      };
      consents: {
        Row: {
          id: string;
          user_id: string;
          submission_id: string | null;
          consent_contact: boolean | null;
          consent_not_legal_advice: boolean | null;
          consent_no_attorney_client: boolean | null;
          consent_accuracy: boolean | null;
          ip_address: string | null;
          user_agent: string | null;
          consented_at: string | null;
        };
        Insert: Omit<Database['public']['Tables']['consents']['Row'], 'consented_at'> & { id?: string };
        Update: Partial<Database['public']['Tables']['consents']['Insert']>;
      };
      lead_status_history: {
        Row: {
          id: string;
          submission_id: string;
          old_status: string | null;
          new_status: string;
          changed_by: string | null;
          note: string | null;
          created_at: string | null;
        };
        Insert: Omit<Database['public']['Tables']['lead_status_history']['Row'], 'created_at'> & { id?: string };
        Update: Partial<Database['public']['Tables']['lead_status_history']['Insert']>;
      };
      admin_notes: {
        Row: {
          id: string;
          submission_id: string;
          admin_id: string;
          note: string;
          created_at: string | null;
        };
        Insert: Omit<Database['public']['Tables']['admin_notes']['Row'], 'created_at'> & { id?: string };
        Update: Partial<Database['public']['Tables']['admin_notes']['Insert']>;
      };
      buyer_destinations: {
        Row: {
          id: string;
          name: string;
          contact_email: string | null;
          contact_phone: string | null;
          notes: string | null;
          active: boolean | null;
          created_at: string | null;
        };
        Insert: Omit<Database['public']['Tables']['buyer_destinations']['Row'], 'created_at'> & { id?: string };
        Update: Partial<Database['public']['Tables']['buyer_destinations']['Insert']>;
      };
    };
  };
}

// Convenience types
export type Profile = Database['public']['Tables']['profiles']['Row'];
export type Case = Database['public']['Tables']['cases']['Row'];
export type Question = Database['public']['Tables']['questions']['Row'];
export type CaseQuestion = Database['public']['Tables']['case_questions']['Row'];
export type MatchingRule = Database['public']['Tables']['matching_rules']['Row'];
export type Submission = Database['public']['Tables']['submissions']['Row'];
export type Answer = Database['public']['Tables']['answers']['Row'];
export type UploadedDocument = Database['public']['Tables']['uploaded_documents']['Row'];
export type Consent = Database['public']['Tables']['consents']['Row'];
export type LeadStatusHistory = Database['public']['Tables']['lead_status_history']['Row'];
export type AdminNote = Database['public']['Tables']['admin_notes']['Row'];
export type BuyerDestination = Database['public']['Tables']['buyer_destinations']['Row'];

export type MatchTier = 'strong_match' | 'possible_match' | 'more_info_needed' | 'not_eligible';
export type SubmissionStatus = 'not_started' | 'in_progress' | 'submitted' | 'under_review' | 'routed' | 'accepted' | 'rejected' | 'duplicate' | 'bad_contact' | 'closed';
