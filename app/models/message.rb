class Message < ApplicationRecord
  normalizes :title, :body, with: ->(s) { s&.strip }

  validates :title, :project, presence: true
  validates :body, presence: true

  belongs_to :author, class_name: :User, optional: true
  belongs_to :project, optional: true
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :references, dependent: :destroy, class_name: 'Reference'
end