class NoteLink < ApplicationRecord
  attr_accessor :skip_callbacks

  belongs_to :source_note, class_name: :Note
  belongs_to :target_note, class_name: :Note

  validates :source_note_id, uniqueness: { scope: :target_note_id }
  validate :no_self_reference
  validate :no_circular_reference

  after_create :create_reverse_link
  after_destroy :destroy_reverse_link

  private

  def no_self_reference
    errors.add(:target_note, "can't link to itself") if source_note_id == target_note_id
  end

  def no_circular_reference
    return unless target_note_id
    
    # Check if target already links back to source
    if NoteLink.exists?(source_note_id: target_note_id, target_note_id: source_note_id)
      errors.add(:base, "circular link detected")
    end
  end

  def create_reverse_link
    unless NoteLink.exists?(source_note_id: target_note_id, target_note_id: source_note_id)
      link = NoteLink.new(
        source_note_id: target_note_id,
        target_note_id: source_note_id,
        skip_callbacks: true
      )
      link.save(validate: false)
    end
  end

  def destroy_reverse_link
    unless skip_callbacks
      NoteLink.where(source_note_id: target_note_id, target_note_id: source_note_id).destroy_all
    end
  end
end
