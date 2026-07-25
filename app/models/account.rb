class Account < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :clients, dependent: :destroy
  has_many :services, dependent: :destroy
  has_many :jobs, dependent: :destroy

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true,
                   format: { with: /\A[a-z0-9\-]+\z/, message: "smí obsahovat jen malá písmena, číslice a pomlčky" }

  before_validation :generate_slug_from_name, if: :should_generate_slug?

  # Čísla zakázek jdou po sobě v rámci roku a firmy: 2026-0001, 2026-0002, …
  def next_job_number
    current_year = Date.current.year
    highest_number = jobs.where("number LIKE ?", "#{current_year}-%").maximum(:number)
    next_sequence = highest_number ? highest_number.split("-").last.to_i + 1 : 1

    format("%d-%04d", current_year, next_sequence)
  end

  private

  def should_generate_slug?
    slug.blank? && name.present?
  end

  def generate_slug_from_name
    self.slug = name.parameterize
  end
end
