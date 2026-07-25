# Data z veřejného poptávkového formuláře. Není to tabulka v databázi — jen
# schránka, která hlídá, že poptávka dává smysl, než z ní vznikne zakázka.
class JobRequestForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :client_name, :string
  attribute :email, :string
  attribute :phone, :string
  attribute :street, :string
  attribute :city, :string
  attribute :postal_code, :string
  attribute :title, :string
  attribute :description, :string

  validates :client_name, presence: true
  validates :street, presence: true
  validates :city, presence: true
  validates :title, presence: true
  validate :phone_or_email_is_filled_in

  private

  def phone_or_email_is_filled_in
    return if phone.present? || email.present?

    errors.add(:phone, "nebo e-mail musí být vyplněný, ať se máme jak ozvat")
  end
end
