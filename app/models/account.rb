class Account < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :clients, dependent: :destroy

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true,
                   format: { with: /\A[a-z0-9\-]+\z/, message: "smí obsahovat jen malá písmena, číslice a pomlčky" }

  before_validation :generate_slug_from_name, if: :should_generate_slug?

  private

  def should_generate_slug?
    slug.blank? && name.present?
  end

  def generate_slug_from_name
    self.slug = name.parameterize
  end
end
