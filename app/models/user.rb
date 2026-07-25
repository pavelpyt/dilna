class User < ApplicationRecord
  ROLES = %w[owner staff].freeze

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :account

  # Při registraci vzniká firma i její první uživatel jedním uložením.
  accepts_nested_attributes_for :account

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :role, inclusion: { in: ROLES }

  def owner?
    role == "owner"
  end

  def staff?
    role == "staff"
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def initials
    "#{first_name.first}#{last_name.first}".upcase
  end
end
