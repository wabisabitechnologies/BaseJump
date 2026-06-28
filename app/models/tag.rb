class Tag < ApplicationRecord
  has_many :taggings, dependent: :destroy
  has_many :messages, through: :taggings, source: :taggable, source_type: 'Message'
  has_many :todos, through: :taggings, source: :taggable, source_type: 'Todo'
  has_many :events, through: :taggings, source: :taggable, source_type: 'Event'
  has_many :projects, through: :taggings, source: :taggable, source_type: 'Project'

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  
  normalizes :name, with: ->(name) { name.strip.downcase }

  scope :for_project, ->(project) { joins(:taggings).where(taggings: { taggable_type: 'Project', taggable_id: project.id }).distinct }
end
