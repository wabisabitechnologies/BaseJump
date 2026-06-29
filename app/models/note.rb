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
  
  # Bi-directional linking
  has_many :outgoing_links, class_name: :NoteLink, foreign_key: :source_note_id, dependent: :destroy
  has_many :incoming_links, class_name: :NoteLink, foreign_key: :target_note_id, dependent: :destroy
  has_many :linked_notes, through: :outgoing_links, source: :target_note
  has_many :backlinked_notes, through: :incoming_links, source: :source_note

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

  # Find [[wiki-style]] links in body and return note titles
  def extract_wiki_links
    body.to_s.scan(/\[\[([^\]]+)\]\]/).flatten.uniq
  end

  # Parse body and replace [[wiki links]] with actual HTML links
  def body_with_links
    return body unless body.present?
    
    result = body.dup
    extract_wiki_links.each do |title|
      linked_note = Note.find_by(title: title)
      if linked_note
        replacement = "<a href=\"/projects/#{linked_note.project_id}/docs/#{linked_note.id}\" class=\"wiki-link\">#{title}</a>"
        result.gsub!("[[#{title}]]", replacement)
      end
    end
    result.html_safe
  end
end
