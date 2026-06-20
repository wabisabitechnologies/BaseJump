import React from 'react';
import useFormSubmit from '../../frontend/hooks/useFormSubmit';
import { Button, Input } from '../../src/ui';

export default {
  title: 'Hooks/useFormSubmit',
  parameters: {
    docs: {
      description: {
        component: 'Standard form submission hook. Manages loading, errors, and reset state for async form submissions.',
      },
    },
  },
};

// Mock API function that simulates success or failure
const mockSubmit = (data) => new Promise((resolve, reject) => {
  setTimeout(() => {
    if (data.username === 'error') {
      reject({
        responseJSON: {
          errors: ['Username is already taken', 'Password is too short'],
        },
      });
    } else {
      resolve({ success: true, user: data });
    }
  }, 1000);
});

const FormDemo = ({ triggerError }) => {
  const { submit, loading, errors } = useFormSubmit(mockSubmit, {
    onSuccess: (result) => console.log('Success:', result),
  });
  const [username, setUsername] = React.useState('');
  const [password, setPassword] = React.useState('');

  const handleSubmit = (e) => {
    e.preventDefault();
    submit({ username, password });
  };

  return (
    <div style={{ maxWidth: 400, padding: 20 }}>
      <h2 style={{ marginBottom: 16 }}>useFormSubmit Demo</h2>
      <form onSubmit={handleSubmit}>
        <div style={{ marginBottom: 12 }}>
          <label style={{ display: 'block', marginBottom: 4, fontWeight: 600 }}>Username</label>
          <Input
            value={username}
            onChange={(e) => setUsername(e.target.value)}
            placeholder={triggerError ? 'error' : 'Enter username'}
          />
          {errors.username && (
            <span style={{ color: 'red', fontSize: 13 }}>{errors.username}</span>
          )}
        </div>
        <div style={{ marginBottom: 16 }}>
          <label style={{ display: 'block', marginBottom: 4, fontWeight: 600 }}>Password</label>
          <Input
            type="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            placeholder="Enter password"
          />
          {errors.password && (
            <span style={{ color: 'red', fontSize: 13 }}>{errors.password}</span>
          )}
        </div>
        <Button type="submit" variant="primary" disabled={loading}>
          {loading ? 'Submitting...' : 'Submit'}
        </Button>
      </form>
      {loading && <p style={{ marginTop: 12, color: '#666' }}>Loading...</p>}
      {!loading && Object.keys(errors).length > 0 && (
        <div style={{ marginTop: 12, padding: 8, background: '#fff0f0', borderRadius: 4 }}>
          <strong>Errors:</strong>
          <ul style={{ margin: '4px 0 0', color: 'red' }}>
            {Object.entries(errors).map(([key, msg]) => (
              <li key={key}>{msg}</li>
            ))}
          </ul>
        </div>
      )}
    </div>
  );
};

export const Default = {
  render: () => <FormDemo />,
  parameters: { docs: { description: { story: 'Default form. Submit with normal data to see success flow.' } } },
};

export const ErrorState = {
  render: () => <FormDemo triggerError />,
  parameters: { docs: { description: { story: 'Submit with username "error" to trigger validation errors.' } } },
};

export const LoadingState = {
  render: () => <FormDemo />,
  parameters: { docs: { description: { story: 'Loading state shown during submission (1s delay).' } } },
};
