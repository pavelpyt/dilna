class JobItem < ApplicationRecord
  belongs_to :job
  belongs_to :service, optional: true

  validates :description, presence: true
  validates :quantity, numericality: { greater_than: 0 }
  validates :unit_price, numericality: { greater_than_or_equal_to: 0 }
  validates :vat_rate, numericality: { greater_than_or_equal_to: 0 }

  def total_without_vat
    quantity * unit_price
  end

  def total_with_vat
    total_without_vat * (1 + vat_rate / 100.0)
  end

  # Předvyplní položku podle služby z ceníku.
  def copy_from_service(service)
    self.description = service.name
    self.unit = service.unit
    self.unit_price = service.unit_price
    self.vat_rate = service.vat_rate
  end
end
