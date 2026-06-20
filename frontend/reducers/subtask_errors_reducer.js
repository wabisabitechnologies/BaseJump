import { RECEIVE_SUBTASKS, RECEIVE_SUBTASK, REMOVE_SUBTASK, RECEIVE_SUBTASK_ERRORS } from '../actions/subtask_actions'


const SubtaskErrorsReducer = (state = [], action) => {
  switch (action.type) {
    case RECEIVE_SUBTASK_ERRORS:
      return action.errors

    case RECEIVE_SUBTASKS || RECEIVE_SUBTASK || REMOVE_SUBTASK:
      return []

    default:
      return state
  }
}

export default SubtaskErrorsReducer
