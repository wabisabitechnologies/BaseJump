import React from 'react';
import { useParams, useNavigate, useLocation } from 'react-router-dom';

// react-router-dom v7 removed withRouter. This shim recreates it using hooks
// so existing container files don't need to be rewritten all at once.
export function withRouter(Component) {
  function ComponentWithRouterProp(props) {
    const params = useParams();
    const navigate = useNavigate();
    const location = useLocation();
    return (
      <Component
        {...props}
        params={params}
        navigate={navigate}
        location={location}
        match={{ params: params || {} }}
      />
    );
  }
  ComponentWithRouterProp.displayName = `withRouter(${Component.displayName || Component.name || 'Component'})`;
  return ComponentWithRouterProp;
}
