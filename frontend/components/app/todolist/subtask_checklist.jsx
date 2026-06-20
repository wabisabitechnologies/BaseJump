import React, { useState, useCallback } from 'react';
import { useDispatch } from 'react-redux';
import { Button, Input } from '../../../src/ui';
import {
  createSubtask,
  updateSubtask,
  destroySubtask,
} from '../../../actions/subtask_actions';
import useFormSubmit from '../../../hooks/useFormSubmit';

const SubtaskChecklist = ({ todoId, subtasks }) => {
  const dispatch = useDispatch();
  const [title, setTitle] = useState('');

  const { submit, loading, errors } = useFormSubmit(
    (data) => dispatch(createSubtask(data)),
    { onSuccess: () => setTitle('') },
  );

  const handleCreate = useCallback(
    (e) => {
      e.preventDefault();
      if (!title.trim()) return;
      submit({ title, parent_todo_id: todoId });
    },
    [submit, title, todoId],
  );

  const handleToggle = useCallback(
    (subtask) => {
      dispatch(updateSubtask({ ...subtask, done: !subtask.done }));
    },
    [dispatch],
  );

  const handleDelete = useCallback(
    (subtaskId) => {
      dispatch(destroySubtask(subtaskId));
    },
    [dispatch],
  );

  const subtaskList = subtasks
    ? (Array.isArray(subtasks) ? subtasks : Object.values(subtasks)).filter(
        (s) => s.parent_todo_id === todoId,
      )
    : [];

  const doneSubtasks = subtaskList.filter((s) => s.done);
  const pendingSubtasks = subtaskList.filter((s) => !s.done);

  return (
    <div className="subtask-checklist mt-2 pl-4 border-l-2 border-gray-200">
      <div className="flex gap-2 mb-2">
        <Input
          value={title}
          onChange={(e) => setTitle(e.target.value)}
          placeholder="Add a subtask..."
          className="flex-1 text-sm py-1"
        />
        <Button
          type="button"
          variant="primary"
          size="sm"
          onClick={handleCreate}
          disabled={loading || !title.trim()}
        >
          {loading ? 'Adding...' : 'Add'}
        </Button>
      </div>
      {errors.title && (
        <p className="text-red-500 text-xs mb-1">{errors.title}</p>
      )}

      {pendingSubtasks.length > 0 && (
        <ul className="list-none p-0 m-0">
          {pendingSubtasks.map((s) => (
            <li key={s.id} className="flex items-center gap-2 py-1 group">
              <input
                type="checkbox"
                checked={s.done}
                onChange={() => handleToggle(s)}
                className="cursor-pointer"
              />
              <span className="flex-1 text-sm">{s.title}</span>
              <button
                onClick={() => handleDelete(s.id)}
                className="text-xs text-gray-400 hover:text-red-500 opacity-0 group-hover:opacity-100 transition-opacity bg-transparent border-none cursor-pointer"
              >
                Delete
              </button>
            </li>
          ))}
        </ul>
      )}

      {doneSubtasks.length > 0 && (
        <details className="mt-1">
          <summary className="text-xs text-gray-500 cursor-pointer">
            {doneSubtasks.length} completed
          </summary>
          <ul className="list-none p-0 m-0 mt-1">
            {doneSubtasks.map((s) => (
              <li key={s.id} className="flex items-center gap-2 py-0.5 group">
                <input
                  type="checkbox"
                  checked={s.done}
                  onChange={() => handleToggle(s)}
                  className="cursor-pointer"
                />
                <span className="flex-1 text-sm line-through text-gray-400">
                  {s.title}
                </span>
                <button
                  onClick={() => handleDelete(s.id)}
                  className="text-xs text-gray-400 hover:text-red-500 opacity-0 group-hover:opacity-100 transition-opacity bg-transparent border-none cursor-pointer"
                >
                  Delete
                </button>
              </li>
            ))}
          </ul>
        </details>
      )}

      {subtaskList.length === 0 && (
        <p className="text-xs text-gray-400 italic">No subtasks yet</p>
      )}
    </div>
  );
};

export default SubtaskChecklist;
