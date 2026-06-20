export const fetchCompanyUsers = async (id) => {
  const res = await fetch(`/api/projects/${id}/users`);
  if (!res.ok) throw { responseJSON: await res.json() };
  return res.json();
};

export const fetchUser = async (id) => {
  const res = await fetch(`/api/users/${id}`);
  if (!res.ok) throw { responseJSON: await res.json() };
  return res.json();
};
