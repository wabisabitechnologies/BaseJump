import React from 'react';
export const Checkbox = ({ checked, onChange, label, ...props }) => {
  return (
    <label className="flex items-center space-x-2">
      <input
        type="checkbox"
        checked={checked}
        onChange={onChange}
        className="
          h-4 w-4 text-landing-blue focus:ring-landing-blue
          border-gray-300 rounded
        "
        {...props}
      />
      {label && <span className="text-sm text-gray-700">{label}</span>}
    </label>
  );
};
