export const fetchUserProjects = async (id, projectType) => {
  let url = `/api/users/${id}/projects`;
  if (projectType) {
    url = `/api/users/${id}/projects?project_type=${projectType}`;
  }
  const res = await fetch(url);
  if (!res.ok) throw { responseJSON: await res.json() };
  return res.json();
};

export const fetchProject = async (id) => {
  const res = await fetch(`/api/projects/${id}`);
  if (!res.ok) throw { responseJSON: await res.json() };
  return res.json();
};

export const postProject = async (project) => {
  const res = await fetch('/api/projects', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ project }),
  });
  if (!res.ok) throw { responseJSON: await res.json() };
  return res.json();
};

export const updateProject = async (project) => {
  const res = await fetch(`/api/projects/${project.id}`, {
    method: 'PATCH',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ project }),
  });
  if (!res.ok) throw { responseJSON: await res.json() };
  return res.json();
};
