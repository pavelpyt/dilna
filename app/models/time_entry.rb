# Docházka technika. Jeden záznam = jedno „naskočil / skončil".
class TimeEntry < ApplicationRecord
  belongs_to :user
  belongs_to :job, optional: true

  validates :started_at, presence: true
  validate :ended_at_is_after_started_at
  validate :user_has_no_other_running_entry, on: :create

  scope :running, -> { where(ended_at: nil) }
  scope :finished, -> { where.not(ended_at: nil) }
  scope :started_between, ->(from, to) { where(started_at: from..to) }
  scope :newest_first, -> { order(started_at: :desc) }

  def running?
    ended_at.nil?
  end

  def stop!
    update!(ended_at: Time.current)
  end

  def duration_in_hours
    finished_at = ended_at || Time.current

    ((finished_at - started_at) / 3600).round(2)
  end

  private

  def ended_at_is_after_started_at
    return if started_at.blank? || ended_at.blank?
    return if ended_at > started_at

    errors.add(:ended_at, "musí být po začátku")
  end

  def user_has_no_other_running_entry
    return if user.nil?
    return unless TimeEntry.running.exists?(user_id: user_id)

    errors.add(:base, "Máš rozdělanou jinou docházku, nejdřív ji ukonči.")
  end
end
