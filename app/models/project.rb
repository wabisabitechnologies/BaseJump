class Project < ApplicationRecord
  normalizes :name, :description, with: ->(s) { s&.strip }

  PROJECT_TYPES = %w[company team project].freeze

  validates :name, :project_type, presence: true
  validates :project_type, inclusion: { in: PROJECT_TYPES }

  belongs_to :admin, class_name: :User, optional: true
  belongs_to :company, optional: true
  has_many :user_projects, dependent: :destroy
  has_many :users, through: :user_projects
  has_many :todo_lists, dependent: :destroy
  has_many :todos, through: :todo_lists
  has_many :events, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  scope :company_hq, -> { where(project_type: 'company') }
  scope :teams, -> { where(project_type: 'team') }
  scope :projects_only, -> { where(project_type: 'project') }

  def add_user(user)
    user_projects.create(user: user)
  end
end