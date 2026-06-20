import React from 'react';
import { Provider } from 'react-redux';
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import LandingPage from './landing_page/main';
import AppContainer from './app/main_container';
import AuthFormContainer from './auth/auth_form_container';

const Root = ({ store }) => {
  const currentUser = store.getState().session.currentUser;

  return (
    <Provider store={store}>
      <BrowserRouter>
        <Routes>
          <Route path="/login" element={
            currentUser
              ? <Navigate to={`/${currentUser.id}/projects`} replace />
              : <AuthFormContainer formType="login" />
          } />
          <Route path="/signup" element={
            currentUser
              ? <Navigate to={`/${currentUser.id}/projects`} replace />
              : <AuthFormContainer formType="signup" />
          } />
          <Route path="/:userId/projects/*" element={
            currentUser
              ? <AppContainer currentUser={currentUser} />
              : <Navigate to="/login" replace />
          } />
          <Route path="*" element={<LandingPage />} />
        </Routes>
      </BrowserRouter>
    </Provider>
  );
};

export default Root;
