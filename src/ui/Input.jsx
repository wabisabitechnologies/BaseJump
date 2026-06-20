import React from 'react';
export const Input = ({ type = 'text', placeholder, className: extraClass, ...props }) => {
  const baseClass = `
    block w-full rounded-md border-gray-300 shadow-sm
    focus:border-landing-blue focus:ring-2 focus:ring-landing-blue
    bg-white px-3 py-2 text-sm
  `.trim();
  const className = extraClass ? `${baseClass} ${extraClass}` : baseClass;
  return (
    <input
      type={type}
      placeholder={placeholder}
      className={className}
      {...props}
    />
  );
};
