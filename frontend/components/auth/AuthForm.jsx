import React, { useState, useCallback } from 'react';
import { Link } from 'react-router-dom';
import { Button, Input } from '../../../src/ui';
import Loading from '../app/loader';

const basecampLogo = 'https://res.cloudinary.com/basejump/image/upload/v1580630789/basecamp-logo-mini.png';


const AuthForm = ({ formType, processForm, user: initialUser, errors: initialErrors, fetchUserProjects, fetchCompany, loading: initialLoading }) => {
  const [user, setUser] = useState(initialUser || { username: '', password: '', name: '', email: '', company: '' });
  const [errors, setErrors] = useState(initialErrors || {});
  const [loading, setLoading] = useState(initialLoading || false);

  const update = useCallback((field) => (e) => {
    setErrors({});
    setUser((prev) => ({ ...prev, [field]: e.target.value }));
  }, []);

  const handleSubmit = useCallback((e) => {
    e.preventDefault();
    setLoading(true);
    processForm(user)
      .then((res) =>
        fetchUserProjects(res.user.id)
          .then((subRes) => fetchCompany(res.user.companyId))
      )
      .catch((res) => {
        setLoading(false);
        const errs = {};
        (res.responseJSON?.errors || []).forEach((error) => {
          const key = error.split(' ')[0].toLowerCase();
          errs[key] = error;
        });
        setErrors(errs);
      });
  }, [user, processForm, fetchUserProjects, fetchCompany]);

  const demo = useCallback(() => {
    setUser({ username: 'johndoe', password: 'password' });
  }, []);

  const isLogin = formType === 'login';

  const inputClass = (field) =>
    errors[field] ? 'border-red-500 mb-2.5' : 'mb-2.5';

  const signUpFields = !isLogin ? (
    <div className="w-full">
      <label className="font-bold mb-1 block">Name</label>
          <Input
            value={user.name}
            onChange={update('name')}
            placeholder="John Doe"
            className={inputClass('name')}
          />
      {errors.name && <span className="text-red-600 text-sm">{errors.name}</span>}

          <Input
            value={user.email}
            onChange={update('email')}
            placeholder="john@doe.com"
            className={inputClass('email')}
          />
      {errors.email && <span className="text-red-600 text-sm">{errors.email}</span>}

          <Input
            value={user.company}
            onChange={update('company')}
            placeholder="John's Dough Company"
            className={inputClass('company')}
          />
      {errors.company && <span className="text-red-600 text-sm">{errors.company}</span>}
    </div>
  ) : null;

  const formHeader = isLogin ? (
    <div className="flex flex-col items-center text-center w-full mb-5">
      <h3 className="text-xl font-bold mb-5">Happy {DAYS[new Date().getDay()]}!</h3>
      <p className="mb-5">Just enter your email address or username and we'll get you right into Basejump</p>
    </div>
  ) : null;

  return (
    <div>
      {loading && <Loading styles={{ position: 'absolute', top: '0%' }} />}
      <div className="min-h-screen flex flex-col items-center pt-[50px] bg-[#F4EFE7] font-sans">
        <Link to="/">
          <img
            src={basecampLogo}
            alt="Basejump"
            className="h-[75px] transition-transform duration-200 hover:scale-110"
          />
        </Link>

        <form
          onSubmit={handleSubmit}
          className={`relative mt-5 p-5 flex flex-col items-start w-[380px] bg-white rounded-[5px] ${isLogin ? '' : 'border-2 border-signup-blue'}`}
          style={{ boxShadow: '0 1px 3px rgba(0,0,0,0.1)' }}
        >
          {/* Arrow on top */}
          <div className="absolute -top-[15px] left-1/2 -ml-[15px] w-0 h-0 border-l-[15px] border-r-[15px] border-b-[15px] border-l-transparent border-r-transparent border-b-white" />

          {!isLogin && (
            <span className="absolute bottom-[97%] left-[29%] bg-signup-blue text-white px-3.5 py-1 rounded-full z-10 text-sm">
              Sign up for Basejump
            </span>
          )}

          {formHeader}

          {!isLogin && (
            <div className="flex flex-col items-center text-center w-full mb-5">
              <p className="barred-span mt-2.5 text-[rgba(40,60,70,0.8)]">
                Type your email address
              </p>
            </div>
          )}

          {signUpFields}

          <label className="font-bold mb-1 block">Username</label>
          <Input
            value={user.username}
            onChange={update('username')}
            placeholder="johndoe"
            className={inputClass('username')}
          />
          {errors.username && <span className="text-red-600 text-sm">{errors.username}</span>}

          <label className="font-bold mb-1 block">Password</label>
          <Input
            type="password"
            value={user.password}
            onChange={update('password')}
            className={inputClass('password')}
          />
          {errors.password && <span className="text-red-600 text-sm">{errors.password}</span>}

          <div className="flex items-center gap-2.5 w-full mt-2.5">
            <Button type="submit" variant="primary" size="lg" className="flex-1">
              {isLogin ? 'Login' : 'Sign Up'}
            </Button>
            {isLogin && (
              <Button type="button" variant="secondary" size="lg" className="flex-1" onClick={demo}>
                Demo Login
              </Button>
            )}
          </div>
        </form>

        <p className="mt-5 text-sm">
          {isLogin ? (
            <>
              Don't have an account?{' '}
              <Link to="/signup" className="font-medium text-landing-blue hover:text-landing-dark">
                Sign up here!
              </Link>
            </>
          ) : (
            <>
              Already have an account?{' '}
              <Link to="/login" className="font-medium text-landing-blue hover:text-landing-dark">
                Sign in here!
              </Link>
            </>
          )}
        </p>
      </div>
    </div>
  );
};

export default AuthForm;
