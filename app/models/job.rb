class Job < ApplicationRecord
  # Stavový automat ze sekce 5.6 technického dokumentu. Prostý seznam stavů
  # a povolených přechodů — žádný gem, žádné DSL, dá se přečíst shora dolů.
  STATUSES = %w[
    inquiry priced quote_sent approved scheduled
    in_progress completed invoiced paid
    complaint rejected cancelled
  ].freeze

  # Hlavní cesta zakázky, kterou ukazuje pruh stavů na detailu.
  MAIN_FLOW_STATUSES = %w[
    inquiry priced quote_sent approved scheduled
    in_progress completed invoiced paid
  ].freeze

  ALLOWED_NEXT_STATUSES = {
    "inquiry" => %w[priced rejected cancelled],
    "priced" => %w[quote_sent cancelled],
    "quote_sent" => %w[approved rejected cancelled],
    "approved" => %w[scheduled cancelled],
    "scheduled" => %w[in_progress cancelled],
    "in_progress" => %w[completed cancelled],
    "completed" => %w[invoiced complaint],
    "invoiced" => %w[paid complaint],
    "paid" => %w[complaint],
    "complaint" => %w[scheduled],
    "rejected" => [],
    "cancelled" => []
  }.freeze

  belongs_to :account
  belongs_to :client
  belongs_to :property, optional: true

  has_many :job_items, -> { order(:position, :id) }, dependent: :destroy
  has_many :notes, -> { order(created_at: :desc) }, dependent: :destroy
  has_many :job_photos, -> { order(:created_at) }, dependent: :destroy

  validates :title, presence: true
  validates :number, presence: true, uniqueness: { scope: :account_id }
  validates :status, inclusion: { in: STATUSES }
  validate :property_belongs_to_client

  before_validation :assign_number, on: :create

  scope :newest_first, -> { order(created_at: :desc) }
  scope :with_status, ->(status) { where(status: status) }
  scope :open, -> { where.not(status: %w[paid rejected cancelled]) }

  def can_change_status_to?(new_status)
    ALLOWED_NEXT_STATUSES.fetch(status, []).include?(new_status)
  end

  def change_status_to!(new_status)
    raise ArgumentError, "Ze stavu #{status} nejde přejít do #{new_status}." unless can_change_status_to?(new_status)

    update!(status: new_status)
  end

  def allowed_next_statuses
    ALLOWED_NEXT_STATUSES.fetch(status, [])
  end

  def on_main_flow?
    MAIN_FLOW_STATUSES.include?(status)
  end

  def total_without_vat
    job_items.sum(&:total_without_vat)
  end

  def total_with_vat
    job_items.sum(&:total_with_vat)
  end

  private

  def assign_number
    return if number.present? || account.nil?

    self.number = account.next_job_number
  end

  def property_belongs_to_client
    return if property.nil? || property.client_id == client_id

    errors.add(:property, "musí patřit vybranému klientovi")
  end
end
