class ChecklistItem < ApplicationRecord
  belongs_to :job
  belongs_to :completed_by_user, class_name: "User", optional: true

  validates :label, presence: true

  scope :in_order, -> { order(:position, :id) }

  def completed?
    completed_at.present?
  end

  def toggle_completed_by!(user)
    return update!(completed_at: nil, completed_by_user: nil) if completed?

    update!(completed_at: Time.current, completed_by_user: user)
  end
end
