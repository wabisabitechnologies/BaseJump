import { connect } from 'react-redux';
import AuthForm from './AuthForm';
import { fetchCompany } from '../../actions/company_actions';
import { fetchUserProjects } from '../../actions/project_actions';
import { login, signup } from '../../actions/session_actions';

const mapStateToProps = (state) => ({
  user: { username: '', password: '', name: '', email: '', company: '' },
  errors: state.errors?.session || {},
});

// formType is passed as a prop from the Route in root.jsx
const mapDispatchToProps = (dispatch, ownProps) => {
  const formType = ownProps.formType || 'login';
  const action = formType === 'login' ? login : signup;
  return {
    fetchCompany: (id) => dispatch(fetchCompany(id)),
    fetchUserProjects: (id) => dispatch(fetchUserProjects(id)),
    processForm: (user) => dispatch(action(user)),
    formType,
  };
};

export default connect(mapStateToProps, mapDispatchToProps)(AuthForm);
