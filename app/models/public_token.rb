# Vstupenka do client hubu. Ve veřejné adrese nikdy nefiguruje id z databáze,
# jen tenhle náhodný token.
class PublicToken < ApplicationRecord
  DEFAULT_VALIDITY_IN_DAYS = 60

  belongs_to :job

  has_secure_token :token, length: 32

  scope :still_valid, -> { where("expires_at IS NULL OR expires_at > ?", Time.current) }

  def expired?
    expires_at.present? && expires_at < Time.current
  end
end
