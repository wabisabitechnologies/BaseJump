export const fetchProjectLooseTodos = async (id) => {
  const res = await fetch(`/api/projects/${id}/loose_todos`);
  if (!res.ok) throw { responseJSON: await res.json() };
  return res.json();
};
