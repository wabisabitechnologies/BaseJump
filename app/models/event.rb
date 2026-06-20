class Event < ApplicationRecord
  normalizes :title, :description, with: ->(s) { s&.strip }

  validates :title, :author, :project, presence: true
  validate :end_date_after_start_date

  belongs_to :author, class_name: :User, optional: true
  belongs_to :project, optional: true
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :references, dependent: :destroy, class_name: 'Reference'

  def start_datetime
    return nil unless start_date.present?
    Time.zone.parse(start_date.to_s)
  end

  def end_datetime
    return nil unless end_date.present?
    Time.zone.parse(end_date.to_s)
  end

  private

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?
    errors.add(:end_date, 'must be after start date') if start_date.to_s > end_date.to_s
  end
end