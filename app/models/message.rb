class Message < ApplicationRecord
  include PgSearch::Model
  
  normalizes :title, :body, with: ->(s) { s&.strip }

  validates :title, :project, presence: true
  validates :body, presence: true

  belongs_to :author, class_name: :User, optional: true
  belongs_to :project, optional: true
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :references, dependent: :destroy, class_name: 'Reference'
  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, through: :taggings

  pg_search_scope :search, 
    against: [:title, :body],
    using: {
      tsearch: { dictionary: "english", prefix: true },
      trigram: { threshold: 0.3 }
    }
end