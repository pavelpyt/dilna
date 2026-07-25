class Payment < ApplicationRecord
  STATUSES = %w[pending succeeded failed].freeze

  belongs_to :invoice

  validates :status, inclusion: { in: STATUSES }
  validates :amount, numericality: { greater_than_or_equal_to: 0 }

  def succeeded?
    status == "succeeded"
  end
end
