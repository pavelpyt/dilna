# Evidence odeslaných SMS. Vede se od začátku pořádně — kdy, komu, co a kolikátá —
# ať jde doložit, že zákazník byl informovaný.
class SmsMessage < ApplicationRecord
  STATUSES = %w[queued sent failed].freeze

  belongs_to :client
  belongs_to :job, optional: true

  validates :body, presence: true
  validates :status, inclusion: { in: STATUSES }

  scope :newest_first, -> { order(created_at: :desc) }

  def sent?
    status == "sent"
  end

  def mark_as_sent!(external_id)
    update!(status: "sent", external_id: external_id, sent_at: Time.current)
  end

  def mark_as_failed!
    update!(status: "failed")
  end
end
