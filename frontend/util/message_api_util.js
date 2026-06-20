export const fetchProjectMessages = async (id) => {
  const res = await fetch(`/api/projects/${id}/messages`);
  if (!res.ok) throw { responseJSON: await res.json() };
  return res.json();
};

export const fetchMessage = async (id) => {
  const res = await fetch(`/api/messages/${id}`);
  if (!res.ok) throw { responseJSON: await res.json() };
  return res.json();
};

export const createMessage = async (message) => {
  const res = await fetch('/api/messages', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ message }),
  });
  if (!res.ok) throw { responseJSON: await res.json() };
  return res.json();
};

export const updateMessage = async (message) => {
  const res = await fetch(`/api/messages/${message.id}`, {
    method: 'PATCH',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ message }),
  });
  if (!res.ok) throw { responseJSON: await res.json() };
  return res.json();
};

export const deleteMessage = async (id) => {
  const res = await fetch(`/api/messages/${id}`, {
    method: 'DELETE',
    headers: { 'Content-Type': 'application/json' },
  });
  if (!res.ok) throw { responseJSON: await res.json() };
  return res.json();
};
