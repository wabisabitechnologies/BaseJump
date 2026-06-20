export const fetchCompany = async (id) => {
  const res = await fetch(`/api/companies/${id}`);
  if (!res.ok) throw { responseJSON: await res.json() };
  return res.json();
};

export const updateCompany = async (company) => {
  const res = await fetch(`/api/companies/${company.id}`, {
    method: 'PATCH',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ company }),
  });
  if (!res.ok) throw { responseJSON: await res.json() };
  return res.json();
};
