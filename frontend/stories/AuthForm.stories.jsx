import React from 'react';
import { MemoryRouter, Routes, Route } from 'react-router-dom';
import AuthForm from '../../frontend/components/auth/AuthForm';

export default {
  title: 'Auth/AuthForm',
  component: AuthForm,
  decorators: [
    (Story) => (
      <MemoryRouter initialEntries={['/login']}>
        <Routes>
          <Route path="/login" element={<Story />} />
        </Routes>
      </MemoryRouter>
    ),
  ],
  argTypes: {
    formType: {
      control: { type: 'select' },
      options: ['login', 'signup'],
    },
  },
};

const defaultUser = { username: '', password: '', name: '', email: '', company: '' };

// Mock functions
const processForm = () => Promise.resolve({ user: { id: 1, companyId: 1 } });
const fetchUserProjects = () => Promise.resolve([]);
const fetchCompany = () => Promise.resolve({});

export const LoginForm = {
  args: {
    formType: 'login',
    user: defaultUser,
    errors: {},
    processForm,
    fetchUserProjects,
    fetchCompany,
    loading: false,
  },
};

export const SignUpForm = {
  args: {
    formType: 'signup',
    user: defaultUser,
    errors: {},
    processForm,
    fetchUserProjects,
    fetchCompany,
    loading: false,
  },
};

export const LoginWithErrors = {
  args: {
    formType: 'login',
    user: defaultUser,
    errors: { username: 'Username is required', password: 'Password is too short (minimum is 6 characters)' },
    processForm,
    fetchUserProjects,
    fetchCompany,
    loading: false,
  },
};

export const Loading = {
  args: {
    formType: 'login',
    user: { ...defaultUser, username: 'johndoe', password: 'password' },
    errors: {},
    processForm,
    fetchUserProjects,
    fetchCompany,
    loading: true,
  },
};
