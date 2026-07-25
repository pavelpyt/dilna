class Visit < ApplicationRecord
  STATUSES = %w[planned done cancelled].freeze

  belongs_to :job
  belongs_to :user, optional: true

  validates :starts_at, presence: true
  validates :ends_at, presence: true
  validates :status, inclusion: { in: STATUSES }
  validate :ends_at_is_after_starts_at
  validate :technician_has_no_other_visit_at_the_same_time

  scope :starting_between, ->(from, to) { where(starts_at: from...to) }
  scope :chronological, -> { order(:starts_at) }
  scope :for_technician, ->(user) { where(user: user) }

  def duration_in_minutes
    ((ends_at - starts_at) / 60).round
  end

  private

  def ends_at_is_after_starts_at
    return if starts_at.blank? || ends_at.blank?
    return if ends_at > starts_at

    errors.add(:ends_at, "musí být po začátku termínu")
  end

  # Stejnou kolizi hlídá i exclusion constraint v databázi. Tady je kvůli
  # srozumitelné hlášce, tam kvůli souběžnému ukládání.
  def technician_has_no_other_visit_at_the_same_time
    return if user_id.blank? || starts_at.blank? || ends_at.blank?

    overlapping_visits = Visit.where(user_id: user_id)
                              .where.not(id: id)
                              .where("starts_at < ? AND ends_at > ?", ends_at, starts_at)

    return unless overlapping_visits.exists?

    errors.add(:base, "Technik už má v tuhle dobu jiný termín.")
  end
end
