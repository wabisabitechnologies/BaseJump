import React from 'react';
import { Checkbox } from '../../src/ui/Checkbox';

export default {
  title: 'UI/Checkbox',
  component: Checkbox,
};

export const Default = {
  args: {
    label: 'Check me',
    checked: false,
  },
};

export const Checked = {
  args: {
    label: 'I am checked',
    checked: true,
  },
};
