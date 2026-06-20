class Todo < ApplicationRecord
  normalizes :title, with: ->(title) { title.strip }

  validates :title, :author_id, presence: true
  validates :done, inclusion: { in: [true, false] }

  belongs_to :author, class_name: :User, optional: true
  belongs_to :todo_list, class_name: :TodoList, optional: true

  has_many :user_todos, dependent: :destroy
  has_many :assignees, through: :user_todos, source: :user
  has_many :subtasks, dependent: :destroy, foreign_key: :parent_todo_id, inverse_of: :parent_todo
  has_one :project, through: :todo_list

  scope :loose, -> { where(todo_list_id: nil) }
  scope :done, -> { where(done: true) }
  scope :not_done, -> { where(done: false) }

  def toggle_status
    update(done: !done)
  end

  def loose?
    todo_list_id.nil?
  end
end