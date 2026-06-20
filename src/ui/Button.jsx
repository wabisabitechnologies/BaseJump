import React from 'react';
// TODO: Replace with actual COSS UI Button when available
// import { Button as COSSButton } from 'coss-ui/Button';
export const Button = ({ variant = 'primary', size = 'md', children, ...props }) => {
  // Map variant/size to Tailwind classes
  const variantMap = {
    primary: 'bg-landing-blue hover:bg-landing-dark text-white',
    secondary: 'bg-white hover:bg-gray-200 text-landing-blue border border-landing-blue',
    danger: 'bg-red-600 hover:bg-red-700 text-white',
  };
  const sizeMap = {
    sm: 'px-3 py-1.5 text-sm',
    md: 'px-4 py-2 text-base',
    lg: 'px-5 py-3 text-lg',
  };
  const className = `
    ${variantMap[variant] || variantMap.primary}
    ${sizeMap[size] || sizeMap.md}
    rounded-md font-medium flex items-center justify-center
    transition-colors duration-200
  `.trim();
  return (
    <button className={className} {...props}>
      {children}
    </button>
  );
};
