class Property < ApplicationRecord
  belongs_to :client
  has_many :jobs, dependent: :nullify

  validates :street, presence: true
  validates :city, presence: true

  def full_address
    [ street, [ postal_code, city ].compact_blank.join(" ") ].compact_blank.join(", ")
  end

  def display_label
    label.presence || full_address
  end

  def has_coordinates?
    latitude.present? && longitude.present?
  end
end
