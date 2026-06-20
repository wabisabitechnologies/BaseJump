export const fetchTodoSubtasks = async (id) => {
  const res = await fetch(`/api/todos/${id}/subtasks`);
  if (!res.ok) throw { responseJSON: await res.json() };
  return res.json();
};

export const createSubtask = async (subtask) => {
  const res = await fetch('/api/subtasks', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ subtask }),
  });
  if (!res.ok) throw { responseJSON: await res.json() };
  return res.json();
};

export const updateSubtask = async (subtask) => {
  const res = await fetch(`/api/subtasks/${subtask.id}`, {
    method: 'PATCH',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ subtask }),
  });
  if (!res.ok) throw { responseJSON: await res.json() };
  return res.json();
};

export const destroySubtask = async (id) => {
  const res = await fetch(`/api/subtasks/${id}`, {
    method: 'DELETE',
    headers: { 'Content-Type': 'application/json' },
  });
  if (!res.ok) throw { responseJSON: await res.json() };
  return res.json();
};
