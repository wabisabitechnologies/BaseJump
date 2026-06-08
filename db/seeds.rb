company = Company.create!(
  name: "John's Dough Company",
  image_url: "https://i.pinimg.com/originals/87/ad/9d/87ad9dfcc0cb1fb7a5d26a2cd3773b5e.png"
)

john = User.create!(
  name: "John Doe",
  username: "johndoe",
  email: "john@doe.com",
  password: 'password',
  company: company,
  owner: true,
  session_token: SecureRandom.urlsafe_base64(16)
)

jane = User.create!(
  name: "Jane Doe",
  username: "janedoe",
  email: "jane@doe.com",
  password: 'password',
  company: company,
  session_token: SecureRandom.urlsafe_base64(16)
)

ted = User.create!(
  name: "Ted Mosby",
  username: "tedmosby",
  email: "ted.mosby@gmail.com",
  password: 'password',
  company: company,
  session_token: SecureRandom.urlsafe_base64(16)
)

hq_project = Project.create!(
  name: "Company HQ",
  description: "Company-wide announcements and stuff everyone needs to know",
  project_type: "company",
  admin: john,
  company: company
)

hr_team = Project.create!(
  name: "Human Resources",
  description: "Hirings and Firings",
  project_type: "team",
  admin: john,
  company: company
)

finance_team = Project.create!(
  name: "Finance",
  description: "Provide the bread and butter",
  project_type: "team",
  admin: john,
  company: company
)

it_project = Project.create!(
  name: "Create IT Department",
  description: "Collaboration with HR and Finance to plan IT hirings",
  project_type: "project",
  admin: john,
  company: company
)

[hq_project, hr_team, finance_team, it_project].each do |project|
  UserProject.create!(user: john, project: project)
end

UserProject.create!(user: jane, project: hq_project)
UserProject.create!(user: jane, project: hr_team)
UserProject.create!(user: jane, project: it_project)
UserProject.create!(user: ted, project: hq_project)
UserProject.create!(user: ted, project: finance_team)
UserProject.create!(user: ted, project: it_project)