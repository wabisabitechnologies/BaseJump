class Subtask < ApplicationRecord
  belongs_to :author, class_name: :User, optional: true
  belongs_to :parent_todo, class_name: :Todo, optional: false

  scope :done, -> { where(done: true) }
  scope :not_done, -> { where(done: false) }

  validates :title, presence: true
end