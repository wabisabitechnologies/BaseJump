class Comment < ApplicationRecord
  normalizes :body, with: ->(body) { body.strip }

  validates :body, presence: true
  validates :body, length: { minimum: 1 }

  belongs_to :author, class_name: :User, optional: true
  belongs_to :commentable, polymorphic: true, optional: true

  has_many :references, dependent: :destroy, class_name: 'Reference'
end
