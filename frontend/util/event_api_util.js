export const fetchProjectEvents = async (id) => {
  const res = await fetch(`/api/projects/${id}/events`);
  if (!res.ok) throw { responseJSON: await res.json() };
  return res.json();
};

export const fetchEvent = async (id) => {
  const res = await fetch(`/api/events/${id}`);
  if (!res.ok) throw { responseJSON: await res.json() };
  return res.json();
};

export const createEvent = async (event) => {
  const res = await fetch('/api/events', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ event }),
  });
  if (!res.ok) throw { responseJSON: await res.json() };
  return res.json();
};

export const updateEvent = async (event) => {
  const res = await fetch(`/api/events/${event.id}`, {
    method: 'PATCH',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ event }),
  });
  if (!res.ok) throw { responseJSON: await res.json() };
  return res.json();
};

export const deleteEvent = async (id) => {
  const res = await fetch(`/api/events/${id}`, {
    method: 'DELETE',
    headers: { 'Content-Type': 'application/json' },
  });
  if (!res.ok) throw { responseJSON: await res.json() };
  return res.json();
};
