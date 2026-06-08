class Company < ApplicationRecord
  normalizes :name, with: ->(name) { name.to_s.strip.downcase }

  validates :name, presence: true

  has_many :employees, dependent: :destroy
  has_many :projects, through: :employees

  def hq_project
    projects.find_by(project_type: 'company')
  end
end