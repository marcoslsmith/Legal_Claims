import React from 'react';
import { FileText } from 'lucide-react';

export const DOC_TYPE_OPTIONS = [
  { value: 'diagnosis_proof', label: 'Diagnosis / Medical Records' },
  { value: 'prescription_records', label: 'Prescription Records' },
  { value: 'proof_of_purchase', label: 'Proof of Purchase' },
  { value: 'employment_docs', label: 'Employment Documents' },
  { value: 'data_breach_notice', label: 'Data Breach Notice' },
  { value: 'other', label: 'Other Supporting Documents' },
];

interface Props {
  requireDocs: boolean;
  requiredDocTypes: string[];
  onRequireDocsChange: (v: boolean) => void;
  onRequiredDocTypesChange: (v: string[]) => void;
}

export function DocRequirementsFields({ requireDocs, requiredDocTypes, onRequireDocsChange, onRequiredDocTypesChange }: Props) {
  const toggle = (value: string) => {
    onRequiredDocTypesChange(
      requiredDocTypes.includes(value)
        ? requiredDocTypes.filter(t => t !== value)
        : [...requiredDocTypes, value]
    );
  };

  return (
    <div className="border border-slate-200 rounded-xl p-4 space-y-3 bg-slate-50">
      <div className="flex items-center justify-between gap-3">
        <div className="flex items-center gap-2">
          <FileText size={15} className="text-slate-500" />
          <span className="text-sm font-medium text-slate-700">Require Document Uploads</span>
        </div>
        <button
          type="button"
          onClick={() => onRequireDocsChange(!requireDocs)}
          className={`relative inline-flex h-6 w-11 shrink-0 cursor-pointer rounded-full border-2 border-transparent transition-colors duration-200 focus:outline-none ${requireDocs ? 'bg-blue-600' : 'bg-slate-300'}`}
          aria-pressed={requireDocs}
        >
          <span
            className={`pointer-events-none inline-block h-5 w-5 transform rounded-full bg-white shadow ring-0 transition duration-200 ${requireDocs ? 'translate-x-5' : 'translate-x-0'}`}
          />
        </button>
      </div>

      {requireDocs && (
        <div className="space-y-2 pt-1">
          <p className="text-xs text-slate-500 font-medium">Select which document types users must upload:</p>
          <div className="grid grid-cols-1 gap-1.5">
            {DOC_TYPE_OPTIONS.map(opt => (
              <label key={opt.value} className="flex items-center gap-2.5 cursor-pointer group">
                <input
                  type="checkbox"
                  checked={requiredDocTypes.includes(opt.value)}
                  onChange={() => toggle(opt.value)}
                  className="w-4 h-4 rounded border-slate-300 text-blue-600 focus:ring-blue-500 cursor-pointer"
                />
                <span className="text-sm text-slate-700 group-hover:text-slate-900 transition-colors">{opt.label}</span>
              </label>
            ))}
          </div>
          {requiredDocTypes.length === 0 && (
            <p className="text-xs text-amber-600 bg-amber-50 border border-amber-200 rounded-lg px-3 py-2">
              Documents are required but no types are selected — users will be blocked but won't know what to upload. Select at least one type.
            </p>
          )}
        </div>
      )}
    </div>
  );
}
