class Contact < ApplicationRecord
  belongs_to :client

  validates :first_name, presence: true
  validates :last_name, presence: true

  def full_name
    "#{first_name} #{last_name}"
  end

  def description_line
    [ position, phone, email ].compact_blank.join(" · ")
  end

  def initials
    "#{first_name.first}#{last_name.first}".upcase
  end
end
