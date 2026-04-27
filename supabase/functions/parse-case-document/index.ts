import "jsr:@supabase/functions-js/edge-runtime.d.ts";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type, Authorization, X-Client-Info, Apikey",
};

const SYSTEM_PROMPT = `You are a legal intake system configurator. Given a legal case qualification document (1-pager, email, criteria sheet, etc.), extract structured data to configure a legal lead generation platform.

Return ONLY valid JSON with this exact structure — no markdown, no explanation:

{
  "case": {
    "name": "Full case name (e.g. 'Roundup Weedkiller Cancer Lawsuit')",
    "slug": "url-safe-slug (lowercase, hyphens only)",
    "case_type": "mass_tort" or "class_action",
    "short_description": "1-2 sentence summary shown to users",
    "long_description": "2-3 paragraph description of the case",
    "estimated_lead_value": number in dollars (guess based on case type if not specified),
    "priority_score": number 1-100 (higher = more valuable/urgent),
    "internal_notes": "Any criteria, notes, or caveats for internal use"
  },
  "questions": [
    {
      "question_text": "Full question shown to user",
      "field_key": "snake_case_unique_key",
      "question_type": "yes_no" | "dropdown" | "multi_select" | "text" | "number" | "date",
      "answer_options": ["option1", "option2"] (only for dropdown/multi_select, empty array otherwise),
      "category": "medical" | "product_exposure" | "employment" | "military" | "data_breach" | "consumer" | "case_specific" | "profile",
      "help_text": "Optional clarifying text shown under the question",
      "required": true or false,
      "is_profile_field": true if this question applies broadly (state, age, etc.), false if case-specific
    }
  ],
  "rules": [
    {
      "field_key": "must match a question field_key above",
      "operator": "equals" | "not_equals" | "in_list" | "greater_than" | "less_than",
      "value": "single value string (for equals/not_equals/greater_than/less_than)",
      "value_list": ["list", "of", "values"] (only for in_list, empty array otherwise),
      "points": number (points awarded when rule matches, ignored if disqualifying),
      "is_disqualifying": true if this rule should immediately disqualify the user,
      "description": "Brief explanation of why this rule exists"
    }
  ]
}

Rules for generating good output:
- Extract ALL qualification criteria as matching rules
- Disqualifying rules: prior attorney representation, wrong state, wrong diagnosis, outside date range
- Point-scoring rules: correct diagnosis (+30-50), correct product use (+20-40), correct state (+10-20), correct date range (+10-20)
- Total non-disqualifying points should add up to ~100 for a fully qualifying lead
- Questions must cover every field_key referenced in rules
- Keep field_keys concise: used_product, diagnosis_type, state, treatment_received, etc.
- For yes/no questions about product use or diagnosis, use question_type "yes_no"
- For state selection, use dropdown with US states
- Generate 6-12 questions typically — enough to qualify without overwhelming
`;

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response(null, { status: 200, headers: corsHeaders });
  }

  try {
    const apiKey = Deno.env.get("OPENAI_API_KEY");
    if (!apiKey) {
      return new Response(
        JSON.stringify({ error: "OPENAI_API_KEY is not configured. Add it as a Supabase secret." }),
        { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    const body = await req.json();
    const { document_text, pdf_base64 } = body;

    if (!document_text?.trim() && !pdf_base64?.trim()) {
      return new Response(
        JSON.stringify({ error: "document_text or pdf_base64 is required" }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // Build the user message — PDF gets sent as a base64 file attachment, text as plain content
    let userMessage: unknown;
    if (pdf_base64) {
      userMessage = {
        role: "user",
        content: [
          {
            type: "file",
            file: {
              filename: "document.pdf",
              file_data: `data:application/pdf;base64,${pdf_base64}`,
            },
          },
          {
            type: "text",
            text: "Parse this legal case qualification document and return the structured JSON:",
          },
        ],
      };
    } else {
      userMessage = {
        role: "user",
        content: `Parse this legal case qualification document and return the structured JSON:\n\n${document_text}`,
      };
    }

    const response = await fetch("https://api.openai.com/v1/chat/completions", {
      method: "POST",
      headers: {
        "Authorization": `Bearer ${apiKey}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        model: "gpt-4o",
        max_tokens: 4096,
        messages: [
          { role: "system", content: SYSTEM_PROMPT },
          userMessage,
        ],
        response_format: { type: "json_object" },
      }),
    });

    if (!response.ok) {
      const err = await response.text();
      return new Response(
        JSON.stringify({ error: `OpenAI API error: ${err}` }),
        { status: 502, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    const data = await response.json();
    const rawText = data.choices?.[0]?.message?.content || "";

    let parsed;
    try {
      parsed = JSON.parse(rawText);
    } catch {
      const match = rawText.match(/\{[\s\S]*\}/);
      if (match) {
        parsed = JSON.parse(match[0]);
      } else {
        return new Response(
          JSON.stringify({ error: "Failed to parse AI response as JSON", raw: rawText }),
          { status: 422, headers: { ...corsHeaders, "Content-Type": "application/json" } }
        );
      }
    }

    return new Response(
      JSON.stringify({ result: parsed }),
      { headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  } catch (err) {
    return new Response(
      JSON.stringify({ error: String(err) }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
});
