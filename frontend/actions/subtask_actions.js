import * as APIUtil from '../util/subtask_api_util'

export const RECEIVE_SUBTASKS = 'RECEIVE_SUBTASKS'
export const RECEIVE_SUBTASK = 'RECEIVE_SUBTASK'
export const REMOVE_SUBTASK = 'REMOVE_SUBTASK'
export const RECEIVE_SUBTASK_ERRORS = 'RECEIVE_SUBTASK_ERRORS'

const receiveSubtasks = subtasks => {
  return {
    type: RECEIVE_SUBTASKS,
    subtasks
  }
}

const receiveSubtask = subtask => {
  return {
    type: RECEIVE_SUBTASK,
    subtask
  }
}

const removeSubtask = id => {
  return {
    type: REMOVE_SUBTASK,
    id
  }
}

const receiveSubtaskErrors = errors => {
  return {
    type: RECEIVE_SUBTASK_ERRORS,
    errors
  }
}

export const fetchTodoSubtasks = id => dispatch => {
  return APIUtil.fetchTodoSubtasks(id).
    then(res => dispatch(receiveSubtasks(res.subtasks))).
    catch(res => dispatch(receiveSubtaskErrors(res.responseJSON.errors)))
}

export const createSubtask = subtask => dispatch => {
  return APIUtil.createSubtask(subtask).
    then(res => dispatch(receiveSubtask(res.subtask))).
    catch(res => dispatch(receiveSubtaskErrors(res.responseJSON.errors)))
}

export const updateSubtask = subtask => dispatch => {
  return APIUtil.updateSubtask(subtask).
    then(res => dispatch(receiveSubtask(res.subtask))).
    catch(res => dispatch(receiveSubtaskErrors(res.responseJSON.errors)))
}

export const destroySubtask = id => dispatch => {
  return APIUtil.destroySubtask(id).
    then(res => dispatch(removeSubtask(id))).
    catch(res => dispatch(receiveSubtaskErrors(res.responseJSON.errors)))
}
