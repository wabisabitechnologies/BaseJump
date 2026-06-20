import { connect } from 'react-redux'
import App from './main'
import { withRouter } from '../../util/with_router_shim'

const mapStateToProps = state => {
  return {
    currentUserId: state.session.currentUser.id
  }
}

export default withRouter(connect(mapStateToProps)(App))
