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

  has_many :visits, -> { order(:starts_at) }, dependent: :destroy
  has_many :quotes, dependent: :destroy
  has_many :checklist_items, -> { order(:position, :id) }, dependent: :destroy
  has_many :time_entries, dependent: :nullify
  has_many :public_tokens, dependent: :destroy
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

  # Nabídka, kterou zákazník vidí v client hubu — vždycky ta poslední.
  def current_quote
    quotes.order(:created_at).last
  end

  # Z naceněné zakázky udělá nabídku a posune ji do stavu „nabídka odeslána".
  def issue_quote!(valid_until: Quote::DEFAULT_VALIDITY_IN_DAYS.days.from_now.to_date)
    transaction do
      quote = quotes.create!(status: "sent", valid_until: valid_until, sent_at: Time.current)
      change_status_to!("quote_sent")
      quote
    end
  end

  # Odkaz do client hubu — jeden platný token na zakázku stačí.
  def public_token_for_client_hub
    public_tokens.still_valid.order(:created_at).last ||
      public_tokens.create!(expires_at: PublicToken::DEFAULT_VALIDITY_IN_DAYS.days.from_now)
  end

  def next_visit
    visits.where("starts_at > ?", Time.current).order(:starts_at).first
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
