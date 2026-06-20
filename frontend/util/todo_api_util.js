export const fetchProjectTodos = async (id) => {
  const res = await fetch(`/api/projects/${id}/todos`);
  if (!res.ok) throw { responseJSON: await res.json() };
  return res.json();
};

export const fetchTodoListTodos = async (id) => {
  const res = await fetch(`/api/todolists/${id}/todos`);
  if (!res.ok) throw { responseJSON: await res.json() };
  return res.json();
};

export const fetchTodo = async (id) => {
  const res = await fetch(`/api/todos/${id}`);
  if (!res.ok) throw { responseJSON: await res.json() };
  return res.json();
};

export const createTodo = async (todo) => {
  const res = await fetch('/api/todos', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ todo }),
  });
  if (!res.ok) throw { responseJSON: await res.json() };
  return res.json();
};

export const updateTodo = async (todo) => {
  const res = await fetch(`/api/todos/${todo.id}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ todo }),
  });
  if (!res.ok) throw { responseJSON: await res.json() };
  return res.json();
};

export const toggleTodo = async (id) => {
  const res = await fetch(`/api/todos/${id}/toggle`, {
    method: 'PATCH',
    headers: { 'Content-Type': 'application/json' },
  });
  if (!res.ok) throw { responseJSON: await res.json() };
  return res.json();
};
