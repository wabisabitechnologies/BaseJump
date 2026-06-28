class Note < ApplicationRecord
  include PgSearch::Model
  
  normalizes :title, :body, with: ->(s) { s&.strip }

  validates :title, presence: true

  belongs_to :author, class_name: :User, optional: true
  belongs_to :project, optional: true
  belongs_to :parent, class_name: :Note, optional: true
  
  has_many :children, class_name: :Note, foreign_key: :parent_id, dependent: :destroy
  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, through: :taggings
  has_many :comments, as: :commentable, dependent: :destroy

  scope :roots, -> { where(parent_id: nil) }
  scope :for_project, ->(project) { where(project: project) }

  pg_search_scope :search,
    against: [:title, :body],
    using: {
      tsearch: { dictionary: "english", prefix: true },
      trigram: { threshold: 0.3 }
    }

  def root?
    parent_id.nil?
  end

  def ancestors
    node = self
    nodes = []
    while node.parent
      nodes << node.parent
      node = node.parent
    end
    nodes.reverse
  end

  def breadcrumb_path
    ancestors.map(&:title).push(title).join(" / ")
  end
end
