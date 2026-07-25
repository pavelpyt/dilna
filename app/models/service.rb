class Service < ApplicationRecord
  UNITS = %w[ks hod km m bm m2 sada].freeze

  belongs_to :account
  has_many :job_items, dependent: :nullify

  validates :name, presence: true
  validates :unit, inclusion: { in: UNITS }
  validates :unit_price, numericality: { greater_than_or_equal_to: 0 }
  validates :vat_rate, numericality: { greater_than_or_equal_to: 0 }

  scope :available, -> { where(archived: false).order(:name) }
  scope :by_name, -> { order(:name) }
end
