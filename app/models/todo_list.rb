class TodoList < ApplicationRecord
  normalizes :title, :description, with: ->(s) { s&.strip }

  validates :title, :project, presence: true

  belongs_to :project
  belongs_to :author, class_name: :User, optional: true

  has_many :todos, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  def loose_todos
    todos.where(todo_list_id: nil)
  end

  def progress_percentage
    return 0 if todos.empty?
    (todos.done.count.to_f / todos.count * 100).round
  end
end