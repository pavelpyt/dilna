# Zrcadlo faktury, kterou fyzicky vystavila externí služba. Vlastní daňový
# doklad negenerujeme — držíme jen referenci a stav kvůli přehledu.
class Invoice < ApplicationRecord
  STATUSES = %w[issued paid cancelled].freeze

  belongs_to :job

  has_many :payments, dependent: :destroy

  validates :number, presence: true
  validates :due_on, presence: true
  validates :status, inclusion: { in: STATUSES }

  scope :unpaid, -> { where(status: "issued") }
  scope :newest_first, -> { order(created_at: :desc) }

  def paid?
    status == "paid"
  end

  def overdue?
    !paid? && due_on < Date.current
  end

  def days_overdue
    return 0 unless overdue?

    (Date.current - due_on).to_i
  end

  # Volá se po úspěšné platbě. Zakázka jde zároveň do stavu „zaplaceno".
  def mark_as_paid!
    transaction do
      update!(status: "paid", paid_at: Time.current)
      job.change_status_to!("paid") if job.can_change_status_to?("paid")
    end
  end
end
