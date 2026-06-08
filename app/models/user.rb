class User < ApplicationRecord
  has_secure_password

  normalizes :email, :username, with: ->(value) { value.strip.downcase }

  validates :name, :username, :email, :company, presence: true
  validates :username, uniqueness: true
  validates :email, uniqueness: true
  validates :password, length: { minimum: 6 }, allow_nil: true

  belongs_to :company, optional: true
  has_many :user_projects, dependent: :destroy
  has_many :projects, through: :user_projects
  has_many :adminned_projects, class_name: :Project, foreign_key: :admin_id
  has_many :authored_todo_lists, class_name: :TodoList, foreign_key: :author_id
  has_many :authored_todos, class_name: :Todo, foreign_key: :author_id
  has_many :user_todos, dependent: :destroy
  has_many :assigned_todos, through: :user_todos, source: :todo
  has_many :authored_messages, class_name: :Message, foreign_key: :author_id
  has_many :authored_events, class_name: :Event, foreign_key: :author_id
  has_many :comments, class_name: :Comment, foreign_key: :author_id

  attr_accessor :company_name

  before_create :ensure_session_token, :ensure_avatar

  def self.find_by_username_or_email(login_cred)
    find_by(username: login_cred) || find_by(email: login_cred)
  end

  def self.find_by_credentials(login_cred, password)
    user = find_by_username_or_email(login_cred)
    user&.authenticate(password)
  end

  def reset_session_token!
    update(session_token: SecureRandom.urlsafe_base64(16))
  end

  private

  def ensure_session_token
    self.session_token ||= SecureRandom.urlsafe_base64(16)
  end

  def ensure_avatar
    return if avatar_url.present?
    self.avatar_url = "https://placehold.co/500x500?text=#{name.first}&font=roboto"
  end
end