export const fetchProjectTodoLists = async (id) => {
  const res = await fetch(`/api/projects/${id}/todolists`);
  if (!res.ok) throw { responseJSON: await res.json() };
  return res.json();
};

export const fetchTodoList = async (id) => {
  const res = await fetch(`/api/todolists/${id}`);
  if (!res.ok) throw { responseJSON: await res.json() };
  return res.json();
};

export const createTodoList = async (todo_list) => {
  const res = await fetch('/api/todolists', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ todo_list }),
  });
  if (!res.ok) throw { responseJSON: await res.json() };
  return res.json();
};

export const updateTodoList = async (todo_list) => {
  const res = await fetch(`/api/todolists/${todo_list.id}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ todo_list }),
  });
  if (!res.ok) throw { responseJSON: await res.json() };
  return res.json();
};
