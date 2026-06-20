export const fetchTodoListComments = async (id) => {
  const res = await fetch(`/api/todolists/${id}/comments`);
  if (!res.ok) throw { responseJSON: await res.json() };
  return res.json();
};

export const fetchMessageComments = async (id) => {
  const res = await fetch(`/api/messages/${id}/comments`);
  if (!res.ok) throw { responseJSON: await res.json() };
  return res.json();
};

export const fetchEventComments = async (id) => {
  const res = await fetch(`/api/events/${id}/comments`);
  if (!res.ok) throw { responseJSON: await res.json() };
  return res.json();
};

export const createComment = async (comment) => {
  const res = await fetch('/api/comments', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ comment }),
  });
  if (!res.ok) throw { responseJSON: await res.json() };
  return res.json();
};

export const updateComment = async (comment) => {
  const res = await fetch(`/api/comments/${comment.id}`, {
    method: 'PATCH',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ comment }),
  });
  if (!res.ok) throw { responseJSON: await res.json() };
  return res.json();
};

export const destroyComment = async (id) => {
  const res = await fetch(`/api/comments/${id}`, {
    method: 'DELETE',
    headers: { 'Content-Type': 'application/json' },
  });
  if (!res.ok) throw { responseJSON: await res.json() };
  return res.json();
};
