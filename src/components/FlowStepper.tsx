import React from 'react';
import { Check } from 'lucide-react';

interface Step {
  label: string;
}

interface FlowStepperProps {
  steps: Step[];
  currentStep: number; // 0-indexed
}

export function FlowStepper({ steps, currentStep }: FlowStepperProps) {
  return (
    <div className="w-full max-w-lg mx-auto px-4 sm:px-6 pt-5 pb-1">
      <div className="flex items-center gap-0">
        {steps.map((step, idx) => {
          const done = idx < currentStep;
          const active = idx === currentStep;
          return (
            <React.Fragment key={step.label}>
              <div className="flex flex-col items-center shrink-0">
                <div className={`w-7 h-7 rounded-full flex items-center justify-center text-xs font-bold transition-colors border-2 ${
                  done
                    ? 'bg-emerald-500 border-emerald-500 text-white'
                    : active
                    ? 'bg-blue-700 border-blue-700 text-white'
                    : 'bg-white border-slate-300 text-slate-400'
                }`}>
                  {done ? <Check size={13} strokeWidth={3} /> : <span>{idx + 1}</span>}
                </div>
                <span className={`text-[9px] sm:text-[10px] mt-1 font-medium text-center leading-tight max-w-[44px] sm:max-w-none transition-colors ${
                  active ? 'text-blue-700' : done ? 'text-emerald-600' : 'text-slate-400'
                }`}>
                  {step.label}
                </span>
              </div>
              {idx < steps.length - 1 && (
                <div className={`flex-1 h-0.5 mb-4 mx-1 transition-colors ${done ? 'bg-emerald-400' : 'bg-slate-200'}`} />
              )}
            </React.Fragment>
          );
        })}
      </div>
    </div>
  );
}
