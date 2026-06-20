import { useState, useCallback } from 'react';

/**
 * useFormSubmit - Standard form submission hook
 *
 * Accepts an async function and returns submit/loading/errors/reset.
 * Every new form in the app should use this instead of duplicating state.
 *
 * @param {Function} submitFn - Async function to call on submit (receives form data)
 * @param {Object} options
 * @param {Function} options.onSuccess - Called with the resolved value on success
 * @param {Function} options.onError - Called with parsed errors on failure
 * @returns {{ submit: Function, loading: boolean, errors: Object, reset: Function }}
 */
const useFormSubmit = (submitFn, { onSuccess, onError } = {}) => {
  const [loading, setLoading] = useState(false);
  const [errors, setErrors] = useState({});

  const submit = useCallback(async (data) => {
    setLoading(true);
    setErrors({});
    try {
      const result = await submitFn(data);
      if (onSuccess) onSuccess(result);
      return result;
    } catch (err) {
      const errs = {};
      const rawErrors = err?.responseJSON?.errors || [];
      rawErrors.forEach((error) => {
        const key = error.split(' ')[0].toLowerCase();
        errs[key] = error;
      });
      setErrors(errs);
      if (onError) onError(errs);
    } finally {
      setLoading(false);
    }
  }, [submitFn, onSuccess, onError]);

  const reset = useCallback(() => {
    setLoading(false);
    setErrors({});
  }, []);

  return { submit, loading, errors, reset };
};

export default useFormSubmit;
