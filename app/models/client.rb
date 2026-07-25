class Client < ApplicationRecord
  CLIENT_TYPES = %w[person company].freeze

  belongs_to :account
  has_many :properties, dependent: :destroy
  has_many :contacts, dependent: :destroy
  has_many :jobs, dependent: :destroy
  has_many :invoices, through: :jobs

  validates :name, presence: true
  validates :client_type, inclusion: { in: CLIENT_TYPES }

  scope :by_name, -> { order(:name) }

  # Hledání podle jména, telefonu, e-mailu nebo adresy některé z nemovitostí.
  def self.matching(search_term)
    return by_name if search_term.blank?

    pattern = "%#{search_term.strip}%"

    left_joins(:properties)
      .where(
        "clients.name ILIKE :pattern OR clients.phone ILIKE :pattern OR clients.email ILIKE :pattern " \
        "OR properties.street ILIKE :pattern OR properties.city ILIKE :pattern",
        pattern: pattern
      )
      .distinct
      .by_name
  end

  def contact_line
    [ phone, email ].compact_blank.join(" · ")
  end

  def company?
    client_type == "company"
  end

  def person?
    client_type == "person"
  end
end
