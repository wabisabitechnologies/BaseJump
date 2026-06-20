import React from 'react';
import { MemoryRouter, Routes, Route } from 'react-router-dom';
import SessionForm from '../components/session/session_form';

export default {
  title: 'Auth/SessionForm',
  component: SessionForm,
  argTypes: {
    formType: { control: { type: 'select' }, options: ['login', 'signup'] },
  },
  decorators: [
    (Story) => (
      <MemoryRouter initialEntries={['/login']}>
        <Routes>
          <Route path="/login" element={<Story />} />
          <Route path="/signup" element={<Story />} />
        </Routes>
      </MemoryRouter>
    ),
  ],
};

const defaultArgs = {
  user: { username: '', password: '', name: '', email: '', company: '' },
  processForm: () => new Promise((resolve) => setTimeout(() => resolve({ user: { id: 1, companyId: 1 } }), 500)),
  fetchUserProjects: () => Promise.resolve({ projects: [] }),
  fetchCompany: () => Promise.resolve({ company: {} }),
};

export const LoginForm = {
  args: {
    ...defaultArgs,
    formType: 'login',
  },
};

export const SignUpForm = {
  args: {
    ...defaultArgs,
    formType: 'signup',
  },
};

export const LoginWithErrors = {
  args: {
    ...defaultArgs,
    formType: 'login',
    errors: { username: 'Username is required', password: 'Password is too short' },
  },
};

export const LoginLoading = {
  args: {
    ...defaultArgs,
    formType: 'login',
    loading: true,
  },
};

export const WithDemoPrefill = {
  args: {
    ...defaultArgs,
    formType: 'login',
    processForm: (user) => {
      console.log('Submitting with:', user);
      return Promise.resolve({ user: { id: 1, companyId: 1 } });
    },
  },
};
