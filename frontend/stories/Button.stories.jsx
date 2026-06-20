import React from 'react';
import { Button } from '../../src/ui/Button';

export default {
  title: 'UI/Button',
  component: Button,
  argTypes: {
    variant: { control: { type: 'select' }, options: ['primary', 'secondary', 'danger'] },
    size: { control: { type: 'select' }, options: ['sm', 'md', 'lg'] },
  },
};

export const Primary = {
  args: {
    children: 'Primary Button',
    variant: 'primary',
    size: 'md',
  },
};

export const Secondary = {
  args: {
    children: 'Secondary Button',
    variant: 'secondary',
    size: 'md',
  },
};

export const Small = {
  args: {
    children: 'Small Button',
    variant: 'primary',
    size: 'sm',
  },
};
