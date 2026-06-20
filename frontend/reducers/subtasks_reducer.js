import { RECEIVE_SUBTASKS, RECEIVE_SUBTASK, REMOVE_SUBTASK } from '../actions/subtask_actions'

const SubtasksReducer = (state = {}, action) => {
  Object.freeze(state)
  switch (action.type) {
    case RECEIVE_SUBTASKS:
      if (Boolean(action.subtasks)){
        return Object.assign({}, state, action.subtasks)
      } else {
        return state
      }
    case RECEIVE_SUBTASK:
      return Object.assign({}, state, { [action.subtask.id]: action.subtask })
    case REMOVE_SUBTASK:
      const newState = Object.assign({}, state)
      delete newState[action.id]
      return newState
    default:
      return state
  }
}

export default SubtasksReducer
