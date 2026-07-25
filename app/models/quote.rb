class Quote < ApplicationRecord
  STATUSES = %w[draft sent approved rejected].freeze

  DEFAULT_VALIDITY_IN_DAYS = 14

  belongs_to :job

  validates :status, inclusion: { in: STATUSES }

  delegate :job_items, :total_without_vat, :total_with_vat, to: :job

  def sent?
    status == "sent"
  end

  def approved?
    status == "approved"
  end

  def rejected?
    status == "rejected"
  end

  def waiting_for_customer?
    sent? && !expired?
  end

  def expired?
    valid_until.present? && valid_until < Date.current
  end

  # Zákazník klikl v client hubu na Schválit.
  def approve_by_customer!
    transaction do
      update!(status: "approved", decided_at: Time.current)
      job.change_status_to!("approved")
    end
  end

  def reject_by_customer!
    transaction do
      update!(status: "rejected", decided_at: Time.current)
      job.change_status_to!("rejected")
    end
  end
end
