import React, { useState, useEffect, useCallback } from 'react';
import { useDispatch } from 'react-redux';
import { Button, Input, Checkbox } from '../../../src/ui';
import { fetchProjectTodos, toggleTodo } from '../../../actions/todo_actions';
import * as TodoAPIUtil from '../../../util/todo_api_util';
import useFormSubmit from '../../../hooks/useFormSubmit';

const LooseTodoList = ({ todos, currentUser, projectId }) => {
  const dispatch = useDispatch();
  const [title, setTitle] = useState('');
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    setLoading(true);
    dispatch(fetchProjectTodos(projectId)).finally(() => setLoading(false));
  }, [dispatch, projectId]);

  const { submit, loading: creating, errors } = useFormSubmit(
    (data) =>
      TodoAPIUtil.createTodo({
        ...data,
        author_id: currentUser.id,
        todo_list_id: null,
      }),
    {
      onSuccess: () => {
        setTitle('');
        dispatch(fetchProjectTodos(projectId));
      },
    },
  );

  const handleCreate = useCallback(
    (e) => {
      e.preventDefault();
      if (!title.trim()) return;
      submit({ title });
    },
    [submit, title],
  );

  const handleToggle = useCallback(
    (todoId) => {
      dispatch(toggleTodo(todoId));
    },
    [dispatch],
  );

  const looseTodos = todos
    ? (Array.isArray(todos) ? todos : Object.values(todos)).filter(
        (todo) => !todo.todo_list_id,
      )
    : [];

  if (loading) {
    return (
      <div className="flex items-center justify-center py-8 text-gray-500">
        <div className="mr-2 h-5 w-5 animate-spin rounded-full border-2 border-landing-blue border-t-transparent" />
        <span className="text-sm">Loading todos...</span>
      </div>
    );
  }

  return (
    <div className="loose-todo-list">
      <h2 className="mb-3 text-lg font-semibold text-gray-800">
        Unsorted Todos
      </h2>

      <form onSubmit={handleCreate} className="mb-4 flex items-center gap-2">
        <Input
          type="text"
          placeholder="Add a loose todo..."
          value={title}
          onChange={(e) => setTitle(e.target.value)}
          className="flex-1"
        />
        <Button
          type="submit"
          variant="primary"
          size="sm"
          disabled={creating || !title.trim()}
        >
          {creating ? 'Adding...' : 'Add'}
        </Button>
      </form>
      {errors.title && (
        <p className="mb-2 text-sm text-red-500">{errors.title}</p>
      )}

      {looseTodos.length === 0 ? (
        <p className="text-sm italic text-gray-400">
          No loose todos. Drop a todo here or create one.
        </p>
      ) : (
        <ul className="space-y-1">
          {looseTodos.map((todo) => (
            <li key={todo.id} className="flex items-center gap-2 py-1">
              <Checkbox
                checked={todo.done}
                onChange={() => handleToggle(todo.id)}
              />
              <span
                className={`flex-1 text-sm ${
                  todo.done
                    ? 'text-gray-400 line-through'
                    : 'text-gray-800'
                }`}
              >
                {todo.title}
              </span>
              {todo.assignees && todo.assignees.length > 0 && (
                <span className="text-xs text-gray-400">
                  {Array.isArray(todo.assignees)
                    ? todo.assignees.join(', ')
                    : String(todo.assignees)}
                </span>
              )}
            </li>
          ))}
        </ul>
      )}
    </div>
  );
};

export default LooseTodoList;
